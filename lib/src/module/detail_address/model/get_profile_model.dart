// To parse this JSON data, do
//
//

import 'dart:convert';

GetProfileData getProfileDataFromJson(String str) =>
    GetProfileData.fromJson(json.decode(str));

String getProfileDataToJson(GetProfileData data) => json.encode(data.toJson());

class GetProfileData {
  int status;
  bool success;
  dynamic error;
  Data data;

  GetProfileData({
    required this.status,
    required this.success,
    this.error,
    required this.data,
  });

  factory GetProfileData.fromJson(Map<String, dynamic> json) => GetProfileData(
        status: json["status"],
        success: json["success"],
        error: json["error"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "error": error,
        "data": data.toJson(),
      };
}

class Data {
  dynamic id;
  dynamic mobile;
  dynamic address;
  dynamic city;
  dynamic email;
  dynamic name;
  dynamic pinCode;
  dynamic state;

  Data({
    required this.id,
    required this.mobile,
    required this.address,
    required this.city,
    required this.email,
    required this.name,
    required this.pinCode,
    required this.state,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"] ?? "",
        mobile: json["mobile"],
        address: json["address"] ?? "",
        city: json["city"] ?? "",
        email: json["email"] ?? "",
        name: json["name"] ?? "Name",
        pinCode: json["pinCode"] ?? "",
        state: json["state"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "address": address,
        "city": city,
        "email": email,
        "name": name,
        "pinCode": pinCode,
        "state": state,
      };
}
