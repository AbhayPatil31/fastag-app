import 'package:fast_tag/pages/skeletonpage.dart';
import 'package:fast_tag/pages/tickets_details.dart';
import 'package:fast_tag/pages/tickets_raise.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:fast_tag/utility/snackbardesign.dart';
import 'package:flutter/material.dart';
import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/Ticketlistresponse.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/colorfile.dart';

class TicketsListPage extends StatefulWidget {
  @override
  _TicketsListPageState createState() => _TicketsListPageState();
}

class _TicketsListPageState extends State<TicketsListPage> {
  List<TicketListData> ticketListData = [];
  bool nodata = true;
  Future<void> fetchTicketsData(bool showprogress) async {
    try {
      ticketListData.clear();
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String ticketsString =
          createjson().createJsonForTicketList(AppUtility.AgentId);

      List<Object?>? list = await NetworkCall().postMethod(
        URLS().all_ticket_list_api,
        URLS().all_ticket_list_apiUrl,
        ticketsString,
        context,
      );
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Ticketlistresponse> response = List.from(list);
        String status = response[0].status!;
        switch (status) {
          case "true":
            ticketListData = response[0].data!;
            if (ticketListData.isNotEmpty) {
              nodata = true;
            } else {
              nodata = false;
            }
            setState(() {});
            break;
          case "false":
            nodata = false;
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

  @override
  void initState() {
    super.initState();
    fetchTicketsData(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ticketListData.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Tickets',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0), // Add padding to the button
              child: TextButton(
                onPressed: () {
                  // Navigate to the RaiseTicketsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RaiseTicketsPage(),
                    ),
                  ).then((value) {
                    fetchTicketsData(true);
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Background color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5), // BorderRadius for rounded corners
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 15.0), // Padding inside the button
                  child: Text(
                    'Raise Ticket', // Text label for the button
                    style: TextStyle(
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFAFAFA),
        body:
            // ticketListData.isEmpty
            //     ? Skeleton()
            //     :
            ticketListData.isEmpty
                ? nodata
                    ? Skeleton()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              'images/helps.png', // Replace with your actual image asset
                              height: 400, // Adjust the height as needed
                            ),
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
                                        builder: (context) =>
                                            TicketsListPage()),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color(0xFF0056D0),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      'Raise Ticket',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                : ListView.builder(
                    itemCount: ticketListData.length,
                    itemBuilder: (context, index) {
                      return transactionCard(ticketListData[index]);
                    },
                  ));
  }

  Widget transactionCard(TicketListData ticketData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailsPage(
              id: ticketData.id!, // Pass the id
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        child: Card(
          color: Color(0xFFFFFFFF),
          elevation: 0.7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  'Ticket No: ${ticketData.ticketNumber}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${ticketData.description}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424752),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${ticketData.ticketCreateDate}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF424752),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 11,
                          color: ticketData.status == "1"
                              ? Color(0xFFB81D01)
                              : colorfile().sucessmessagebcColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${ticketData.status == "1" ? "Pending" : "Completed"}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF424752),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TicketsListPage(),
  ));
}
