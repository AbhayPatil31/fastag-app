// To parse this JSON data, do
//
//     final deletefastagrequestcall = deletefastagrequestcallFromJson(jsonString);

import 'dart:convert';

Deletefastagrequestcall deletefastagrequestcallFromJson(String str) =>
    Deletefastagrequestcall.fromJson(json.decode(str));

String deletefastagrequestcallToJson(Deletefastagrequestcall data) =>
    json.encode(data.toJson());

class Deletefastagrequestcall {
  String? id;
  String? agentId;

  Deletefastagrequestcall({
    this.id,
    this.agentId,
  });

  factory Deletefastagrequestcall.fromJson(Map<String, dynamic> json) =>
      Deletefastagrequestcall(
        id: json["id"],
        agentId: json["agent_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agent_id": agentId,
      };
}
