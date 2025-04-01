import 'package:ecom_app/src/module/home/dashboard.dart';
import 'package:ecom_app/src/module/login/mobile_number_screen.dart';
import 'package:flutter/material.dart';

import '../../splash/splash_screen.dart';
import 'routes_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RoutesName.mobileNumberScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MobileNumberScreen());

      case RoutesName.dashabord:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Dashboard());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => Container());
      case RoutesName.registration:
        return MaterialPageRoute(
            builder: (BuildContext context) => Container());
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Scaffold(
                  body: Center(
                    child: Text("No routes defined"),
                  ),
                ));
    }
  }
}
