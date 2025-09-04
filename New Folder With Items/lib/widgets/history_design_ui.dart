import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chalo_kart_user/models/trips_history_model.dart';

class HistoryDesignUIWidget extends StatefulWidget {
  TripsHistoryModel? tripsHistoryModel;

  HistoryDesignUIWidget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}

class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget> {
  String formatDateAndTime(String? dateTimeFromDB) {
    if (dateTimeFromDB == null) return "No date available";
    try {
      DateTime dateTime = DateTime.parse(dateTimeFromDB);
      String formattedDateTime =
          "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
      return formattedDateTime;
    } catch (e) {
      return "Invalid date format";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatDateAndTime(widget.tripsHistoryModel?.time),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: darkTheme ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 15),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tripsHistoryModel?.driverName ?? "Unknown Driver",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Text(
                                widget.tripsHistoryModel?.ratings ?? "0.0",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Final Cost",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        " ₹${widget.tripsHistoryModel?.fareAmount ?? "0.0"}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.tripsHistoryModel?.status ?? "Unknown",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10),

              Divider(
                thickness: 3,
                color: Colors.grey[200],
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Text(
                    "TRIP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 15),

                      Text(
                        "${(widget.tripsHistoryModel?.originAddress ?? "Unknown Origin").substring(0, (widget.tripsHistoryModel?.originAddress?.length ?? 0) > 15 ? 15 : (widget.tripsHistoryModel?.originAddress?.length ?? 0))} ...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 15),

                      Text(
                        widget.tripsHistoryModel?.destinationAddress ?? "Unknown Destination",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
