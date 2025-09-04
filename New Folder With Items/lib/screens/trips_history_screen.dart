import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chalo_kart_user/infoHandler/app_info.dart';
import 'package:chalo_kart_user/Assistance/assistance_methods.dart';

import '../Assistance/assistance_methods.dart';
import '../widgets/history_design_ui.dart';

class TripsHistoryScreen extends StatefulWidget {
  const TripsHistoryScreen({super.key});

  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Clear existing history list
    Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.clear();
    // Load trip history data
    AssistantMethods.readTripsKeysForOnlineUser(context);
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: darkTheme ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
        title: Text(
          "Trips History",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkTheme ? Colors.green.shade400 : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: darkTheme ? Colors.amber.shade400 : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Consumer<AppInfo>(
          builder: (context, appInfo, child) {
            return ListView.separated(
              itemBuilder: (context, i) {
                return Card(
                  color: darkTheme ? Colors.black : Colors.grey[100],
                  shadowColor: Colors.transparent,
                  child: HistoryDesignUIWidget(
                    tripsHistoryModel: appInfo.allTripsHistoryInformationList[i],
                  ),
                );
              },
              separatorBuilder: (context, i) => SizedBox(height: 30),
              itemCount: appInfo.allTripsHistoryInformationList.length,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
            );
          }
        ),
      ),
    );
  }
}
