import 'dart:async';

import 'package:fast_tag/api/response/validateotploginresponse.dart';
import 'package:fast_tag/pages/homeScreen.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/Loginresponse.dart';
import '../utility/colorfile.dart';
import '../utility/progressdialog.dart';
import '../utility/snackbardesign.dart';

class SignUpOtpPage extends StatefulWidget {
  final String otp, mobilenumber, pushtoken;

  SignUpOtpPage(this.otp, this.mobilenumber, this.pushtoken);

  @override
  _SignUpOtpPageState createState() => _SignUpOtpPageState();
}

class _SignUpOtpPageState extends State<SignUpOtpPage> {
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  int secondsRemaining = 40;
  bool enableResend = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.infinity,
            height: 400,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/succes.png', // Replace with your actual image path
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Congratulations',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your account is ready to use. You will\n be redirected to the Home page in\n a few seconds.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Delay redirecting to the home screen for 5 seconds
    Future.delayed(Duration(seconds: 3), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => MyDashboard()),
      // );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return MyDashboard();
        },
      ), (route) => false);
    });
  }

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(int index) {
    return SizedBox(
      width: 50,
      height: 45,
      child: TextField(
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify phone',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 5),
                // Text(
                //   'Please enter the 6 digit security code we just sent you at 222-444-XXXX',
                //   style: TextStyle(
                //     fontSize: 18,
                //   ),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RichText(
                      text: TextSpan(
                          text:
                              'Please enter the 6 digit security code we just sent you at ',
                          style: TextStyle(
                              color: Color(0xff3B4453),
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                          children: <TextSpan>[
                        TextSpan(
                            text: widget.mobilenumber.replaceRange(
                                6, widget.mobilenumber.length, 'XXXX'),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff3B4453)))
                      ])),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _buildTextField(index)),
                ),
                SizedBox(
                  height: 20,
                ),
                enableResend
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF0056D0).withOpacity(0.4),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Verify',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_controllers.isEmpty) {
                              SnackBarDesign(
                                  "Please enter OTP",
                                  context,
                                  colorfile().errormessagebcColor,
                                  colorfile().errormessagetxColor);
                            } else {
                              Networkcallforverifyotp();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF0056D0),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Verify',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    // 'Resend in $_resendTimer Sec',
                    'Resend in $secondsRemaining Sec',
                    style: TextStyle(
                        color: Color(0xff0056D0),
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
              alignment: Alignment.center,
              child: RichText(
                  text: TextSpan(
                      text: 'Didn’t receive the code? ',
                      style: TextStyle(
                          color: Color(0xff717784),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                    TextSpan(
                        text: "Resend ",
                        style: TextStyle(
                            color: Color(0xff0056D0),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Networkcallforresendotp();
                          })
                  ])))),
    );
  }

  Future<void> Networkcallforverifyotp() async {
    try {
      ProgressDialog.showProgressDialog(context, " title");
      String abc = "";
      for (var element in _controllers) {
        abc = abc + element.text;
      }
      print(abc);
      String assignfaasttag = createjson()
          .createjsonforverifyotplogin(widget.mobilenumber, abc, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().validate_agent_login_otp_api,
          URLS().validate_agent_login_otp_api_url,
          assignfaasttag,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Validateotploginresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            // SnackBarDesign(
            //     "OTP verify successfully!!",
            //     context,
            //     colorfile().sucessmessagebcColor,
            //     colorfile().sucessmessagetxColor);
            savevaluetosharedpref(widget.mobilenumber, response[0].data![0].id!,
                response[0].data![0].firstName!);
            break;
          case "false":
            SnackBarDesign(
                response[0].message!,
                context,
                colorfile().errormessagebcColor,
                colorfile().errormessagetxColor);
            break;
        }
      } else {
        Navigator.pop(context);
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  savevaluetosharedpref(String mobileNumber, String userId, String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('mobile_number', mobileNumber); // Set mobile number
      await prefs.setString('user_id', userId); // Set user ID
      await prefs.setString("Name", name);
      AppUtility.Mobile_Number = mobileNumber;
      AppUtility.Name = name;
      AppUtility.AgentId = userId;
      setState(() {});
      _showSuccessDialog(context);
    } catch (e) {
      print(e.toString());
    }
  }

  movetonext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyDashboard();
        },
      ),
    );
  }

  Future<void> Networkcallforresendotp() async {
    try {
      setState(() {
        secondsRemaining = 40;
        enableResend = false;
      });
      ProgressDialog.showProgressDialog(context, "");
      String profileString = createjson()
          .createJsonForLogin(widget.mobilenumber, widget.pushtoken);

      List<Object?>? loginResponse = await NetworkCall().postMethod(
          URLS().agent_login_api,
          URLS().agent_login_apiUrl,
          profileString,
          context);

      if (loginResponse != null) {
        Navigator.pop(context);
        List<Loginresponse>? responseData = List.from(loginResponse!);
        String status = responseData[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "OTP sent successfully", context, Colors.green, Colors.white);

            break;
          case "false":
            SnackBarDesign("Unable to send otp , Please try again", context,
                Colors.red, Colors.white);

            break;
        }
      } else {
        Navigator.pop(context);
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
