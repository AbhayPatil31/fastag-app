// To parse this JSON data, do
//
//     final addvehicledetailscall = addvehicledetailscallFromJson(jsonString);

import 'dart:convert';

Addvehicledetailscall addvehicledetailscallFromJson(String str) =>
    Addvehicledetailscall.fromJson(json.decode(str));

String addvehicledetailscallToJson(Addvehicledetailscall data) =>
    json.encode(data.toJson());

class Addvehicledetailscall {
  String? sessionId;
  String? vehicleNumber;
  String? vehicleCategory;
  String? chassisNo;
  String? serialNo;
  String? rcImageFront;
  String? rcImageBack;
  String? vehicleImage;
  String? agentId;

  Addvehicledetailscall({
    this.sessionId,
    this.vehicleNumber,
    this.vehicleCategory,
    this.chassisNo,
    this.serialNo,
    this.rcImageFront,
    this.rcImageBack,
    this.vehicleImage,
    this.agentId,
  });

  factory Addvehicledetailscall.fromJson(Map<String, dynamic> json) =>
      Addvehicledetailscall(
        sessionId: json["sessionId"],
        vehicleNumber: json["vehicle_number"],
        vehicleCategory: json["vehicleCategory"],
        chassisNo: json["chassisNo"],
        serialNo: json["serialNo"],
        rcImageFront: json["rcImageFront"],
        rcImageBack: json["rcImageBack"],
        vehicleImage: json["vehicleImage"],
        agentId: json["agent_id"],
      );

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "vehicle_number": vehicleNumber,
        "vehicleCategory": vehicleCategory,
        "chassisNo": chassisNo,
        "serialNo": serialNo,
        "rcImageFront": rcImageFront,
        "rcImageBack": rcImageBack,
        "vehicleImage": vehicleImage,
        "agent_id": agentId,
      };
}
