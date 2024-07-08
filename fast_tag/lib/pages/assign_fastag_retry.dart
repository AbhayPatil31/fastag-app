import 'package:dio/dio.dart';
import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/assignfasttagresponse.dart';
import 'package:fast_tag/pages/assign_otp.dart';
import 'package:fast_tag/utility/colorfile.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:fast_tag/utility/snackbardesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

final vehiclecontroller = TextEditingController();
final mobilecontroller = TextEditingController();

class AssignFastagRetryPage extends StatefulWidget {
  String mobilenumber, vehiclenumber;
  AssignFastagRetryPage(this.mobilenumber, this.vehiclenumber);
  State createState() => AssignFastagRetryPageState();
}

class AssignFastagRetryPageState extends State<AssignFastagRetryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobilecontroller.text = widget.mobilenumber;
    vehiclecontroller.text = widget.vehiclenumber;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    validatemobilenumber = true;
    validatevehicle = true;
    errorformobile = "";
    errorforvehicle = "";
    vehiclecontroller.clear();
    mobilecontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assign FasTag',
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
              Center(
                child: Image.asset(
                  'images/fastatag1.png', // Make sure to replace with your actual image asset
                  height: 400, // Adjust the height as needed
                ),
              ),

              Text(
                'Enter Details',
                style: TextStyle(
                  fontSize: 25, // 25px size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
              SizedBox(height: 20), // Adding space before the first text field
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
                  controller: vehiclecontroller,
                  readOnly: true,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Vehicle Number*',
                    errorText: validatevehicle ? null : errorforvehicle,
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
              SizedBox(height: 20),

              // Adding space before the second text field
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
                  controller: mobilecontroller,
                  readOnly: true,
                  enabled: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile Number*',
                    errorText: validatemobilenumber ? null : errorformobile,
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
              SizedBox(height: 30), // Adding space before the button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String? validate = validatefield();
                    if (validate == null) {
                      Networkcallforassignfasttag();
                    }
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

  bool validatevehicle = true, validatemobilenumber = true;
  String errorforvehicle = "Please enter vehicle number",
      errorformobile = "Please enter mobile number";
  String? validatefield() {
    validatevehicle = true;
    validatemobilenumber = true;
    if (vehiclecontroller.text.isEmpty && mobilecontroller.text.isEmpty) {
      validatevehicle = false;
      validatemobilenumber = false;
      errorforvehicle = "Please enter vehicle number";
      errorformobile = "Please enter mobile number";
      setState(() {});
      return 'abc';
    } else if (vehiclecontroller.text.isEmpty) {
      validatevehicle = false;
      errorforvehicle = "Please enter vehicle number";
      setState(() {});
      return 'abc';
    } else if (isValidVehicleNumberPlate(vehiclecontroller.text) == "false") {
      validatevehicle = false;
      errorforvehicle = "Please enter valid vehicle number";
      setState(() {});
      return 'abc';
    } else if (mobilecontroller.text.isEmpty) {
      validatemobilenumber = false;
      errorformobile = "Please enter mobile number";
      setState(() {});
      return 'abc';
    } else if (mobilecontroller.text.isPhoneNumber == false) {
      validatemobilenumber = false;
      errorformobile = "Please enter valid mobile number";
      setState(() {});
      return 'abc';
    } else {
      setState(() {});

      return null;
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

  Future<void> Networkcallforassignfasttag() async {
    try {
      ProgressDialog.showProgressDialog(context, " title");
      String assignfaasttag = createjson().createjsonforassignfasttag(
          vehiclecontroller.text, mobilecontroller.text, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().generate_otp_by_vehicle,
          URLS().generate_otp_by_vehicle_url,
          assignfaasttag,
          context);
      if (list != null) {
        Navigator.pop(context);
        List<Assignvehicleresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "OTP send on your mobile number",
                context,
                colorfile().sucessmessagebcColor,
                colorfile().sucessmessagetxColor);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AssignOtpPage(
                      response[0].data![0].requestId!,
                      response[0].data![0].sessionId!,
                      mobilecontroller.text,
                      vehiclecontroller.text)),
            );
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
