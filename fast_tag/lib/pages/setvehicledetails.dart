import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/assignfasttagresponse.dart';
import 'package:fast_tag/api/response/getvehicleclassresponse.dart';
import 'package:fast_tag/api/response/setvehicledetailsmanuallyresponse.dart';
import 'package:fast_tag/api/response/vehiclemodelresponse.dart';
import 'package:fast_tag/pages/assign_otp.dart';
import 'package:fast_tag/utility/colorfile.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:fast_tag/utility/snackbardesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../api/response/getmapperclassresponse.dart';
import '../api/response/vehiclemakerresponse.dart';
import 'assign_customer_details.dart';

List<String> vehiclemaker = [];
String? vehiclemakerselectedValue;
final TextEditingController textEditingControllervehiclemaker =
    TextEditingController();
List<String> vehiclemodellist = [];
String? vehiclemodelselectedValue;
final TextEditingController textEditingControllervehiclemodel =
    TextEditingController();
final List<String> type = [];
String? typeselectedValue;
final TextEditingController textEditingControllertype = TextEditingController();
final List<String> vehicletype = [];
String? vehicletypeselectedValue;
final TextEditingController textEditingControllervehicletype =
    TextEditingController();

List<String> npciVehicleClassID = [];
String? npciVehicleClassIDselectedValue;
final TextEditingController textEditingControllernpciVehicleClassID =
    TextEditingController();

// List<String> tagVehicleClassID = [];
String? tagVehicleClassIDselectedValue;
final TextEditingController textEditingControllertagVehicleClassID =
    TextEditingController();
bool _isChecked = false;

class SetVehicleDetails extends StatefulWidget {
  String sessionId, vehicle_number;
  SetVehicleDetails(this.sessionId, this.vehicle_number);
  State createState() => SetvehicledetailsState();
}

final vehiclecolorcontroller = TextEditingController();

class SetvehicledetailsState extends State<SetVehicleDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setvalue();
    Networkcallforvehiclemakerlist();
    Networkcallforgetvehicleclass();
    // Networkcallforgetmapperclass();
    if (_isChecked == true) {
      textEditingControllertype.text = "LPV";
      setState(() {});
    } else {
      textEditingControllertype.text = "LMV";
      setState(() {});
    }
  }

  setvalue() {
    type.clear();
    vehicletype.clear();
    npciVehicleClassID.clear();
    tagVehicleClassID.clear();
    type.add("LMV");
    type.add("LPV");
    type.add("LGV(only for tata ace pickup/mini light commercial vehicle)");
    vehicletype.add("Motor Car");
    vehicletype.add("Motor Cab");
    vehicletype.add("Maxi Cab");
    vehicletype.add(
        "Goods Carrier(only for Tata Ace Pickup/Mini Light commercial vehicle for VC 20)");
    // npciVehicleClassID.add("4");
    // npciVehicleClassID.add("20");
    //tagVehicleClassID.add("4");
    setState(() {});
  }

  Future<void> Networkcallforvehiclemakerlist() async {
    try {
      ProgressDialog.showProgressDialog(context, " title");
      vehiclemaker.clear();
      vehiclemodellist.clear();
      vehiclemakerselectedValue = null;
      vehiclemodelselectedValue = null;
      setState(() {});
      String vehiclemakerlist = createjson().createjsonforvehiclemakerlist(
          widget.sessionId, widget.vehicle_number, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().vehicleMakerList,
          URLS().vehicleMakerList_url,
          vehiclemakerlist,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Vehiclemakerresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            vehiclemaker = response[0].data![0].vehicleMakerList!;

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

  Future<void> Networkcallforvehiclemodel(String vehiclemaker) async {
    try {
      vehiclemodellist.clear();
      setState(() {});
      ProgressDialog.showProgressDialog(context, " title");
      String vehiclemodel = createjson().createjsonforvehiclemodel(
          widget.sessionId, vehiclemaker, widget.vehicle_number, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().vehicleModelList,
          URLS().vehicleModelList_url,
          vehiclemodel,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Vehiclemodelresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            vehiclemodellist = response[0].data![0].vehicleModelList!;
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
//below i have to work today,have to add get_mapper_class_api response id to below list
  List<String> tagVehicleClassID = [];
  Future<void> Networkcallforgetvehicleclass() async {
    try {
      List<Object?>? list = await NetworkCall().getMethod(
          URLS().get_vehicle_class_api,
          URLS().get_vehicle_class_api_url,
          context);
      if (list != null) {
        List<Getvehicleclassresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            for (int i = 0; i < response[0].data!.length; i++) {
              tagVehicleClassID.add(response[0].data![i].id!);
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
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> Networkcallforgetmapperclass(String vehicleId) async {
    try {
       String vehiclclassid = createjson().createjsonforgetmapperclass(
          vehicleId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().get_mapper_class_api,
          URLS().get_mapper_class_api_url,
          vehiclclassid,
          context,);
      if (list != null) {
        List<Getmapperclassresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            for (int i = 0; i < response[0].data!.length; i++) {
              npciVehicleClassID.add(response[0].data![i].id!);
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
    clearfields();
  }

  clearfields() {
    vehiclemaker.clear();
    vehiclemakerselectedValue = null;
    textEditingControllervehiclemaker.clear();
    vehiclemodellist.clear();
    vehiclemodelselectedValue = null;
    textEditingControllervehiclemodel.clear();

    type.clear();
    typeselectedValue = null;
    textEditingControllertype.clear();
    vehicletype.clear();
    vehicletypeselectedValue = null;
    textEditingControllervehicletype.clear();

    npciVehicleClassID.clear();
    npciVehicleClassIDselectedValue = null;
    textEditingControllernpciVehicleClassID.clear();

    tagVehicleClassID.clear();
    tagVehicleClassIDselectedValue = null;
    textEditingControllertagVehicleClassID.clear();
    vehiclecolorcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set vehicle details',
          style: TextStyle(
            fontSize: 20, // 25px size
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 1, child: vehiclemakerdropdown()),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(flex: 1, child: vehiclemodeldropdown()),
                ],
              ),
              // space(),
              // typedropdown(),

              space(),
              vehicletypedropdown(),
              space(),
              tagVehicleClassIDtypedropdown(),
              space(),
              npciVehicleClassIDdropdown(),
              space(),
              //vehiclemodeldropdown(),
              // vehiclemodellist.isNotEmpty ? space() : Container(),
              npciVehicleClassIDselectedValue != "" &&
                      npciVehicleClassIDselectedValue == "20"
                  ? Container()
                  : Row(
                      children: [
                        Checkbox(
                          value: _isChecked, // Use the state variable here
                          onChanged: (value) {
                            _isChecked = value!;
                            if (_isChecked == true) {
                              textEditingControllertype.text = "LPV";
                              setState(() {});
                            } else {
                              textEditingControllertype.text = "LMV";
                              setState(() {});
                            }
                          },
                        ),
                        Flexible(
                          child: Text(
                            'commercial Vehicle',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),

              space(),
              // Container(
              //   decoration: BoxDecoration(
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color.fromARGB(255, 219, 213, 213)
              //             .withOpacity(0.5), // Shadow color
              //         spreadRadius: 3, // Spread radius
              //         blurRadius: 5, // Blur radius
              //         offset: Offset(0, 3), // Offset in x and y directions
              //       ),
              //     ],
              //   ),
              //   child: TextField(
              //     controller: textEditingControllertype,
              //     enabled: true,
              //     readOnly: true,
              //     decoration: InputDecoration(
              //       hintText: 'Select Type*',
              //       errorText: validatecolor ? null : errormessageforcolor,
              //       errorStyle: TextStyle(color: Colors.red, fontSize: 10),
              //       border: OutlineInputBorder(), // Remove underline
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //             color: Colors.blue), // Change border color on focus
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //             color: const Color.fromARGB(
              //                 255, 252, 250, 250)!), // Change border color
              //       ),
              //       fillColor: Theme.of(context).scaffoldBackgroundColor,
              //       filled: true,
              //       contentPadding:
              //           EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              //     ),
              //   ),
              // ),
              space(),
              Container(
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
                  controller: vehiclecolorcontroller,
                  decoration: InputDecoration(
                    hintText: 'Enter Vehicle Color*',
                    errorText: validatecolor ? null : errormessageforcolor,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                    border: OutlineInputBorder(), // Remove underline
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue), // Change border color on focus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(
                              255, 252, 250, 250)!), // Change border color
                    ),
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              space(),
              Container(
                height: 50,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    validatefields();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF0056D0),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Button corner radius 5px
                      ),
                    ),
                  ),
                  child: Container(
                    width:
                        double.infinity, // Make button width match its parent
                    child: Center(
                      child: Text(
                        'Proceed',
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

  Widget space() {
    return SizedBox(
      height: 20,
    );
  }

  Widget vehiclemakerdropdown() {
    return vehiclemaker.isNotEmpty
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
                      'Select Vehicle Maker*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: vehiclemaker
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
                    value: vehiclemakerselectedValue,
                    onChanged: (value) {
                      vehiclemodellist.clear();
                      vehiclemodelselectedValue = null;
                      setState(() {
                        vehiclemakerselectedValue = value;
                      });

                      Networkcallforvehiclemodel(vehiclemakerselectedValue!);
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
                      searchController: textEditingControllervehiclemaker,
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
                          controller: textEditingControllervehiclemaker,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for vehicle maker',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        print(searchValue.toLowerCase());
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingControllervehiclemaker.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatevehiclemaker
                  ? Container()
                  : Text(
                      errormessageformaker,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  Widget vehiclemodeldropdown() {
    return vehiclemodellist.isNotEmpty
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
                      'Select Vehicle Model*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),

                    items: vehiclemodellist
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
                    value: vehiclemodelselectedValue,
                    onChanged: (value) {
                      setState(() {
                        vehiclemodelselectedValue = value;
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
                      searchController: textEditingControllervehiclemodel,
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
                          controller: textEditingControllervehiclemodel,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for vehicle model',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingControllervehiclemodel.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatemodel
                  ? Container()
                  : Text(
                      errormessageformodel,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Column(
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
                      'Select Vehicle Model*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),

                    items: [],
                    value: vehiclemodelselectedValue,
                    onChanged: (value) {
                      setState(() {
                        vehiclemodelselectedValue = value;
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
                      searchController: textEditingControllervehiclemodel,
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
                          controller: textEditingControllervehiclemodel,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for vehicle model',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingControllervehiclemodel.clear();
                      }
                    },
                  ),
                ),
              ),
            ],
          );
  }

  Widget typedropdown() {
    return type.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 55,
                // margin: EdgeInsets.only(bottom: 20),
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
                      'Select Type*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),

                    items: type
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
                    value: typeselectedValue,
                    onChanged: (value) {
                      setState(() {
                        typeselectedValue = value;
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
                      searchController: textEditingControllertype,
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
                          controller: textEditingControllertype,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for type',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingControllertype.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatetype
                  ? Container()
                  : Text(
                      errormessagefortype,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  Widget vehicletypedropdown() {
    return vehicletype.isNotEmpty
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
                      'Select Vehicle Type*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),

                    items: vehicletype
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
                    value: vehicletypeselectedValue,
                    onChanged: (value) {
                      setState(() {
                        vehicletypeselectedValue = value;
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
                      searchController: textEditingControllervehicletype,
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
                          controller: textEditingControllervehicletype,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for vehicle type',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingControllervehicletype.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatevehicletype
                  ? Container()
                  : Text(
                      errormessageforvehicletype,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  Widget npciVehicleClassIDdropdown() {
    return npciVehicleClassID.isNotEmpty
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
                      'Select Mapper*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),

                    items: npciVehicleClassID
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
                    value: npciVehicleClassIDselectedValue,
                    onChanged: (value) {
                      setState(() {
                        npciVehicleClassIDselectedValue = value;
                        textEditingControllertype.text = "LGV";
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
                      searchController: textEditingControllernpciVehicleClassID,
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
                          controller: textEditingControllernpciVehicleClassID,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for mapper class id',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingControllernpciVehicleClassID.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatenpciid
                  ? Container()
                  : Text(
                      errormessagefornpciid,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  Widget tagVehicleClassIDtypedropdown() {
    return tagVehicleClassID.isNotEmpty
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
                      'Select Tag Vehicle*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),

                    items: tagVehicleClassID
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
                    value: tagVehicleClassIDselectedValue,
                    onChanged: (value) {
                      setState(() {
                        tagVehicleClassIDselectedValue = value;
                        Networkcallforgetmapperclass(tagVehicleClassIDselectedValue!);
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
                      searchController: textEditingControllertagVehicleClassID,
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
                          controller: textEditingControllertagVehicleClassID,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for tag vehicle class id',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingControllertagVehicleClassID.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatetagid
                  ? Container()
                  : Text(
                      errormessagefortagid,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  bool validatevehiclemaker = true,
      validatemodel = true,
      validatetype = true,
      validatevehicletype = true,
      validatenpciid = true,
      validatetagid = true,
      validatecolor = true;
  String errormessageformaker = "Please select vehicle maker",
      errormessageformodel = "Please select vehicle model",
      errormessagefortype = "Please select type",
      errormessageforvehicletype = "Please select vehicle type",
      errormessagefornpciid = "Please select mapper class id",
      errormessagefortagid = "Please select tag vehicle class id",
      errormessageforcolor = "Please enter color of vehicle";
  validatefields() {
    validatevehiclemaker = true;
    validatemodel = true;
    validatetype = true;
    validatevehicletype = true;
    validatenpciid = true;
    validatetagid = true;
    validatecolor = true;
    if (vehiclemakerselectedValue == null &&
        typeselectedValue == null &&
        vehicletypeselectedValue == null &&
        npciVehicleClassIDselectedValue == null &&
        tagVehicleClassIDselectedValue == null &&
        vehiclemodelselectedValue == null &&
        vehiclecolorcontroller.text.isEmpty) {
      validatevehiclemaker = false;
      validatemodel = false;
      validatetype = false;
      validatevehicletype = false;
      validatenpciid = false;
      validatetagid = false;
      validatecolor = false;
      setState(() {});
    } else if (typeselectedValue == null &&
        vehicletypeselectedValue == null &&
        npciVehicleClassIDselectedValue == null &&
        tagVehicleClassIDselectedValue == null &&
        vehiclemakerselectedValue == null &&
        vehiclecolorcontroller.text.isEmpty) {
      validatetype = false;
      validatemodel = false;
      validatevehicletype = false;
      validatenpciid = false;
      validatetagid = false;
      validatecolor = false;
      setState(() {});
    } else if (vehicletypeselectedValue == null &&
        npciVehicleClassIDselectedValue == null &&
        tagVehicleClassIDselectedValue == null &&
        vehiclemodelselectedValue == null &&
        vehiclecolorcontroller.text.isEmpty) {
      validatevehicletype = false;
      validatemodel = false;
      validatenpciid = false;
      validatetagid = false;
      validatecolor = false;
      setState(() {});
    } else if (npciVehicleClassIDselectedValue == null &&
        tagVehicleClassIDselectedValue == null &&
        vehiclemodelselectedValue == null &&
        vehiclecolorcontroller.text.isEmpty) {
      validatenpciid = false;
      validatemodel = false;
      validatetagid = false;
      validatecolor = false;
      setState(() {});
    } else if (tagVehicleClassIDselectedValue == null &&
        vehiclemodelselectedValue == null &&
        vehiclecolorcontroller.text.isEmpty) {
      validatetagid = false;
      validatemodel = false;

      validatecolor = false;
      setState(() {});
    } else if (vehiclemodelselectedValue == null &&
        vehiclecolorcontroller.text.isEmpty) {
      validatemodel = false;

      validatecolor = false;
      setState(() {});
    } else if (vehiclecolorcontroller.text.isEmpty) {
      validatecolor = false;
      setState(() {});
    } else {
      setState(() {});
      Networkcallforsetvehicledetailsmanually();
    }
  }

  Future<void> Networkcallforsetvehicledetailsmanually() async {
    try {
      ProgressDialog.showProgressDialog(context, " title");
      String assignfaasttag = createjson()
          .createjsonforsetvehicledetailsmanually(
              vehiclemakerselectedValue!,
              vehiclemodelselectedValue!,
              typeselectedValue ?? '',
              vehicletypeselectedValue!,
              npciVehicleClassIDselectedValue!,
              tagVehicleClassIDselectedValue!,
              vehiclecolorcontroller.text,
              "Active",
              widget.vehicle_number,
              context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().set_manually_vehicle_details,
          URLS().set_manually_vehicle_details_url,
          assignfaasttag,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Setvehicledetailsmanuallyresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "Vehicle details set successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDetailsPage(
                    widget.vehicle_number, widget.sessionId),
              ),
            );
            break;
          case "false":
            SnackBarDesign(
                "Unable to set vehicle details , Please try again",
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
