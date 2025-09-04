import 'package:firebase_auth/firebase_auth.dart';
import 'package:chalo_kart_user/models/direction_details_info.dart';
import 'package:chalo_kart_user/models/direction_details_with_polyline.dart';
import 'package:chalo_kart_user/models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

String userDropOffAddress = "";

DirectionDetailsWithPolyline? tripDirectionDetailsInfo;
String driverCartDetailsModel = "";
String driverCartDetailsNumber = "";
String driverCartDetailsType = "";
String driverCartDetailsColor = "";
String driverName = "";
String driverPhone = "";
String driverRatings = "";
double countRatingStars = 0.0;
String titleStarsRating = "";
String cloudMessagingServerToken = "";
List driversList = [];
double fareAmountCalculated = 0;
