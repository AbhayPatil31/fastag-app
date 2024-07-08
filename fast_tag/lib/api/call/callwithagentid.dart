// To parse this JSON data, do
//
//     final callwithagentid = callwithagentidFromJson(jsonString);

import 'dart:convert';

Callwithagentid callwithagentidFromJson(String str) =>
    Callwithagentid.fromJson(json.decode(str));

String callwithagentidToJson(Callwithagentid data) =>
    json.encode(data.toJson());

class Callwithagentid {
  String? agentId;

  Callwithagentid({
    this.agentId,
  });

  factory Callwithagentid.fromJson(Map<String, dynamic> json) =>
      Callwithagentid(
        agentId: json["agent_id"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
      };
}
