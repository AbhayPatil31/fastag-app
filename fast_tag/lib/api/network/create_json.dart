import 'dart:convert';

import 'package:fast_tag/api/call/Logincalljson.dart';
import 'package:fast_tag/api/call/Profilejson.dart';
import 'package:fast_tag/api/call/addcustomerdetailscall.dart';
import 'package:fast_tag/api/call/addvehicledetailscall.dart';
import 'package:fast_tag/api/call/agentplancall.dart';
import 'package:fast_tag/api/call/assignvehiclecall.dart';
import 'package:fast_tag/api/call/callwithagentid.dart';
import 'package:fast_tag/api/call/cancelpendingissuancecall.dart';
import 'package:fast_tag/api/call/completefasttagrequestcall.dart';
import 'package:fast_tag/api/call/deletefastatgrequestcall.dart';
import 'package:fast_tag/api/call/editfasttagrequestcall.dart';
import 'package:fast_tag/api/call/getallbarcodecall.dart';
import 'package:fast_tag/api/call/getassigntagwisedcall.dart';
import 'package:fast_tag/api/call/rechargenowcall.dart';
import 'package:fast_tag/api/call/replacevehiclecall.dart';
import 'package:fast_tag/api/call/replacevehicleotpcall.dart';
import 'package:fast_tag/api/call/setvehicledetailsmanuallycall.dart';
import 'package:fast_tag/api/call/setwithdrawcall.dart';
import 'package:fast_tag/api/call/stockcategorycall.dart';
import 'package:fast_tag/api/call/stocklistcall.dart';
import 'package:fast_tag/api/call/vehicalmakercall.dart';
import 'package:fast_tag/api/call/vehiclemodelcall.dart';
import 'package:fast_tag/api/call/verifyotpcall.dart';
import 'package:fast_tag/api/call/walletamountcall.dart';
import 'package:fast_tag/api/call/wallettransactionhistorycall.dart';
import 'package:fast_tag/api/response/getassigntagwisedresponse.dart';
import 'package:fast_tag/api/response/paymentresponse.dart';
import 'package:fast_tag/utility/apputility.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../call/editfasttagrequestcall.dart' as editcategorycall;
import '../call/TicketdetailsListjson.dart';
import '../call/Ticketdetailsjson.dart';
import '../call/Ticketlistjson.dart';
import '../call/Ticketraisejson.dart';
import '../call/categorydetailscall.dart';
import '../call/categorydetailscall.dart' as categorycall;
import '../call/validateotpcall.dart';

class createjson {
  String createJsonForLogin(String? mobile_number, String pushtoken) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Logincalljson loginjsonCreation =
          Logincalljson(mobile_number: mobile_number, push_token: pushtoken);
      var result = Logincalljson.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createJsonForProfile(String? id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Profilejson loginjsonCreation = Profilejson(id: id);
      var result = Profilejson.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforstocklist(String agentId, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Stocklistcall Stocklistcalljson = Stocklistcall(agentId: agentId);
      var result = Stocklistcall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforstockcategory(
      String agentId, String vehicle, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Stockcategorycall stockcategorycall =
          Stockcategorycall(agentId: agentId, vehicleCategory: vehicle);
      var result = Stockcategorycall.fromJson(stockcategorycall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  } // Raise All Tickits List

  String createJsonForTicketList(String? agent_id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Ticketlistjson loginjsonCreation = Ticketlistjson(agent_id: agent_id);
      var result = Ticketlistjson.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  // Raise Tickits For Add reply
  String createJsonForTicketDetailsInfo(String? id, String? description) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Ticketdetailsjson loginjsonCreation =
          Ticketdetailsjson(id: id, description: description);
      var result = Ticketdetailsjson.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

// Raise Tickits For Single list
  String ticketdetailsListresponseFromJson(String? id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      TicketdetailsListjson loginjsonCreation = TicketdetailsListjson(id: id);
      var result = TicketdetailsListjson.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

// Raise Tickits For Add Tickits
  String ticketraiseresponseFromJson(
      String? agent_id, String? description, String? help_type_id) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Ticketraisejson loginjsonCreation = Ticketraisejson(
          agent_id: agent_id,
          description: description,
          help_type_id: help_type_id);
      var result = Ticketraisejson.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonfortotalwalletamount(
      String? agent_id, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Wallettotalamountcall loginjsonCreation = Wallettotalamountcall(
        agentId: agent_id,
      );
      var result = Wallettotalamountcall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforwallettransactionhistory(
      String? agent_id, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Wallettransactionhistorycall loginjsonCreation =
          Wallettransactionhistorycall(
        agentId: agent_id,
      );
      var result =
          Wallettransactionhistorycall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforcategorydetails(String agentid,
      List<categorycall.Category> listofcategory, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Categorydetailscall loginjsonCreation =
          Categorydetailscall(agentId: agentid, categories: listofcategory);
      var result = Categorydetailscall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforgetfasttagrequestlist(
      String? agent_id, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Callwithagentid loginjsonCreation = Callwithagentid(
        agentId: agent_id,
      );
      var result = Callwithagentid.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforcompletefasttagrequestcall(
      String? agent_id, String requestid, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Completefasttagrequestcall loginjsonCreation =
          Completefasttagrequestcall(agentId: agent_id, requestId: requestid);
      var result =
          Completefasttagrequestcall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforeditfasttagrequest(
      String agentid,
      List<editcategorycall.Category> listofcategory,
      String requestid,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Editfasttagrequestcall loginjsonCreation = Editfasttagrequestcall(
          agentId: agentid, categories: listofcategory, requestId: requestid);
      var result = Editfasttagrequestcall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforupdatepaymentstatus(
      String agentid,
      String amount,
      String paymentmode,
      String remark,
      String transactiontype,
      String transactionId,
      String payment_status,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Rechargenowcall loginjsonCreation = Rechargenowcall(
          agentId: agentid,
          amount: amount,
          paymentMode: paymentmode,
          remark: remark,
          transactionType: transactiontype,
          transcationId: transactionId,
          payment_status: payment_status);
      var result = Rechargenowcall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforassignfasttag(
      String vehiclenumber, String mobilenumber, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Assignvehiclecall loginjsonCreation = Assignvehiclecall(
          agentId: AppUtility.AgentId,
          mobileNumber: mobilenumber,
          vehicleNumber: vehiclenumber);
      var result = Assignvehiclecall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforverifyotp(String otp, String requestId, String sessionid,
      String vehicle_number, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Verifyotpcall loginjsonCreation = Verifyotpcall(
          agentId: AppUtility.AgentId,
          requestId: requestId,
          sessionId: sessionid,
          otp: otp,
          vehicle_number: vehicle_number);
      var result = Verifyotpcall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforvehiclemakerlist(
      String seesionid, String vehicle_number, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Vehiclemakercall loginjsonCreation = Vehiclemakercall(
          agentId: AppUtility.AgentId,
          sessionId: seesionid,
          vehicle_number: vehicle_number);
      var result = Vehiclemakercall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforvehiclemodel(String seesionid, String vehiclemaker,
      String vehicle_number, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Vehiclemodelcall loginjsonCreation = Vehiclemodelcall(
        agentId: AppUtility.AgentId,
        sessionId: seesionid,
        vehicleMake: vehiclemaker,
        vehicle_number: vehicle_number,
      );
      var result = Vehiclemodelcall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforsetvehicledetailsmanually(
      String vehiclemakerselectedValue,
      String vehiclemodelselectedValue,
      String typeselectedValue,
      String vehicletypeselectedValue,
      String npciVehicleClassIDselectedValue,
      String tagVehicleClassIDselectedValue,
      String vehiclecolor,
      String NPCIStatus,
      String vehiclenumber,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Setvehicledetailsmanuallycall loginjsonCreation =
          Setvehicledetailsmanuallycall(
        agentId: AppUtility.AgentId,
        vehicleManuf: vehiclemakerselectedValue,
        model: vehiclemodelselectedValue,
        npcIstatus: NPCIStatus,
        npciVehicleClassId: npciVehicleClassIDselectedValue,
        tagVehicleClassId: tagVehicleClassIDselectedValue,
        vehicleColour: vehiclecolor,
        type: typeselectedValue,
        vehicleType: vehicletypeselectedValue,
        vehicleNumber: vehiclenumber,
      );
      var result =
          Setvehicledetailsmanuallycall.fromJson(loginjsonCreation.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforplan(String agentId, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Agentplancall Stocklistcalljson = Agentplancall(agentId: agentId);
      var result = Agentplancall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforaddcustomerdetails(
      String name,
      String dob,
      String idtype,
      String idnumbe,
      String planid,
      String vehiclenumber,
      String sessionId,
      String expirydate,
      // String RcbackImage,
      // String RcfrontImage,
      // String vehicleimage,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Addcustomerdetailscall Stocklistcalljson = Addcustomerdetailscall(
        name: name,
        dob: dob,
        docType: idtype,
        docNo: idnumbe,
        planId: planid,
        vehicleNumber: vehiclenumber,
        agentId: AppUtility.AgentId,
        expiryDate: expirydate,
        sessionId: sessionId,
      );
      var result = Addcustomerdetailscall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforaddvehicledetails(
      String categoryid,
      String vehiclenumber,
      String chassisnumber,
      String vehicleserialnumber,
      String rcfrontimage,
      String rcbackimage,
      String vehicleimagestring,
      String sessionId,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Addvehicledetailscall Stocklistcalljson = Addvehicledetailscall(
          agentId: AppUtility.AgentId,
          vehicleCategory: categoryid,
          vehicleNumber: vehiclenumber,
          chassisNo: chassisnumber,
          sessionId: sessionId,
          serialNo: vehicleserialnumber,
          rcImageFront: rcfrontimage,
          rcImageBack: rcbackimage,
          vehicleImage: vehicleimagestring);
      var result = Addvehicledetailscall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforgenerateotpforreplacevehicle(
      String mobilenumber,
      String vehiclenumber,
      String vehicleserialnumber,
      String reason,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Replacevehiclecall Stocklistcalljson = Replacevehiclecall(
          agentId: AppUtility.AgentId,
          mobileNumber: mobilenumber,
          vehicleNumber: vehiclenumber,
          serialNo: vehicleserialnumber,
          reason: reason);
      var result = Replacevehiclecall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforverifyreplaceotp(String abc, String requestId,
      String sessionId, String vehiclenumber, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Replacevehicleotpcall Stocklistcalljson = Replacevehicleotpcall(
          agentId: AppUtility.AgentId,
          sessionId: sessionId,
          vehicleNumber: vehiclenumber,
          requestId: requestId,
          otp: abc);
      var result = Replacevehicleotpcall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforgetallbarcode(BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Getallbarcodecall Stocklistcalljson =
          Getallbarcodecall(agentId: AppUtility.AgentId);
      var result = Getallbarcodecall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

//18008969999
  String createjsonforverifyotplogin(
      String mobilenumber, String abc, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Validateotplogincall Stocklistcalljson =
          Validateotplogincall(mobileNumber: mobilenumber, otp: abc);
      var result = Validateotplogincall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsondeletefasttagrequestlist(
      String agentId, String id, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Deletefastagrequestcall Stocklistcalljson =
          Deletefastagrequestcall(id: id, agentId: agentId);
      var result = Deletefastagrequestcall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsoncancelpendingissuance(String id, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Cancelpendingissuancecall Stocklistcalljson =
          Cancelpendingissuancecall(id: id);
      var result =
          Cancelpendingissuancecall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsongetassigntag(
      String fromdate, String todate, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Getassignedtagdatewisecall Stocklistcalljson = Getassignedtagdatewisecall(
          agentId: AppUtility.AgentId, fromDate: fromdate, toDate: todate);
      var result =
          Getassignedtagdatewisecall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonforsetwithdrarequest(
      String agentId, String amount, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Setwithdrawcall Stocklistcalljson =
          Setwithdrawcall(agentId: agentId, withdraAmount: amount);
      var result = Setwithdrawcall.fromJson(Stocklistcalljson.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }
}
