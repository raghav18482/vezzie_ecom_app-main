class MyOrderListing {
  int status;
  bool success;
  List<Order> orders;

  MyOrderListing({
    required this.status,
    required this.success,
    required this.orders,
  });

  factory MyOrderListing.fromJson(Map<String, dynamic> json) => MyOrderListing(
        status: json["status"] ?? 0,
        success: json["success"] ?? false,
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  String id;
  User user;
  String invoiceNumber;
  Address address;
  List<ProductElement> products;
  String paymentMode;
  int discount;
  int deliveryCharge;
  int total;
  int subTotal;
  dynamic couponId;
  int tipAmount;
  String status;
  String createdAt;
  String updatedAt;
  int v;

  Order({
    required this.id,
    required this.user,
    required this.invoiceNumber,
    required this.address,
    required this.products,
    required this.paymentMode,
    required this.discount,
    required this.deliveryCharge,
    required this.total,
    required this.subTotal,
    required this.couponId,
    required this.tipAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["_id"] ?? "",
        user: User.fromJson(json["user"] ?? {}),
        invoiceNumber: json["invoiceNumber"] ?? "",
        address: Address.fromJson(json["address"] ?? {}),
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
        paymentMode: json["paymentMode"] ?? "",
        discount: json["discount"] ?? 0,
        deliveryCharge: json["deliveryCharge"] ?? 0,
        total: json["total"] ?? 0,
        subTotal: json["subTotal"] ?? 0,
        couponId: json["couponId"] ?? "",
        tipAmount: json["tipAmount"] ?? 0,
        status: json["status"] ?? "",
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user.toJson(),
        "invoiceNumber": invoiceNumber,
        "address": address.toJson(),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "paymentMode": paymentMode,
        "discount": discount,
        "deliveryCharge": deliveryCharge,
        "total": total,
        "subTotal": subTotal,
        "couponId": couponId,
        "tipAmount": tipAmount,
        "status": status,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "__v": v,
      };
}

class Address {
  String id;
  String user;
  String name;
  int mobile;
  String addressLineOne;
  String addressLineTwo;
  String city;
  String state;
  String pinCode;
  int v;
  String updatedAt;

  Address({
    required this.id,
    required this.user,
    required this.name,
    required this.mobile,
    required this.addressLineOne,
    required this.addressLineTwo,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.v,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["_id"] ?? "",
        user: json["user"] ?? "",
        name: json["name"] ?? "",
        mobile: json["mobile"] ?? 0,
        addressLineOne: json["addressLineOne"] ?? "",
        addressLineTwo: json["addressLineTwo"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        pinCode: json["pinCode"] ?? "",
        v: json["__v"] ?? 0,
        updatedAt: json["updatedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "name": name,
        "mobile": mobile,
        "addressLineOne": addressLineOne,
        "addressLineTwo": addressLineTwo,
        "city": city,
        "state": state,
        "pinCode": pinCode,
        "__v": v,
        "updatedAt": updatedAt.toString(),
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
        product: ProductProduct.fromJson(json["product"] ?? {}),
        qty: json["qty"] ?? 0,
        id: json["_id"] ?? "",
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

  ProductProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.unit,
    required this.price,
    required this.actualPrice,
    required this.images,
    required this.v,
  });

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        unit: json["unit"] ?? "",
        price: json["price"] ?? 0,
        actualPrice: json["actualPrice"] ?? 0,
        images: List<String>.from(json["images"] ?? []),
        v: json["__v"] ?? 0,
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

class User {
  String id;
  int? mobile;
  bool? isAdmin;
  int? v;
  String? address;
  String? city;
  String? email;
  String? name;
  String? pinCode;
  String? state;
  String? updatedAt;

  User({
    required this.id,
    this.mobile,
    this.isAdmin,
    this.v,
    this.address,
    this.city,
    this.email,
    this.name,
    this.pinCode,
    this.state,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] ?? "",
        mobile: json["mobile"] ?? 0,
        isAdmin: json["isAdmin"] ?? false,
        v: json["__v"] ?? 0,
        address: json["address"] ?? "",
        city: json["city"] ?? "",
        email: json["email"] ?? "",
        name: json["name"] ?? "",
        pinCode: json["pinCode"] ?? "",
        state: json["state"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "isAdmin": isAdmin,
        "__v": v,
        "address": address,
        "city": city,
        "email": email,
        "name": name,
        "pinCode": pinCode,
        "state": state,
        "updatedAt": updatedAt?.toString() ?? "",
      };
}
