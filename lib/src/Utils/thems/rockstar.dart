import 'package:flutter/material.dart';

// ignore: camel_case_types
class Rockstar {
  static Color themeColorName = const Color(0xff00008B);

  static String fontName = "Exo";

  static Color primaryBtnColor = const Color.fromRGBO(0, 139, 81, 1);
  static Color secondaryBtnColor = const Color.fromRGBO(255, 242, 18, 1);
  static Color bgGradientColor1 = const Color.fromRGBO(255, 255, 255, 1);
  static Color bgGradientColor2 = const Color.fromRGBO(0, 139, 81, 1);

  static Map themeDetails() {
    return {
      'themeColor': themeColorName,
      'fontFamily': fontName,
      'primaryBtnColor': primaryBtnColor,
      'secondaryBtnColor': secondaryBtnColor,
      'gradientCol1': bgGradientColor1,
      'gradientCol2': bgGradientColor2
    };
  }
}
