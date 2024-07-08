// To parse this JSON data, do
//
//     final validateotplogincall = validateotplogincallFromJson(jsonString);

import 'dart:convert';

Validateotplogincall validateotplogincallFromJson(String str) =>
    Validateotplogincall.fromJson(json.decode(str));

String validateotplogincallToJson(Validateotplogincall data) =>
    json.encode(data.toJson());

class Validateotplogincall {
  String? mobileNumber;
  String? otp;

  Validateotplogincall({
    this.mobileNumber,
    this.otp,
  });

  factory Validateotplogincall.fromJson(Map<String, dynamic> json) =>
      Validateotplogincall(
        mobileNumber: json["mobile_number"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "mobile_number": mobileNumber,
        "otp": otp,
      };
}
