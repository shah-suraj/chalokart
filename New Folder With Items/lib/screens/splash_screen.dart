import 'sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../Assistance/assistance_methods.dart';
import '../global/global.dart';
import '../utils/logger.dart';
import 'main_screen.dart';
import '../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(Duration(seconds: 3), () async {
      if (firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null
            ? AssistantMethods.readCurrentOnlineUserInfo()
            : null;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => MainScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => SignInScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Future<void> _initializeApp() async {
  //   // Short delay to show splash screen
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   if (!mounted) return;
  //
  //   _checkAuth();
  // }
  // Future<void> _checkAuth() async {
  //   try {
  //     AppLogger.info('Checking authentication status');
  //
  //     // Use our new auth service which handles SharedPreferences
  //     final isSignedIn = await _authService.isSignedInFromPrefs();
  //
  //     if (!mounted) return;
  //
  //     // Navigate based on auth status
  //     if (isSignedIn) {
  //       AppLogger.info('User is signed in, navigating to home');
  //       Navigator.of(context).pushReplacementNamed('/home');
  //     } else {
  //       AppLogger.info('User is not signed in, navigating to signin');
  //       Navigator.of(context).pushReplacementNamed('/signin');
  //     }
  //   } catch (e) {
  //     AppLogger.error('Error checking auth', e);
  //
  //     if (mounted) {
  //       // On error, go to sign in screen
  //       Navigator.of(context).pushReplacementNamed('/signin');
  //     }
  //   }
  // }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4CE5B1), Color(0xFF3AC598)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            'Chalo',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0,
                              fontFamily: 'Montserrat',
                              height: 0.8,
                            ),
                          ),
                          Positioned(
                            right: -30,
                            top: -20,
                            child: Icon(
                              Icons.near_me,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'KART',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0,
                      fontFamily: 'Montserrat',
                      height: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // const SizedBox(height: 5

              // Tagline
              const Text(
                "Your journey starts here",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),

              const SizedBox(height: 40),

              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
