import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:chalo_kart_user/Assistance/request_assistant.dart';
import 'package:chalo_kart_user/global/global.dart';
import 'package:chalo_kart_user/models/direction.dart';
import 'package:chalo_kart_user/models/direction_details_info.dart';
import 'package:chalo_kart_user/models/direction_details_with_polyline.dart';
import 'package:chalo_kart_user/models/trips_history_model.dart';
import 'package:chalo_kart_user/models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUser!.uid);
    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeoCoordinates(Position position, context,) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error occurred, no response") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickupAddress = Directions();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(
        context,
        listen: false,
      ).updatePickupLocationAddress(userPickupAddress);
    }
    return humanReadableAddress;
  }

  static Future<(DirectionDetailsWithPolyline, dynamic)> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition,) async {
    DirectionDetailsWithPolyline directionDetailsWithPolyline =
        DirectionDetailsWithPolyline();
    // print("Function called");
    var responseDirectionApi =
        await RequestAssistant.receiveRequestForDirectionDetails(
          originPosition,
          destinationPosition,
        );
    DirectionDetailsWithPolyline nullInstance = DirectionDetailsWithPolyline(
      e_points: null,
      distance_value_in_meters: null,
      duration_text_in_s: null,
    );
    // print(responseDirectionApi);
    if (responseDirectionApi == "Error occurred, no response") {
      return (nullInstance, "");
    }
    directionDetailsWithPolyline.e_points =
        responseDirectionApi["routes"][0]["polyline"]["encodedPolyline"];
    directionDetailsWithPolyline.distance_value_in_meters =
        responseDirectionApi["routes"][0]["distanceMeters"];
    directionDetailsWithPolyline.duration_text_in_s =
        responseDirectionApi["routes"][0]["duration"];
    // print("asdf");
    // print(responseDirectionApi["routes"][0]["polyline"]["encodedPolyline"]);
    return (
      directionDetailsWithPolyline,
      responseDirectionApi["routes"][0]["polyline"]["encodedPolyline"],
    );
  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsWithPolyline directionDetailsWithPolyline) {
    String timeString = directionDetailsWithPolyline.duration_text_in_s!;
    String numericPart = RegExp(r'\d+').firstMatch(timeString)?.group(0) ?? "0";
    int seconds = int.parse(numericPart);
    double timeTravelledFareAmountPerMinute =
        (seconds/ 60) * 0.1;
    double distanceTravelledFareAmountPerKilometer =
        (directionDetailsWithPolyline.distance_value_in_meters! / 100) * 1;
    double totalFareAmount =
        timeTravelledFareAmountPerMinute +
            distanceTravelledFareAmountPerKilometer;
    // String formattedFare = totalFareAmount.toStringAsFixed(1);
    fareAmountCalculated = totalFareAmount;
    fareAmountCalculated=fareAmountCalculated.truncateToDouble();
    return fareAmountCalculated;
  }

  static Future<void> sendNotificationToDriverNow(String? driverToken, String? rideRequestId, BuildContext context,) async {
    if (driverToken == null || rideRequestId == null) {
      print("Driver token or ride request ID is null");
      return;
    }

    var destinationInformation = Provider.of<AppInfo>(context, listen: false)
        .userDropOffLocation!
        .locationName!;

    try {
      // Format for FCM API v1
      Map<String, dynamic> messageData = {
        "message": {
          "token": driverToken,
          "notification": {
            "title": "New Ride Request",
            "body": "Destination: $destinationInformation",
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done",
            "ride_request_id": rideRequestId,
            "destinationAddress": destinationInformation,
          }
        }
      };

      // Using the FCM API v1 endpoint
      var response = await http.post(
        Uri.parse("https://fcm.googleapis.com/v1/projects/chalokart-83ef4/messages:send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $cloudMessagingServerToken",
        },
        body: jsonEncode(messageData),
      );

      print("FCM Response Status: ${response.statusCode}");
      print("FCM Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("Notification sent successfully");
        Fluttertoast.showToast(msg: "Notification sent successfully");
      } else {
        print("Failed to send notification: ${response.body}");
        Fluttertoast.showToast(msg: "Failed to send notification: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending notification: $e");
      Fluttertoast.showToast(msg: "Error sending notification");
    }
  }

  static void readTripsKeysForOnlineUser(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .orderByChild("userId")
        .equalTo(userModelCurrentInfo!.id)
        .once()
        .then((snap) {
          if (snap.snapshot.value != null) {
            Map keysTripsId = snap.snapshot.value as Map;
            int overAllTripsCounter = keysTripsId.length;
            Provider.of<AppInfo>(
              context,
              listen: false,
            ).updateOverAllTripsCounter(overAllTripsCounter);
            List<String> tripKeysList = [];
            keysTripsId.forEach((key, value) {
              tripKeysList.add(key);
            });
            Provider.of<AppInfo>(
              context,
              listen: false,
            ).updateOverAllTripsKeys(tripKeysList);
            
            // Read trip history information after getting the keys
            readTripsHistoryInformation(context);
          }
        });
  }

  static void readTripsHistoryInformation(context) {
    var tripsAllKeys =
        Provider.of<AppInfo>(context, listen: false).historyTripsKeyList;
    for (String eachKey in tripsAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap) {
            var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);
            if ((snap.snapshot.value as Map)["status"] == "ended") {
              Provider.of<AppInfo>(
                context,
                listen: false,
              ).updateOverAllTripsHistoryInformation(eachTripHistory);
            }
          });
    }
  }
}
