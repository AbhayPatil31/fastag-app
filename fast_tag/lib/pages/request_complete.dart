import 'package:fast_tag/api/response/completerequestresponse.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast_tag/pages/request_list.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart'; // Import your FastTagRequestListPage if needed

List<CompletefasttagrequestDatum> completedrequest = [];

class CompletePage extends StatefulWidget {
  String requestid;
  CompletePage(this.requestid);
  State createState() => CompletePageState();
}

class CompletePageState extends State<CompletePage> {
  Future<void> Networkcallforcompletedrequestlist() async {
    try {
      ProgressDialog.showProgressDialog(context, "title");
      String craetejsonString = createjson()
          .createjsonforcompletefasttagrequestcall(
              AppUtility.AgentId, widget.requestid, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_request_completed_api,
          URLS().get_request_completed_api_url,
          craetejsonString,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Completefasttagrequestresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            completedrequest = response[0].data!;
            for (int i = 0; i < completedrequest.length; i++) {
              totalrequestcount =
                  totalrequestcount + int.parse(completedrequest[i].requested!);

              totalapproedcount = totalapproedcount +
                  (completedrequest[i].approved == null
                      ? 0
                      : int.parse(completedrequest[i].approved));
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
        Navigator.pop(context);
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforcompletedrequestlist();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    completedrequest.clear();
    totalrequestcount = 0;
    totalapproedcount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Completed Fastag',
            style: TextStyle(fontWeight: FontWeight.w500)),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Header Row
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade700),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  // color: Colors.blue,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Tag Class',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0056D0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Request',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0056D0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.0,
                      height: 50,
                      color: Colors.blue, // Replace with your desired color
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Approved',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0056D0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Table Row 1
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.blue.shade700),
                      right: BorderSide(color: Colors.blue.shade700),
                      bottom: BorderSide(color: Colors.blue.shade700),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: completedrequest.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right:
                                      BorderSide(color: Colors.blue.shade700),
                                  bottom:
                                      BorderSide(color: Colors.blue.shade700),
                                  left: BorderSide(color: Colors.blue.shade700),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Text(
                                  completedrequest[index].categoryName!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.blue.shade700),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Text(
                                    completedrequest[index].requested == null
                                        ? '-'
                                        : completedrequest[index].requested!),
                              ),
                            ),
                          ),
                          Container(
                            width: 1.0,
                            height: 70,
                            color:
                                Colors.blue, // Replace with your desired color
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.blue.shade700),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Text(
                                    completedrequest[index].approved == null
                                        ? "0"
                                        : completedrequest[index].approved),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF0056D0)),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  color: Color(0xFF0056D0),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              'Total Tags',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              totalrequestcount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              totalapproedcount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int totalrequestcount = 0, totalapproedcount = 0;
  var controllerfortext = <int, TextEditingController>{};
  hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }
}
