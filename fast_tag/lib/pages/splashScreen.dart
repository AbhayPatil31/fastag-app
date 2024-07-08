import 'package:fast_tag/pages/homeScreen.dart';
import 'package:fast_tag/pages/onboardingScreen1.dart';
import 'package:fast_tag/pages/signUp.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../notification_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NotificationServices().requestNotificationPermission(context);
    notificationServices.getDevicetoken().then((value) {
      print('Device Token ${value}');
      pushtoken = value;
    });
    Future.delayed(Duration(seconds: 3), () async {});
    getvaluefromsharedpref();
  }

  getvaluefromsharedpref() async {
    SharedPreferences idsaver = await SharedPreferences.getInstance();
    AppUtility.Mobile_Number = idsaver.getString('mobile_number') ?? '';
    AppUtility.AgentId = idsaver.getString('user_id') ?? '';
    AppUtility.isloginfirst = idsaver.getString("isloginfirst") ?? '';
    AppUtility.Name = idsaver.getString("Name") ?? '';
    setState(() {});
    movenext();
  }

  movenext() {
    if (AppUtility.Mobile_Number != "") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyDashboard(),
        ),
      );
    } else {
      if (AppUtility.isloginfirst == "1") {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return SignUpPage();
          },
        ));
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Onboarding(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Image.asset(
            'images/splashScreen.png',
            fit: BoxFit.cover,
          ),
          // Center Logo Image
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  // Adjust the width and height of the logo image as needed
                  width: 400,
                  height: 400,
                ),
                SizedBox(height: 20),
                // You can uncomment the CircularProgressIndicator if needed
                // CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
