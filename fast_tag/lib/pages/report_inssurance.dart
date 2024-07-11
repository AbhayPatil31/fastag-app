import 'package:fast_tag/api/response/getassigntagwisedresponse.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/colorfile.dart';
import '../utility/progressdialog.dart';
import '../utility/snackbardesign.dart';
import 'skeletonpage.dart';

String fromdate = "From Date", todate = "To Date";
DateTime _pickedfromdate = DateTime.now();
List<GetassignedtagdatewisDatum> assigntagdatewiselist = [];
bool nodata = true;

class ReportIssuancePage extends StatefulWidget {
  State createState() => ReportIssuancePageState();
}

class ReportIssuancePageState extends State<ReportIssuancePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromdate = "From Date";
    todate = "To Date";
    Networkcallforcount(true, "", "");
  }

  Future<void> Networkcallforcount(
      bool showprogress, String fromdate, String todate) async {
    assigntagdatewiselist.clear();
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String createjsonforstocklist =
          createjson().createjsongetassigntag(fromdate, todate, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_assigned_tag_date_wise,
          URLS().get_assigned_tag_date_wise_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Getassignedtagdatewiseresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            assigntagdatewiselist = response[0].data!;
            if (assigntagdatewiselist.isEmpty) {
              nodata = false;
            } else {
              nodata = true;
            }
            setState(() {});
            break;
          case "false":
            assigntagdatewiselist = [];
            nodata = false;
            setState(() {});
            SnackBarDesign(
                "No assign fastag available",
                context,
                colorfile().errormessagebcColor,
                colorfile().errormessagetxColor);
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
    fromdate = "";
    todate = "";
    assigntagdatewiselist.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text('Issuance Report',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Filter by Date',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40, // Decrease height of text input
                    child: GestureDetector(
                      onTap: () async {
                        todate = "";
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          String day = pickedDate.day.toString();
                          String month = pickedDate.month.toString();
                          String year = pickedDate.year.toString();
                          String date = day + '/' + month + '/' + year;
                          _pickedfromdate = pickedDate;
                          fromdate = date;
                          setState(() {});
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              fromdate,
                              // textAlign: TextAlign.center,
                            ),
                          )),
                      // child: TextField(
                      //   readOnly: true,
                      //   enabled: true,
                      //   decoration: InputDecoration(
                      //     labelText: 'From Date',
                      //     border: OutlineInputBorder(
                      // borderSide:
                      //     BorderSide(color: Colors.blue), // Blue outline
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //           color: Colors.blue), // Blue focused border
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40, // Decrease height of text input
                    child: GestureDetector(
                      onTap: () async {
                        if (fromdate == "From Date") {
                          SnackBarDesign(
                              "Please select from date first",
                              context,
                              colorfile().errormessagebcColor,
                              colorfile().errormessagetxColor);
                        } else {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: _pickedfromdate,
                              lastDate: DateTime.now());

                          if (pickedDate != null) {
                            String day = pickedDate.day.toString();
                            String month = pickedDate.month.toString();
                            String year = pickedDate.year.toString();
                            String date = day + '/' + month + '/' + year;
                            todate = date;
                            setState(() {});
                            Networkcallforcount(true, fromdate, todate);
                          }
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              todate,
                              // textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today,
                      color: Colors.blue), // Blue icon
                  onPressed: () {
                    // Add your calendar logic here
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          assigntagdatewiselist.isEmpty
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
                          ' No assign tag found ',
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
                  child: RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(const Duration(seconds: 1), () {
                        if (fromdate == "From Date" ||
                            todate == "To Date" ||
                            todate == "") {
                          fromdate = "From Date";
                          todate = "To Date";
                          setState(() {});
                          Networkcallforcount(false, "", "");
                        } else {
                          Networkcallforcount(false, fromdate, todate);
                        }
                      });
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                          itemCount: assigntagdatewiselist.length,
                          itemBuilder: (context, index) {
                            return CardWidget(
                                context, assigntagdatewiselist[index]);
                          },
                        )),
                  ),
                ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

Widget CardWidget(
    BuildContext context, GetassignedtagdatewisDatum assigntagdatewiselist) {
  return Card(
    color: Color.fromRGBO(255, 255, 255, 1),
    elevation: 0.7,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  'Name         : ${assigntagdatewiselist.name ?? '-'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF424752),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  'Barcode     :  ${assigntagdatewiselist.serialNo ?? '-'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF424752),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  'VRN            : ${assigntagdatewiselist.vehicleNumber ?? '-'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF424752),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  'Created On : ${DateFormat('dd/MM/yyyy').format(assigntagdatewiselist.createdOn!)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF424752),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 150,
          decoration: BoxDecoration(
            color: Color(0xFF0056D0),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  '${assigntagdatewiselist.createdOn!.day}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
