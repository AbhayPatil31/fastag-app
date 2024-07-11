import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fast_tag/api/response/replacevehicleresponse.dart';
import 'package:fast_tag/pages/assign_otp.dart';
import 'package:fast_tag/pages/replace_otp.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/getallbarcoderesponse.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';

List<String> resonlist = [];
final _resoncontroller = TextEditingController();
String? selectedvalue, idselectedValue;
final _customernamecontroller = TextEditingController();
final _vehiclenumbercontroller = TextEditingController();
String? vehiclebarcodeselectedvalue;
final TextEditingController _barcodenumbercontroller = TextEditingController();

class ReplaceFastagPage extends StatefulWidget {
  State createState() => ReplaceFastagPageState();
}

class ReplaceFastagPageState extends State<ReplaceFastagPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setvalue();
    Networkcallgetallbarcode();
  }

  setvalue() {
    resonlist.clear();
    resonlist.add('Tag Damaged');
    resonlist.add('Lost Tag');
    resonlist.add('Tag Not Working');
    resonlist.add('Others');
    setState(() {});
  }

  List<GetallbarcodeDatum> barcodelist = [];
  Future<void> Networkcallgetallbarcode() async {
    try {
      ProgressDialog.showProgressDialog(context, "title");
      String jsonstring = createjson().createjsonforgetallbarcode(context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_my_available_barcode,
          URLS().get_my_available_barcode_url,
          jsonstring,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Getallbarcoderesponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            barcodelist = response[0].data!;

            setState(() {});
            break;
          case "false":
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    resonlist.clear();
    idselectedValue = null;
    selectedvalue = null;
    _customernamecontroller.clear();
    _vehiclenumbercontroller.clear();
    _barcodenumbercontroller.clear();
    vehiclebarcodeselectedvalue = null;
    barcodelist.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa), // Set background color to #F5F5F5
      appBar: AppBar(
        // backgroundColor: Color(0xFFF5F5F5), // Set background color to #F5F5F5

        title: Text('Replace FasTag',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                'Enter Details',
                style: GoogleFonts.inter(
                  fontSize: 18, // 25px size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
              SizedBox(height: 20), // Adding space before the first text field
              customername(),
              SizedBox(height: 20),
              vehiclenumber(),

              SizedBox(height: 20),
              barcode(),
              SizedBox(
                height: 3,
              ),
              reasonselectwidget(),
              SizedBox(height: 30), // Adding space before the button
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    validatefields();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Button corner radius 5px
                      ),
                    ),
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF08469D),
                          Color(0xFF0056D0),
                          Color(0xFF0C92DD),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Container(
                      width:
                          double.infinity, // Make button width match its parent
                      alignment: Alignment.center,
                      child: Text(
                        'Submit',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget customername() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 219, 213, 213)
                .withOpacity(0.5), // Shadow color
            spreadRadius: 3, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 3), // Offset in x and y directions
          ),
        ],
      ),
      child: TextField(
        controller: _customernamecontroller,
        onChanged: (value) {
          validatecustomername = true;
          setState(() {});
        },
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
        decoration: InputDecoration(
          hintText: 'Enter Mobile Number*',
          errorText: validatecustomername ? null : errorforcutomername,
          errorStyle: TextStyle(color: Colors.red, fontSize: 10),
          border: OutlineInputBorder(), // Remove underline
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue), // Change border color on focus
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color.fromARGB(
                    255, 252, 250, 250)!), // Change border color
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget vehiclenumber() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 219, 213, 213)
                .withOpacity(0.5), // Shadow color
            spreadRadius: 3, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 3), // Offset in x and y directions
          ),
        ],
      ),
      child: TextField(
        controller: _vehiclenumbercontroller,
        onChanged: (value) {
          validatevehicle = true;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Enter Vehicle Number*',
          errorText: validatevehicle ? null : errorforvehiclenumber,
          errorStyle: TextStyle(color: Colors.red, fontSize: 10),
          border: OutlineInputBorder(), // Remove underline
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue), // Change border color on focus
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color.fromARGB(
                    255, 252, 250, 250)!), // Change border color
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget barcode() {
    return barcodelist.isNotEmpty
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
                      'Select barcode number*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: barcodelist.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                          child: Text(
                            e.barcode.toString(),
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          value: e.barcode.toString());
                    }).toList(),
                    value: vehiclebarcodeselectedvalue,
                    onChanged: (value) {
                      setState(() {
                        vehiclebarcodeselectedvalue = value;
                        validatebarcode = true;
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
                      searchController: _barcodenumbercontroller,
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
                          controller: _barcodenumbercontroller,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for barcode number',
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
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        _barcodenumbercontroller.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatebarcode
                  ? Container()
                  : Text(
                      errorforbarcode,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  Widget reasonselectwidget() {
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
                'Select Reason*',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: resonlist
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
                validatereson = true;
                setState(() {
                  selectedvalue = value;
                });
                if (selectedvalue == "Tag Damaged") {
                  idselectedValue = "1";
                } else if (selectedvalue == "Lost Tag") {
                  idselectedValue = "2";
                } else if (selectedvalue == "Tag Not Working") {
                  idselectedValue = "3";
                } else if (selectedvalue == "Others") {
                  idselectedValue = "99";
                }
                validatereson = true;
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
                searchController: _resoncontroller,
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
                    controller: _resoncontroller,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search for reason',
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
                  _resoncontroller.clear();
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        validatereson
            ? Container()
            : Text(
                errorforreson,
                style: TextStyle(color: Colors.red, fontSize: 10),
              )
      ],
    );
  }

  bool validatecustomername = true,
      validatevehicle = true,
      validatebarcode = true,
      validatereson = true;
  String errorforcutomername = "Please enter mobile number",
      errorforvehiclenumber = "Please enter vehicle number",
      errorforbarcode = "Please select barcode number",
      errorforreson = "Please select reason for fastag replace";

  validatefields() {
    validatecustomername = true;
    validatevehicle = true;
    validatebarcode = true;
    validatereson = true;
    if (_customernamecontroller.text.isEmpty &&
        _vehiclenumbercontroller.text.isEmpty &&
        vehiclebarcodeselectedvalue == null &&
        idselectedValue == null) {
      validatecustomername = false;
      validatevehicle = false;
      validatebarcode = false;
      validatereson = false;
      setState(() {});
    } else if (_vehiclenumbercontroller.text.isEmpty &&
        vehiclebarcodeselectedvalue == null &&
        idselectedValue == null) {
      validatevehicle = false;
      validatebarcode = false;
      validatereson = false;
      setState(() {});
    } else if (isValidVehicleNumberPlate(_vehiclenumbercontroller.text) ==
        "false") {
      validatevehicle = false;
      errorforvehiclenumber = "Please enter valid vehicle number";
      setState(() {});
      return 'abc';
    } else if (vehiclebarcodeselectedvalue == null && idselectedValue == null) {
      validatebarcode = false;
      validatereson = false;
      setState(() {});
      // } else if ((_isValidFormat(_barcodenumbercontroller.text)) == false) {
      //   validatebarcode = false;
      //   errorforbarcode =
      //       "Invalid format, please enter in 123456-123-1234567 format";
      //   setState(() {});
    } else if (idselectedValue == null) {
      validatereson = false;
      setState(() {});
    } else {
      Networkcallforreplacetaggenerateotp();
    }
  }

  String isValidVehicleNumberPlate(String NUMBERPLATE) {
    if (hasMatch(NUMBERPLATE, r'^[A-Z]{2}[0-9]{2}[A-HJ-NP-Z]{1,2}[0-9]{4}$') ==
        true) {
      return "true";
    } else if (hasMatch(NUMBERPLATE, r'[0-9]{2}BH[0-9]{4}[A-HJ-NP-Z]{1,2}$') ==
        true) {
      return "true";
    } else {
      return "false";
    }
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  bool _isValidFormat(String input) {
    final RegExp regex = RegExp(r'^\d{6}-\d{3}-\d{7}$');
    return regex.hasMatch(input);
  }

  Future<void> Networkcallforreplacetaggenerateotp() async {
    try {
      ProgressDialog.showProgressDialog(context, " title");
      String assignfaasttag = createjson()
          .createjsonforgenerateotpforreplacevehicle(
              _customernamecontroller.text,
              _vehiclenumbercontroller.text,
              vehiclebarcodeselectedvalue!,
              idselectedValue!,
              context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().rep_generate_otp_by_vehicle,
          URLS().rep_generate_otp_by_vehicle_url,
          assignfaasttag,
          context);

      if (list != null) {
        Navigator.pop(context);
        List<Replacevehicleresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            List<ReplacevehicleDatum> data = response[0].data!;
            SnackBarDesign(
                "OTP send successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReplaceOtpPage(
                      data[0].sessionId!,
                      data[0].requestId!,
                      _vehiclenumbercontroller.text,
                      _customernamecontroller.text,
                      _barcodenumbercontroller.text,
                      idselectedValue!)),
            );
            break;
          case "false":
            SnackBarDesign(
                "Unable to send OTP , Please try again",
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
