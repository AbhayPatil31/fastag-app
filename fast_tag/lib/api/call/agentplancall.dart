// To parse this JSON data, do
//
//     final agentplancall = agentplancallFromJson(jsonString);

import 'dart:convert';

Agentplancall agentplancallFromJson(String str) =>
    Agentplancall.fromJson(json.decode(str));

String agentplancallToJson(Agentplancall data) => json.encode(data.toJson());

class Agentplancall {
  String? agentId;

  Agentplancall({
    this.agentId,
  });

  factory Agentplancall.fromJson(Map<String, dynamic> json) => Agentplancall(
        agentId: json["agent_id"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
      };
}
