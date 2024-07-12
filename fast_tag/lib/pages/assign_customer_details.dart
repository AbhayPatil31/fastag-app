import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fast_tag/api/response/addcustomerdetailsresponse.dart';
import 'package:fast_tag/api/response/agentplanresponse.dart';
import 'package:fast_tag/pages/UpperCaseTextInputFormatter%20.dart';
import 'package:fast_tag/pages/assign_vehicle_details.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';

final _namecontroller = TextEditingController();
final _lastnamecontroller = TextEditingController();

final _dobcontroller = TextEditingController();
final _idnumbercontroller = TextEditingController();
final _idcontroller = TextEditingController();
final _expdatecontroller = TextEditingController();
String? selectedvalue, idselectedValue;
List<AgentplanDatum> agentplan = [];
String? agentplanselectedValue;
final TextEditingController textEditingControlleragentplan =
    TextEditingController();
List<String> idprooflist = [];

class CustomerDetailsPage extends StatefulWidget {
  String vehiclenumber, sessionId;
  CustomerDetailsPage(this.vehiclenumber, this.sessionId);
  State createState() => CustomerDetailsPageState();
}

class CustomerDetailsPageState extends State<CustomerDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setvalue();
    Networkcallforagentplan();
  }

  setvalue() {
    idprooflist.clear();
    idprooflist.add('Pan Card');
    idprooflist.add('Driving Licence');
    idprooflist.add('Voter Id');
    idprooflist.add('Passport');
    setState(() {});
  }

  Future<void> Networkcallforagentplan() async {
    try {
      String vehiclemakerlist =
          createjson().createjsonforplan(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_agent_plan,
          URLS().get_agent_plan_url,
          vehiclemakerlist,
          context);
      if (list != null) {
        List<Agentplanresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            agentplan = response[0].data!;

            setState(() {});
            break;
          case "false":
            SnackBarDesign(
                "No agent plan available",
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _namecontroller.clear();
    _lastnamecontroller.clear();
    _dobcontroller.clear();
    _idcontroller.clear();
    _idnumbercontroller.clear();
    idprooflist.clear();
    agentplan.clear();
    _expdatecontroller.clear();
    idselectedValue = null;
    selectedvalue = null;
    agentplanselectedValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Details',
          style: GoogleFonts.inter(
            color: Color(0xFF1D2024),
            fontSize: 18, // 25px size
            fontWeight: FontWeight.w600, // Bold text
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color.fromARGB(
                  255, 176, 206, 245), // Background color for the row
              padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Customer Details',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D2024),
                        fontSize: 16,
                      )),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    // Replace 'assets/profile_image.jpg' with your actual profile image asset
                    backgroundImage: AssetImage('images/man.png'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 50), // Adding space before the input fields

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter Your Details',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D2024),
                          fontSize: 15,
                        )),
                    SizedBox(height: 15),
                    firstnamewidget(),
                    lastnamewidget(),
                    dobwidget(),
                    idprofselectwidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    idselectedValue == "2" || idselectedValue == "4"
                        ? expwidget()
                        : Container(),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    idnumberwidget(),
                    planselectwidget(),
                    // rcImage(),
                    // vehicleImage(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30), // Adding space before the button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 50,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF08469D),
                      Color(0xFF0056D0),
                      Color(0xFF0C92DD),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Implement button onPressed
                    validatefields();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors
                          .transparent, // Set background to transparent to show gradient
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(
                      Colors.transparent, // No shadow color
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Container(
                    height: 60,
                    width:
                        double.infinity, // Make button width match its parent
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors
                              .white, // Set text color to white for better contrast
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget firstnamewidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _namecontroller,
        onChanged: (value) {
          validatecustomername = true;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Enter First Name*',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          errorText: validatecustomername ? null : errorforname,
          errorStyle: TextStyle(color: Colors.red, fontSize: 10),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 252, 250, 250)!),
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget lastnamewidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _lastnamecontroller,
        onChanged: (value) {
          validatecustomername = true;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Enter Last Name*',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          errorText: validatecustomername ? null : errorforname,
          errorStyle: TextStyle(color: Colors.red, fontSize: 10),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 252, 250, 250)!),
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget dobwidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _dobcontroller,
        onChanged: (value) {
          validatedob = true;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Date Of Birth*',
          errorText: validatedob ? null : errorfordob,
          errorStyle: TextStyle(color: Colors.red, fontSize: 10),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 252, 250, 250)!),
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: GestureDetector(
            onTap: () async {
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
                _dobcontroller.text = date;
                setState(() {
                  // expensedate = pickedDate;
                });
              }
            },
            child: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Widget idprofselectwidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          // margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Select ID Proof*',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: idprooflist
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),

              value: selectedvalue,
              onChanged: (value) {
                validateidprof = true;
                setState(() {
                  selectedvalue = value;
                });
                if (selectedvalue == "Voter Id") {
                  idselectedValue = "3";
                } else if (selectedvalue == "Pan Card") {
                  idselectedValue = "1";
                } else if (selectedvalue == "Driving Licence") {
                  idselectedValue = "2";
                } else if (selectedvalue == "Passport") {
                  idselectedValue = "4";
                }
              },
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 400,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: _idcontroller,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: _idcontroller,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search for id proof name',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value.toString().contains(searchValue);
                },
              ),
              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  _idcontroller.clear();
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        validateidprof
            ? Container()
            : Text(
                errorforidprof,
                style: TextStyle(color: Colors.red, fontSize: 10),
              )
      ],
    );
  }

  Widget expwidget() {
    return idselectedValue == "2" || idselectedValue == "4"
        ? Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _expdatecontroller,
              onChanged: (value) {
                validateexpirydate = true;
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Expiry Date*',
                errorText: validateexpirydate ? null : errorforexpirydate,
                errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 252, 250, 250)!),
                ),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                suffixIcon: GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      String day = pickedDate.day.toString();
                      String month = pickedDate.month.toString();
                      String year = pickedDate.year.toString();
                      String date = day + '/' + month + '/' + year;
                      _expdatecontroller.text = date;
                      setState(() {
                        // expensedate = pickedDate;
                      });
                    }
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget idnumberwidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _idnumbercontroller,
        textCapitalization:
            TextCapitalization.characters, // Forces capitalization
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'[A-Z0-9]')), // Allow only uppercase letters and digits
        ],
        onChanged: (value) {
          validateidnumber = true;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'ID Proof Number*',
          errorText: validateidnumber ? null : errorforidnumber,
          errorStyle: TextStyle(color: Colors.red, fontSize: 10),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 252, 250, 250)!),
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget planselectwidget() {
    return agentplan.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 55,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Plan*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),

                    items: [
                      // const DropdownMenuItem(
                      //     child: Text(
                      //       "Select Plan",
                      //       style: TextStyle(
                      //           color: Color.fromARGB(255, 117, 117, 117),
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     value: ""),
                      ...agentplan.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                            child: Text(
                              e.planName.toString(),
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            value: e.id.toString());
                      }).toList()
                    ],
                    value: agentplanselectedValue,
                    onChanged: (value) {
                      setState(() {
                        agentplanselectedValue = value;
                        validateplan = true;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 400,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: textEditingControlleragentplan,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: textEditingControlleragentplan,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for plan',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value.toString().contains(searchValue);
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingControlleragentplan.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validateplan
                  ? Container()
                  : Text(
                      errorforplan,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  bool validatecustomername = true,
      validatedob = true,
      validateidprof = true,
      validateidnumber = true,
      validateplan = true,
      validateexpirydate = true;
  String errorforname = "Please enter customer name",
      errorfordob = "Please select birthdate",
      errorforidprof = "Please select id proof",
      errorforidnumber = "Please enter id number",
      errorforplan = "Please select plan",
      errorforexpirydate = "Please select expiry date ";
  validatefields() {
    if (_namecontroller.text.isEmpty &&
        _lastnamecontroller.text.isEmpty &&
        _dobcontroller.text.isEmpty &&
        idselectedValue == null &&
        _idnumbercontroller.text.isEmpty &&
        agentplanselectedValue == null) {
      validatecustomername = false;
      validatedob = false;
      validateidprof = false;
      validateidnumber = false;
      validateplan = false;
      setState(() {});
    } else if (_dobcontroller.text.isEmpty &&
        idselectedValue == null &&
        _idnumbercontroller.text.isEmpty &&
        agentplanselectedValue == null) {
      validatedob = false;
      validateidprof = false;
      validateidnumber = false;
      validateplan = false;
      setState(() {});
    } else if (idselectedValue == null &&
        _idnumbercontroller.text.isEmpty &&
        agentplanselectedValue == null) {
      validateidprof = false;
      validateidnumber = false;
      validateplan = false;
      setState(() {});
    } else if ((idselectedValue == "2" || idselectedValue == "4") &&
        _expdatecontroller.text.isEmpty) {
      validateexpirydate = false;
      setState(() {});
    } else if (_idnumbercontroller.text.isEmpty &&
        agentplanselectedValue == null) {
      validateidnumber = false;
      validateplan = false;
      setState(() {});
    } else if (agentplanselectedValue == null) {
      validateplan = false;
      setState(() {});
    } else {
      setState(() {});
      Networkcallforcustomerdetails();
    }
  }

  Future<void> Networkcallforcustomerdetails() async {
    try {
      ProgressDialog.showProgressDialog(context, "title");
      String assignfaasttag = createjson().createjsonforaddcustomerdetails(
          _namecontroller.text,
          _lastnamecontroller.text,
          _dobcontroller.text,
          idselectedValue!,
          _idnumbercontroller.text,
          agentplanselectedValue!,
          widget.vehiclenumber,
          widget.sessionId,
          _expdatecontroller.text,
          // rcfrontimage,
          // rcbackimage,
          // vehicleimage,
          context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().update_customer_details,
          URLS().update_customer_details_url,
          assignfaasttag,
          context);

      if (list != null) {
        Navigator.pop(context);
        List<Addcustomerdetailsresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "Customer details added  successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  // super.dispose();
                  return AssignVehicleDetails(
                    widget.sessionId,
                    widget.vehiclenumber,
                  );
                },
              ),
            );
            break;
          case "false":
            SnackBarDesign(
                "Unable to add customer details , Please try again",
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
