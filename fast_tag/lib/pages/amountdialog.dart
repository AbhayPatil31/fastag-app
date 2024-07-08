import 'dart:math';

import 'package:fast_tag/utility/colorfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/paymentresponse.dart';
import '../utility/apputility.dart';
import '../utility/snackbardesign.dart';

final amountcontroller = TextEditingController();
bool validateamount = true;
String erroramount = "Please enter amount";

class Amountdialog extends StatefulWidget {
  State createState() => AmountdialogState();
}

class AmountdialogState extends State<Amountdialog> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 35,
                  width: 25,
                ),
                // Lottie.asset("assets/images/done.json", height: 100),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Amount',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff101623)),
                ),
                SizedBox(
                  height: 10,
                ),
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
                    controller: amountcontroller,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,10}')),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter amount*',
                      errorText: validateamount ? null : erroramount,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 10),
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
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      //  width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (amountcontroller.text.isEmpty) {
                            validateamount = false;
                            erroramount = "Please enter amount";
                          } else {
                            rechargenow();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF0056D0),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Button corner radius 5px
                            ),
                          ),
                        ),
                        child: Container(
                          // width: double
                          //     .infinity, // Make button width match its parent
                          child: Center(
                            child: Text(
                              'Proceed',
                              style: TextStyle(
                                color: Colors
                                    .white, // Set text color to white for better contrast
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 76,
                )
              ],
            ),
          )),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    print(response.data);

    Networkcallforupdatepaymentstatus(response.paymentId!,
        amountcontroller.text, "2", "Payment Successful", "1");
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

  rechargenow() async {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_GA1PYehm4iMiCa',
      'amount': double.parse(amountcontroller.text) * 100,
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
            //  List<RechargeNowDatum> rechargenowresponse = response[0].data!;
            SnackBarDesign(
                "Recharge successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            Navigator.pop(context);
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
}
