import 'package:another_flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class Utils {
  static toastMessage({required String message, Color color = Colors.green}) {
    Fluttertoast.showToast(msg: message, backgroundColor: color);
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void flushBarErrorMessage(
      {required String message,
      required BuildContext context,
      String? title,
      Color? color,
      FlushbarPosition? postion}) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          flushbarPosition: postion ?? FlushbarPosition.BOTTOM,
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(15),
          title: title,
          backgroundColor: color ?? Colors.redAccent,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          icon: const Icon(
            Icons.error,
            size: 20,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3),
          message: message,
        )..show(context));
  }
}
