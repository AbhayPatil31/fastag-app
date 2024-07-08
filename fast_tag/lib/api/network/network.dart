import 'dart:developer';

import 'package:fast_tag/api/call/cancelpendingissuancecall.dart';
import 'package:fast_tag/api/call/getmapperclasscall.dart';
import 'package:fast_tag/api/call/walletamountcall.dart';
import 'package:fast_tag/api/call/wallettransactionhistorycall.dart';
import 'package:fast_tag/api/response/Profileresponse.dart';
import 'package:fast_tag/api/response/addcustomerdetailsresponse.dart';
import 'package:fast_tag/api/response/addvehicledetailsresponse.dart';
import 'package:fast_tag/api/response/agentplanresponse.dart';
import 'package:fast_tag/api/response/assignfasttagresponse.dart';
import 'package:fast_tag/api/response/bannerresponse.dart';
import 'package:fast_tag/api/response/cancelpendingissuanceresponse.dart';
import 'package:fast_tag/api/response/categorydetailsresponse.dart';
import 'package:fast_tag/api/response/completerequestresponse.dart';
import 'package:fast_tag/api/response/deletefasttagrequestresponse.dart';
import 'package:fast_tag/api/response/editfasttagrequestresponse.dart';
import 'package:fast_tag/api/response/fasttagrequestlistresponse.dart';
import 'package:fast_tag/api/response/getallbarcoderesponse.dart';
import 'package:fast_tag/api/response/getassigntagwisedresponse.dart';
import 'package:fast_tag/api/response/getmapperclassresponse.dart';
import 'package:fast_tag/api/response/getnotificationresponse.dart';
import 'package:fast_tag/api/response/getvehicleclassresponse.dart';
import 'package:fast_tag/api/response/getwithdrawresponse.dart';
import 'package:fast_tag/api/response/inssuancereportcounterboxresponse.dart';
import 'package:fast_tag/api/response/paymentresponse.dart';
import 'package:fast_tag/api/response/pendingissuanceresponse.dart';
import 'package:fast_tag/api/response/replacevehicleotpresponse.dart';
import 'package:fast_tag/api/response/replacevehicleresponse.dart';
import 'package:fast_tag/api/response/requestcategoryresponse.dart';
import 'package:fast_tag/api/response/setvehicledetailsmanuallyresponse.dart';
import 'package:fast_tag/api/response/setwithdrawresponse.dart';
import 'package:fast_tag/api/response/stockcategoryresponse.dart';
import 'package:fast_tag/api/response/stocklistresponse.dart';
import 'package:fast_tag/api/response/totalwithdrawamountresponse.dart';
import 'package:fast_tag/api/response/validateotploginresponse.dart';
import 'package:fast_tag/api/response/validateotpresponse.dart';
import 'package:fast_tag/api/response/vehiclemakerresponse.dart';
import 'package:fast_tag/api/response/vehiclemodelresponse.dart';
import 'package:fast_tag/api/response/wallettotalamountresponse.dart';
import 'package:fast_tag/api/response/wallettransactionhistoryresponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../response/Helpresponse.dart';
import '../response/Loginresponse.dart';
import '../response/TicketdetailsListresponse.dart';
import '../response/Ticketdetailsresponse.dart';
import '../response/Ticketlistresponse.dart';
import '../response/Ticketraiseresponse.dart';

class NetworkCall {
  Future<List<Object?>?> postMethod(
      int requestCode, String url, String body, BuildContext context) async {
    var response = await http.post(Uri.parse(url), body: body);
    // var data = response.body;
    try {
      if (response.statusCode == 200) {
        String ResponseString = response.body;

        String str = "[" + ResponseString + "]";
        print(str);

        switch (requestCode) {
          case 1:
            final loginresponse = loginresponseFromJson(str);
            return loginresponse;
          case 2:
            final profileresponse = profileresponseFromJson(str);
            return profileresponse;
          case 4:
            final ticketdetailsresponse = ticketdetailsresponseFromJson(str);
            return ticketdetailsresponse;
          case 5:
            final ticketlistresponse = ticketlistresponseFromJson(str);
            return ticketlistresponse;

          case 6:
            final ticketdetailsListresponse =
                ticketdetailsListresponseFromJson(str);
            return ticketdetailsListresponse;
          case 7:
            final ticketraiseresponse = ticketraiseresponseFromJson(str);
            return ticketraiseresponse;
          case 8:
            final stocklistresponse = stocklistresponseFromJson(str);
            return stocklistresponse;

          case 9:
            final stockcategory = stockcategoryresponseFromJson(str);
            return stockcategory;
          case 10:
            final walletamount = wallettotalamountresponseFromJson(str);
            return walletamount;
          case 11:
            final wallettransactionhistory =
                wallettransactionhistoryresponseFromJson(str);
            return wallettransactionhistory;
          case 12: //Get Method
            break;
          case 13:
            final categorydetails = categorydetailsresponseFromJson(str);
            return categorydetails;
          case 14:
            final requestlist = fasttagrequestlistresponseFromJson(str);
            return requestlist;
          case 15:
            final completerequest = completefasttagrequestresponseFromJson(str);
            return completerequest;
          case 16:
            final editfastage = editfasttagrequestresponseFromJson(str);
            return editfastage;
          case 17:
            final payment = rechargeNowResponseFromJson(str);
            return payment;
          case 18:
            final assignfasttag = assignvehicleresponseFromJson(str);
            return assignfasttag;
          case 19:
            final validateotp = verifyotpresponseFromJson(str);
            return validateotp;
          case 20:
            final vehiclemaker = vehiclemakerresponseFromJson(str);
            return vehiclemaker;
          case 21:
            final vehiclemodel = vehiclemodelresponseFromJson(str);
            return vehiclemodel;
          case 22:
            final agentplan = agentplanresponseFromJson(str);
            return agentplan;
          case 23:
            final customerdetails = addcustomerdetailsresponseFromJson(str);
            return customerdetails;
            break;
          case 24:
            final setvehicledetails =
                setvehicledetailsmanuallyresponseFromJson(str);
            return setvehicledetails;
          case 25: //update vehicle details
            final addvehicle = addvehicledetailsresponseFromJson(str);
            return addvehicle;
          case 26:
            final replace = replacevehicleresponseFromJson(str);
            return replace;

          case 27:
            final replaceotp = replacevehicleotpresponseFromJson(str);
            return replaceotp;
          case 28:
            final getallbarcode = getallbarcoderesponseFromJson(str);
            return getallbarcode;
          case 29:
            final verifyotp = validateotploginresponseFromJson(str);
            return verifyotp;
          case 30:
            final notificationlist = getnotificationresponseFromJson(str);
            return notificationlist;
          case 31:
            final issuancecount =
                issusancereportcounterboxresponseFromJson(str);
            return issuancecount;
          case 32:
            final pendinglist = pendingissuanceresponseFromJson(str);
            return pendinglist;
          case 33:
            final deleterequest = deletefastagrequestresponseFromJson(str);
            return deleterequest;
          case 34:
            final cancelpending = cancelpendingissuanceresponseFromJson(str);
            return cancelpending;
          case 35:
            final assigntag = getassignedtagdatewiseresponseFromJson(str);
            return assigntag;
          case 37:
            final setwithdraw = setwithdrawresponseFromJson(str);
            return setwithdraw;
          case 38:
            final getwithdraw = getwithdrawresponseFromJson(str);
            return getwithdraw;
          case 39:
            final total = totalwithdrawamountresponseFromJson(str);
            return total;
          case 40://this is 8-7-24 work,have to add id to otherlist.
            final mapperclass = getmapperclassresponseFromJson(str);//this is 8-7-24 work,have to add id to otherlist.
            return mapperclass;
        }
      } else if (response.statusCode == 400) {
        switch (requestCode) {
          case 1:
            break;
          case 2:
            break;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      // SnackBarDesign("Something went wrong", context);
    }
    return null;
  }

  Future<List<Object?>?> getMethod(
      int requestCode, String url, BuildContext context) async {
    var response = await http.get(Uri.parse(url),);
    log("url : $url");
    
    try {
      if (response.statusCode == 200) {
        String ResponseString = response.body;

        String str = "[" + ResponseString + "]";
        log("Response : $str");
        switch (requestCode) {
          case 3:
            final helplist = helpresponseFromJson(str);
            return helplist;
          case 12:
            final requestcategory = requestcategoryresponseFromJson(str);
            return requestcategory;
          case 36:
            final banner = bannerresponseFromJson(str);
            return banner;
          case 41:
            final Getvehicleclassresponse =
                getvehicleclassresponseFromJson(str);
            return Getvehicleclassresponse;

          default:
            break;
        }
      } else if (response.statusCode == 400) {
        switch (requestCode) {
          case 11:
            break;

          default:
            break;
        }
      } else {}
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
