import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/pages/signUp.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/Profileresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/snackbardesign.dart';

class ProfileItem {
  final String label;
  final String value;
  final IconData? icon;

  ProfileItem({required this.label, required this.value, this.icon});
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<ProfileItem> profileData = [];
  ProfileData? profileDataObject;

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
          profileDataObject = responseFinal[0].data;

          if (profileDataObject != null) {
            print('Profile Data: $profileDataObject');

            setState(() {
              profileData = [
                ProfileItem(
                  label: "Full Name",
                  value:
                      "${profileDataObject!.firstName ?? ''} ${profileDataObject!.lastName ?? ''}",
                  icon: Icons.account_circle,
                ),
                ProfileItem(
                  label: "Mobile Number",
                  value: profileDataObject!.mobileNumber ?? '',
                  icon: Icons.phone,
                ),
                ProfileItem(
                  label: "Alternate Mobile Number",
                  value: profileDataObject!.alternameMobileNumber ?? '',
                  icon: Icons.phone_android,
                ),
                ProfileItem(
                  label: "Email",
                  value: profileDataObject!.email ?? '',
                  icon: Icons.email,
                ),
                ProfileItem(
                  label: "Address",
                  value: profileDataObject!.address ?? '',
                  icon: Icons.home,
                ),
                ProfileItem(
                  label: "Pincode",
                  value: profileDataObject!.pincode ?? '',
                  icon: Icons.pin_drop,
                ),
                ProfileItem(
                  label: "City",
                  value: profileDataObject!.city ?? '',
                  icon: Icons.location_city,
                ),
                ProfileItem(
                  label: "State",
                  value: profileDataObject!.state ?? '',
                  icon: Icons.map,
                ),
                ProfileItem(
                  label: "Country",
                  value: profileDataObject!.country ?? '',
                  icon: Icons.flag,
                ),
                ProfileItem(
                  label: "IFSC Code",
                  value: profileDataObject!.ifscCode ?? '',
                  icon: Icons.account_balance,
                ),
                ProfileItem(
                  label: "City Name",
                  value: profileDataObject!.cityName ?? '',
                  icon: Icons.location_city,
                ),
                ProfileItem(
                  label: "State Name",
                  value: profileDataObject!.stateName ?? '',
                  icon: Icons.map,
                ),
                ProfileItem(
                  label: "Country Name",
                  value: profileDataObject!.countryName ?? '',
                  icon: Icons.flag,
                ),
                // Logout button
                ProfileItem(
                  label: "Logout",
                  value: "",
                  icon: Icons.logout,
                ),
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
                backgroundImage: profileDataObject != null &&
                        profileDataObject!.imagePathPhoto != null &&
                        profileDataObject!.imagePathPhoto!.isNotEmpty
                    ? NetworkImage(profileDataObject!.imagePathPhoto!)
                    : AssetImage('images/man.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),

            // Second section: Display profile information
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: profileData.length,
                  itemBuilder: (context, index) {
                    final item = profileData[index];
                    if (item.value.isEmpty && item.label != "Logout") {
                      return SizedBox.shrink();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 20,
                      ),
                      child: GestureDetector(
                        onTap: item.label == "Logout"
                            ? () {
                                _showLogoutConfirmationDialog(context);
                              }
                            : null,
                        child: Container(
                          margin: EdgeInsets.all(7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (item.icon != null) ...[
                                Icon(
                                  item.icon,
                                  color: Color.fromRGBO(121, 120, 120, 1),
                                ),
                                SizedBox(width: 30),
                              ],
                              Text(
                                item.value.isNotEmpty ? item.value : item.label,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: item.label == "NLogout"
                                      ? Colors.red
                                      : Color(0xFF727272),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
