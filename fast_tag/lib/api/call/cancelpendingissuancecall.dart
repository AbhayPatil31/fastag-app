// To parse this JSON data, do
//
//     final cancelpendingissuancecall = cancelpendingissuancecallFromJson(jsonString);

import 'dart:convert';

Cancelpendingissuancecall cancelpendingissuancecallFromJson(String str) =>
    Cancelpendingissuancecall.fromJson(json.decode(str));

String cancelpendingissuancecallToJson(Cancelpendingissuancecall data) =>
    json.encode(data.toJson());

class Cancelpendingissuancecall {
  String? id;

  Cancelpendingissuancecall({
    this.id,
  });

  factory Cancelpendingissuancecall.fromJson(Map<String, dynamic> json) =>
      Cancelpendingissuancecall(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
