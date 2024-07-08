// To parse this JSON data, do
//
//     final vehiclemakercall = vehiclemakercallFromJson(jsonString);

import 'dart:convert';

Vehiclemakercall vehiclemakercallFromJson(String str) =>
    Vehiclemakercall.fromJson(json.decode(str));

String vehiclemakercallToJson(Vehiclemakercall data) =>
    json.encode(data.toJson());

class Vehiclemakercall {
  String? sessionId;
  String? agentId;
  String? vehicle_number;

  Vehiclemakercall({
    this.sessionId,
    this.agentId,
    this.vehicle_number,
  });

  factory Vehiclemakercall.fromJson(Map<String, dynamic> json) =>
      Vehiclemakercall(
        sessionId: json["sessionId"],
        agentId: json["agent_id"],
        vehicle_number: json["vehicle_number"],
      );

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "agent_id": agentId,
        "vehicle_number": vehicle_number,
      };
}
