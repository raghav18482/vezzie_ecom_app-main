// To parse this JSON data, do
//
//     final cartInfo = cartInfoFromJson(jsonString);

import 'dart:convert';

CartInfo cartInfoFromJson(String str) => CartInfo.fromJson(json.decode(str));

String cartInfoToJson(CartInfo data) => json.encode(data.toJson());

class CartInfo {
  int status;
  bool success;
  int qty;
  int subTotal;
  int total;
  int deliveryCharge;
  int driverTip;
  int discount;

  CartInfo({
    required this.status,
    required this.success,
    required this.qty,
    required this.subTotal,
    required this.discount,
    required this.total,
    required this.deliveryCharge,
    required this.driverTip,
  });

  factory CartInfo.fromJson(Map<String, dynamic> json) => CartInfo(
        status: json["status"] ?? 0,
        success: json["success"] ?? false,
        discount: json["discount"] ?? 0,
        qty: json["qty"] ?? 0,
        subTotal: json["subTotal"] ?? 0,
        total: json["total"] ?? 0,
        deliveryCharge: json["deliveryCharge"] ?? 0,
        driverTip: json["DriverTip"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "qty": qty,
        "subTotal": subTotal,
        "total": total,
        "deliveryCharge": deliveryCharge,
        "DriverTip": driverTip,
      };
}
