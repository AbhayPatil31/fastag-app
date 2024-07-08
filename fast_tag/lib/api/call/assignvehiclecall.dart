// To parse this JSON data, do
//
//     final assignvehiclecall = assignvehiclecallFromJson(jsonString);

import 'dart:convert';

Assignvehiclecall assignvehiclecallFromJson(String str) =>
    Assignvehiclecall.fromJson(json.decode(str));

String assignvehiclecallToJson(Assignvehiclecall data) =>
    json.encode(data.toJson());

class Assignvehiclecall {
  String? vehicleNumber;
  String? agentId;
  String? mobileNumber;

  Assignvehiclecall({
    this.vehicleNumber,
    this.agentId,
    this.mobileNumber,
  });

  factory Assignvehiclecall.fromJson(Map<String, dynamic> json) =>
      Assignvehiclecall(
        vehicleNumber: json["vehicle_number"],
        agentId: json["agent_id"],
        mobileNumber: json["mobile_number"],
      );

  Map<String, dynamic> toJson() => {
        "vehicle_number": vehicleNumber,
        "agent_id": agentId,
        "mobile_number": mobileNumber,
      };
}
