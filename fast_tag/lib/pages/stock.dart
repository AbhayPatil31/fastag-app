import 'package:fast_tag/api/network/create_json.dart';
import 'package:fast_tag/api/network/network.dart';
import 'package:fast_tag/api/network/uri.dart';
import 'package:fast_tag/api/response/stocklistresponse.dart';
import 'package:fast_tag/pages/assign_barcode.dart';
import 'package:fast_tag/pages/skeletonpage.dart';
import 'package:fast_tag/pages/stockcategorylist.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/colorfile.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:fast_tag/utility/snackbardesign.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

List<StocklistDatum> stocklist = [];
bool nodata = true;

class StockPage extends StatefulWidget {
  State createState() => StockPageState();
}

class StockPageState extends State<StockPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforstocklist(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stocklist.clear();
  }

  Future<void> Networkcallforstocklist(bool showprogress) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String createjsonforstocklist =
          createjson().createjsonforstocklist(AppUtility.AgentId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().stock_list_api,
          URLS().stock_list_api_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Stocklistresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            stocklist = response[0].data!;
            if (stocklist.isNotEmpty) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Stock',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D2024),
              fontSize: 18,
            )),
      ),
      body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              Networkcallforstocklist(false);
            });
          },
          child: stocklist.isEmpty
              ? Skeleton()
              : RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 1), () {
                      Networkcallforstocklist(false);
                    });
                  },
                  child: stocklist.isEmpty
                      ? nodata
                          ? Expanded(child: Skeleton())
                          : Column(
                              children: [
                                Center(
                                  child: Lottie.asset(
                                    'images/nodatawithvehicle.json',
                                  ),
                                ),
                                Text(
                                  ' No stock found ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Looks like you haven't any stock yet ",
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
                      : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            itemCount: stocklist.length,
                            itemBuilder: (context, index) {
                              return buildCard(
                                  stocklist[index].count.toString(),
                                  stocklist[index].categoryName!,
                                  Color(hexStringToHexInt(
                                      stocklist[index].vehicleColor!)),
                                  stocklist[index].id!);
                            },
                          ),
                        ),
                )),
    );
  }

  hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  Widget buildCard(
      String number, String title, Color color, String vechicleid) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return StockCategoryList(vechicleid, title);
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: color, width: 2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      height: 4,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 20.0), // Equal inner space on all sides
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 05,
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff353B43),
                          ),
                        ),
                      ),
                      // Add more children here if needed
                    ],
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
