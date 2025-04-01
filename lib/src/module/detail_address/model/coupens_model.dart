// To parse this JSON data, do
//
//     final couponCodeModel = couponCodeModelFromJson(jsonString);

import 'dart:convert';

CouponCodeModel couponCodeModelFromJson(String str) =>
    CouponCodeModel.fromJson(json.decode(str));

String couponCodeModelToJson(CouponCodeModel data) =>
    json.encode(data.toJson());

class CouponCodeModel {
  dynamic status;
  bool success;
  dynamic error;
  List<AvailableCoupon> availableCoupons;

  CouponCodeModel({
    required this.status,
    required this.success,
    required this.error,
    required this.availableCoupons,
  });

  factory CouponCodeModel.fromJson(Map<String, dynamic> json) =>
      CouponCodeModel(
        status: json["status"],
        success: json["success"],
        error: json["error"],
        availableCoupons: List<AvailableCoupon>.from(
            json["availableCoupons"].map((x) => AvailableCoupon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? "",
        "success": success,
        "error": error ?? "",
        "availableCoupons":
            List<dynamic>.from(availableCoupons.map((x) => x.toJson())),
      };
}

class AvailableCoupon {
  String id;
  String code;
  String title;
  String description;
  String type;
  bool public;
  dynamic limit;
  dynamic discountPercent;
  dynamic amountUpto;
  dynamic minimumOrder;

  AvailableCoupon({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.public,
    required this.limit,
    required this.discountPercent,
    required this.amountUpto,
    required this.minimumOrder,
  });

  factory AvailableCoupon.fromJson(Map<String, dynamic> json) =>
      AvailableCoupon(
        id: json["_id"] ?? "",
        code: json["code"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        type: json["type"] ?? "",
        public: json["public"] ?? "",
        limit: json["limit"] ?? "",
        discountPercent: json["discountPercent"] ?? "",
        amountUpto: json["amountUpto"] ?? "",
        minimumOrder: json["minimumOrder"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "title": title,
        "description": description,
        "type": type,
        "public": public,
        "limit": limit,
        "discountPercent": discountPercent,
        "amountUpto": amountUpto,
        "minimumOrder": minimumOrder,
      };
}
