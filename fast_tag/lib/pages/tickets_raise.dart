import 'dart:developer';
import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';

import 'package:fast_tag/pages/tickets_list.dart';
import 'package:fast_tag/utility/colorfile.dart';
import 'package:fast_tag/utility/snackbardesign.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/response/Helpresponse.dart';

class RaiseTicketsPage extends StatefulWidget {
  @override
  _RaiseTicketsPageState createState() => _RaiseTicketsPageState();
}

class _RaiseTicketsPageState extends State<RaiseTicketsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NetworkcallforHelplist();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    finallocationlist.clear();
  }

  String? selectedHelpTypeId;
  List<HelpData> finallocationlist = [];
  //List<HelpData> helplistData = [];

  Future<void> NetworkcallforHelplist() async {
    try {
      NetworkCall networkCall = NetworkCall();
      List<Object?>? list = await networkCall.getMethod(
          URLS().help_type_master_api, URLS().help_type_master_apiUrl, context);
      if (list != null) {
        List<Helpresponse> helplistResponse = List.from(list!);

        String? status = helplistResponse[0].status;
        switch (status) {
          case "true":
            finallocationlist = helplistResponse[0].data!;
            // finallocationlist.addAll(helplistData);
            setState(() {});
            break;
          case "false":
            finallocationlist = [];
            setState(() {});
            break;
        }
      } else {
        Navigator.pop(context);
        log('Something went wrong');
      }
    } catch (e) {
      Navigator.pop(context);
      log(e.toString());
    }
  }

  Future<void> addTickit(
      String agent_id, String description, String help_type_id) async {
    try {
      String raiseString = createjson()
          .ticketraiseresponseFromJson(agent_id, description, help_type_id);
      NetworkCall networkCall = NetworkCall();

      var ticketraiseresponse = await networkCall.postMethod(
        URLS().raise_ticket_api,
        URLS().raise_ticket_apiUrl,
        raiseString,
        context,
      );

      if (ticketraiseresponse != null) {
        List<dynamic>? responseData = List.from(ticketraiseresponse!);
        String status = responseData[0].status!;

        switch (status) {
          case "true":
            SnackBarDesign(
                "Ticket raised successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);

            // Clear Input
            _descriptionController.clear();
            Navigator.pop(context);
            break;

          case "false":
            SnackBarDesign(
                "Unable to raise ticket, Please try again!",
                context,
                colorfile().errormessagebcColor,
                colorfile().errormessagetxColor);

            break;
        }
      } else {
        print('Invalid response or null value');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Raise Tickets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, We are here to help',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 219, 213, 213)
                                .withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 252, 250, 250),
                            ),
                          ),
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        hint: Center(child: Text('Select Your Help Type')),
                        items: finallocationlist.map((HelpData helpData) {
                          return DropdownMenuItem<String>(
                            value: helpData.id, // Using helpTypeId as value
                            child: Text(helpData.helpType ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedHelpTypeId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a help type';
                          }
                          return null;
                        },
                        value: selectedHelpTypeId,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 219, 213, 213)
                                .withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 252, 250, 250),
                            ),
                          ),
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                        ),
                        minLines: 10,
                        maxLines: 15,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String id = prefs.getString('user_id') ?? '';

                    String description = _descriptionController.text;

                    // Validate form and add reply only if validation passes
                    if (_formKey.currentState!.validate()) {
                      if (selectedHelpTypeId != null) {
                        addTickit(id, description, selectedHelpTypeId!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a help type'),
                            duration: Duration(seconds: 5),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF0056D0),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RaiseTicketsPage(),
  ));
}
