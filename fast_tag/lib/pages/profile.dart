import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/Profileresponse.dart';

import '../utility/snackbardesign.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> profileData = [];

  Future<void> fetchProfileData() async {
    NetworkCall networkCall = NetworkCall();
    String profileString =
        createjson().createJsonForProfile(AppUtility.AgentId);

    List<Object?>? list = await networkCall.postMethod(
      URLS().profile_details_api,
      URLS().profile_details_apiUrl,
      profileString,
      context,
    );
    if (list != null) {
      List<Profileresponse> responseFinal = List.from(list);
      String status = responseFinal![0].status!;
      switch (status) {
        case "true":
          ProfileData? profileDataObject = responseFinal[0].data;

          if (profileDataObject != null) {
            print('Profile Data: $profileDataObject');

            setState(() {
              profileData = [
                {
                  "label": "Full Name",
                  "value":
                      "${profileDataObject.firstName} ${profileDataObject.lastName}",
                  "icon": Icons.account_circle
                },
                {
                  "label": "Mobile Number",
                  "value": profileDataObject.mobileNumber,
                  "icon": Icons.phone
                },
                {
                  "label": "Email",
                  "value": profileDataObject.email,
                  "icon": Icons.email
                },
                {
                  "label": "Address",
                  "value": profileDataObject.address,
                  "icon": Icons.home
                },
                {
                  "label": "Pincode",
                  "value": profileDataObject.pincode,
                  "icon": Icons.pin_drop
                },
                {
                  "label": "IFSC Code",
                  "value": profileDataObject.ifscCode,
                  "icon": Icons.location_city
                },
              ];
            });
          }
          break;
        case "false":
          break;
      }
    } else {
      SomethingWentWrongSnackBarDesign(context);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // First section: Profile photo in a circle with blue border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/man.png'),
              ),
            ),
            SizedBox(height: 20),

            // Second section: Display profile information
            Container(
              color: Colors.white,
              height: 617, // Adjust height as needed
              child: Column(
                children: profileData
                    .where((item) =>
                        item['value'] != null &&
                        item['value'].toString().isNotEmpty)
                    .map((item) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 20,
                    ),
                    child: Container(
                      margin: EdgeInsets.all(7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            item['icon'],
                            color: Color.fromRGBO(121, 120, 120, 1),
                          ),
                          SizedBox(width: 30),
                          Text(
                            item['value'],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color(0xFF727272),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
