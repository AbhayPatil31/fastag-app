// To parse this JSON data, do
//
//     final stockcategorycall = stockcategorycallFromJson(jsonString);

import 'dart:convert';

Stockcategorycall stockcategorycallFromJson(String str) =>
    Stockcategorycall.fromJson(json.decode(str));

String stockcategorycallToJson(Stockcategorycall data) =>
    json.encode(data.toJson());

class Stockcategorycall {
  String? agentId;
  String? vehicleCategory;

  Stockcategorycall({
    this.agentId,
    this.vehicleCategory,
  });

  factory Stockcategorycall.fromJson(Map<String, dynamic> json) =>
      Stockcategorycall(
        agentId: json["agent_id"],
        vehicleCategory: json["vehicle_category"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "vehicle_category": vehicleCategory,
      };
}
