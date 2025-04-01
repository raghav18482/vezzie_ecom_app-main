// ignore_for_file: must_be_immutable

import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    required this.title,
    this.onTapHome,
    this.showIcons = true,
    this.showBackButton = false,
  });
  String title;
  bool showIcons;
  bool showBackButton;
  void Function()? onTapHome;
  void Function()? onTapSearch;

  @override
  Size get preferredSize =>
      const Size.fromHeight(100); // Adjust the height as needed

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.buttonColor,
          statusBarIconBrightness: Brightness.light),
      toolbarHeight: preferredSize.height,
      flexibleSpace: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: kToolbarHeight, // Adjust the height as needed
              child: Center(
                child: Image.asset(
                  AppImages.appBarLogo,
                  width: 100,
                  // Adjust the height as needed
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                replacement: const Spacer(),
                visible: showIcons,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: InkWell(
                    onTap: onTapHome,
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer()
            ],
          ),
        ],
      ),
    );
  }
}
