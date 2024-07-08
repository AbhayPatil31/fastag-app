import 'dart:async';

import 'package:fast_tag/pages/onboardingScreen1.dart';
import 'package:fast_tag/pages/signUp.dart';
import 'package:flutter/material.dart';

class OnboardingLast extends StatefulWidget {
  const OnboardingLast({Key? key}) : super(key: key);

  @override
  State<OnboardingLast> createState() => _OnboardingLastState();
}

class _OnboardingLastState extends State<OnboardingLast> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'images/bgimg.jpg'), // Replace 'path_to_your_background_image.png' with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (int page) {
            setState(() {
              currentPage = page;
            });
          },
          children: <Widget>[
            _buildPage(
              imagePath: 'images/slider3.png',
              title: 'Effortless Payment',
              subtitle: 'Settlement for Agents',
              description:
                  'Link your bank account and we\'ll automatically recharge your FASTag whenever required.',
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75.0), // Adjust the radius as needed
                topRight: Radius.circular(75.0), // Adjust the radius as needed
              ),
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
                  ),
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
                                builder: (context) => SignUpPage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF0056D0),
                          ),
                        ),
                        child: Text(
                          'Get Started',
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageq({
    required String imagePath,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                //  padding: EdgeInsets.only(bottom: 0.0),
                child: Image.asset(
                  imagePath,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            //  margin: EdgeInsets.only(top: 60.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75.0), // Adjust the radius as needed
                topRight: Radius.circular(75.0), // Adjust the radius as needed
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF0056D0),
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
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return SignUpPage();
                            },
                          ));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF0056D0),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0, // Set the font size
                            fontWeight: FontWeight.bold, // Set the font weight
                          ),
                        ),
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
