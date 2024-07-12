import 'dart:math';

import 'package:fast_tag/api/call/wallettransactionhistorycall.dart';
import 'package:fast_tag/api/response/paymentresponse.dart';
import 'package:fast_tag/api/response/wallettotalamountresponse.dart';
import 'package:fast_tag/api/response/wallettransactionhistoryresponse.dart';
import 'package:fast_tag/pages/amountdialog.dart';
import 'package:fast_tag/pages/recharge.dart';
import 'package:fast_tag/pages/skeletonpage.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast_tag/pages/assign_vehicle_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';

List<WallettotalamountDatum> wallenttotalamount = [];
List<WallettransactionhistoryDatum> wallettransactionlist = [];
bool nodata = true;

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforwalletamount();
    Networkcallforwallettransactionhistory(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    wallenttotalamount.clear();
    wallettransactionlist.clear();
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

  Future<void> Networkcallforwallettransactionhistory(bool showprogress) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, "title");
      }
      String createjsonforstocklist =
          createjson().createjsonforstocklist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().wallet_transaction_history_api,
          URLS().wallet_transaction_history_api_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Wallettransactionhistoryresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            wallettransactionlist = response[0].data!;
            if (wallettransactionlist.isNotEmpty) {
              nodata = true;
            } else {
              nodata = false;
            }
            setState(() {});
            break;
          case "false":
            nodata = false;
            setState(() {});
            // SnackBarDesign(
            //     response[0].message!,
            //     context,
            //     colorfile().errormessagebcColor,
            //     colorfile().errormessagetxColor);
            break;
        }
      } else {
        nodata = false;
        setState(() {});
        if (showprogress) {
          Navigator.pop(context);
        }
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
      ),
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 86, 208, 1),
                  Color.fromRGBO(0, 55, 133, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Summary',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      wallenttotalamount.isNotEmpty
                          ? wallenttotalamount[0].amount!
                          : '0',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return Amountdialog();
                      //   },
                      // ).then((value) {
                      //   Networkcallforwalletamount();
                      //   Networkcallforwallettransactionhistory(true);
                      // });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RechargePage("wallet")),
                      ).then((value) {
                        Networkcallforwalletamount();
                        Networkcallforwallettransactionhistory(true);
                      });
                    },
                    label: Text(
                      'Recharge Now',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide(
                        color: const Color.fromARGB(255, 192, 177, 177),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    icon: Icon(CupertinoIcons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(224, 236, 252, 1),
            ),
            padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    'Transaction History',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424752),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      // Handle button press
                    },
                    child: Container(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  Networkcallforwallettransactionhistory(false);
                });
              },
              child: wallettransactionlist.isEmpty
                  ? nodata
                      ? Skeleton()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: Lottie.asset(
                                  'images/nodatawithvehicle.json',
                                ),
                              ),
                              Text(
                                ' No transaction history found ',
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Looks like you haven't any transaction yet ",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                  : ListView.builder(
                      itemCount: wallettransactionlist.length,
                      itemBuilder: (context, index) {
                        return transactionCard(wallettransactionlist[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionCard(WallettransactionhistoryDatum wallettransactionlist) {
    String title = wallettransactionlist.transactionType == "1"
        ? 'Received From'
        : 'Send To';
    String amount = wallettransactionlist.transactionType == "1"
        ? '₹${wallettransactionlist.amount} Cr'
        : '₹${wallettransactionlist.amount} Dr';
    String type = wallettransactionlist.transactionType == "1"
        ? 'Credited to Wallet'
        : 'Debited to Wallet';
    DateTime createdOn = DateTime.now(); // Replace with your DateTime object
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(wallettransactionlist!.createdOn!);
    String formattedTime =
        DateFormat('hh:mm a').format(wallettransactionlist!.createdOn!);
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: Color(0xFFFFFFFF),
        elevation: 0.7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424752),
                    ),
                  ),
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424752),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'TXN ID  : ${wallettransactionlist.transcationId}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424752),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Balance : ₹  ${wallettransactionlist.walletBalance}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF424752),
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF424752),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF424752),
                        ),
                      ),
                      SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          'images/wallet.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
