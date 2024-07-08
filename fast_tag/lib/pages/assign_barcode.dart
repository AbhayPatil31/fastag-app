import 'package:fast_tag/api/response/stockcategoryresponse.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';

List<StockcategoryDatum> stockcategory = [];

class AssignBarcode extends StatefulWidget {
  String vehicleId;
  AssignBarcode(this.vehicleId);

  @override
  State<AssignBarcode> createState() => _AssignBarcodeState();
}

class _AssignBarcodeState extends State<AssignBarcode> {
  @override
  void initState() {
    super.initState();

    Networkcallforstockcategory();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stockcategory.clear();
  }

  Future<void> Networkcallforstockcategory() async {
    try {
      String createjsonforstocklist = createjson().createjsonforstockcategory(
          AppUtility.AgentId, widget.vehicleId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().stock_category_api,
          URLS().stock_category_api_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        List<Stockcategoryresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            stockcategory = response[0].data!;
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController barcodeController = TextEditingController();

        return AlertDialog(
          content: Container(
            width: 330,
            height: 220, // Adjust height as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter Barcode Number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: barcodeController,
                    style:
                        TextStyle(color: Colors.white), // Text color to white
                    keyboardType: TextInputType.number, // Numeric keyboard
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only digits allowed
                    decoration: InputDecoration(
                      hintText: 'Barcode Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      String barcodeNumber = barcodeController.text;
                      // Handle submit logic here
                      print('Submitted Barcode Number: $barcodeNumber');
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0056D0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Delay redirecting to the home screen for 5 seconds
    // Future.delayed(Duration(seconds: 5), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => AssignBarcode()),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assign Barcode List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter/Scan Barcode Number',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Image(
                    height: 40,
                    image: AssetImage('images/scanner.png'),
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0056D0),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    // filterSearchResults(value);
                  },
                  style: TextStyle(color: Colors.white), // Text color to white
                  keyboardType: TextInputType.number, // Numeric keyboard
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only digits allowed
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0056D0)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Search By Last 4 Digits ',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 40.0),
                      stockcategory != null && stockcategory.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: stockcategory.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _showConfirmationDialog(context);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                        horizontal: 35,
                                        vertical: 4,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 0),
                                            )
                                          ],
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      '${stockcategory[index]} (${getUnitName(stockcategory[index].mapperVehicleClass!)})',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors
                                                            .grey.shade700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Text('No data'),
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getUnitName(String unitId) {
    switch (unitId) {
      case '1':
        return 'Kg';
      case '2':
        return 'Lit';
      case '3':
        return 'NOS';
      default:
        return 'Unknown';
    }
  }
}
