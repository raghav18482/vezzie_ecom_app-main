import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTheme {
  static ThemeData get themeData {
    const Color primaryColor = Color(0xFF520098);
    return ThemeData(
      primaryColor: primaryColor,
      useMaterial3: false,
      fontFamily: 'Inder',
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
    );
  }
}
