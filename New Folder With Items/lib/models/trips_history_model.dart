import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel {
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? carType;
  String? carModel;
  String? carNumber;
  String? carColor;
  String? driverName;
  String? ratings;

  TripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.fareAmount,
    this.carType,
    this.carModel,
    this.carNumber,
    this.carColor,
    this.driverName,
    this.ratings,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    carType = (dataSnapshot.value as Map)["carType"];
    carModel = (dataSnapshot.value as Map)["carModel"];
    carNumber = (dataSnapshot.value as Map)["carNumber"];
    carColor = (dataSnapshot.value as Map)["carColor"];
    driverName = (dataSnapshot.value as Map)["driverName"];
    ratings = (dataSnapshot.value as Map)["ratings"];
  }
}
