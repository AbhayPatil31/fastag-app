import 'package:flutter/material.dart';

class AssignActivationBarcodePage extends StatefulWidget {
  @override
  _AssignActivationBarcodePageState createState() =>
      _AssignActivationBarcodePageState();
}

class _AssignActivationBarcodePageState
    extends State<AssignActivationBarcodePage> {
  // Add state variables and methods as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Scan Barcode',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0), // Adjust the horizontal padding as needed
              child: Text(
                'Proof Of Fitment Of Fastag',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
             SizedBox(height: 20),
            Card(
              color: Color(0xFFFFFFFF),
              elevation: 0.7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                // side: BorderSide(
                //   color: Color(0xFF0056D0),
                //   width: 2.0,
                // ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column for labels
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424752),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Vehicle No',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424752),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tag ID',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424752),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Barcode No',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424752),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20), // Space between columns
                        // Right column for values
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ':  Partha Palallatkar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424752),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              ':  WB44J8800',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424752),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              ':  34161FA820328EE82FAB0500',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424752),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              ':  608116-023-0874536',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424752),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
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
                                color: Color(0xFF0056D0), // Blue border color
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Implement print challan action
                              },
                              child: Text(
                                'Print Challan',
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
                              color: Color(0xFF0056D0), // Blue background color
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Implement back to home action
                              },
                              child: Text(
                                'Back to Home',
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
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AssignActivationBarcodePage(),
  ));
}
