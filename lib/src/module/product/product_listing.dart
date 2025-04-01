import 'dart:convert';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:ecom_app/src/Resource/components/app_bar_with_search.dart';
import 'package:ecom_app/src/Resource/components/pink_cart.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/Utils/genral/util.dart';
import 'package:ecom_app/src/module/product/product_search_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../Resource/color/colors.dart';
import '../../Resource/const/api.dart';
import 'model/product_list_model.dart';

class ProductListing extends StatefulWidget {
  final String productCatogery;
  const ProductListing({super.key, required this.productCatogery});

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  final BaseAPiServices _apiServices = NetworkApiService();
  List<Product> productListing = [];

  List<int> count = [];
  bool showShimmer = false;
  getProduct({required String category, bool showShimmerWidget = false}) async {
    if (showShimmerWidget) {
      setState(() {
        showShimmer = true;
      });
    }
    String userID = await Pref.getUserID();
    _apiServices.httpGet(
        api: "${API.getproduct}?category=$category&userId=$userID",
        showLoader: false,
        offlineSupport: true,
        offlineData: (data) {
          String jsonString = json.encode(data);
          final getProduct = getProductFromJson(jsonString);

          setState(() {
            if (showShimmerWidget) {
              setState(() {
                showShimmer = false;
              });
            }
            productListing = getProduct.products;
          });
          for (int i = 0; i < productListing.length; i++) {
            count.add(productListing[i].qty);
          }
        },
        success: (sucess) {
          String jsonString = json.encode(sucess);
          final getProduct = getProductFromJson(jsonString);

          setState(() {
            if (showShimmerWidget) {
              setState(() {
                showShimmer = false;
              });
            }
            productListing = getProduct.products;
          });
          for (int i = 0; i < productListing.length; i++) {
            count.add(productListing[i].qty);
          }
        },
        failure: (error) {
          if (showShimmerWidget) {
            setState(() {
              showShimmer = false;
            });
          }
          if (kDebugMode) {
            print("eerror $error");
          }
        });
  }

  _addToCart(
      {required String productId,
      required dynamic quantity,
      required int productIndex}) {
    {
      Map<String, dynamic> body = {
        "product": productId,
      };
      if (kDebugMode) {
        print("cartx $body");
      }

      _apiServices.httpPost(
          api: API.addCart,
          showLoader: true,
          parameters: body,
          success: (sucess) {
            //    Utils.toastMessage(message: sucess["msg"]);
            sendBroadcast(Const.getCartInfo);
            getProduct(category: widget.productCatogery);
          },
          failure: (error) {
            setState(() {
              if (count[productIndex] != 0) {
                count[productIndex] = count[productIndex] - 1;
              }
            });
            Utils.toastMessage(message: "Cart Not Updated");
          });
    }
  }

  @override
  void initState() {
    getProduct(category: widget.productCatogery, showShimmerWidget: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
            // onWillPop: () async {
            //   if (FocusScope.of(context).hasFocus) {
            //     FocusScope.of(context).unfocus();
            //     return false; // Prevent back navigation if keyboard is open
            //   }
            //   return true; // Allow back navigation if keyboard is not open
            // },
            onWillPop: () {
              if (Navigator.of(context).userGestureInProgress) {
                FocusScope.of(context).unfocus();
              }
              return Future.value(true); // Allow back navigation
            },
            child: (showShimmer)
                ? shimmerProductGrid()
                : (productListing.isNotEmpty)
                    ? Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: CustomAppBarWithSearch(),
                        bottomNavigationBar: PinkCart(
                          onTap: () {
                            sendBroadcast("cartTabScreen");
                            Navigator.pop(context);
                          },
                        ),
                        body: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                //  color: AppColors.buttonColor.withOpacity(.1),
                                //    height: MediaQuery.of(context).size.height * 68,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: .8),
                                    itemCount: productListing.length,
                                    itemBuilder: (context, index) {
                                      return productCard2(index: index);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Scaffold(
                        body: Center(
                          child: Text(
                            "No Product Found For This Catogery",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        ),
                      )),
      ),
    );
  }

  Widget shimmerProductGrid() {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0, // Square aspect ratio
        ),
        itemCount: 8, // Replace with the actual number of products
        itemBuilder: (context, index) {
          return shimmerProductCard();
        },
      ),
    );
  }

  Widget shimmerProductCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 100,
              height: 12,
              color: Colors.white,
            ),
            const SizedBox(height: 4.0),
            Container(
              width: 60,
              height: 12,
              color: Colors.white,
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 80,
              height: 12,
              color: Colors.white,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 24,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard({required int index}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductSearchScreen(
                productData: productListing[index],
                productCatogeryID: productListing[index].category,
              ),
            ));
      },
      child: Container(
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

                      //   fit: BoxFit.cover,
                      // errorBuilder: (context, error, stackTrace) {
                      //   return const SizedBox(
                      //     width: 100,
                      //     height: 100,
                      //     child: Icon(
                      //       Icons.error,
                      //       color: AppColors.buttonColor,
                      //       size: 24,
                      //     ),
                      //   );
                      // },
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
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
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
                      child: Text(
                        "Rs. ${productListing[index].price}",
                      )),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: (count[index] > 0) ? AppColors.pink : Colors.white,
                      border: Border.all(
                        color: AppColors.pink,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        //

                        Visibility(
                          visible: (count[index] > 0),
                          child: InkWell(
                              onTap: () {
                                if (count[index] > 0) {
                                  setState(() {
                                    count[index] = count[index] - 1;
                                  });
                                  _addToCart(
                                      productIndex: index,
                                      productId: productListing[index].id,
                                      quantity: count[index]);
                                }
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              )),
                        ),

                        InkWell(
                          onTap: () {
                            if (count[index] == 0) {
                              setState(() {
                                count[index] = count[index] + 1;
                              });
                              _addToCart(
                                  productIndex: index,
                                  productId: productListing[index].id,
                                  quantity: count[index]);
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
                                _addToCart(
                                    productIndex: index,
                                    productId: productListing[index].id,
                                    quantity: count[index]);
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
                        // errorBuilder: (context, error, stackTrace) {
                        //   return const SizedBox(
                        //     width: 100,
                        //     height: 100,
                        //     child: Icon(
                        //       Icons.error,
                        //       color: Colors.red,
                        //       size: 24,
                        //     ),
                        //   );
                        // },
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
                    //  maxLines: 2,

                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold),
                    //    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 5.5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    productListing[index].unit,
                    style: const TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.w500),
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
                  Transform.scale(
                    scale: .85,
                    child: Container(
                      margin: const EdgeInsets.only(right: 7, bottom: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color:
                            (count[index] > 0) ? AppColors.pink : Colors.white,
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
                                  _addToCart(
                                      productIndex: index,
                                      productId: productListing[index].id,
                                      quantity: count[index]);
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
                                _addToCart(
                                    productIndex: index,
                                    productId: productListing[index].id,
                                    quantity: count[index]);
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
                                  _addToCart(
                                      productIndex: index,
                                      productId: productListing[index].id,
                                      quantity: count[index]);
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
}
