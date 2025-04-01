// To parse this JSON data, do
//
//     final addressListModel = addressListModelFromJson(jsonString);

import 'dart:convert';

AddressListModel addressListModelFromJson(String str) =>
    AddressListModel.fromJson(json.decode(str));

String addressListModelToJson(AddressListModel data) =>
    json.encode(data.toJson());

class AddressListModel {
  int status;
  bool success;
  dynamic error;
  List<Address> address;

  AddressListModel({
    required this.status,
    required this.success,
    required this.error,
    required this.address,
  });

  factory AddressListModel.fromJson(Map<String, dynamic> json) =>
      AddressListModel(
        status: json["status"],
        success: json["success"],
        error: json["error"],
        address:
            List<Address>.from(json["address"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "error": error,
        "address": List<dynamic>.from(address.map((x) => x.toJson())),
      };
}

class Address {
  String id;
  String user;
  String name;
  int mobile;
  bool isSelected;
  String addressLineOne;
  String addressLineTwo;
  String city;
  String state;
  String pinCode;
  int v;

  Address({
    required this.id,
    required this.user,
    required this.name,
    required this.mobile,
    required this.addressLineOne,
    required this.addressLineTwo,
    required this.city,
    required this.state,
    required this.isSelected,
    required this.pinCode,
    required this.v,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["_id"],
        user: json["user"],
        name: json["name"],
        mobile: json["mobile"],
        isSelected: false,
        addressLineOne: json["addressLineOne"],
        addressLineTwo: json["addressLineTwo"],
        city: json["city"],
        state: json["state"],
        pinCode: json["pinCode"],
        v: json["__v"],
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
      };
}
