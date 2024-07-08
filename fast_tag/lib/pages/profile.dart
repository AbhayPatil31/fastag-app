import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/Profileresponse.dart';

import '../utility/snackbardesign.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> profileData = {};

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
              profileData = {
                "fullName":
                    "${profileDataObject.firstName} ${profileDataObject.lastName}",
                "mobileNumber": profileDataObject.mobileNumber,
                "email": profileDataObject.email,
                "address": profileDataObject.address,
                "pincode": profileDataObject.pincode,
                "ifscCode": profileDataObject.ifscCode,
              };
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

  Map<String, IconData> icons = {
    "fullName": Icons.account_circle,
    "mobileNumber": Icons.phone,
    "email": Icons.email,
    "address": Icons.home,
    "ifscCode": Icons.location_city,
    "pincode": Icons.pin_drop,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile', style: TextStyle(color: Colors.black)),
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
                children: profileData.entries.map((entry) {
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
                            icons[entry.key],
                            color: Color.fromRGBO(121, 120, 120, 1),
                          ),
                          SizedBox(width: 30),
                          Text(
                            entry.value ?? '',
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
