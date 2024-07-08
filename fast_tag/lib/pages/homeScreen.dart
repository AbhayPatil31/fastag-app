import 'package:fast_tag/api/response/Profileresponse.dart';
import 'package:fast_tag/api/response/bannerresponse.dart';
import 'package:fast_tag/pages/assign_fastag.dart';
import 'package:fast_tag/pages/notifiation.dart';
import 'package:fast_tag/pages/npci_details.dart';
import 'package:fast_tag/pages/profile.dart';
import 'package:fast_tag/pages/recharge.dart';
import 'package:fast_tag/pages/replace_fastag.dart';
import 'package:fast_tag/pages/report.dart';
import 'package:fast_tag/pages/request_fastag.dart';
import 'package:fast_tag/pages/request_list.dart';
import 'package:fast_tag/pages/sidebar.dart';
import 'package:fast_tag/pages/signUp.dart';
import 'package:fast_tag/pages/stock.dart';
import 'package:fast_tag/pages/tickets_list.dart';
import 'package:fast_tag/pages/tickets_raise.dart';
import 'package:fast_tag/pages/wallet.dart';
import 'package:fast_tag/pages/withdraw_request.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../api/response/wallettotalamountresponse.dart';
import '../utility/colorfile.dart';
import '../utility/progressdialog.dart';
import '../utility/snackbardesign.dart';
import 'setvehicledetails.dart';
import 'withdraw_history.dart';

String wallenttotalamount = "0";

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

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
          AppUtility.Name = profileDataObject!.firstName!;
          AppUtility.Mobile_Number = profileDataObject!.mobileNumber!;
          setState(() {});
          Networkcallforwalletamount();
          Networkcallforbanner(false);
          break;
        case "false":
          break;
      }
    } else {
      SomethingWentWrongSnackBarDesign(context);
      SharedPreferences idsaver = await SharedPreferences.getInstance();
      await idsaver.clear();
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    }
  }

  Future<void> Networkcallforwalletamount() async {
    try {
      //AppUtility.AgentId,
      String createjsonforstocklist =
          createjson().createjsonforstocklist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().wallet_total_amount_api,
          URLS().wallet_total_amount_api_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        List<Wallettotalamountresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            wallenttotalamount = response[0].data![0].amount!;
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

  List<BannerDatum> bannerimageslist = [];
  String bannerimagebaseurl = "";
  Future<void> Networkcallforbanner(bool showprogress) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }

      List<Object?>? list = await NetworkCall().getMethod(
          URLS().get_banner_list, URLS().get_banner_list_url, context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Bannerresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            bannerimagebaseurl = response[0].imageUrl!;
            bannerimageslist = response[0].data!;
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
        if (showprogress) {
          Navigator.pop(context);
        }
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index
    switch (index) {
      case 0:
        _navigateToHome();
        break;
      case 1:
        _navigateToAssignFasttag();
        break;
      case 2:
        _navigateToReplaceFastag();
        break;
      case 3:
        _navigateToRequestFastag();
        break;
    }
  }

  void _navigateToRequestFastag() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => RequestFastag()))
        .then((value) {
      _selectedIndex = 0;
      Networkcallforwalletamount();
      setState(() {});
    });
  }

  void _navigateToReplaceFastag() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ReplaceFastagPage()))
        .then((value) {
      _selectedIndex = 0;
      Networkcallforwalletamount();
      setState(() {});
    });
  }

  void _navigateToHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyDashboard()));
  }

  void _navigateToAssignFasttag() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => AssignFastagPage()))
        .then((value) {
      _selectedIndex = 0;
      Networkcallforwalletamount();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // _showLogoutConfirmationDialog(context);
        //return true;
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          _onItemTapped(_selectedIndex);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(
            0, 86, 208, 1), // Set background color for the entire screen
        appBar: AppBar(
          toolbarHeight: 80.0,
          backgroundColor: Color.fromRGBO(0, 86, 208, 1),
          automaticallyImplyLeading: false, // Add this line
          //    flexibleSpace: ,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Shaurya Softrack',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),

        endDrawer: SideBar(),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              //Networkcallforwalletamount();
              //Networkcallforbanner(false);
              fetchProfileData();
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Color(0xFF0056D0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              16.0), // Add your desired horizontal padding here
                      child: Text(
                        "Hi, ${AppUtility.Name} 🙋‍♂️ ",
                        style: TextStyle(
                          fontSize: 20, // Add your desired font size here
                          color: Colors.white,
                          fontWeight: FontWeight
                              .w600, // Add your desired text color here
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        "Balance : ₹ $wallenttotalamount ",
                        style: TextStyle(
                          fontSize: 16, // Add your desired font size here
                          color:
                              Colors.white, // Add your desired text color here
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              firstcardwidget(),
              SizedBox(height: 20.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 25.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportPage()),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/report.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'Report',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StockPage()),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/stock.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'Stock',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WalletPage()),
                                        ).then((value) {
                                          Networkcallforwalletamount();
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/wallet.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'Wallet',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 15),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage()),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/profiles.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'Profile',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TicketsListPage()),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/raise.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'Raise Ticket',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NPCIDetailsPage()),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/npci.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'NPCI',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RechargePage("home")),
                                        ).then((value) {
                                          Networkcallforwalletamount();
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/wallet.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'Recharge',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationPage()),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/notification.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'Notification',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WithdrawHistoryPage()),
                                        ).then((value) {
                                          Networkcallforwalletamount();
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'images/wallet.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            'Withdraw',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),

                              bannerimageslist.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.all(
                                          0.0), // Adjust padding as needed
                                      child: CarouselWithIndicator(
                                          bannerimagebaseurl, bannerimageslist),
                                    )
                                  : Container(),

                              // Why Shaurya Pay
                              SizedBox(height: 30),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 0),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                    left: 0,
                                    right: 0,
                                  ), // Add padding all around the Row
                                  color: Color.fromRGBO(235, 243, 255,
                                      1), // Set background color to light blue
                                  child: Column(
                                    children: [
                                      Text(
                                        'Why Shaurya Pay ?', // Add your text here
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 14),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           FastTagRequestListPage()),
                                              // );
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  'images/transperency.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                Text(
                                                  'Transparency',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Add navigation logic here for the 'Stock' page
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  'images/recharge.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                Text(
                                                  'Easy to Recharge',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Add navigation logic here for the 'Wallet' page
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  'images/time.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                Text(
                                                  'Time-Saving',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Set
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF0056D0),

          unselectedItemColor:
              Colors.black, // Set the unselected icon color to black
          showUnselectedLabels: true, // Show labels for all items
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              label: 'Assign',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speaker_notes_outlined),
              label: 'Replace',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Request',
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to exit?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Replace current route with the Login page
                Navigator.pop(context);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColumn(IconData icon, String text) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget firstcardwidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        firstcardinsidecardwidget('images/assignFastag.png', 'Assign', 0),
        firstcardinsidecardwidget('images/replaceFastag.png', 'Replace', 1),
        firstcardinsidecardwidget('images/requestFastag.png', 'Request', 2)
      ],
    );
  }

  Widget firstcardinsidecardwidget(String imagename, String name, int index) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            _navigateToAssignFasttag();
            break;
          case 1:
            _navigateToReplaceFastag();
            break;
          case 2:
            _navigateToRequestFastag();
            break;
        }
      },
      child: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.25, // Adjust width based on screen size
          height: MediaQuery.of(context).size.width *
              0.35, // Adjust height based on screen size
          child: Container(
            color: Color.fromRGBO(0, 72, 175, 1).withOpacity(0.6),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    imagename,
                    width: 28,
                    height: 28,
                  ),
                  SizedBox(height: 8),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class CarouselWithIndicator extends StatefulWidget {
  String imageurl;
  List<BannerDatum> bannerimageslist;
  CarouselWithIndicator(this.imageurl, this.bannerimageslist);

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.bannerimageslist
              .map((item) => GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(item.bannerLink!);
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0), // 5px radius
                        border: Border.all(
                          color: Colors.blue, // 1px blue border
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0), // 5px radius

                        child: Image.network(
                          widget.imageurl + item.banner!,
                          width: 330,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.5,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.bannerimageslist.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.blue)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
