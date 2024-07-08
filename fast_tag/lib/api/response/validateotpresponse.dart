// To parse this JSON data, do
//
//     final verifyotpresponse = verifyotpresponseFromJson(jsonString);

import 'dart:convert';

List<Verifyotpresponse> verifyotpresponseFromJson(String str) =>
    List<Verifyotpresponse>.from(
        json.decode(str).map((x) => Verifyotpresponse.fromJson(x)));

String verifyotpresponseToJson(List<Verifyotpresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Verifyotpresponse {
  String? status;
  String? message;
  List<VerifyotpDatum>? data;

  Verifyotpresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Verifyotpresponse.fromJson(Map<String, dynamic> json) =>
      Verifyotpresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<VerifyotpDatum>.from(
                json["data"]!.map((x) => VerifyotpDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class VerifyotpDatum {
  String? requestId;
  String? sessionId;
  String? agentId;
  String? vehicleNo;
  dynamic engineNo;
  dynamic vehicleManuf;
  dynamic model;
  dynamic vehicleColour;
  String? type;
  dynamic rtoStatus;
  bool? commercial;
  String? tagVehicleClassId;
  String? npciVehicleClassId;
  dynamic vehicleType;
  String? rechargeAmount;
  String? securityDeposit;
  String? tagCost;
  String? repTagCost;
  String? walletStatus;
  String? kycStatus;
  dynamic walletId;

  VerifyotpDatum({
    this.requestId,
    this.sessionId,
    this.agentId,
    this.vehicleNo,
    this.engineNo,
    this.vehicleManuf,
    this.model,
    this.vehicleColour,
    this.type,
    this.rtoStatus,
    this.commercial,
    this.tagVehicleClassId,
    this.npciVehicleClassId,
    this.vehicleType,
    this.rechargeAmount,
    this.securityDeposit,
    this.tagCost,
    this.repTagCost,
    this.walletStatus,
    this.kycStatus,
    this.walletId,
  });

  factory VerifyotpDatum.fromJson(Map<String, dynamic> json) => VerifyotpDatum(
        requestId: json["requestId"],
        sessionId: json["sessionId"],
        agentId: json["agent_id"],
        vehicleNo: json["vehicleNo"],
        engineNo: json["engineNo"],
        vehicleManuf: json["vehicleManuf"],
        model: json["model"],
        vehicleColour: json["vehicleColour"],
        type: json["type"],
        rtoStatus: json["rtoStatus"],
        commercial: json["commercial"],
        tagVehicleClassId: json["tagVehicleClassID"],
        npciVehicleClassId: json["npciVehicleClassID"],
        vehicleType: json["vehicleType"],
        rechargeAmount: json["rechargeAmount"],
        securityDeposit: json["securityDeposit"],
        tagCost: json["tagCost"],
        repTagCost: json["repTagCost"],
        walletStatus: json["walletStatus"],
        kycStatus: json["kycStatus"],
        walletId: json["walletId"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "sessionId": sessionId,
        "agent_id": agentId,
        "vehicleNo": vehicleNo,
        "engineNo": engineNo,
        "vehicleManuf": vehicleManuf,
        "model": model,
        "vehicleColour": vehicleColour,
        "type": type,
        "rtoStatus": rtoStatus,
        "commercial": commercial,
        "tagVehicleClassID": tagVehicleClassId,
        "npciVehicleClassID": npciVehicleClassId,
        "vehicleType": vehicleType,
        "rechargeAmount": rechargeAmount,
        "securityDeposit": securityDeposit,
        "tagCost": tagCost,
        "repTagCost": repTagCost,
        "walletStatus": walletStatus,
        "kycStatus": kycStatus,
        "walletId": walletId,
      };
}
