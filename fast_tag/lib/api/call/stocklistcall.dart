// To parse this JSON data, do
//
//     final stocklistcall = stocklistcallFromJson(jsonString);

import 'dart:convert';

Stocklistcall stocklistcallFromJson(String str) =>
    Stocklistcall.fromJson(json.decode(str));

String stocklistcallToJson(Stocklistcall data) => json.encode(data.toJson());

class Stocklistcall {
  String? agentId;

  Stocklistcall({
    this.agentId,
  });

  factory Stocklistcall.fromJson(Map<String, dynamic> json) => Stocklistcall(
        agentId: json["agent_id"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
      };
}
