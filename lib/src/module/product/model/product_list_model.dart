// To parse this JSON data, do
//
//     final getProduct = getProductFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

GetProduct getProductFromJson(String str) =>
    GetProduct.fromJson(json.decode(str));

String getProductToJson(GetProduct data) => json.encode(data.toJson());

class GetProduct {
  int status;
  bool success;
  dynamic error;
  List<Product> products;

  GetProduct({
    required this.status,
    required this.success,
    this.error,
    required this.products,
  });

  factory GetProduct.fromJson(Map<String, dynamic> json) {
    return GetProduct(
      status: json["status"],
      success: json["success"],
      error: json["error"],
      products:
          List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );
  }
  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "error": error,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  String id;
  String name;
  String description;
  String category;
  String unit;
  int price;
  int actualPrice;
  dynamic qty;
  dynamic percentage;
  List<String> images;
  int v;

  Product({
    required this.id,
    required this.name,
    required this.percentage,
    required this.description,
    required this.category,
    required this.qty,
    required this.unit,
    required this.price,
    required this.actualPrice,
    required this.images,
    required this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    log("this is ax $json");
    return Product(
      id: json["_id"],
      name: json["name"],
      percentage:
          (((json["actualPrice"] - json["price"]) / json["actualPrice"]) * 100),
      description: json["description"],
      qty: json["qty"] ?? 0,
      category: json["category"],
      unit: json["unit"],
      price: json["price"],
      actualPrice: json["actualPrice"],
      images: List<String>.from(json["images"].map((x) => x)),
      v: json["__v"],
    );
  }
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
