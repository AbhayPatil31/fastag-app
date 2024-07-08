// To parse this JSON data, do
//
//     final completefasttagrequestcall = completefasttagrequestcallFromJson(jsonString);

import 'dart:convert';

Completefasttagrequestcall completefasttagrequestcallFromJson(String str) =>
    Completefasttagrequestcall.fromJson(json.decode(str));

String completefasttagrequestcallToJson(Completefasttagrequestcall data) =>
    json.encode(data.toJson());

class Completefasttagrequestcall {
  String? agentId;
  String? requestId;

  Completefasttagrequestcall({
    this.agentId,
    this.requestId,
  });

  factory Completefasttagrequestcall.fromJson(Map<String, dynamic> json) =>
      Completefasttagrequestcall(
        agentId: json["agent_id"],
        requestId: json["request_id"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "request_id": requestId,
      };
}
