import 'package:fast_tag/api/response/stockcategoryresponse.dart';
import 'package:fast_tag/pages/skeletonpage.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:fast_tag/utility/progressdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../api/network/create_json.dart';
import '../api/network/network.dart';
import '../api/network/uri.dart';
import '../utility/colorfile.dart';
import '../utility/snackbardesign.dart';

List<StockcategoryDatum> stockcategory = [];
bool nodata = true;

class StockCategoryList extends StatefulWidget {
  String vehicleId, title;
  StockCategoryList(this.vehicleId, this.title);

  @override
  State<StockCategoryList> createState() => StockCategoryListState();
}

class StockCategoryListState extends State<StockCategoryList> {
  @override
  void initState() {
    super.initState();

    Networkcallforstockcategory(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stockcategory.clear();
    nodata = true;
  }

  Future<void> Networkcallforstockcategory(bool showprogress) async {
    try {
      nodata = true;
      setState(() {});
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String createjsonforstocklist = createjson().createjsonforstockcategory(
          AppUtility.AgentId, widget.vehicleId, context);
      List<Object?>? list = await NetworkCall().postMethod(
          URLS().stock_category_api,
          URLS().stock_category_api_url,
          createjsonforstocklist,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Stockcategoryresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            stockcategory = response[0].data!;
            if (stockcategory.isNotEmpty) {
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
        title: Text(
          'Stock Category List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            Networkcallforstockcategory(false);
          });
        },
        child: Column(
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.0),
                      stockcategory.isEmpty
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
                                      ' No stock category found ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Looks like you haven't any category yet ",
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
                          : Expanded(
                              child: ListView.builder(
                                itemCount: stockcategory.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                      horizontal: 35,
                                      vertical: 4,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0, 0),
                                          )
                                        ],
                                        border: Border.all(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    '${stockcategory[index].barcode} ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                      // : Center(
                      //     child: Text('No data'),
                      //   ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
