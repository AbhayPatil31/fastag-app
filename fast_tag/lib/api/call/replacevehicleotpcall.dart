// To parse this JSON data, do
//
//     final replacevehicleotpcall = replacevehicleotpcallFromJson(jsonString);

import 'dart:convert';

Replacevehicleotpcall replacevehicleotpcallFromJson(String str) =>
    Replacevehicleotpcall.fromJson(json.decode(str));

String replacevehicleotpcallToJson(Replacevehicleotpcall data) =>
    json.encode(data.toJson());

class Replacevehicleotpcall {
  String? otp;
  String? requestId;
  String? sessionId;
  String? agentId;
  String? vehicleNumber;

  Replacevehicleotpcall({
    this.otp,
    this.requestId,
    this.sessionId,
    this.agentId,
    this.vehicleNumber,
  });

  factory Replacevehicleotpcall.fromJson(Map<String, dynamic> json) =>
      Replacevehicleotpcall(
        otp: json["otp"],
        requestId: json["requestId"],
        sessionId: json["sessionId"],
        agentId: json["agent_id"],
        vehicleNumber: json["vehicle_number"],
      );

  Map<String, dynamic> toJson() => {
        "otp": otp,
        "requestId": requestId,
        "sessionId": sessionId,
        "agent_id": agentId,
        "vehicle_number": vehicleNumber,
      };
}
