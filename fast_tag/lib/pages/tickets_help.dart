import 'package:fast_tag/api/response/TicketdetailsListresponse.dart';
import 'package:fast_tag/pages/tickets_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tickets_list.dart';
import 'tickets_raise.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
        backgroundColor: Color(0xFFFFFFFF), // Set white color here
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Center(
                    child: Image.asset(
                      'images/helps.png', // Replace with your actual image asset
                      height: 300, // Adjust the height as needed
                    ),
                  ),
                  Text("No Data Found",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D2024),
                        fontSize: 12,
                      )),
                ],
              ),
              const SizedBox(
                height: 49,
              ),
              Center(
                child: SizedBox(
                  width: 180.0, // Set the desired width here
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RaiseTicketsPage(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets
                            .zero, // Remove padding to make the gradient fill the button
                      ),
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return null; // Use the default color for pressed state
                        } else {
                          // Use gradient for default state
                          return null;
                        }
                      }),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF08469D),
                            Color(0xFF0056D0),
                            Color(0xFF0C92DD),
                          ],
                          stops: [0.0, 0.3425, 0.9974],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints.expand(
                            width: 180.0,
                            height: 50.0), // Set width and height constraints
                        child: Center(
                          child: Text(
                            'Raise Ticket',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HelpPage(),
  ));
}
