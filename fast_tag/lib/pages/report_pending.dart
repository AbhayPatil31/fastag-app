import 'package:fast_tag/api/response/cancelpendingissuanceresponse.dart';
import 'package:fast_tag/api/response/pendingissuanceresponse.dart';
import 'package:fast_tag/pages/assign_fastag.dart';
import 'package:fast_tag/pages/assign_fastag_retry.dart';
import 'package:fast_tag/pages/skeletonpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/apputility.dart';
import '../utility/colorfile.dart';
import '../utility/progressdialog.dart';
import '../utility/snackbardesign.dart';

class PendingIssuancePage extends StatefulWidget {
  @override
  _PendingIssuancePageState createState() => _PendingIssuancePageState();
}

class _PendingIssuancePageState extends State<PendingIssuancePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforpendingissuance(true);
  }

  List<PendingissuanceDatum> pendingissuancelist = [];
  bool nodata = true;
  Future<void> Networkcallforpendingissuance(bool showprogress) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String createjsonforstocklist =
          createjson().createjsonforstocklist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_issusance_report_pending,
          URLS().get_issusance_report_pending_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Pendingissuanceresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            pendingissuancelist = response[0].data!;
            if (pendingissuancelist.isEmpty) {
              nodata = false;
            } else {
              nodata = true;
            }
            setState(() {});
            break;
          case "false":
            nodata = true;
            setState(() {});
            SnackBarDesign(
                response[0].message!,
                context,
                colorfile().errormessagebcColor,
                colorfile().errormessagetxColor);
            break;
        }
      } else {
        nodata = true;
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
    pendingissuancelist.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Pending Issuances',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              Networkcallforpendingissuance(false);
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              pendingissuancelist.isEmpty
                  ? nodata
                      ? Expanded(child: Skeleton())
                      : Column(
                          children: [
                            Center(
                              child: Lottie.asset(
                                'images/nodatawithvehicle.json',
                              ),
                            ),
                            Text(
                              ' No pending issuance found ',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Looks like you haven't any issuance yet ",
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
                        )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: pendingissuancelist
                            .length, // Change this to the number of cards you want
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Card(
                              color: Color(0xFFFFFFFF),
                              elevation: 0.7,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors
                                      .blue, // Add blue color to the border
                                  width: 2.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Mobile Number  :  ${pendingissuancelist[index].mobileNumber}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF424752),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  'VRN Number  :   ${pendingissuancelist[index].vehicleNumber}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF424752),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    'Name  :  ${pendingissuancelist[index].name} ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF424752),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0,
                                                horizontal:
                                                    0), // Adjust the padding as needed
                                            child: InkWell(
                                              onTap: () {
                                                _showRetryConfirmationDialog(
                                                    context,
                                                    pendingissuancelist[index]
                                                        .mobileNumber!,
                                                    pendingissuancelist[index]
                                                        .vehicleNumber!);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: Colors
                                                          .blue, // Specify your desired color here
                                                      width:
                                                          2.0, // Specify the width of the border
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft: Radius.circular(
                                                        10.0), // Adjust the radius as needed
                                                  ),
                                                ),
                                                height: 50,
                                                // Set your desired background color
                                                child: Center(
                                                  child: Text(
                                                    'Retry',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xFF424752),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                0.0), // Adjust the padding as needed
                                            child: InkWell(
                                              onTap: () {
                                                _showCancelConfirmationDialog(
                                                    context,
                                                    pendingissuancelist[index]
                                                        .id!);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      0, 86, 208, 1),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                  ),
                                                ),
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 0),
                                                child: Center(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          236, 237, 240, 1),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> Networkcallforcancelpendingissuance(
      bool showprogress, String id) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String createjsonforstocklist =
          createjson().createjsoncancelpendingissuance(id, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().cancel_issusance_report_pending,
          URLS().cancel_issusance_report_pending_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Cancelpendingissuanceresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "Issuance cancel successfully!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            Networkcallforpendingissuance(true);
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

  void _showRetryConfirmationDialog(
      BuildContext context, String mobileNumber, vehicleNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                ClipRect(
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Retry",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 86, 208, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300], // Horizontal gray line
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Are you sure you want to retry?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              // Use Expanded for Cancel button
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the modal
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.resolveWith<
                                      BorderSide>(
                                    (Set<MaterialState> states) {
                                      return BorderSide(
                                          color:
                                              Colors.grey[300]!); // Gray border
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 50), // Adjust spacing between buttons
                            Expanded(
                              // Use Expanded for Yes, logout button
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return AssignFastagRetryPage(
                                          mobileNumber, vehicleNumber);
                                    },
                                  ));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromRGBO(
                                        0, 86, 208, 1), // Blue background
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCancelConfirmationDialog(BuildContext context, String id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                ClipRect(
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 86, 208, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300], // Horizontal gray line
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Are you sure you want to cancel?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              // Use Expanded for Cancel button
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the modal
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.resolveWith<
                                      BorderSide>(
                                    (Set<MaterialState> states) {
                                      return BorderSide(
                                          color:
                                              Colors.grey[300]!); // Gray border
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 50), // Adjust spacing between buttons
                            Expanded(
                              // Use Expanded for Yes, logout button
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Networkcallforcancelpendingissuance(true, id);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromRGBO(
                                        0, 86, 208, 1), // Blue background
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
