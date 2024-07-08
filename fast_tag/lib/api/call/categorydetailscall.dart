// To parse this JSON data, do
//
//     final categorydetailscall = categorydetailscallFromJson(jsonString);

import 'dart:convert';

Categorydetailscall categorydetailscallFromJson(String str) =>
    Categorydetailscall.fromJson(json.decode(str));

String categorydetailscallToJson(Categorydetailscall data) =>
    json.encode(data.toJson());

class Categorydetailscall {
  String? agentId;
  List<Category>? categories;

  Categorydetailscall({
    this.agentId,
    this.categories,
  });

  factory Categorydetailscall.fromJson(Map<String, dynamic> json) =>
      Categorydetailscall(
        agentId: json["agent_id"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
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
