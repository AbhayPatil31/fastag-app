import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/Loginresponse.dart';
import 'package:fast_tag/pages/homeScreen.dart';
import 'package:fast_tag/pages/signUpOtp.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:fast_tag/utility/snackbardesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notification_services.dart';

String pushtoken = "";
NotificationServices notificationServices = NotificationServices();

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  String errormessage = "";
  bool validatemobilenumber = true;
  bool _isChecked = true; // State variable to store checkbox state
  bool loading = true;

  Future<void> login(String mobileNumber) async {
    try {
      ProgressDialog.showProgressDialog(context, "");
      String profileString =
          createjson().createJsonForLogin(mobileNumber, pushtoken);

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
            String userId = responseData[0].data![0].id!;

            SnackBarDesign(
                "OTP sent successfully", context, Colors.green, Colors.white);

            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return SignUpOtpPage(
                    responseData[0].otp!, mobileNumber, pushtoken);
              },
            ));
            break;
          case "false":
            SnackBarDesign(
                "No valid data received", context, Colors.red, Colors.white);

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

  @override
  void initState() {
    super.initState();
    notificationServices.getDevicetoken().then((value) {
      print('Device Token ${value}');
      pushtoken = value;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    validatemobilenumber = true;
    errormessage = "";
    _mobileController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start Your Safe Journey!',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 5),
              // Adding some space between the heading and the next row
              Row(
                children: [
                  Text(
                    'Create a new account',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 40), // Adding space before the text field
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 219, 213, 213)
                          .withOpacity(0.5), // Shadow color
                      spreadRadius: 3, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 3), // Offset in x and y directions
                    ),
                  ],
                ),
                child: TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  onChanged: (value) {
                    validatemobilenumber = true;
                    errormessage = "";
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: EdgeInsets.only(
                          right: 15), // Add margin to the right side
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Color.fromARGB(
                                255, 240, 230, 230), // Adjust color as needed
                            width: 1, // Adjust width as needed
                          ),
                        ),
                      ),
                      child: Icon(Icons.phone),
                      padding: EdgeInsets.only(
                          left: 10, right: 10), // Adjust padding as needed
                    ),
                    hintText: 'Enter Your Mobile Number',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffB7B7B7)),
                    errorText: validatemobilenumber ? null : errormessage,
                    border: OutlineInputBorder(), // Remove underline
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue), // Change border color on focus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(
                              255, 252, 250, 250)!), // Change border color
                    ),
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              SizedBox(height: 20), // Adding space before the checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isChecked, // Use the state variable here
                    onChanged: (value) {
                      // setState(() {
                      //   _isChecked = value!;
                      // });
                    },
                  ),
                  Flexible(
                    child: Text(
                      'A 6 digit security code will be sent via SMS to verify your mobile number!',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: ElevatedButton(
                    onPressed: () {
                      String mobileNumber = _mobileController.text;
                      validatemobilenumber = true;
                      errormessage = "";
                      if (mobileNumber.isEmpty) {
                        validatemobilenumber = false;
                        errormessage = "Please enter mobile number";
                        setState(() {});
                      } else if (mobileNumber.isPhoneNumber == false) {
                        validatemobilenumber = false;
                        errormessage = "Please enter valid mobile number";
                        setState(() {});
                      } else {
                        setState(() {});
                        login(mobileNumber);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF0056D0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5.0), // Button corner radius 5px
                        ),
                      ),
                    ),
                    child: Container(
                      width:
                          double.infinity, // Make button width match its parent
                      child: Center(
                        child: Text(
                          'Get OTP',
                          style: TextStyle(
                              color: Colors
                                  .white, // Set text color to white for better contrast
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}
