// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';

class AccountRequiredPopup extends StatelessWidget {
  AccountRequiredPopup(
      {super.key,
      required this.mainContext,
      required this.onPressed,
      required this.body,
      this.showCancel = true,
      required this.title});
  BuildContext mainContext;
  VoidCallback onPressed;
  String title;
  String body;
  bool showCancel;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        children: <Widget>[
          Text(
            body,
            style: const TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        Visibility(
          child: CupertinoDialogAction(
            child: const Text(
              "Cancel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        CupertinoDialogAction(
          child: const Text(
            "OK",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onPressed();

            // You can navigate to your account creation or login screen here
          },
        ),
      ],
    );
  }
}
