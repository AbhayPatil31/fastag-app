// To parse this JSON data, do
//
//     final getmapperclasscall = getmapperclasscallFromJson(jsonString);

import 'dart:convert';

Getmapperclasscall getmapperclasscallFromJson(String str) =>
    Getmapperclasscall.fromJson(json.decode(str));

String getmapperclasscallToJson(Getmapperclasscall data) =>
    json.encode(data.toJson());

class Getmapperclasscall {
  String? vehicleClassId;

  Getmapperclasscall({
    this.vehicleClassId,
  });

  factory Getmapperclasscall.fromJson(Map<String, dynamic> json) =>
      Getmapperclasscall(
        vehicleClassId: json["vehicle_class_id"],
      );

  Map<String, dynamic> toJson() => {
        "vehicle_class_id": vehicleClassId,
      };
}
