import 'package:flutter/material.dart';
import 'package:fast_tag/pages/assign_fastag.dart';
import 'package:fast_tag/pages/onboardingScreen2.dart';
import 'package:fast_tag/pages/profile.dart';
import 'package:fast_tag/pages/replace_fastag.dart';
import 'package:fast_tag/pages/report.dart';
import 'package:fast_tag/pages/request_fastag.dart';
import 'package:fast_tag/pages/signUp.dart';
import 'package:fast_tag/pages/stock.dart';
import 'package:fast_tag/pages/tickets_help.dart';
import 'package:fast_tag/pages/wallet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'request_list.dart';
import 'tickets_list.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  void initState() {
    super.initState();
    // Perform initialization if needed
  }

  @override
  Widget build(BuildContext context) {
    double width1 = MediaQuery.of(context).size.width * 0.2;
    double height1 = MediaQuery.of(context).size.height * 0.26;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/sideBar.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.only(top: height1),
          children: <Widget>[
            // DrawerHeader(
            //   padding: EdgeInsets.all(10),
            //   child: Container(
            //     height: 200,
            //   ), // Adjust as needed
            //   decoration: BoxDecoration(
            //     color: Colors.transparent,

            //   ),

            // ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.sports_hockey),
              title: Text(
                'Stock',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text(
                'Reports',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.wallet),
              title: Text(
                'Wallet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text(
                'Raise Ticket',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicketsListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_add),
              title: Text(
                'Assign Fastag',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignFastagPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.find_replace),
              title: Text(
                'Replace Fastag',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReplaceFastagPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.request_page_outlined),
              title: Text(
                'Request for Fastag',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestFastag()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.request_page_outlined),
              title: Text(
                'Fastag Request List',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FastTagRequestListPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                ClipRect(
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Logout",
                          style: GoogleFonts.inter(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 86, 208, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300], // Horizontal gray line
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              // Use Expanded for Cancel button
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the modal
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.resolveWith<
                                      BorderSide>(
                                    (Set<MaterialState> states) {
                                      return BorderSide(
                                          color:
                                              Colors.grey[300]!); // Gray border
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 50), // Adjust spacing between buttons
                            Expanded(
                              // Use Expanded for Yes, logout button
                              child: ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences idsaver =
                                      await SharedPreferences.getInstance();
                                  await idsaver.clear();
                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromRGBO(
                                        0, 86, 208, 1), // Blue background
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Yes, logout',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
