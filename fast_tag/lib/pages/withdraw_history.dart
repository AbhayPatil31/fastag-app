import 'package:fast_tag/api/response/getwithdrawresponse.dart';
import 'package:fast_tag/api/response/totalwithdrawamountresponse.dart';
import 'package:fast_tag/pages/withdraw_request.dart';
import 'package:flutter/material.dart';
import 'package:fast_tag/pages/assign_vehicle_details.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/apputility.dart';
import '../utility/colorfile.dart';
import '../utility/progressdialog.dart';
import '../utility/snackbardesign.dart';
import 'skeletonpage.dart';

List<GetwithdrawDatum> wallettransactionlist = [];
bool nodata = true;
String totalamount = "";

class WithdrawHistoryPage extends StatefulWidget {
  @override
  _WithdrawHistoryPageState createState() => _WithdrawHistoryPageState();
}

class _WithdrawHistoryPageState extends State<WithdrawHistoryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforwalletamount();
    Networkcallforwallettransactionhistory(true);
  }

  Future<void> Networkcallforwalletamount() async {
    try {
      //AppUtility.AgentId,
      String createjsonforstocklist =
          createjson().createjsonforstocklist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_total_withdra_amount,
          URLS().get_total_withdra_amount_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        List<Totalwithdrawamountresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            totalamount = response[0].data!.totalRequestedAmount!;
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
      wallettransactionlist.clear();
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, "title");
      }
      String createjsonforstocklist =
          createjson().createjsonforstocklist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_withdra_request,
          URLS().get_withdra_request_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Getwithdrawresponse> response = List.from(list!);
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      'Transaction Summary ',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '₹$totalamount',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WithdrawPage()),
                      ).then((value) {
                        Networkcallforwalletamount();
                        Networkcallforwallettransactionhistory(true);
                      });
                    },
                    icon: Icon(
                      Icons.file_download,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Withdraw',
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(66, 71, 82, 1),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      // Handle button press
                    },
                    child: Container(
                      child: Image.asset(
                        'images/list.png',
                        width: 20,
                        height: 20,
                        color: Color(0xFF424752),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 20.0),
          //       child: Column(
          //         children: [
          //           transactionCard(false), // For Send To
          //           transactionCard(true), // For Received From
          //           transactionCard(false), // For Send To
          //           transactionCard(true), // For Received From
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
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
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Looks like you haven't any transaction yet ",
                                style: TextStyle(
                                  fontSize: 16,
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
                        return transactionCard(
                            wallettransactionlist[index], false);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionCard(
      GetwithdrawDatum wallettransactionlist, bool isReceivedFrom) {
    String title = isReceivedFrom ? 'Received From' : 'Withdraw';
    String amount = isReceivedFrom ? '₹1,000 Cr' : '₹1,000 Dr';
    String type = isReceivedFrom ? 'Credited to Wallet' : 'Debited to Wallet';
    String status = "";
    if (wallettransactionlist.approveStatus == "1") {
      status = "Approved";
    } else if (wallettransactionlist.approveStatus == "2") {
      status = "Rejected";
    } else {
      status = "Pending";
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: Color(0xFFFFFFFF),
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
                    '₹ ' + wallettransactionlist.withdraAmount!,
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
                'TXN ID  : ${wallettransactionlist.requestNumber}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424752),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Request Status :  ' + status,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424752),
                ),
              ),
              // Text(
              //   'Total Requested Amount : ' +
              //       wallettransactionlist.withdraAmount!,
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xFF424752),
              //   ),
              // ),
              wallettransactionlist.approveStatus == "1"
                  ? Text(
                      '${status} Amount : ₹ ' +
                          wallettransactionlist.approvedAmount!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )
                  : Container(),
              wallettransactionlist.approveStatus == "2"
                  ? Text(
                      '${status} Amount : ' +
                          wallettransactionlist.approvedAmount!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )
                  : Container(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy hh:mm a')
                        .format(wallettransactionlist.createdOn!),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF424752),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       type,
                  //       style: TextStyle(
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w400,
                  //         color: Color(0xFF424752),
                  //       ),
                  //     ),
                  //     SizedBox(width: 5),
                  //     Icon(
                  //       Icons.account_balance_wallet,
                  //       size: 16,
                  //       color: Color(0xFF424752),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
