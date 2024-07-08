// To parse this JSON data, do
//
//     final wallettotalamountcall = wallettotalamountcallFromJson(jsonString);

import 'dart:convert';

Wallettotalamountcall wallettotalamountcallFromJson(String str) =>
    Wallettotalamountcall.fromJson(json.decode(str));

String wallettotalamountcallToJson(Wallettotalamountcall data) =>
    json.encode(data.toJson());

class Wallettotalamountcall {
  String? agentId;

  Wallettotalamountcall({
    this.agentId,
  });

  factory Wallettotalamountcall.fromJson(Map<String, dynamic> json) =>
      Wallettotalamountcall(
        agentId: json["agent_id"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
      };
}
