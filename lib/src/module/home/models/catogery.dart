// To parse this JSON data, do
//
//     final getCatogery = getCatogeryFromJson(jsonString);

import 'dart:convert';

GetCatogery getCatogeryFromJson(String str) =>
    GetCatogery.fromJson(json.decode(str));

String getCatogeryToJson(GetCatogery data) => json.encode(data.toJson());

class GetCatogery {
  int status;
  bool success;
  dynamic error;
  List<Categories> categorys;

  GetCatogery({
    required this.status,
    required this.success,
    this.error,
    required this.categorys,
  });

  factory GetCatogery.fromJson(Map<String, dynamic> json) => GetCatogery(
        status: json["status"],
        success: json["success"],
        error: json["error"],
        categorys: List<Categories>.from(
            json["categorys"].map((x) => Categories.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "error": error,
        "categorys": List<dynamic>.from(categorys.map((x) => x.toJson())),
      };
}

class Categories {
  String id;
  String name;
  String image;
  int v;

  Categories({
    required this.id,
    required this.name,
    required this.image,
    required this.v,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "__v": v,
      };
}
