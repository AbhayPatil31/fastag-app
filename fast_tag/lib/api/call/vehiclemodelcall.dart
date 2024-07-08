// To parse this JSON data, do
//
//     final vehiclemodelcall = vehiclemodelcallFromJson(jsonString);

import 'dart:convert';

Vehiclemodelcall vehiclemodelcallFromJson(String str) =>
    Vehiclemodelcall.fromJson(json.decode(str));

String vehiclemodelcallToJson(Vehiclemodelcall data) =>
    json.encode(data.toJson());

class Vehiclemodelcall {
  String? sessionId;
  String? vehicleMake;
  String? agentId;
  String? vehicle_number;

  Vehiclemodelcall({
    this.sessionId,
    this.vehicleMake,
    this.agentId,
    this.vehicle_number,
  });

  factory Vehiclemodelcall.fromJson(Map<String, dynamic> json) =>
      Vehiclemodelcall(
        sessionId: json["sessionId"],
        vehicleMake: json["vehicleMake"],
        agentId: json["agent_id"],
        vehicle_number: json["vehicle_number"],
      );

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "vehicleMake": vehicleMake,
        "agent_id": agentId,
        "vehicle_number": vehicle_number,
      };
}
