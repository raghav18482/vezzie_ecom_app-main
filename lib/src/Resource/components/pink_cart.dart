import 'dart:convert';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:ecom_app/src/Resource/const/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../module/home/models/cart_info_model.dart';
import '../color/colors.dart';
import '../const/const.dart';

class PinkCart extends StatefulWidget {
  const PinkCart({super.key, this.onTap});
  final void Function()? onTap;
  @override
  State<PinkCart> createState() => _PinkCartState();
}

class _PinkCartState extends State<PinkCart> with AutoCancelStreamMixin {
  final BaseAPiServices _apiServices = NetworkApiService();
  bool showBlank = true;
  CartInfo? _cartInfo;
  getCartInfo() {
    _apiServices.httpGet(
      api: API.getCartInfo,
      showLoader: true,
      success: (response) {
        String jsonString = json.encode(response);

        setState(() {
          _cartInfo = cartInfoFromJson(jsonString);
          showBlank = (_cartInfo!.qty > 0) ? false : true;
        });
        Pref.setCartCount(count: _cartInfo!.qty.toString());
        if (kDebugMode) {
          print("response cart $response");
        }
      },
      failure: (error) {
        print("error showb $error");
        setState(() {
          showBlank = true;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCartInfo();
  }

  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver([
      Const.getCartInfo,
    ]).listen((intent) {
      switch (intent.action) {
        case Const.getCartInfo:
          getCartInfo();
          sendBroadcast(Const.updateCount);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (showBlank)
        ? const SizedBox()
        : GestureDetector(
          onTap: widget.onTap,
          child: Container(
              //  color: AppColors.buttonColor.withOpacity(.1),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                color: AppColors.pink,
                elevation: 20,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.pink,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      (_cartInfo != null)
                          ? Text(
                              "${_cartInfo!.qty} Items / ₹${_cartInfo!.total}",
                              style: const TextStyle(color: Colors.white),
                            )
                          : const Text(
                              "Items / ₹",
                              style: TextStyle(color: Colors.white),
                            ),
                      InkWell(
                        onTap: widget.onTap,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.shopping_cart_checkout,
                              color: Colors.white,
                            ),
                            Text(
                              "View Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        );
  }
}
