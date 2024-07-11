import 'dart:math';

import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/paymentresponse.dart';
import '../api/response/wallettotalamountresponse.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';
import 'wallet.dart';

List<WallettotalamountDatum> wallenttotalamount = [];
final _amountcontroller = TextEditingController();
bool validateamount = true;

class RechargePage extends StatefulWidget {
  String pagefrom;
  RechargePage(this.pagefrom);
  State createState() => RechargePageState();
}

class RechargePageState extends State<RechargePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforwalletamount();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    wallenttotalamount.clear();
    _amountcontroller.clear();
    validateamount = true;
  }

  Future<void> Networkcallforwalletamount() async {
    try {
      _amountcontroller.clear();
      String createjsonforstocklist =
          createjson().createjsonforstocklist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().wallet_total_amount_api,
          URLS().wallet_total_amount_api_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        List<Wallettotalamountresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            wallenttotalamount = response[0].data!;
            setState(() {});
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
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the app bar
      appBar: AppBar(
        title: Text('Recharge/ Refill',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // Set the background image as the body
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/rechargeBackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundColor: Color.fromRGBO(
                    255, 255, 255, 1), // Set the background color
                backgroundImage: AssetImage('images/recharge.gif'),
              ),
              SizedBox(height: 30),
              // Text(
              //   '₹5,000',
              //   style: TextStyle(
              //     fontSize: 50, // Increase font size to 24
              //     fontWeight: FontWeight.bold, // Increase font weight to bold
              //     color: Colors.white,
              //   ),
              // ),
              Text(
                'Enter Your Amount',
                style: GoogleFonts.inter(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200, // Adjust the width as needed
                child: TextField(
                  controller: _amountcontroller,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,10}')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'RS.', // Add placeholder text
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    errorText:
                        validateamount ? null : "Please enter recharge amount",
                    errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                    filled: true,
                    fillColor: const Color(0xFF0056D1),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ), // Adjust the padding
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Existing Balance is Rs.${wallenttotalamount.isEmpty ? 0 : wallenttotalamount[0].amount}',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  if (_amountcontroller.text.isEmpty) {
                    validateamount = false;
                  } else {
                    rechargenow();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5), // Set border radius to 5px
                  ),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.inter(
                      fontSize: 18, color: Color.fromRGBO(1, 67, 121, 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  rechargenow() async {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_GA1PYehm4iMiCa',
      'amount': double.parse(_amountcontroller.text) * 100,
      'name': 'Shaurya Softrack',
      'description': '',
      'id': '${AppUtility.AgentId}_${Random().nextInt(100)})',
      'send_sms_hash': true,
      'prefill': {
        'contact': AppUtility.Mobile_Number,
      },
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  Future<void> Networkcallforupdatepaymentstatus(
      String paymentId,
      String amount,
      String paymentmode,
      String remark,
      String transactiontype) async {
    try {
      String craetejsonString = createjson().createjsonforupdatepaymentstatus(
          AppUtility.AgentId,
          amount,
          paymentmode,
          remark,
          transactiontype,
          paymentId,
          "1",
          context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().set_wallet_amount_api,
          URLS().set_wallet_amount_api_url,
          craetejsonString,
          context);
      if (list != null) {
        List<RechargeNowResponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "Recharge successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            if (widget.pagefrom == "wallet") {
              Navigator.pop(context);
            } else {
              Networkcallforwalletamount();
            }
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
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    print(response.data);

    Networkcallforupdatepaymentstatus(response.paymentId!,
        _amountcontroller.text, "2", "Payment Successful", "1");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
