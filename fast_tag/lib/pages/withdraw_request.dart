import 'package:fast_tag/api/response/setwithdrawresponse.dart';
import 'package:fast_tag/pages/amountdialog.dart';
import 'package:fast_tag/pages/withdraw_history.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/wallettotalamountresponse.dart';
import '../utility/colorfile.dart';
import '../utility/progressdialog.dart';
import '../utility/snackbardesign.dart';

List<WallettotalamountDatum> wallenttotalamount = [];
final _amountcontroller = TextEditingController();
bool validateamount = true;
String errormessage = "Please enter withdraw amount";

class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
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
  }

  Future<void> Networkcallforwalletamount() async {
    try {
      //AppUtility.AgentId,
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
        title: Text('Withdrawal'),
        backgroundColor: Colors.transparent,
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
              SizedBox(height: 20),
              CircleAvatar(
                radius: 100,
                backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                backgroundImage: AssetImage('images/wallet.gif'),
              ),
              SizedBox(height: 35),
              Text(
                'Enter Your Amount',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200, // Adjust the width as needed
                child: TextField(
                  controller: _amountcontroller,
                  onChanged: (value) {
                    if (value != null) {
                      if (int.parse(value) >
                          int.parse(wallenttotalamount[0].amount!)) {
                        validateamount = false;
                        errormessage =
                            "Withdraw amount must  less than available balance";
                        setState(() {});
                      } else {
                        validateamount = true;
                        errormessage = "";
                        setState(() {});
                      }
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,10}')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'RS.', // Add placeholder text
                    border: OutlineInputBorder(),
                    errorText: validateamount ? null : errormessage,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 1),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ), // Adjust the padding
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              wallenttotalamount.isEmpty
                  ? Text(
                      '₹0',
                      style: TextStyle(
                        fontSize: 30, // Increase font size to 24
                        fontWeight:
                            FontWeight.bold, // Increase font weight to bold
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '₹${wallenttotalamount[0].amount}',
                      style: TextStyle(
                        fontSize: 30, // Increase font size to 24
                        fontWeight:
                            FontWeight.bold, // Increase font weight to bold
                        color: Colors.white,
                      ),
                    ),
              SizedBox(height: 10),
              Text(
                'Available Balance',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_amountcontroller.text.isEmpty) {
                    validateamount = false;
                    setState(() {});
                  } else {
                    Networkcallforwithdraw(true);
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
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(1, 67, 121, 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> Networkcallforwithdraw(bool showprogress) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String createjsonforstocklist = createjson()
          .createjsonforsetwithdrarequest(
              AppUtility.AgentId, _amountcontroller.text, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().set_withdra_request,
          URLS().set_withdra_request_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Setwithdrawresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "Amount withdraw successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);

            setState(() {});
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => WithdrawHistoryPage(),
            //   ),
            // );
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
        if (showprogress) {
          Navigator.pop(context);
        }
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
