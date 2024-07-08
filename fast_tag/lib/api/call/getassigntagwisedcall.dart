// To parse this JSON data, do
//
//     final getassignedtagdatewisecall = getassignedtagdatewisecallFromJson(jsonString);

import 'dart:convert';

Getassignedtagdatewisecall getassignedtagdatewisecallFromJson(String str) =>
    Getassignedtagdatewisecall.fromJson(json.decode(str));

String getassignedtagdatewisecallToJson(Getassignedtagdatewisecall data) =>
    json.encode(data.toJson());

class Getassignedtagdatewisecall {
  String? agentId;
  String? fromDate;
  String? toDate;

  Getassignedtagdatewisecall({
    this.agentId,
    this.fromDate,
    this.toDate,
  });

  factory Getassignedtagdatewisecall.fromJson(Map<String, dynamic> json) =>
      Getassignedtagdatewisecall(
        agentId: json["agent_id"],
        fromDate: json["from_date"],
        toDate: json["to_date"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "from_date": fromDate,
        "to_date": toDate,
      };
}
