import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/response/deletefasttagrequestresponse.dart';
import 'package:fast_tag/api/response/fasttagrequestlistresponse.dart';
import 'package:fast_tag/pages/request_complete.dart';
import 'package:fast_tag/pages/request_fasttag_edit.dart';
import 'package:fast_tag/pages/skeletonpage.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';

List<FasttagrequestlistDatum> fasttagrequestlist = [];
bool nodata = true;

class FastTagRequestListPage extends StatefulWidget {
  @override
  _FastTagRequestListPageState createState() => _FastTagRequestListPageState();
}

class _FastTagRequestListPageState extends State<FastTagRequestListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforfasttagrequestlist(true);
  }

  Future<void> Networkcallforfasttagrequestlist(bool showprogress) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, "");
      }
      String craetejsonString = createjson()
          .createjsonforgetfasttagrequestlist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_fastag_request_list_api,
          URLS().get_fastag_request_list_url,
          craetejsonString,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Fasttagrequestlistresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            fasttagrequestlist = response[0].data!;
            if (fasttagrequestlist.isEmpty) {
              nodata = false;
            } else {
              nodata = true;
            }
            setState(() {});
            break;
          case "false":
            nodata = false;
            setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Fastag Request List',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D2024),
            fontSize: 18,
          ),
        ),
      ),
      body: fasttagrequestlist.isEmpty
          ? nodata
              ? Skeleton()
              : Column(
                  children: [
                    Center(
                      child: Lottie.asset(
                        'images/nodatawithvehicle.json',
                      ),
                    ),
                    Text(
                      'No request found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Looks like you haven't requested fastag yet",
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
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  await Networkcallforfasttagrequestlist(false);
                  setState(() {}); // Refresh the UI after data is updated
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: fasttagrequestlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    Request request = fasttagrequestlist[index].request!;
                    return Card(
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
                              children: [
                                Text(
                                  'Request No.: ${request.requestNumber}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF424752),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Status:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF424752),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${request.requestStatus == "0" ? "Pending" : "Completed"}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: request.requestStatus == '0'
                                        ? Colors.red
                                        : (request.requestStatus == '1'
                                            ? Colors.green
                                            : Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: _buildNumberWidgets(
                                  fasttagrequestlist[index].details),
                            ),
                            SizedBox(height: 20),
                            if (request.requestStatus == '0')
                              _buildPendingButtons(request.id!,
                                  fasttagrequestlist[index].details!)
                            else if (request.requestStatus == '1')
                              _buildCompletedButton(request.id!),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildPendingButtons(String requestid, List<Detail> listofdetails) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 130, // Adjusted width
              height: 40, // Adjusted height
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF0056D0),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return EditRequestFastag(requestid, listofdetails);
                    },
                  )).then((value) {
                    Networkcallforfasttagrequestlist(true);
                  });
                },
                child: Text(
                  'Edit Request',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0056D0),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 40),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 140, // Adjusted width
              height: 40, // Adjusted height
              decoration: BoxDecoration(
                color: Color(0xFF0056D0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextButton(
                onPressed: () {
                  Networkcallfordeletefasttagrequestlist(requestid);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedButton(String requestid) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 130, // Adjusted width
              height: 40, // Adjusted height
            ),
          ),
        ),
        SizedBox(width: 40),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 140, // Adjusted width
              height: 40, // Adjusted height
              decoration: BoxDecoration(
                color: Color(0xFF0056D0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompletePage(requestid)),
                  );
                },
                child: Text(
                  'View',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildNumberWidgets(List<Detail>? details) {
    List<Widget> widgets = [];
    for (int i = 0; i < details!.length; i += 3) {
      List<Detail> rowNumbers = details!.skip(i).take(3).toList();
      widgets.add(Row(
        children: rowNumbers.map((number) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 6),
            decoration: BoxDecoration(
              color: Color(number.vehicleColor == null
                  ? 0xff000000
                  : hexStringToHexInt(number.vehicleColor!)),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Text(
                  "Tag Class",
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                const SizedBox(
                  height: 9,
                ),
                Center(
                  child: Text(
                    number.requested!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ));
    }
    return widgets;
  }

  hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  Future<void> Networkcallfordeletefasttagrequestlist(String id) async {
    try {
      ProgressDialog.showProgressDialog(context, "title");
      String craetejsonString = createjson()
          .createjsondeletefasttagrequestlist(AppUtility.AgentId, id, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().delete_requested_fastag,
          URLS().delete_requested_fastag_url,
          craetejsonString,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Deletefastagrequestresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            Networkcallforfasttagrequestlist(false);
            break;
          case "false":
            nodata = false;
            setState(() {});
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
