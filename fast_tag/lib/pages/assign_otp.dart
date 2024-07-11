import 'dart:async';
import 'package:fast_tag/api/response/validateotpresponse.dart';
import 'package:fast_tag/pages/assign_customer_details.dart';
import 'package:fast_tag/pages/setvehicledetails.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/assignfasttagresponse.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';
import 'wallet.dart';

class AssignOtpPage extends StatefulWidget {
  String requestId, sessionId, mobilenumber, vehicalenumber;
  AssignOtpPage(
      this.requestId, this.sessionId, this.mobilenumber, this.vehicalenumber);

  @override
  _AssignOtpPageState createState() => _AssignOtpPageState();
}

class _AssignOtpPageState extends State<AssignOtpPage> {
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
      appBar: AppBar(
        title: Text('OTP Verification',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Image.asset(
                'images/assignOtp.png',
                height: 400,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OTP Verification',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D2024),
                        fontSize: 18,
                      )),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: RichText(
                        text: TextSpan(
                            text:
                                'Please enter the 6 digit security code we just sent you at ',
                            style: TextStyle(
                                color: Color(0xffA1A8B0),
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: widget.mobilenumber.replaceRange(
                                  6, widget.mobilenumber.length, 'XXXX'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff101623)))
                        ])),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        List.generate(6, (index) => _buildTextField(index)),
                  ),
                  SizedBox(height: 20),
                  enableResend
                      ? SizedBox(
                          height: 60,
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
                              height: 70,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Verify',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
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
                                    fontSize: 18.0,
                                  ),
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
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                    TextSpan(
                        text: "Resend ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
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
      String assignfaasttag = createjson().createjsonforverifyotp(abc,
          widget.requestId, widget.sessionId, widget.vehicalenumber, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().validate_otp_bajaj,
          URLS().validate_otp_bajaj_url,
          assignfaasttag,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Verifyotpresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "OTP verify successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            List<VerifyotpDatum> otpverifydata = response[0].data!;
            if (otpverifydata[0].engineNo == null ||
                otpverifydata[0].engineNo == "") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SetVehicleDetails(
                      widget.sessionId, widget.vehicalenumber),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDetailsPage(
                      widget.vehicalenumber, widget.sessionId),
                ),
              );
            }
            break;
          case "false":
            if (response[0].message ==
                "Low wallet amount, please recharge to proceed") {
              SnackBarDesign(
                  response[0].message!,
                  context,
                  colorfile().errormessagebcColor,
                  colorfile().errormessagetxColor);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return WalletPage();
                },
              ));
            } else {
              SnackBarDesign(
                  response[0].message!,
                  context,
                  colorfile().errormessagebcColor,
                  colorfile().errormessagetxColor);
            }
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

  Future<void> Networkcallforresendotp() async {
    try {
      ProgressDialog.showProgressDialog(context, "title");
      setState(() {
        secondsRemaining = 40;
        enableResend = false;
      });
      String assignfaasttag = createjson().createjsonforassignfasttag(
          widget.vehicalenumber, widget.mobilenumber, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().generate_otp_by_vehicle,
          URLS().generate_otp_by_vehicle_url,
          assignfaasttag,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Assignvehicleresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            widget.requestId = response[0].data![0].requestId!;
            widget.sessionId = response[0].data![0].sessionId!;
            setState(() {});
            SnackBarDesign(
                "OTP send on your mobile number",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);

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
}
