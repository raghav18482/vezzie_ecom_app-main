import 'package:action_broadcast/action_broadcast.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/components/webview.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:ecom_app/src/Utils/genral/util.dart';
import 'package:ecom_app/src/module/home/dashboard.dart';
import 'package:ecom_app/src/module/login/common_widgets.dart';
import 'package:ecom_app/src/module/login/otp_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Resource/components/round_button.dart';
import 'google_auth/firebase_mobile_verfication.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  TextEditingController mobileNumber = TextEditingController();
  final FirebaseOTPVerification _firebaseOTPVerification =
      FirebaseOTPVerification();
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: CustomAppBar(
        //   title: "Account",
        // ),
        body: SingleChildScrollView(child: _body()),
      ),
    );
  }

  sendOtp({required String phoneNumber}) {
    sendBroadcast(Const.showLoader);
    _firebaseOTPVerification.verifyPhoneNumber(
      phoneNumber,
      (verificationId) {
        Utils.toastMessage(message: "Otp Sent To your mobile number");
        route(id: verificationId);
        if (kDebugMode) {
          print("verify $verificationId");
        }
      },
      (errorMessage) {
        if (kDebugMode) {
          print("error $errorMessage");
        }
      },
      (message) {},
    );
  }

  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.height * .55,
      //   color: Colors.red,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            AppImages.loginpage, // Replace with the path to your SVG file

            // You can use a placeholder while the SVG is loading.
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ));
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(9.0),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontFamily: "inter",
                      color: AppColors.pink,
                      fontWeight: FontWeight.w100,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     "Sign in \nto Vezzie",
          //     style: TextStyle(
          //       fontFamily: "Inder",
          //       fontSize: 50,
          //     ),
          //   ),
          // ),
          // const Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     "to access your addresses & orders.",
          //     style: TextStyle(
          //       fontFamily: "inter",
          //       fontWeight: FontWeight.w400,
          //       fontSize: 15,
          //     ),
          //   ),
          // ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Login",
              style: TextStyle(
                fontFamily: "Inder",
                fontSize: 30,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .050),
              child: CommonWidgets.textFormFieldWithunderLineOnly(
                  keyboardTextInputType: TextInputType.number,
                  onlyNumber: true,
                  onChanged: (value) {
                    if (value.length == 10) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  controller: mobileNumber,
                  hintText: "Enter Your Mobile Number",
                  prefixWidget: const Text("+91"))),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .070),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: RoundButton(
                title: "Get OTP",
                onPress: () async {
                  if (mobileNumber.text.length != 10) {
                    Utils.flushBarErrorMessage(
                        message: "Mobile NUmber is Not Valid",
                        context: context);
                  } else {
                    await sendOtp(
                        phoneNumber: "+91${mobileNumber.text.trim()}");
                  }
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const MyWebView(
                    title: "",
                    url: "https://vezzie.in/terms-of-use",
                  );
                },
              ));
            },
            child: const Align(
              alignment: Alignment.bottomLeft,
              heightFactor: 4,
              child: Text(
                "Terms of Services &\nPrivacy Policy ",
                style: TextStyle(
                  fontFamily: "inter",
                  color: AppColors.blackColor,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w100,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  route({required String id}) {
    sendBroadcast(Const.hideLoader);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(
          mobileNumber: mobileNumber.text.trim(),
          verificationID: id,
        ),
      ),
    );
  }
}
