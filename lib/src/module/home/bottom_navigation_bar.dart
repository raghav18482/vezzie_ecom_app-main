// ignore_for_file: library_private_types_in_public_api

import 'package:action_broadcast/action_broadcast.dart';
import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/components/auth_popup.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/module/home/tabs/cart_tab.dart';
import 'package:ecom_app/src/module/home/tabs/catogeries_tab.dart';
import 'package:ecom_app/src/module/login/mobile_number_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Resource/components/app_bar_with_search.dart';
import '../../Resource/images/app_images.dart';
import '../detail_address/profile_screen.dart';
import 'tabs/home_tab.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with AutoCancelStreamMixin {
  int _currentIndex = 0;
  // int _cartCount = 0;
  // Added to store the cart count value
  final ValueNotifier<int> _cartCount = ValueNotifier<int>(0);
  String token = "";
  final List<Widget> _tabs = [
    const HomeScreenTab(),
    const CatogeriesTabScreen(),
    const ProfileScreen(),
    const CartScreenTab(),
  ];

  @override
  void initState() {
    super.initState();
    checkAuth();
    //   initData(true);
    _updateCartCount(); // Call this function to initialize the cart count
  }

//

  checkAuth() async {
    token = await Pref.getToken();
  }

  void _updateCartCount() async {
    // Replace this with your logic to retrieve the cart count from your cart data
    // For example:
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //  checkForceUpdate();
    _updateCartCount(); // Call this function whenever the widget is built or dependencies change
  }

  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver(
            ["CatogeriesTabScreen", "cartTabScreen","goHome",Const.updateCount])
        .listen((intent) {
      switch (intent.action) {
      case "goHome":
      setState(() {
       
        _currentIndex=0;
      });
      break;
        case Const.updateCount:
          setState(() {
            _currentIndex = _currentIndex + 1;
            _currentIndex = _currentIndex - 1;
          });
          break;
        case "CatogeriesTabScreen":
          setState(() {
            _currentIndex = 1;
          });
          break;
        case "cartTabScreen":
          //      print("token $token");
          if (token.isNotEmpty) {
            setState(() {
              _currentIndex = 3;
              return;
            });
          } else {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext x) {
                return AccountRequiredPopup(
                  mainContext: context,
                  body:
                      "To access your cart, please create an account or log in ! 😀",
                  title: "Account Required",
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileNumberScreen(),
                        ));
                  },
                );
              },
            );
          }

          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: () {
            if (Navigator.of(context).userGestureInProgress) {
              FocusScope.of(context).unfocus();
            }
            return Future.value(true); // Allow back navigation
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBarWithSearch(
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
            body: _tabs[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              backgroundColor: Colors.white,
              onTap: (int index) {
                // NotificationService()
                //     .showNotification(title: 'Sample title', body: 'It works!');
                FocusScope.of(context).unfocus();

                if (index == 3) {
                  if (token.isNotEmpty) {
                    setState(() {
                      _currentIndex = 3;
                    });
                  } else {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext x) {
                        return AccountRequiredPopup(
                          mainContext: context,
                          body:
                              "To access your cart, please create an account or log in ! 😀",
                          title: "Account Required",
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MobileNumberScreen(),
                                ));
                          },
                        );
                      },
                    );
                  }
                } else {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    //   color: AppColors.buttonColor,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    AppImages.categories,
                    width: 20,
                    color: (_currentIndex == 1)
                        ? AppColors.buttonColor
                        : AppColors.commonTextColor,
                  ),
                  label: 'Category',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline,
                    //   color: AppColors.buttonColor,
                  ),
                  label: 'Admin',
                ),
                BottomNavigationBarItem(
                  icon: ValueListenableBuilder(
                    valueListenable: _cartCount,
                    builder: (context, value, child) {
                      return Stack(
                        // Wrap the icon with Stack to overlay the count indicator
                        children: [
                          const Icon(
                            Icons.shopping_cart,
                            //   color: AppColors.buttonColor,
                            size: 28,
                          ),
                          _cartCount.value > 0
                              ? Positioned(
                                  top: -1,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors
                                          .red, // Customize the background color of the count indicator
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 14,
                                      minHeight: 14,
                                    ),
                                    child: Text(
                                      '${_cartCount.value}',
                                      style: const TextStyle(
                                        color: Colors
                                            .white, // Customize the text color of the count indicator
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      );
                    },
                  ),
                  label: 'Cart',
                ),
              ],
              fixedColor: AppColors.buttonColor,
              unselectedLabelStyle:
                  const TextStyle(color: AppColors.buttonColor),
              unselectedItemColor: AppColors.commonTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
