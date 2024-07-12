import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fast_tag/api/call/addvehicledetailscall.dart';
import 'package:fast_tag/api/response/addvehicledetailsresponse.dart';
import 'package:fast_tag/api/response/getallbarcoderesponse.dart';
import 'package:fast_tag/pages/assign_barcode.dart';
import 'package:fast_tag/pages/request_fastag.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fast_tag/pages/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/requestcategoryresponse.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';

final _vehiclenumbercontroller = TextEditingController();
final _vehiclechassisnumbercontroller = TextEditingController();
String? showfilename;
//final _vehicleserialnumbercontroller = TextEditingController();
final TextEditingController _vehicleserialnumbercontroller =
    TextEditingController();

class AssignVehicleDetails extends StatefulWidget {
  String sessionId, vehiclenumber;

  AssignVehicleDetails(this.sessionId, this.vehiclenumber);
  State createState() => AssignVehicleDetailsState();
}

String rcfrontimage = "", rcbackimage = "", vehicleimagestring = "";
String rcfrontimageattachmentPath = "",
    rcbackimageattachmentPath = "",
    vehicleimageattachmentPath = "";
String frontImageErrorMessage = "";
String backImageErrorMessage = "";
String vehicleImageErrorMessage = "";

class AssignVehicleDetailsState extends State<AssignVehicleDetails> {
  String? frontImagePath;
  String? backImagePath;
  String? vehicleImagePath;
  // bool validatercbackimage = true;
  // String errorforrcbackimage = "Please select an image";

  Future<void> uploadFile(File file, String filename, String filetype) async {
    print("File base name: " + filename);
    showfilename = filename;
    try {
      final bytes = await File(file.path).readAsBytes();
      String base64String = base64Encode(bytes);
      switch (filetype) {
        case "rc_image_front":
          rcfrontimage = base64String;
          rcfrontimageattachmentPath = filename;
          print(base64String);
          setState(() {});
          break;
        case "rc_image_back":
          rcbackimage = base64String;
          rcbackimageattachmentPath = filename;

          setState(() {});
          break;
        case "vehicle_image":
          vehicleimagestring = base64String;
          vehicleimageattachmentPath = filename;

          setState(() {});
          break;
      }
    } catch (e) {
      print("Error uploading file: " + e.toString());
    }
  }

  Future<void> profile(BuildContext context, String imagetype) async {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 396,
            padding: EdgeInsets.only(left: 0, top: 38, right: 0, bottom: 38),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Text(
                    'Choose Source',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF008357),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    'Select a source for the image upload',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, top: 28, right: 30, bottom: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(context).pop();
                            final XFile? image = await ImagePicker().pickImage(
                                source: ImageSource.camera, imageQuality: 50);
                            if (image != null) {
                              setState(() {
                                if (imagetype == "rc_image_front") {
                                  frontImagePath = image.path;
                                } else if (imagetype == "rc_image_back") {
                                  backImagePath = image.path;
                                } else if (imagetype == "vehicle_image") {
                                  vehicleImagePath = image.path;
                                }
                              });
                              String fileName = image.name;
                              await uploadFile(
                                  File(image.path), fileName, imagetype);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: Color(0xFF008357),
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "Camera",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF008357),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(context).pop();
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'jpeg',
                                      'png',
                                      'pdf'
                                    ],
                                    compressionQuality: 50);
                            if (result != null) {
                              setState(() {
                                if (imagetype == "rc_image_front") {
                                  frontImagePath = result.files.single.path!;
                                } else if (imagetype == "rc_image_back") {
                                  backImagePath = result.files.single.path!;
                                } else if (imagetype == "vehicle_image") {
                                  vehicleImagePath = result.files.single.path!;
                                }
                              });
                              final ext =
                                  result.files.first.name.split('.').last;
                              String fileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString() +
                                  '.' +
                                  ext;
                              await uploadFile(File(result.files.single.path!),
                                  fileName, imagetype);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: Color(0xFF008357)),
                                color: Color(0xFF008357),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "File Picker",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void showOverlay(BuildContext context, String message) {
  //   OverlayEntry overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: MediaQuery.of(context).size.height * 0.5,
  //       left: MediaQuery.of(context).size.width * 0.1,
  //       right: MediaQuery.of(context).size.width * 0.1,
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  //           decoration: BoxDecoration(
  //             color: Colors.black.withOpacity(0.7),
  //             borderRadius: BorderRadius.circular(8.0),
  //           ),
  //           child: Text(
  //             message,
  //             style: TextStyle(color: Colors.white, fontSize: 14),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   Overlay.of(context)?.insert(overlayEntry);
  //   Future.delayed(Duration(seconds: 30), () {
  //     overlayEntry.remove();
  //   });
  // }

// succesPOpup
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.infinity, // Cover full width
            height: 350, // Set a fixed height as needed

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/succes.png', // Replace with the actual path to your image asset
                    width: 200, // Set image width as needed
                    height: 200, // Set image height as needed
                  ),
                  SizedBox(height: 20), // Space between image and text
                  Text(
                    'Activation Successful',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),

                  Text(
                    'Your account is ready to use. You will\n be redirected to the Home page in\n a few seconds.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

//rejection popup
  void _showRejectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.infinity, // Cover full width
            height: 400, // Set a fixed height as needed

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/sad.png', // Replace with the actual path to your image asset
                    width: 200, // Set image width as needed
                    height: 200, // Set image height as needed
                  ),
                  // SizedBox(height: 5), // Space between image and text
                  Text(
                    'Activation Rejected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),

                  Text(
                    'Your account is ready to use. You will\n be redirected to the Home page in\n a few seconds.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Delay redirecting to the home screen for 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyDashboard()),
      );
    });
  }

  @override
  void initState() {
    frontImageErrorMessage = "";
    backImageErrorMessage = "";
    vehicleImageErrorMessage = "";
    // TODO: implement initState
    super.initState();

    _vehiclenumbercontroller.text = widget.vehiclenumber;
    Networkcallforwallettransactionhistory();
    Networkcallgetallbarcode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rcfrontimage = "";
    rcbackimage = "";
    vehicleimagestring = "";
    rcfrontimageattachmentPath = "";
    rcbackimageattachmentPath = "";
    vehicleimageattachmentPath = "";
    _vehiclenumbercontroller.clear();
    _vehiclechassisnumbercontroller.clear();
    _vehicleserialnumbercontroller.clear();
  }

  List<RequestcategoryDatum> requestcategory = [];
  List<GetallbarcodeDatum> barcodelist = [];

  Future<void> Networkcallforwallettransactionhistory() async {
    try {
      ProgressDialog.showProgressDialog(context, "title");
      List<Object?>? list = await NetworkCall().getMethod(
          URLS().fastag_category_request_api,
          URLS().fastag_category_request_api_url,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Requestcategoryresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            requestcategory = response[0].data!;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
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
                  Text(
                    'Vehicle Details',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Image(
                    height: 65,
                    image: AssetImage(
                        'images/automobile.png'), // Replace 'images/automobile.png' with your image path
                  )
                ],
              ),
            ),

            SizedBox(height: 30), // Adding space before the input fields

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Your Vehicle Details',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16, // Adjust the font size as needed
                    ),
                  ),
                  SizedBox(height: 15),
                  categorydropdown(),
                  SizedBox(
                    height: 5,
                  ),
                  vehiclenumber(),
                  SizedBox(
                    height: 5,
                  ),
                  vehiclechassis(),
                  SizedBox(
                    height: 5,
                  ),
                  vehiclebarcode(),
                  SizedBox(
                    height: 5,
                  ),
                  rcimages(),
                  SizedBox(
                    height: 5,
                  ),
                  vehicleimage(),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 30), // Adding space before the button

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  //_showConfirmationDialog(context);
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
                  height: 50,
                  child: Center(
                    child: Text(
                      'Done',
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
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget categorydropdown() {
    return requestcategory.isNotEmpty
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
                      'Select Vehicle Category*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: requestcategory.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                          child: Text(
                            e.categoryName.toString(),
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          value: e.id.toString());
                    }).toList(),
                    value: vehiclecategoryselectedValue,
                    onChanged: (value) {
                      setState(() {
                        vehiclecategoryselectedValue = value;
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
                      searchController: textEditingControllervehiclecategory,
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
                          controller: textEditingControllervehiclecategory,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for vehicle category',
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
                        textEditingControllervehiclecategory.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatevehiclecategory
                  ? Container()
                  : Text(
                      errormessageforcategory,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  Widget vehiclenumber() {
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
        controller: _vehiclenumbercontroller,
        readOnly: true,
        enabled: true,
        decoration: InputDecoration(
          hintText: 'Vehicle Number*',
          errorText: validatevehiclecategory ? null : errormessageforcategory,
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

  Widget vehiclechassis() {
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
        controller: _vehiclechassisnumbercontroller,
        decoration: InputDecoration(
          hintText: 'Vehicle Chassis Number',
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

  // Widget vehiclebarcode() {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 20),
  //     decoration: BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //           color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
  //           spreadRadius: 3,
  //           blurRadius: 5,
  //           offset: Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: TextField(
  //       controller: _vehicleserialnumbercontroller,
  //       inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
  //       keyboardType: TextInputType.number,
  //       decoration: InputDecoration(
  //         hintText: 'Enter Fastag Bar-Code Number*',
  //         errorText: validateserialnumber ? null : errorforserialnumber,
  //         errorStyle: TextStyle(color: Colors.red, fontSize: 10),
  //         border: OutlineInputBorder(),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.blue),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderSide:
  //               BorderSide(color: const Color.fromARGB(255, 252, 250, 250)!),
  //         ),
  //         fillColor: Theme.of(context).scaffoldBackgroundColor,
  //         filled: true,
  //         contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  //       ),
  //     ),
  //   );
  // }

  Widget vehiclebarcode() {
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
                      'Select barcode*',
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
                      searchController: _vehicleserialnumbercontroller,
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
                          controller: _vehicleserialnumbercontroller,
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
                        _vehicleserialnumbercontroller.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              validatevehiclecategory
                  ? Container()
                  : Text(
                      errormessageforcategory,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    )
            ],
          )
        : Container();
  }

  Widget rcimages() {
    return Container(
      width: double.infinity, // Set width to full

      padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 253, 248, 253),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(5.0),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  'Upload Vehicle RC Image',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 83, 83, 83),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                child: Text(
                  'Please upload image, size less than 100KB',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      profile(context, 'rc_image_front');
                    },
                    child: frontImagePath != null
                        ? Container(
                            width: 140,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors
                                    .blue, // Border color for the container
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Image.file(
                              File(frontImagePath!),
                              width: 140,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 140,
                            height: 80,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/upload-icon.png',
                                  height: 25,
                                  fit: BoxFit.contain,
                                ),
                                // SizedBox(height: 10),
                                // Text(
                                //   'Front Side',
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     fontSize: 5,
                                //     fontWeight: FontWeight.w400,
                                //     color: errormessage!.isNotEmpty
                                //         ? Colors.red
                                //         : Colors.blue,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                  ),
                  validatercfrontimage
                      ? Container()
                      : Text(
                          errorforrcfrontimage,
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                frontImageErrorMessage!.isNotEmpty
                    ? frontImageErrorMessage!
                    : 'Front Side',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: frontImageErrorMessage!.isNotEmpty
                      ? Colors.red
                      : Colors.blue,
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      profile(context, 'rc_image_back');
                    },
                    child: backImagePath != null
                        ? Container(
                            width: 140,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Image.file(
                              File(backImagePath!),
                              width: 140,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 140,
                            height: 80,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/upload-icon.png',
                                  height: 25,
                                  fit: BoxFit.contain,
                                ),
                                // SizedBox(height: 10),
                                // Text(
                                //   'Back Side',
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     fontSize: 9,
                                //     fontWeight: FontWeight.w400,
                                //     color: Colors.blue,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                  ),
                  validatercbackimage
                      ? Container()
                      : Text(
                          errorforrcbackimage,
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            backImageErrorMessage!.isNotEmpty
                ? backImageErrorMessage!
                : 'Back Side',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color:
                  backImageErrorMessage!.isNotEmpty ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget vehicleimage() {
    return Container(
      width: double.infinity, // Set width to full

      padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 253, 248, 253),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(5.0),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  'Upload Vehicle Image',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 83, 83, 83),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                child: Text(
                  'Please upload image, size less than 100KB',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  profile(context, "vehicle_image");
                },
                child: vehicleImagePath != null
                    ? Container(
                        width: 140,
                        height: 80,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Image.file(
                          File(vehicleImagePath!),
                          width: 140,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 140,
                        height: 80,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/upload-icon.png',
                              height: 25,
                              fit: BoxFit.contain,
                            ),
                            // SizedBox(height: 10),
                            // Text(
                            //   'Vehicle Image',
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w400,
                            //     color: Colors.blue,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
              ),
              validatevehicleimage
                  ? Container()
                  : Text(
                      errorforvehicleimage,
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Vehicle Image',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: vehicleImageErrorMessage!.isNotEmpty
                      ? Colors.red
                      : Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? vehiclecategoryselectedValue, vehiclebarcodeselectedvalue;
  bool validatevehiclecategory = true,
      validateserialnumber = true,
      validatercfrontimage = true,
      validatercbackimage = true,
      validatevehicleimage = true,
      validatechasisnumber = true;
  String errormessageforcategory = "Please select category",
      errorforserialnumber = "Please enter serial number",
      errorforrcfrontimage = "Please upload vehicle rc front image",
      errorforrcbackimage = "Please upload vehicle rc back image",
      errorforvehicleimage = "Please upload vehicle image",
      errorforchasisnumber = "Please enter valid chasis number";
  final TextEditingController textEditingControllervehiclecategory =
      TextEditingController();

  validatefields() {
    validatevehiclecategory = true;
    validateserialnumber = true;
    validatercfrontimage = true;
    validatercbackimage = true;
    validatevehicleimage = true;
    validatechasisnumber = true;
    if (vehiclecategoryselectedValue == null &&
        vehiclebarcodeselectedvalue == null &&
        rcfrontimage == "" &&
        rcbackimage == "" &&
        vehicleimagestring == "") {
      validatevehiclecategory = false;
      validateserialnumber = false;
      validatercfrontimage = false;
      validatercbackimage = false;
      validatevehicleimage = false;
      setState(() {});
    } else if (isValidchasisnumber(_vehiclechassisnumbercontroller.text) ==
        "false") {
      validatechasisnumber = false;
      errorforchasisnumber = "Please enter valid chasis number";
      setState(() {});
      return 'abc';
    } else if (vehiclebarcodeselectedvalue == null &&
        rcfrontimage == "" &&
        rcbackimage == "" &&
        vehicleimagestring == "") {
      validateserialnumber = false;
      validatercfrontimage = false;
      validatercbackimage = false;
      validatevehicleimage = false;
      setState(() {});
    } else if (vehiclecategoryselectedValue == null &&
        rcfrontimage == "" &&
        rcbackimage == "" &&
        vehicleimagestring == "") {
      validatevehiclecategory = false;
      validatercfrontimage = false;
      validatercbackimage = false;
      validatevehicleimage = false;
      setState(() {});
    } else if (rcbackimage == "" && vehicleimagestring == "") {
      validatercbackimage = false;
      validatevehicleimage = false;
      setState(() {});
    } else if (vehicleimagestring == "") {
      validatevehicleimage = false;
      setState(() {});
    } else {
      Networkcallforaddvehicledetails();
    }
  }

  String isValidchasisnumber(String chasisnumber) {
    if (chasisnumber.isEmpty) {
      return "true";
    } else {
      if (hasMatch(chasisnumber,
              r'^^[A-HJ-NPR-Za-hj-npr-z\d]{8}[\dX][A-HJ-NPR-Za-hj-npr-z\d]{2}\d{6}$') ==
          true) {
        return "true";
      } else {
        return "false";
      }
    }
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  Future<void> Networkcallforaddvehicledetails() async {
    try {
      ProgressDialog.showProgressDialog(context, "title");
      String assignfaasttag = createjson().createjsonforaddvehicledetails(
          vehiclecategoryselectedValue!,
          _vehiclenumbercontroller.text,
          _vehiclechassisnumbercontroller.text.isEmpty
              ? ''
              : _vehiclechassisnumbercontroller.text,
          _vehicleserialnumbercontroller.text,
          rcfrontimage,
          rcbackimage,
          vehicleimagestring,
          widget.sessionId,
          context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().update_vehicle_details,
          URLS().update_vehicle_details_url,
          assignfaasttag,
          context);

      if (list != null) {
        Navigator.pop(context);
        List<Addvehicledetailsresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "Vehicle details added  successfully!!",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return MyDashboard();
              },
            ), (route) => false);
            break;
          case "false":
            SnackBarDesign(
                "Unable to add vehicle details , Please try again",
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
