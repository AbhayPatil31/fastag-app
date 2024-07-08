import 'dart:async';
import 'package:fast_tag/pages/onboardingScreen2.dart';
import 'package:fast_tag/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/colorfile.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    savevaluetosharedpref();
  }

  savevaluetosharedpref() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('isloginfirst', "1");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bgimg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (int page) {},
          children: <Widget>[
            _buildPage(
              imagePath: 'images/slider1.png',
              title: 'Welcome to!',
              subtitle: 'Shaurya Softrack',
              description:
                  'Just fill in your basic details, add vehicle number,\nchoose a payment method and you are done.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String imagePath,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Column(
      children: <Widget>[
        Expanded(
          //   flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  imagePath,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          //  flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF4A4E53),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF0056D0),
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  description,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingScreen(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF0056D0),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return SignUpPage();
                          },
                        ));
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: colorfile().buttoncolor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
