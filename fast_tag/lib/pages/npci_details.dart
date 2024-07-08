import 'package:fast_tag/pages/npci.dart';
import 'package:flutter/material.dart';

class NPCIDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NPCI Details',
          style: TextStyle(
            fontSize: 20, // 25px size
            fontWeight: FontWeight.bold, // Bold text
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
                  Text(
                    'NPCI',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    width: 160, // Adjust the width as needed
                    height: 35, // Adjust the height as needed
                    decoration: BoxDecoration(
                      
                      // Add other decorations if needed, like border, boxShadow, etc.
                    ),
                    child: Image.asset(
                      'images/npci_detail.png',
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 50), // Adding space before the input fields

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Your Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // Adjust the font size as needed
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Vehicle Number*',
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
                      ),
                    ),
                  ),

                 

                  // Dropdown field
                

                  // Number input field
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
                      decoration: InputDecoration(
                        hintText: 'Enter Tag ID ',
                        border: OutlineInputBorder(), // Remove underline
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.blue), // Change border color on focus
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
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30), // Adding space before the button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement button onPressed

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NPCIPage()),
                  );
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
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NPCIDetailsPage(),
  ));
}
