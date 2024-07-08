// To parse this JSON data, do
//
//     final replacevehiclecall = replacevehiclecallFromJson(jsonString);

import 'dart:convert';

Replacevehiclecall replacevehiclecallFromJson(String str) =>
    Replacevehiclecall.fromJson(json.decode(str));

String replacevehiclecallToJson(Replacevehiclecall data) =>
    json.encode(data.toJson());

class Replacevehiclecall {
  String? vehicleNumber;
  String? agentId;
  String? mobileNumber;
  String? serialNo;
  String? reason;

  Replacevehiclecall({
    this.vehicleNumber,
    this.agentId,
    this.mobileNumber,
    this.serialNo,
    this.reason,
  });

  factory Replacevehiclecall.fromJson(Map<String, dynamic> json) =>
      Replacevehiclecall(
        vehicleNumber: json["vehicle_number"],
        agentId: json["agent_id"],
        mobileNumber: json["mobile_number"],
        serialNo: json["serialNo"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "vehicle_number": vehicleNumber,
        "agent_id": agentId,
        "mobile_number": mobileNumber,
        "serialNo": serialNo,
        "reason": reason,
      };
}
