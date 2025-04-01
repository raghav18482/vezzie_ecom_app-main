// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/components/profile_update.dart';
import 'package:ecom_app/src/Resource/components/round_button.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:ecom_app/src/module/detail_address/address_screen_detail.dart';
import 'package:ecom_app/src/module/login/mobile_number_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../Resource/components/webview.dart';
import '../../Resource/const/api.dart';
import '../../Utils/genral/util.dart';

import '../login/google_auth/firebase_mobile_verfication.dart';
import '../order/my_order_screen_listing.dart';
import 'detail_address_form_screen.dart';
import 'faq_screen.dart';
import 'list_of_address.dart';
import 'model/get_profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GetProfileData? getProfileDataModel;
  String imageurl = "";
  final BaseAPiServices apiServices = NetworkApiService();
  final FirebaseOTPVerification _firebaseOTPVerification =
      FirebaseOTPVerification();

  getProfileData() async {
    await apiServices.httpGet(
        api: API.getProfileData,
        showLoader: false,
        offlineSupport: true,
        offlineData: (data) {
          setState(() {
            getProfileDataModel = getProfileDataFromJson(json.encode(data));
            imageurl =
                "${API.baseUrl}/user/profile/avatar/${getProfileDataModel!.data.id}";
          });
        },
        success: (sucess) {
          setState(() {
            getProfileDataModel = getProfileDataFromJson(json.encode(sucess));
            imageurl =
                "${API.baseUrl}/user/profile/avatar/${getProfileDataModel!.data.id}";

            setState(() {});
          });
        },
        failure: (error) {
          if (kDebugMode) {
            print("error $error");
          }
          // Utils.flushBarErrorMessage(
          //     message: "Somthing went wrong Please connect with Admin",
          //     context: context);
        });
  }

  @override
  void initState() {
    getProfileData();
    //  getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: CustomAppBar(
        //   title: "Profile",
        // ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .055,
                      ),
                      Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () {
                              PofileUpdate().showImageDialog(context);
                              FocusScope.of(context).unfocus();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0,
                                        3), // controls the position of the shadow
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: imageurl,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: AppColors.buttonColor,
                                    child: Icon(
                                      Icons.person,
                                      size: 17.0,
                                      color: Colors.white,
                                    ),
                                  ),

                                  // width: 40.0,
                                  // height: 40.0,
                                  //   fit: BoxFit.cover,
                                  // errorBuilder: (context, error, stackTrace) {
                                  //   return const CircleAvatar(
                                  //     radius: 20.0,
                                  //     backgroundColor: AppColors.buttonColor,
                                  //     child: Icon(
                                  //       Icons.person,
                                  //       size: 17.0,
                                  //       color: Colors.white,
                                  //     ),
                                  //   );
                                  // },
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .055,
                      ),
                      Expanded(
                        flex: 6,
                        child: InkWell(
                          onTap: () async {
                            String token = await Pref.getToken();
                            if (token.isNotEmpty) {
                              route();
                            } else {
                              Utils.flushBarErrorMessage(
                                  message: "You are Not Login/Register",
                                  context: context);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textWidget(
                                  value: (getProfileDataModel != null)
                                      ? getProfileDataModel!.data.name
                                      : "Name"),
                              _textWidget(
                                  value: (getProfileDataModel != null)
                                      ? getProfileDataModel!.data.mobile
                                          .toString()
                                      : "Mobile"),
                              _textWidget(
                                  value: (getProfileDataModel != null)
                                      ? getProfileDataModel!.data.email
                                      : ""),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            String token = await Pref.getToken();
                            if (token.isNotEmpty) {
                              route();
                            } else {
                              Utils.flushBarErrorMessage(
                                  message: "You are Not Login/Register",
                                  context: context);
                            }
                          },
                          icon: const RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.pink,
                              size: 14,
                            ),
                          ))
                    ],
                  ),
                ),
                detailTapWidget(
                    iconName: AppImages.orderBasket,
                    title: "My Orders",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyOrderScreen(),
                          ));
                    }),
                detailTapWidget(
                    iconName: AppImages.faq,
                    title: "Customer Support & FAQ",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FAQScreen(),
                          ));
                    }),
                detailTapWidget(
                    iconName: AppImages.logo,
                    title: "About Vezzie office",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OurAddressScreen(),
                          ));
                    }),
                detailTapWidget(
                    iconName: AppImages.locaction,
                    title: "Addresses",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressList(),
                          ));
                    }),
                // detailTapWidget(
                //     iconName: AppImages.refund,
                //     title: "Refunds",
                //     onPressed: () {}),
                detailTapWidget(
                    iconName: AppImages.info,
                    title: "Genral Information",
                    //  color: Colors.blue,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const MyWebView(
                            title: "",
                            url: "https://vezzie.in/about-us",
                          );
                        },
                      ));
                    }),
                detailTapWidget(
                    iconName: AppImages.watsapp,
                    title: "WhatsApp Us",
                    onPressed: () {
                      //   openWhatsapp(context: context, number: "9079840103");
                      openWatsapp(
                        9511513819,
                        context,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: RoundButton(
                    title: "Log Out",
                    transprantButton: true,
                    onPress: () {
                      _firebaseOTPVerification.handleLogout();
                      Pref.clearAllData();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return const MobileNumberScreen();
                        },
                      ), (route) => false);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void openWhatsapp(
  //     {required BuildContext context, required String number}) async {
  //   var whatsapp = number; //+92xx enter like this
  //   var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp";
  //   // var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";

  //   // android , web
  //   if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
  //     await launchUrl(Uri.parse(whatsappURlAndroid));
  //   } else {
  //     showWerror();
  //   }
  // }
  openWatsapp(number, BuildContext context) {
    try {
      launchUrl(Uri.parse('https://wa.me/+91$number?text=Hi'),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      // showWerror(context);
    }
  }

  showWerror() {
    Utils.flushBarErrorMessage(
        message: "Whatsapp not installed", context: context);
  }

  route() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailAddressScreenForm(
          mobileNumber: getProfileDataModel!.data.mobile.toString(),
        ),
      ),
    );
  }

  Widget detailTapWidget(
      {required String iconName,
      required String title,
      void Function()? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Divider(
                thickness: 1,
                color: AppColors.dividerColour.withOpacity(.5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (iconName == AppImages.logo || iconName == AppImages.faq)
                    ? Image.asset(
                        iconName,
                        width: (AppImages.faq == iconName) ? 22 : 22,
                        color: AppColors.buttonColor,
                      )
                    : Image.asset(
                        iconName,
                        width: 22,
                      ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: onPressed,
                    icon: const RotatedBox(
                      quarterTurns: 2,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.pink,
                        size: 14,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  _textWidget({required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        value,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}
