// To parse this JSON data, do
//
//     final rechargeNowResponse = rechargeNowResponseFromJson(jsonString);

import 'dart:convert';

List<RechargeNowResponse> rechargeNowResponseFromJson(String str) =>
    List<RechargeNowResponse>.from(
        json.decode(str).map((x) => RechargeNowResponse.fromJson(x)));

String rechargeNowResponseToJson(List<RechargeNowResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RechargeNowResponse {
  String? status;
  String? message;
  Data? data;

  RechargeNowResponse({
    this.status,
    this.message,
    this.data,
  });

  factory RechargeNowResponse.fromJson(Map<String, dynamic> json) =>
      RechargeNowResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
