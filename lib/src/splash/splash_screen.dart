import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:ecom_app/src/module/home/dashboard.dart';
import 'package:ecom_app/src/module/login/mobile_number_screen.dart';
import 'package:flutter/material.dart';

import '../Data/local data/prefrence.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    //  checkUSerSession();
  }

  @override
  void didChangeDependencies() {
    checkUSerSession();
    super.didChangeDependencies();
  }

  checkUSerSession() async {
    var token = await Pref.getToken();
    if (token.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          routeToDashboard();
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          routeToLogin();
        }
      });
    }
  }

  routeToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MobileNumberScreen(),
      ),
    );
  }

  routeToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  AppImages.logo,
                  width: MediaQuery.of(context).size.width * .8,
                )),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(AppImages.splashBottom)),
        ],
      ),
    );
  }
}
