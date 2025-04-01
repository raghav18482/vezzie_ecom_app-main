import 'dart:io';

import 'package:ecom_app/src/Data/Network/network_api_services.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/service/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/Data/Network/network_chnage.dart';
import 'src/Network connectivity/network.dart';
import 'src/Utils/routes/routes.dart';
import 'src/Utils/thems/theme.dart';
import 'src/service/notification_srvice.dart';
import 'src/splash/splash_screen.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:
          AppColors.buttonColor, // Set the status bar color to white
      statusBarIconBrightness:
          Brightness.light, // Set the icon brightness to dark
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await  NotificationService().permisson();
  // await NotificationService().initNotification();
  // await FirebaseApi().initNotifications();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Network();
  runApp(const MyApp());
}

notification() {
  FirebaseMessaging.onMessage.listen((event) {
    if (event.notification != null) {
      NotificationService().showNotification(
          title: event.notification?.title, body: event.notification?.body);
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // checkUSerSession();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NetworkChange(
        child: Scaffold(
      body: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Vezzie',
          theme: MyTheme.themeData,
          onGenerateRoute: Routes.generateRoute,
          home: const SplashScreen()),
    ));
  }
}
