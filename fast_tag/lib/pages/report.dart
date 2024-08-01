import 'package:fast_tag/pages/report_inssurance.dart';
import 'package:fast_tag/pages/report_pending.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/inssuancereportcounterboxresponse.dart';
import '../utility/apputility.dart';
import '../utility/colorfile.dart';
import '../utility/progressdialog.dart';
import '../utility/snackbardesign.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforcount(true);
  }

  IssuanceCount? countlist;

  int assignfastag = 0, approvedfastag = 0, requestfastag = 0, refill = 0;
  Future<void> Networkcallforcount(bool showprogress) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String createjsonforstocklist =
          createjson().createjsonforstocklist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().issusance_report_counter_box,
          URLS().issusance_report_counter_box_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Issusancereportcounterboxresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            countlist = response[0].data!;
            if (countlist != null) {
              assignfastag = int.parse(countlist!.assignFastag!);
              approvedfastag = int.parse(countlist!.approvedFastag!);
              requestfastag = int.parse(countlist!.requestedFastag!)!;
              refill = int.parse(countlist!.recharge!);
            }
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
    assignfastag = 0;
    approvedfastag = 0;
    requestfastag = 0;
    refill = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            Networkcallforcount(false);
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    // Blue border
                    color: Color.fromRGBO(0, 86, 208, 1),
                    child: Text(
                      'Issuance Report',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PendingIssuancePage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    color: Color.fromARGB(255, 236, 235,
                        235), // Background color for the second container
                    child: Text(
                      'Pending Issuance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCard('Assign Fastag', assignfastag, 1),
                            SizedBox(width: 10),
                            buildCard('Approved Fastag', approvedfastag, 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCard('Requested Fastag', requestfastag, 3),
                            SizedBox(width: 10),
                            buildCard('Rechargeissusance_report_counter_box',
                                refill, 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: 10.0, vertical: 10.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Row(
                //           // mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             buildCard('Pending', 30),
                //             SizedBox(width: 10),
                //             buildCard('Issuance', 60),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildCard(String text, int count, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportIssuancePage()),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFDFDCDC).withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
              // border: Border.all(color: Color(0xFF189CB1), width: 1.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$count', // Display comment count
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue),
                ),
                SizedBox(height: 5),
                Text(
                  text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
