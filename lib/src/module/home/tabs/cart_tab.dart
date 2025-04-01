import 'dart:convert';
import 'dart:developer';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app/src/Data/Network/network_api_services.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/components/round_button.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:ecom_app/src/module/detail_address/list_of_address.dart';
import 'package:ecom_app/src/module/home/models/cart_info_model.dart';
import 'package:ecom_app/src/module/product/model/product_list_model.dart';
import 'package:ecom_app/src/module/product/product_search_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Data/Network/base_api_services.dart';
import '../../../Resource/const/api.dart';
import '../../../Utils/genral/util.dart';
import '../../detail_address/model/address_list_model.dart';
import '../models/cart_view_model.dart';
import 'coupen.dart';

class CartScreenTab extends StatefulWidget {
  const CartScreenTab({super.key});

  @override
  State<CartScreenTab> createState() => _CartScreenTabState();
}

class _CartScreenTabState extends State<CartScreenTab>
    with AutoCancelStreamMixin {
  final ScrollController _gridScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  List<int> countForCartView = [];
  List<int> count = [];
  bool showShimmer = false;
  Map<String, dynamic> coupenID = {};
  List<ProductElement> cartItemList = [];
  final BaseAPiServices _apiServices = NetworkApiService();
  CartInfo _cartInfo = CartInfo.fromJson({
    "status": 200,
    "success": true,
    "error": null,
    "qty": 0,
    "subTotal": 00,
    "total": 00,
    "deliveryCharge": 00
  });
  List<Product> productListing = [];
  Address? address;
  @override
  void initState() {
    getCartView(showShimmerView: true);

    super.initState();
  }

  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver([
      Const.updateCart,
    ]).listen((intent) {
      switch (intent.action) {
        case Const.updateCart:
          getCartInfo();

          break;
      }
    });
  }

  getCartInfo() {
    _apiServices.httpGet(
      api: API.getCartInfo,
      showLoader: true,
      success: (response) {
        String jsonString = json.encode(response);

        setState(() {
          _cartInfo = cartInfoFromJson(jsonString);
        });
        if (kDebugMode) {
          print("response cart $response");
        }
      },
      failure: (error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (showShimmer) ? cartShimmerEffect() : _body(),
      bottomNavigationBar:
          (cartItemList.isEmpty) ? null : _bottomPaymentWidget(),
    );
  }

  Widget cartShimmerEffect() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: AppColors.buttonColor.withOpacity(.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 24.0,
              color: Colors.white,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 80.0,
                        height: 80.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 12.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                            ),
                            Container(
                              width: 180.0,
                              height: 12.0,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              width: 60.0,
                              height: 12.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                itemCount: 5, // Replace with the actual item count in the cart
              ),
            ),
            //    const SizedBox(height: 14.0),
            const Text(
              'Payment Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              height: 50.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  getCartView({bool showShimmerView = false}) {
    setState(() {
      if (showShimmerView) {
        showShimmer = true;
      }
    });

    // countForCartView.clear();
    // cartItemList.clear();

    try {
      _apiServices.httpGet(
        api: API.cartView,
        showLoader: false,
        success: (response) async {
          String jsonInString = json.encode(response);

          await getProduct();
          await getCartInfo();
          setState(() {
            final cartview = cartviewFromJson(jsonInString);
            log("cart detail $jsonInString");
            if (cartview.cart.isNotEmpty) {
              cartItemList = cartview.cart.first.products;
              coupenID = response['cart'][0]["couponId"] ?? {};
            } else {
              cartItemList = []; // Empty list if 'cart' is empty
              coupenID = {}; // Set coupenID to null if it doesn't exist
            }
            if (showShimmerView) {
              showShimmer = false;
            }
          });

          countForCartView.clear(); // Clear before adding
          for (int i = 0; i < cartItemList.length; i++) {
            countForCartView.add(cartItemList[i].qty);
          }
        },
      );
    } catch (e) {
      setState(() {
        showShimmer = false;
        countForCartView.clear();
        cartItemList.clear();
      });
    }
  }

  // getCartView() {
  //   setState(() {
  //     showShimmer = true;
  //   });

  //   countForCartView.clear();
  //   cartItemList.clear();

  //   try {
  //     _apiServices.httpGet(
  //         api: API.cartView,
  //         showLoader: false,
  //         success: (response) async {
  //           String jsonInString = json.encode(response);

  //           await getProduct();
  //           await getCartInfo();
  //           setState(() {
  //             final cartview = cartviewFromJson(jsonInString);

  //             cartItemList = cartview.cart.first.products;
  //             coupenID = response['cart'][0]["couponId"] ?? {};
  //             if (kDebugMode) {
  //               print("coupenID $coupenID");
  //             }
  //             showShimmer = false;

  //             if (kDebugMode) {
  //               print("cart length ${cartItemList.length}");
  //             }
  //           });
  //           for (int i = 0; i < cartItemList.length; i++) {
  //             if (kDebugMode) {
  //               print(
  //                   "image le in prod index of list=>$i ${cartItemList[i].product.images.first}");
  //             }
  //             countForCartView.add(cartItemList[i].qty);
  //           }
  //         });
  //   } catch (e) {
  //     setState(() {
  //       showShimmer = false;
  //       countForCartView.clear();
  //       cartItemList.clear();
  //     });
  //   }
  // }

  getProduct() {
    _apiServices.httpGet(
        api: "${API.getproduct}?category=64abd47a77cc1c048266d3be",
        showLoader: false,
        success: (sucess) {
          String jsonString = json.encode(sucess);
          final getProduct = getProductFromJson(jsonString);
          setState(() {
            productListing = getProduct.products;
          });
          for (int i = 0; i < productListing.length; i++) {
            count.add(productListing[i].qty);
          }
        },
        failure: (error) {
          if (kDebugMode) {
            print("eerror $error");
          }
        });
  }

  void _scrollListViewToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 300), alignment: 0.0);
    });
  }

  Widget _body() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          // Check if the user is scrolling vertically (axis == Axis.vertical)
          if (notification.metrics.axis == Axis.vertical &&
              _gridScrollController.position.extentAfter == 0) {
            // User reached the end of the GridView
            // Scroll the ListView to make it scrollable again

            _scrollListViewToTop();
          }
        }
        return false;
      },
      child: (cartItemList.isEmpty)
          ? const Center(
              child: Text(
                "Cart is empty ! 🛒",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff9336B4),
                    //   borderRadius: BorderRadius.circular(8.0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    // border: Border.all(color: AppColors.commonTextColor, width: 1.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Quick Delivery",
                        style: TextStyle(color: AppColors.whileColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        color: AppColors.commonTextColor, width: 1.0),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.scooterCart,
                        width: MediaQuery.of(context).size.width * .15,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hurre!"),
                          Text(
                            "Get Free Home Delivery on Orders above ₹ 299*",
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                _cartListView(),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bikaner Namkeen",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                          onTap: () {},
                          child: const Text(
                            "See All",
                            style: TextStyle(color: AppColors.pink),
                          )),
                    ],
                  ),
                ),
                ListView(
                  controller: _horizontalScrollController,
                  shrinkWrap: true,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _horizontalCardList(),
                    )
                  ],
                ),
                Container(
                  color: Colors.blue,
                  height: MediaQuery.of(context).size.height * .10,
                  child: CouponScreen(
                    couponId: coupenID,
                  ),
                ),
                //

                _paymentDetailCard(),
                Card(
                  elevation: 5,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    child: _amountAndTitleWidget(
                        title: "Total",
                        showBigText: true,
                        fakeAmount: "",
                        orignalAmount: "${_cartInfo.total}",
                        showSavedText: false),
                  ),
                ),
                // const Divider(
                //   thickness: 1,
                //   color: AppColors.dividerColour,
                // ),
                //  _bottomPaymentWidget()
              ],
            ),
    );
  }

  Widget _cartListView() {
    return ListView.builder(
      controller: _gridScrollController,
      shrinkWrap: true,
      itemCount: cartItemList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductSearchScreen(
                    productCatogeryID: cartItemList[index].product.category,
                    productKey: cartItemList[index].product.id,
                  ),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: cartItemList[index].product.images[0],
              errorWidget: (context, error, stackTrace) {
                return const SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.error,
                    color: AppColors.buttonColor,
                    size: 24,
                  ),
                );
              },
            ),
          ),
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductSearchScreen(
                    productCatogeryID: cartItemList[index].product.category,
                    productKey: cartItemList[index].product.id,
                  ),
                ),
              );
            },
            child: Text(
              cartItemList[index].product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          subtitle: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductSearchScreen(
                      productCatogeryID: cartItemList[index].product.category,
                      productKey: cartItemList[index].product.id,
                    ),
                  ),
                );
              },
              child: Text(cartItemList[index].product.unit)),
          trailing: Transform.scale(
            scale: .8,
            child: _addToCart(index),
          ),
        );
      },
    );
  }

  _removeCart({required String productId, required int productIndex}) {
    {
      Map<String, dynamic> body = {
        "product": productId,
      };
      if (kDebugMode) {
        print("cart x id $body");
      }

      _apiServices.httpPost(
          api: API.removeFromCart,
          showLoader: false,
          parameters: body,
          success: (sucess) {
            //     Utils.toastMessage(message: sucess["msg"]);
            getCartView();
            getCartInfo();
            getProduct();
          },
          failure: (error) {
            setState(() {
              if (countForCartView[productIndex] != 0) {
                countForCartView[productIndex] =
                    countForCartView[productIndex] + 1;
              }
            });
            Utils.toastMessage(message: "Cart Not Updated");
          });
    }
  }

  _addToCartApiCall({required String productId, required int productIndex}) {
    {
      Map<String, dynamic> body = {
        "product": productId,
      };
      if (kDebugMode) {
        print("cart x id $body");
      }

      _apiServices.httpPost(
          api: API.addCart,
          showLoader: true,
          parameters: body,
          success: (sucess) {
            //   Utils.toastMessage(message: sucess["msg"]);
            getCartView();
            getCartInfo();
            getProduct();
          },
          failure: (error) {
            setState(() {
              if (countForCartView[productIndex] != 0) {
                countForCartView[productIndex] =
                    countForCartView[productIndex] - 1;
              }
            });
            Utils.toastMessage(message: "Cart Not Updated");
          });
    }
  }

  // _bottomPaymentWidget() {
  //   return Card(
  //     elevation: 5,
  //     clipBehavior: Clip.antiAlias,
  //     child: Container(
  //       height: MediaQuery.of(context).size.height * .09,
  //       margin: const EdgeInsets.symmetric(horizontal: 24),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SizedBox(
  //             height: MediaQuery.of(context).size.height * .020,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "₹ ${_cartInfo.total}",
  //                 style: const TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               RoundButton(
  //                 title: "CONTINUE",
  //                 onPress: () {
  //                   //     if (address != null) {
  //                   Navigator.push(context, MaterialPageRoute(
  //                     builder: (context) {
  //                       return AddressList(
  //                         totalAmount: _cartInfo.total.toString(),
  //                       );
  //                     },
  //                   ));
  //                 },
  //                 pinkButton: true,
  //               )
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _bottomPaymentWidget() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Total Amount
            Text(
              "₹ ${_cartInfo.total}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            /// Continue Button
            SizedBox(
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressList(
                        totalAmount: _cartInfo.total.toString(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "CONTINUE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addToCart(index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .35,
      child: Row(
        children: [
          Container(
            width: (countForCartView[index] == 0)
                ? MediaQuery.of(context).size.width * .14
                : MediaQuery.of(context).size.width * .20,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color:
                  (countForCartView[index] > 0) ? AppColors.pink : Colors.white,
              border: Border.all(color: AppColors.pink, width: 1.0),
            ),
            child: Row(
              children: [
                Visibility(
                  visible: (countForCartView[index] > 0),
                  child: InkWell(
                      onTap: () {
                        if (countForCartView[index] > 0) {
                          setState(() {
                            countForCartView[index] =
                                countForCartView[index] - 1;
                          });
                          _removeCart(
                              productId: cartItemList[index].product.id,
                              productIndex: index);
                        }
                      },
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      )),
                ),

                InkWell(
                  onTap: () {
                    if (countForCartView[index] == 0) {
                      setState(() {
                        countForCartView[index] = countForCartView[index] + 1;
                        _addToCartApiCall(
                            productId: cartItemList[index].product.id,
                            productIndex: index);
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      (countForCartView[index] == 0)
                          ? "Add"
                          : "${countForCartView[index]}",
                      style: TextStyle(
                        color: (countForCartView[index] == 0)
                            ? AppColors.pink
                            : Colors.white,
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: (countForCartView[index] > 0),
                  child: InkWell(
                    onTap: () {
                      if (countForCartView[index] > 0) {
                        setState(() {
                          countForCartView[index] = countForCartView[index] + 1;
                        });
                        _addToCartApiCall(
                            productId: cartItemList[index].product.id,
                            productIndex: index);
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),

                //
              ],
            ),
            //7424808477
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("₹ ${cartItemList[index].product.price}"),
              Text(
                "₹ ${cartItemList[index].product.actualPrice}",
                style: const TextStyle(
                    color: AppColors.pink,
                    decoration: TextDecoration.lineThrough,
                    fontSize: 10),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gridScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  _horizontalCardList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * .25,
      child: ListView.builder(
        //    addAutomaticKeepAlives: true,

        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: productListing.length,
        itemBuilder: (context, index) {
          return productCard2(index: index);
        },
      ),
    );
  }

  Widget productCard2({required int index}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductSearchScreen(
              productData: productListing[index],
              productCatogeryID: productListing[index].category,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Same value as InkWell
          ),
          elevation: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: productListing[index].images.first,
                        height: 90,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 24,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Visibility(
                      visible: (productListing[index].percentage > 0),
                      child: Transform.scale(
                        scale: .98,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 3.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF94892), Color(0xFF520098)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Text(
                            "${productListing[index].percentage.toStringAsFixed(0)} %",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    productListing[index].name,
                    maxLines: 2,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold),
                    //    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    productListing[index].unit,
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Rs. ${productListing[index].price}",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: (count[index] > 0) ? AppColors.pink : Colors.white,
                      border: Border.all(
                        color: (count[index] > 0)
                            ? AppColors.pink
                            : AppColors.pink,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Visibility(
                          visible: (count[index] > 0),
                          child: InkWell(
                            onTap: () {
                              if (count[index] > 0) {
                                setState(() {
                                  count[index] = count[index] - 1;
                                });
                                _addToCartApiCall(
                                    productId: productListing[index].id,
                                    productIndex: index);
                              }
                            },
                            child: Icon(
                              Icons.remove,
                              color: (count[index] > 0)
                                  ? Colors.white
                                  : AppColors.pink,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (count[index] == 0) {
                              setState(() {
                                count[index] = count[index] + 1;
                              });
                              _addToCartApiCall(
                                  productId: productListing[index].id,
                                  productIndex: index);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              (count[index] == 0) ? "Add" : "${count[index]}",
                              style: TextStyle(
                                color: (count[index] == 0)
                                    ? AppColors.pink
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (count[index] > 0),
                          child: InkWell(
                            onTap: () {
                              if (count[index] > 0) {
                                setState(() {
                                  count[index] = count[index] + 1;
                                });
                                _addToCartApiCall(
                                    productId: productListing[index].id,
                                    productIndex: index);
                              }
                            },
                            child: Icon(
                              Icons.add,
                              color: (count[index] > 0)
                                  ? Colors.white
                                  : AppColors.pink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productCard({required int index}) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: productListing[index].images.first,
                    height: 110,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.error,
                          color: AppColors.buttonColor,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: -1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: const BoxDecoration(
                    color: AppColors.buttonColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    "${productListing[index].percentage.toStringAsFixed(2)} %",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                productListing[index].name,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                productListing[index].unit,
                style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text("Rs. ${productListing[index].price}"),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: (count[index] > 0) ? AppColors.pink : Colors.white,
                    border: Border.all(color: AppColors.pink, width: 1.0),
                  ),
                  child: Row(
                    children: [
                      Visibility(
                        visible: (count[index] > 0),
                        child: InkWell(
                          onTap: () {
                            if (count[index] > 0) {
                              setState(() {
                                count[index] = count[index] - 1;
                                _removeCart(
                                    productId: productListing[index].id,
                                    productIndex: index);
                              });
                            }
                          },
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          if (count[index] == 0) {
                            setState(() {
                              count[index] = count[index] + 1;
                            });
                            _addToCartApiCall(
                                productId: productListing[index].id,
                                productIndex: index);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            (count[index] == 0) ? "Add" : "${count[index]}",
                            style: TextStyle(
                              color: (count[index] == 0)
                                  ? AppColors.pink
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),

                      //
                      Visibility(
                        visible: (count[index] > 0),
                        child: InkWell(
                          onTap: () {
                            if (count[index] > 0) {
                              setState(() {
                                count[index] = count[index] + 1;
                              });
                              _addToCartApiCall(
                                  productId: productListing[index].id,
                                  productIndex: index);
                            }
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _paymentDetailCard() {
    return Card(
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Payment Details",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600),
                )),
            _amountAndTitleWidget(
                title: "Total of Itmes",
                fakeAmount: "",
                orignalAmount: "${_cartInfo.subTotal}"),
            _amountAndTitleWidget(
              title: "Delivery Fee",
              orignalAmount: "${_cartInfo.deliveryCharge}",
              isPink: true,
              fakeAmount: "",
            ),
            Visibility(
              visible: (_cartInfo.discount > 0),
              child: _amountAndTitleWidget(
                title: "Discount Fee (coupon)",
                showSavedText: true,
                savedAmount: _cartInfo.discount.toString(),
                orignalAmount: _cartInfo.discount.toString(),
                isPink: true,
                fakeAmount: "",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountAndTitleWidget(
      {required String title,
      bool isPink = false,
      bool showBigText = false,
      bool showSavedText = false,
      String savedAmount = "",
      required String fakeAmount,
      required String orignalAmount}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: (showBigText) ? 16 : 12,
                      color: (isPink) ? AppColors.pink : AppColors.blackColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        (fakeAmount != "") ? "₹ $fakeAmount" : "",
                        style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w700,
                            fontSize: 10),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "₹ $orignalAmount",
                        style: TextStyle(
                            color: (isPink)
                                ? AppColors.pink
                                : AppColors.blackColor,
                            fontSize: (showBigText) ? 16 : 13),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            widthFactor: 3.1,
            child: Visibility(
                visible: showSavedText,
                child: Text(
                  "you Saved ₹ $savedAmount",
                  style: const TextStyle(color: AppColors.pink),
                )),
          )
        ],
      ),
    );
  }
}
