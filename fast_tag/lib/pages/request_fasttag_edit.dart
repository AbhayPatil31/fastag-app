import 'package:fast_tag/api/call/editfasttagrequestcall.dart';
import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/response/editfasttagrequestresponse.dart';
import 'package:fast_tag/api/response/fasttagrequestlistresponse.dart';
import 'package:fast_tag/api/response/requestcategoryresponse.dart';
import 'package:fast_tag/pages/request_list.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../api/call/editfasttagrequestcall.dart' as editcategorycall;
import '../api/call/editfasttagrequestcall.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/categorydetailsresponse.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';
import '../api/call/categorydetailscall.dart' as categorycall;

// List<RequestcategoryDatum> requestcategory = [];

class EditRequestFastag extends StatefulWidget {
  String requestid;
  List<Detail> listofdetails;
  EditRequestFastag(this.requestid, this.listofdetails);
  State createState() => EditRequestFastagState();
}

class EditRequestFastagState extends State<EditRequestFastag> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //   Networkcallforwallettransactionhistory();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    listofcategory.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Request Fastag',
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
                      flex: 4,
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
                  ],
                ),
              ),

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
                    itemCount: widget.listofdetails.length,
                    itemBuilder: (context, index) {
                      // controllerfortext.putIfAbsent(
                      //     index, () => TextEditingController(text: null));
                      controllerfortext.addAll({
                        index: TextEditingController(
                            text: widget.listofdetails[index].requested)
                      });

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.blue.shade700),
                              bottom: BorderSide(color: Colors.blue.shade700),
                              left: BorderSide(
                                  width: 5,
                                  color: Color(hexStringToHexInt(widget
                                              .listofdetails[index]
                                              .vehicleColor ==
                                          null
                                      ? '000000'
                                      : widget.listofdetails[index]
                                          .vehicleColor!)))),
                        ),
                        child: Row(
                          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right:
                                        BorderSide(color: Colors.blue.shade700),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    widget.listofdetails[index].category_name ==
                                            null
                                        ? '-'
                                        : widget.listofdetails[index]
                                            .category_name!,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: controllerfortext[index],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none, // No border
                                  // hintText: 'Enter text', // Placeholder text
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0), // Optional padding
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Table Footer Row
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF0056D0)),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  color: Color(0xFF0056D0),
                ),
                //ShauryaPay
                child: GestureDetector(
                  onTap: () {
                    listofcategory.clear();
                    for (int i = 0; i < controllerfortext.length; i++) {
                      if (controllerfortext[i]!.value!.text.isNotEmpty) {
                        editcategorycall.Category abc =
                            editcategorycall.Category(
                                categoryId:
                                    widget.listofdetails[i].category_id!,
                                requested: controllerfortext[i]!.value!.text);
                        listofcategory.add(abc);
                      }
                    }
                    if (listofcategory.isNotEmpty) {
                      Networkcallforeditcategorydetails();
                    }

                    // Navigate to the second page
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              'Edit Request',
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

  var controllerfortext = <int, TextEditingController>{};
  hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  List<editcategorycall.Category> listofcategory = [];
  Future<void> Networkcallforeditcategorydetails() async {
    try {
      ProgressDialog.showProgressDialog(context, "title");
      String createjsonstring = createjson().createjsonforeditfasttagrequest(
          AppUtility.AgentId, listofcategory, widget.requestid, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().fastag_edit_request,
          URLS().fastag_edit_request_url,
          createjsonstring,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Editfasttagrequestresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "Request Edit Sucessfully!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            setState(() {});
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
        Navigator.pop(context);
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
