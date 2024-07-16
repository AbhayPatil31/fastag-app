// To parse this JSON data, do
//
//     final getrazorpaydetailsapiresponse = getrazorpaydetailsapiresponseFromJson(jsonString);

import 'dart:convert';

List<Getrazorpaydetailsapiresponse> getrazorpaydetailsapiresponseFromJson(String str) => List<Getrazorpaydetailsapiresponse>.from(json.decode(str).map((x) => Getrazorpaydetailsapiresponse.fromJson(x)));

String getrazorpaydetailsapiresponseToJson(List<Getrazorpaydetailsapiresponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Getrazorpaydetailsapiresponse {
    String? status;
    String? message;
    GetrazorpaydetailsapiresponseData? data;

    Getrazorpaydetailsapiresponse({
        this.status,
        this.message,
        this.data,
    });

    factory Getrazorpaydetailsapiresponse.fromJson(Map<String, dynamic> json) => Getrazorpaydetailsapiresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : GetrazorpaydetailsapiresponseData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class GetrazorpaydetailsapiresponseData {
    String? razorPayKey;

    GetrazorpaydetailsapiresponseData({
        this.razorPayKey,
    });

    factory GetrazorpaydetailsapiresponseData.fromJson(Map<String, dynamic> json) => GetrazorpaydetailsapiresponseData(
        razorPayKey: json["razor_pay_key"],
    );

    Map<String, dynamic> toJson() => {
        "razor_pay_key": razorPayKey,
    };
}
