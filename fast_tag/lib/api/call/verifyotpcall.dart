// To parse this JSON data, do
//
//     final verifyotpcall = verifyotpcallFromJson(jsonString);

import 'dart:convert';

Verifyotpcall verifyotpcallFromJson(String str) =>
    Verifyotpcall.fromJson(json.decode(str));

String verifyotpcallToJson(Verifyotpcall data) => json.encode(data.toJson());

class Verifyotpcall {
  String? otp;
  String? requestId;
  String? sessionId;
  String? agentId;
  String? vehicle_number;

  Verifyotpcall({
    this.otp,
    this.requestId,
    this.sessionId,
    this.agentId,
    this.vehicle_number,
  });

  factory Verifyotpcall.fromJson(Map<String, dynamic> json) => Verifyotpcall(
        otp: json["otp"],
        requestId: json["requestId"],
        sessionId: json["sessionId"],
        agentId: json["agent_id"],
        vehicle_number: json["vehicle_number"],
      );

  Map<String, dynamic> toJson() => {
        "otp": otp,
        "requestId": requestId,
        "sessionId": sessionId,
        "agent_id": agentId,
        "vehicle_number": vehicle_number,
      };
}
