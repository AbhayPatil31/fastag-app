import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:fast_tag/utility/colorfile.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:fast_tag/utility/snackbardesign.dart';
import 'package:flutter/material.dart';
import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/TicketdetailsListresponse.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'skeletonpage.dart';

class TicketDetailsPage extends StatefulWidget {
  final String id;

  TicketDetailsPage({required this.id});

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  bool loading = true;
  // Map<String, dynamic>? ticketDetails;
  // List<Map<String, dynamic>> data1List = []; // List to store data1 items

  Future<void> addReply(String id, String description) async {
    String profileString =
        createjson().createJsonForTicketDetailsInfo(id, description);
    NetworkCall networkCall = NetworkCall();

    var ticketdetailsresponse = await networkCall.postMethod(
      URLS().set_ticket_reply_api,
      URLS().set_ticket_reply_apiUrl,
      profileString,
      context,
    );

    if (ticketdetailsresponse != null) {
      List<dynamic>? responseData = List.from(ticketdetailsresponse!);
      String status = responseData[0].status!;

      switch (status) {
        case "true":
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reply sent successfully'),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );

          // Fetch updated data after successful reply
          await fetchTicketsInfoData(
              widget.id); // Assuming widget.id is the ticket id
          // Clear Input
          _descriptionController.clear();
          break;

        case "false":
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No valid data received'),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
          break;
      }
    } else {
      print('Invalid response or null value');
    }
  }

  Ticket? ticketData;
  List<Reply> tickereply = [];
  bool nodata = true;
  Future<void> fetchTicketsInfoData(String ticket_id) async {
    try {
      ProgressDialog.showProgressDialog(context, " title");
      String ticketsString =
          createjson().ticketdetailsListresponseFromJson(ticket_id);

      List<dynamic>? list = await NetworkCall().postMethod(
        URLS().ticket_details_api,
        URLS().ticket_details_apiUrl,
        ticketsString,
        context,
      );

      if (list != null) {
        Navigator.pop(context);
        List<TicketdetailsListresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            ticketData = response[0].ticket!;
            tickereply = response[0].reply!;
            if (ticketData == null) {
              nodata = true;
            } else {
              nodata = false;
            }
            setState(() {});
            setState(() {});
            break;
          case "false":
            nodata = false;
            SnackBarDesign(
                "No details found!",
                context,
                colorfile().errormessagebcColor,
                colorfile().errormessagetxColor);
            break;
        }
      } else {
        Navigator.pop(context);
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print('Error fetching ticket info: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTicketsInfoData(widget.id); // Use the id passed from TicketDetailsPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xFFFAFAFA),
      body: ticketData == null
          ? nodata
              ? Skeleton()
              : Column(
                  children: [
                    Center(
                      child: Lottie.asset(
                        'images/nodatawithvehicle.json',
                      ),
                    ),
                    Text(
                      ' No details found ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Looks like you haven't miss something ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
          : SingleChildScrollView(
              child: transactionCard(),
            ),
    );
  }

  Widget transactionCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35),
          // Display ticket details
          Text(
            'Ticket No: ${ticketData?.ticketNumber ?? ''}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${ticketData?.helpTypeName ?? ''}',
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
                'Date: ${ticketData?.ticketCreateDate != null ? DateFormat('dd-MM-yyyy').format(ticketData!.ticketCreateDate!) : ''}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF424752),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Description:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424752),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${ticketData?.description ?? ''}',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(53, 59, 67, 1),
            ),
          ),
          SizedBox(height: 10),
          // Below change the image after coming it from API
          Container(
            height: 182,
            width: 356,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
            ),
            child: ticketData?.getDecodedAttachment() != null
                ? Image.memory(
                    ticketData!.getDecodedAttachment()!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Text(
                      'No Attachment',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
          // Dynamic cards from data1List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tickereply.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color(
                    0xFFADE0F5), // Set the background color with hex code and opacity
                elevation: 0.7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tickereply[index].replyBy == "0"
                                ? "Me: "
                                : "Admin Reply:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424752),
                            ),
                          ),
                          Text(
                            '${DateFormat('dd-MM-yyyy hh:mm a').format(tickereply[index].createdOn!)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF424752),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: Text(
                          '${tickereply[index].description ?? ""}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF424752),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 8),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Reply',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 252, 250, 250),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    ),
                    minLines: 6,
                    maxLines: 6,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a reply';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      String description = _descriptionController.text;
                      // Validate form and add reply only if validation passes
                      if (_formKey.currentState!.validate()) {
                        addReply(ticketData!.id!, description);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0056D0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
