// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';

import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:ecom_app/src/Resource/components/app_bar.dart';
import 'package:ecom_app/src/Resource/components/auth_popup.dart';
import 'package:ecom_app/src/Resource/components/round_button.dart';
import 'package:ecom_app/src/Resource/const/api.dart';
import 'package:ecom_app/src/Utils/genral/util.dart';
import 'package:ecom_app/src/module/home/dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../Resource/color/colors.dart';
import 'google_auth/firebase_mobile_verfication.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen(
      {super.key, required this.mobileNumber, required this.verificationID});
  String mobileNumber;
  String verificationID;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final BaseAPiServices _apiServices = NetworkApiService();
  final FirebaseOTPVerification _firebaseOTPVerification =
      FirebaseOTPVerification();
  final formKey = GlobalKey<FormState>();
  String currentText = "";
  TextEditingController otpFieldValue = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          cupertionsucessDialougOTpDialouf();

          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: "Account",
            showIcons: false,
          ),
          body: _body(),
        ),
      ),
    );
  }

  registerOrLoginUser({required String mobilenumber}) async {
    final firebaseMessaging = FirebaseMessaging.instance;

    String? fcmToken = await firebaseMessaging.getToken();

    Map<String, dynamic> body = {"mobile": mobilenumber, "fcmId": fcmToken};
log("vody $body");
    _apiServices.httpPost(
        api: API.loginOrRegister,
        showLoader: true,
        parameters: body,
        success: (sucess) async {
          await Pref.setToken(token: sucess["token"]);

          Map<String, dynamic> rawData = Jwt.parseJwt(sucess["token"]);
          //    cupertionsucessDialoug();
          Pref.setUserID(token: rawData["_id"]);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ));
          // showSuccessDialog(context);
        },
        failure: (error) {
          log("error detect $error");
          Utils.flushBarErrorMessage(
              message: "Somthing went wrong Please connect with Admin",
              context: context);
        });
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Align(
            heightFactor: 3,
            child: Row(
              children: const [
                Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.pink,
                ),
                Text("Sign in")
              ],
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            heightFactor: 1.5,
            child: Text(
              "Verify Phone Number",
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Inder",
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            heightFactor: 1.5,
            child: Text("An SMS with 6-digit OTP was sent to ",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Inter",
                )),
          ),
          Row(
            children: [
              Text("+91 ${widget.mobileNumber} "),
              const Text("Change Number"),
            ],
          ),
          otpField(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RoundButton(
                  title: "Verify",
                  onPress: () {
                    if (currentText.length < 6) {
                      showVerificationErrorDialog(context);
                    } else {
                          // registerOrLoginUser(
                          //     mobilenumber: widget.mobileNumber);
                      _firebaseOTPVerification.signInWithOTP(
                        currentText,
                        widget.verificationID,
                        () {
                          registerOrLoginUser(
                              mobilenumber: widget.mobileNumber);
                        },
                        (errorMessage) {
                          Utils.flushBarErrorMessage(
                              message:
                                  "Somthing went wrong Please try again after some time !",
                              context: context);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void showVerificationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verification Error'),
          content:
              const Text('The OTP entered is incorrect. Please try again.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform any additional actions here
              },
            ),
          ],
        );
      },
    );
  }

  cupertionsucessDialoug() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext x) {
        return AccountRequiredPopup(
          mainContext: context,
          showCancel: false,
          body: "Your phone number has been successfully verified.",
          title: "Phone Number Verified",
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ));
          },
        );
      },
    );
  }

  cupertionsucessDialougOTpDialouf() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext x) {
        return AccountRequiredPopup(
          mainContext: context,
          showCancel: false,
          body: "Are you Sure You want to go back And Sent OTP Again?",
          title: "Alert !!",
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contextDialoug) {
        return AlertDialog(
          title: const Text('Phone Number Verified'),
          content:
              const Text('Your phone number has been successfully verified.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(contextDialoug).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    )); // Close the dialog
                // Perform any additional actions here
              },
            ),
          ],
        );
      },
    );
  }

  otpField() {
    return Form(
      key: formKey,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
          child: PinCodeTextField(
            appContext: context,
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
            length: 6,
            obscureText: false,
            obscuringCharacter: '*',
            // obscuringWidget: const FlutterLogo(
            //   size: 24,
            // ),
            backgroundColor: Colors.transparent,
            blinkWhenObscuring: false,
            animationType: AnimationType.fade,

            pinTheme: PinTheme(
              inactiveColor: Colors.black,
              inactiveFillColor: Colors.transparent,
              shape: PinCodeFieldShape.underline,
              activeColor: Colors.white,
              selectedColor: Colors.white,
              selectedFillColor: Colors.white,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
            ),
            cursorColor: Colors.black,
            validator: (value) {
              if (value!.length < 4) {
                return "OTP not valid";
              } else {
                return null;
              }
            },
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: otpFieldValue,
            keyboardType: TextInputType.number,
            boxShadows: const [
              BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black12,
                blurRadius: 10,
              )
            ],
            onCompleted: (v) {
              debugPrint("Completed");
            },
            // onTap: () {
            //   print("Pressed");
            // },
            onChanged: (value) {
              debugPrint(value);
              setState(() {
                currentText = value;
              });
            },
            beforeTextPaste: (text) {
              debugPrint("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          )),
    );
  }
}
