import 'dart:async';

import 'package:fast_tag/api/response/validateotploginresponse.dart';
import 'package:fast_tag/pages/homeScreen.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
      List.generate(4, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  int secondsRemaining = 60;
  bool enableResend = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startResendOtpTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  /// Starts the resend OTP countdown timer
  void startResendOtpTimer() {
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
    });

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
        timer?.cancel();
      }
    });
  }

  /// Shows success dialog after OTP is verified successfully
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return MyDashboard();
        },
      ), (route) => false);
    });
  }

  /// Shows an error dialog with a custom message
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

  /// Builds the OTP input text field for a specific index
  Widget _buildTextField(int index) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        cursorColor: Color(0xFF08469D),
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "", // Hide the counter text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.transparent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF008357)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: (String value) {
          if (value.isNotEmpty && index < 3) {
            // Move focus to the next field if a value is entered
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            // Move focus to the previous field if the value is deleted
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
          // Check if all fields are filled to dismiss keyboard
          if (_controllers.every((controller) => controller.text.isNotEmpty)) {
            FocusScope.of(context).unfocus(); // Dismiss the keyboard
          }
        },
        onSubmitted: (_) {
          if (_controllers[index].text.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
        onEditingComplete: () {
          if (_controllers[index].text.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
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
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RichText(
                    text: TextSpan(
                      text:
                          'Please enter the 4 digit security code we just sent you at ',
                      style: GoogleFonts.inter(
                        color: Color(0xff3B4453),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.mobilenumber.replaceRange(
                            0,
                            widget.mobilenumber.length - 4,
                            'X' * (widget.mobilenumber.length - 2),
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff3B4453),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _buildTextField(index)),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_controllers
                          .every((controller) => controller.text.isNotEmpty)) {
                        Networkcallforverifyotp();
                      } else {
                        SnackBarDesign(
                            "Please enter complete OTP",
                            context,
                            colorfile().errormessagebcColor,
                            colorfile().errormessagetxColor);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors
                            .transparent, // Set background to transparent to show gradient
                      ),
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.transparent, // No shadow color
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero), // Remove padding
                    ),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF08469D),
                            Color(0xFF0056D0),
                            Color(0xFF0C92DD),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
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
                    'Resend in $secondsRemaining Sec',
                    style: TextStyle(
                        color: Color(0xff0056D0),
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 20),
                if (enableResend)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Networkcallforresendotp();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn’t receive the code? ",
                            style: TextStyle(
                                color: Color(0xff717784),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Color(0xff0056D0),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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
        _controllers
            .forEach((controller) => controller.clear()); // Clear OTP fields
        FocusScope.of(context).unfocus(); // Dismiss keyboard
        startResendOtpTimer(); // Restart timer
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
