// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  // 1. API offline response
  static Future setAPIResponse(
      {required String responseBody, required String api}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(api, responseBody);
  }

  static Future<String> getAPIResponse({required String api}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(api) ?? "";
  }

  // Token
  static Future setToken({required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") ?? "";
  }

  //fcmtoken
  static Future setFcmToken({required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("fcmtoken", token);
  }

  static Future<String> getFcmToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("fcmtoken") ?? "";
  }

  static Future setUserID({required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userID", token);
  }

  static Future<String> getUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userID") ?? "";
  }

  static Future setName({required String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
  }

  static Future<String> getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("name") ?? "";
  }

  static Future setEmail({required String email}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
  }

  static Future<String> getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("email") ?? "";
  }

  static Future setCartCount({required String count}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cartCount", count);
  }

  static Future<String> getCartCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("cartCount") ?? "";
  }

  static Future clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
