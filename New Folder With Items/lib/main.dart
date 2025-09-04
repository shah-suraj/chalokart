import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:chalo_kart_user/screens/splash_screen.dart';
import 'package:chalo_kart_user/infoHandler/app_info.dart';
import 'package:chalo_kart_user/screens/sign_in_screen.dart';
import 'package:chalo_kart_user/screens/main_screen.dart';
import 'package:chalo_kart_user/screens/splash_screen.dart';
import 'package:chalo_kart_user/themeProvider/theme_provider.dart';
import 'package:chalo_kart_user/utils/app_colors.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'ChaloKart User',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.32, 0.32, 1],
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor,
                  Color(0xFFF8F8F8),
                  Color(0xFFF8F8F8),
                ],
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
