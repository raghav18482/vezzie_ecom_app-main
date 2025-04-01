// To parse this JSON data, do
//
//     final cartview = cartviewFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

Cartview cartviewFromJson(String str) => Cartview.fromJson(json.decode(str));

String cartviewToJson(Cartview data) => json.encode(data.toJson());

class Cartview {
  int status;
  bool success;
  dynamic error;
  List<CartImage> cart;

  Cartview({
    required this.status,
    required this.success,
    required this.error,
    required this.cart,
  });

  factory Cartview.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print("json coupen ID $json");
    }
    return Cartview(
      status: json["status"],
      success: json["success"],
      error: json["error"],
      cart:
          List<CartImage>.from(json["cart"].map((x) => CartImage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "error": error,
        "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
      };
}

class CartImage {
  String id;
  String user;
  List<ProductElement> products;
  int v;

  CartImage({
    required this.id,
    required this.user,
    required this.products,
    required this.v,
  });

  factory CartImage.fromJson(Map<String, dynamic> json) => CartImage(
        id: json["_id"],
        user: json["user"],
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "__v": v,
      };
}

class ProductElement {
  ProductProduct product;
  int qty;
  String id;

  ProductElement({
    required this.product,
    required this.qty,
    required this.id,
  });

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        product: ProductProduct.fromJson(json["product"]),
        qty: json["qty"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "qty": qty,
        "_id": id,
      };
}

class ProductProduct {
  String id;
  String name;
  String description;
  String category;
  String unit;
  int price;
  int actualPrice;
  List<String> images;
  int v;
  dynamic coupenID;

  ProductProduct({
    required this.id,
    required this.name,
    required this.coupenID,
    required this.description,
    required this.category,
    required this.unit,
    required this.price,
    required this.actualPrice,
    required this.images,
    required this.v,
  });

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        coupenID: json["couponId"],
        category: json["category"],
        unit: json["unit"],
        price: json["price"],
        actualPrice: json["actualPrice"],
        images: List<String>.from(json["images"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "category": category,
        "unit": unit,
        "price": price,
        "actualPrice": actualPrice,
        "images": List<dynamic>.from(images.map((x) => x)),
        "__v": v,
      };
}
