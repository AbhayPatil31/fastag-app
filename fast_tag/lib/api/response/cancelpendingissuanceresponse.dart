// To parse this JSON data, do
//
//     final cancelpendingissuanceresponse = cancelpendingissuanceresponseFromJson(jsonString);

import 'dart:convert';

List<Cancelpendingissuanceresponse> cancelpendingissuanceresponseFromJson(
        String str) =>
    List<Cancelpendingissuanceresponse>.from(
        json.decode(str).map((x) => Cancelpendingissuanceresponse.fromJson(x)));

String cancelpendingissuanceresponseToJson(
        List<Cancelpendingissuanceresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cancelpendingissuanceresponse {
  String? status;
  String? message;
  List<dynamic>? data;

  Cancelpendingissuanceresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Cancelpendingissuanceresponse.fromJson(Map<String, dynamic> json) =>
      Cancelpendingissuanceresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<dynamic>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
