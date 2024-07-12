// To parse this JSON data, do
//
//     final addcustomerdetailscall = addcustomerdetailscallFromJson(jsonString);

import 'dart:convert';

Addcustomerdetailscall addcustomerdetailscallFromJson(String str) =>
    Addcustomerdetailscall.fromJson(json.decode(str));

String addcustomerdetailscallToJson(Addcustomerdetailscall data) =>
    json.encode(data.toJson());

class Addcustomerdetailscall {
  String? name;
  String? lastname;
  String? dob;
  String? docType;
  String? docNo;
  String? expiryDate;
  String? planId;

  String? vehicleNumber;
  String? sessionId;
  String? agentId;

  Addcustomerdetailscall({
    this.name,
    this.lastname,
    this.dob,
    this.docType,
    this.docNo,
    this.expiryDate,
    this.planId,
    this.vehicleNumber,
    this.sessionId,
    this.agentId,
  });

  factory Addcustomerdetailscall.fromJson(Map<String, dynamic> json) =>
      Addcustomerdetailscall(
        name: json["name"],
        lastname: json["lastName"],
        dob: json["dob"],
        docType: json["docType"],
        docNo: json["docNo"],
        expiryDate: json["expiryDate"],
        planId: json["plan_id"],
        vehicleNumber: json["vehicle_number"],
        sessionId: json["sessionId"],
        agentId: json["agent_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lastName": lastname,
        "dob": dob,
        "docType": docType,
        "docNo": docNo,
        "expiryDate": expiryDate,
        "plan_id": planId,
        "vehicle_number": vehicleNumber,
        "sessionId": sessionId,
        "agent_id": agentId,
      };
}
