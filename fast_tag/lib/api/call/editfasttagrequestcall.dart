// To parse this JSON data, do
//
//     final editfasttagrequestcall = editfasttagrequestcallFromJson(jsonString);

import 'dart:convert';

Editfasttagrequestcall editfasttagrequestcallFromJson(String str) =>
    Editfasttagrequestcall.fromJson(json.decode(str));

String editfasttagrequestcallToJson(Editfasttagrequestcall data) =>
    json.encode(data.toJson());

class Editfasttagrequestcall {
  String? agentId;
  String? requestId;
  List<Category>? categories;

  Editfasttagrequestcall({
    this.agentId,
    this.requestId,
    this.categories,
  });

  factory Editfasttagrequestcall.fromJson(Map<String, dynamic> json) =>
      Editfasttagrequestcall(
        agentId: json["agent_id"],
        requestId: json["request_id"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "request_id": requestId,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  String? categoryId;
  String? requested;

  Category({
    this.categoryId,
    this.requested,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        requested: json["requested"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "requested": requested,
      };
}
