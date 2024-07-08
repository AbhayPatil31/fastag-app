// To parse this JSON data, do
//
//     final setwithdrawcall = setwithdrawcallFromJson(jsonString);

import 'dart:convert';

Setwithdrawcall setwithdrawcallFromJson(String str) =>
    Setwithdrawcall.fromJson(json.decode(str));

String setwithdrawcallToJson(Setwithdrawcall data) =>
    json.encode(data.toJson());

class Setwithdrawcall {
  String? agentId;
  String? withdraAmount;

  Setwithdrawcall({
    this.agentId,
    this.withdraAmount,
  });

  factory Setwithdrawcall.fromJson(Map<String, dynamic> json) =>
      Setwithdrawcall(
        agentId: json["agent_id"],
        withdraAmount: json["withdra_amount"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "withdra_amount": withdraAmount,
      };
}
