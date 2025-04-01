import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> handleBackgroundMessage(RemoteMessage msg) async {
  if (kDebugMode) {
    print("title ${msg.notification?.title} body ${msg.notification?.body}");
  }
}

class FirebaseApi {
  // create an instance of Firebase Messaging

  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications

  Future<void> initNotifications() async {
// request permission from user (will prompt user)

    await _firebaseMessaging.requestPermission();

// fetch the FCM token for this device

    final fCMToken = await _firebaseMessaging.getToken();
    await Pref.setFcmToken(token: fCMToken!);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

// print the token (normally you would send this to your server)

// function to initialize foreground and background settings
  }
}
