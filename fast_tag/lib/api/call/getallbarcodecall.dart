// To parse this JSON data, do
//
//     final getallbarcodecall = getallbarcodecallFromJson(jsonString);

import 'dart:convert';

Getallbarcodecall getallbarcodecallFromJson(String str) =>
    Getallbarcodecall.fromJson(json.decode(str));

String getallbarcodecallToJson(Getallbarcodecall data) =>
    json.encode(data.toJson());

class Getallbarcodecall {
  String? agentId;

  Getallbarcodecall({
    this.agentId,
  });

  factory Getallbarcodecall.fromJson(Map<String, dynamic> json) =>
      Getallbarcodecall(
        agentId: json["agent_id"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
      };
}
