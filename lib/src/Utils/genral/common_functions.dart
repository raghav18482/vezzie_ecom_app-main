import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class CommonFunctions {
  static bool validateEmail(String input) {
    const pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    final regex = RegExp(pattern);
    return regex.hasMatch(input);
  }

  static Map<String, dynamic> convertStringToMap(jsonString) {
    int startIndex = jsonString.indexOf('{');
    int endIndex = jsonString.lastIndexOf('}');
    String json = jsonString.substring(startIndex, endIndex + 1);

    // Parsing the JSON string into a map
    Map<String, dynamic> map = jsonDecode(json);

    return map;
  }

  static Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }
}
