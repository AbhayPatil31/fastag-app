// To parse this JSON data, do
//
//     final replacevehicleotpresponse = replacevehicleotpresponseFromJson(jsonString);

import 'dart:convert';

List<Replacevehicleotpresponse> replacevehicleotpresponseFromJson(String str) =>
    List<Replacevehicleotpresponse>.from(
        json.decode(str).map((x) => Replacevehicleotpresponse.fromJson(x)));

String replacevehicleotpresponseToJson(List<Replacevehicleotpresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Replacevehicleotpresponse {
  String? status;
  String? message;

  Replacevehicleotpresponse({
    this.status,
    this.message,
  });

  factory Replacevehicleotpresponse.fromJson(Map<String, dynamic> json) =>
      Replacevehicleotpresponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
