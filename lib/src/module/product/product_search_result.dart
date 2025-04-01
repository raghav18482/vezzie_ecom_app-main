// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:ecom_app/src/Data/Network/base_api_services.dart';
import 'package:ecom_app/src/Data/Network/network_api_services.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/components/app_bar.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/module/home/bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../Resource/const/api.dart';
import '../../Utils/genral/util.dart';
import 'model/product_list_model.dart';

class ProductSearchScreen extends StatefulWidget {
  ProductSearchScreen({
    super.key,
    this.productData,
    this.productKey = "",
    required this.productCatogeryID,
    this.search = "",
  });
  Product? productData;
  String search = "";
  String productKey = "";
  String productCatogeryID;

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  int count = 0;
  bool isExpanded = false;
  bool showCounts = false;
  List<Product> productListing = [];
  List<int> countArray = [];
  final BaseAPiServices _apiServices = NetworkApiService();
  bool showLoader = false;
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Product Detail",
          onTapHome: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return BottomNavigation();
              },
            ));
          },
        ),
        body: (showLoader)
            ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.buttonColor,
            ))
            : SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: (widget.search.isNotEmpty),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(text: "Search result for: "),
                          TextSpan(
                            text: widget.search,
                            style: const TextStyle(
                              color: Colors
                                  .red, // Change to your desired color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                carouselSliderWithIndicators(widget.productData!.images,
                    _controller, _currentIndex),
                // Image.network(
                //   widget.productData.images.first,
                //   width: MediaQuery.of(context).size.width * .5,
                // ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.productData!.name,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Product Description
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Quantity:
                      Text(
                        widget.productData!.unit,
                        style: const TextStyle(
                          color: AppColors.commonTextColor,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${widget.productData!.price}", // Replace with actual price
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width * .03,
                          ),
                          Text(
                            "₹ ${widget.productData!.actualPrice}",
                            // Replace with actual price

                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.commonTextColor,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width * .03,
                          ),
                          Transform.scale(
                            scale: .8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF94892),
                                    Color(0xFF520098)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              // decoration: BoxDecoration(
                              //     color: AppColors.buttonColor,
                              //     borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "${widget.productData!.percentage.toStringAsFixed(0)} %",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width * .08,
                          ),
                          Expanded(
                            child: Transform.scale(
                              scale: .6,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(6.0),
                                  color: (count > 0)
                                      ? AppColors.pink
                                      : AppColors.pink,
                                  border: Border.all(
                                      color: AppColors.pink, width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    // Minus Icon Button
                                    Visibility(
                                      visible: (count > 0),
                                      child: IconButton(
                                        onPressed: () {
                                          if (count > 0) {
                                            setState(() {
                                              count = count - 1;
                                            });
                                            _removeCart(
                                                productId: widget
                                                    .productData!.id,
                                                productIndex: -99);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.remove,
                                          color: AppColors.whileColor,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          count = count + 1;
                                        });
                                        _addToCart(
                                            productIndex: -99,
                                            productId:
                                            widget.productData!.id,
                                            quantity: count);
                                      },
                                      child: Padding(
                                        padding: (count == 0)
                                            ? const EdgeInsets.all(12)
                                            : const EdgeInsets.all(0),
                                        child: Text(
                                          (count == 0)
                                              ? "Add to Cart"
                                              : "$count",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    // Plus Icon Button
                                    Visibility(
                                      visible: count > 0,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            count = count + 1;
                                          });
                                          _addToCart(
                                              productIndex: -99,
                                              productId:
                                              widget.productData!.id,
                                              quantity: count);
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: AppColors.whileColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   "Actual Price: Rs ${widget.productData.price}", // Replace with actual price
                      //   style: const TextStyle(
                      //     color: AppColors.buttonColor,
                      //     fontSize: 14,
                      //   ),
                      // ),
                      // Text(
                      //   "Offer: ${widget.productData.percentage.toStringAsFixed(2)} %", // Replace with actual price
                      //   style: const TextStyle(
                      //     color: AppColors.buttonColor,
                      //     fontSize: 14,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "About Product",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: (isExpanded == false) ? 300 : null,
                  child: Html(
                    data: widget.productData!.description,
                    // maxLines: 4,
                    // overflow: TextOverflow.ellipsis,
                    // style: const TextStyle(
                    //   color: AppColors.commonTextColor,
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 14,
                    // ),
                    //    textAlign: TextAlign.justify,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        (isExpanded) ? "See Less" : "See more",
                        style: const TextStyle(color: AppColors.pink),
                      )),
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(height: 16),
                _horizontalCardList(),
                const SizedBox(height: 16),
                // Add to Cart Button
                // Visibility(
                //   visible: (count == 0),
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       if (count == 0) {
                //         count = count + 1;
                //         setState(() {
                //           showCounts = true;
                //         });
                //       } else {
                //         // Implement your Add to Cart logic here
                //       }
                //     },
                //     icon: const Icon(Icons.shopping_cart),
                //     label: const Text(
                //       "Add to Cart",
                //       style: TextStyle(
                //         fontSize: 18,
                //       ),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.pink,
                //       padding: const EdgeInsets.symmetric(
                //         vertical: 16,
                //         horizontal: 32,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getProduct() {
    setState(() {
      showLoader = true;
    });
    _apiServices.httpGet(
        api: "${API.getproduct}?category=${widget.productCatogeryID}",
        showLoader: false,
        success: (sucess) {
          String jsonString = json.encode(sucess);
          final getProduct = getProductFromJson(jsonString);
          setState(() {
            productListing = getProduct.products;
          });
          for (int i = 0; i < productListing.length; i++) {
            if (widget.productKey != "") {
              if (widget.productKey == productListing[i].id) {
                widget.productData = productListing[i];
              }
            }
            setState(() {});
            countArray.add(productListing[i].qty);
          }
          setState(() {
            count = widget.productData!.qty;
            if (kDebugMode) {
              print(" $count ${widget.productCatogeryID} $count");
            }
            if (count > 0) {
              showCounts = true;
            }
          });
          setState(() {
            showLoader = false;
          });
        },
        failure: (error) {
          setState(() {
            showLoader = false;
          });
          if (kDebugMode) {
            print("eerror $error");
          }
        });
  }

  _horizontalCardList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .25,
      child: ListView.builder(
        addAutomaticKeepAlives: true,
        scrollDirection: Axis.horizontal,
        itemCount: productListing.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductSearchScreen(
                          productCatogeryID: productListing[index].category,
                          productData: productListing[index]),
                    ));
              },
              child: productCard2(index: index));
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
        width: MediaQuery.of(context).size.width * .5,
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
                      color: (countArray[index] > 0)
                          ? AppColors.pink
                          : Colors.white,
                      border: Border.all(
                        color: (countArray[index] > 0)
                            ? AppColors.pink
                            : AppColors.pink,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Visibility(
                          visible: (countArray[index] > 0),
                          child: InkWell(
                            onTap: () {
                              if (countArray[index] > 0) {
                                setState(() {
                                  countArray[index] = countArray[index] - 1;
                                });
                                _addToCart(
                                    productIndex: index,
                                    productId: productListing[index].id,
                                    quantity: countArray[index]);
                              }
                            },
                            child: Icon(
                              Icons.remove,
                              color: (countArray[index] > 0)
                                  ? Colors.white
                                  : AppColors.pink,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (countArray[index] == 0) {
                              setState(() {
                                countArray[index] = countArray[index] + 1;
                              });
                              _addToCart(
                                  productIndex: index,
                                  productId: productListing[index].id,
                                  quantity: countArray[index]);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              (countArray[index] == 0)
                                  ? "Add"
                                  : "${countArray[index]}",
                              style: TextStyle(
                                color: (countArray[index] == 0)
                                    ? AppColors.pink
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (countArray[index] > 0),
                          child: InkWell(
                            onTap: () {
                              if (countArray[index] > 0) {
                                setState(() {
                                  countArray[index] = countArray[index] + 1;
                                });
                                _addToCart(
                                    productIndex: index,
                                    productId: productListing[index].id,
                                    quantity: countArray[index]);
                              }
                            },
                            child: Icon(
                              Icons.add,
                              color: (countArray[index] > 0)
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
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    "${productListing[index].percentage.toStringAsFixed(0)} %",
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
                    color:
                    (countArray[index] > 0) ? AppColors.pink : Colors.white,
                    border: Border.all(color: AppColors.pink, width: 1.0),
                  ),
                  child: Row(
                    children: [
                      Visibility(
                        visible: (countArray[index] > 0),
                        child: InkWell(
                          onTap: () {
                            if (countArray[index] > 0) {
                              setState(() {
                                countArray[index] = countArray[index] - 1;
                              });
                              _removeCart(
                                productIndex: index,
                                productId: productListing[index].id,
                              );
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
                          if (countArray[index] == 0) {
                            setState(() {
                              countArray[index] = countArray[index] + 1;
                              _addToCart(
                                  productIndex: index,
                                  productId: productListing[index].id,
                                  quantity: countArray[index]);
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            (countArray[index] == 0)
                                ? "Add"
                                : "${countArray[index]}",
                            style: TextStyle(
                              color: (countArray[index] == 0)
                                  ? AppColors.pink
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (countArray[index] > 0),
                        child: InkWell(
                          onTap: () {
                            if (countArray[index] > 0) {
                              setState(() {
                                countArray[index] = countArray[index] + 1;
                                _addToCart(
                                    productIndex: index,
                                    productId: productListing[index].id,
                                    quantity: countArray[index]);
                              });
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

  _addToCart(
      {required String productId,
        required dynamic quantity,
        required int productIndex}) {
    {
      Map<String, dynamic> body = {
        "product": productId,
      };
      if (kDebugMode) {
        print("cart update here $body");
      }

      _apiServices.httpPost(
          api: API.addCart,
          showLoader: true,
          parameters: body,
          success: (sucess) {
            //   Utils.toastMessage(message: sucess["msg"]);
            sendBroadcast(Const.getCartInfo);
          },
          failure: (error) {
            if (productIndex == -99) {
              setState(() {
                if (count != 0) {
                  count = count - 1;
                }
              });
            } else {
              setState(() {
                if (countArray[productIndex] != 0) {
                  countArray[productIndex] = countArray[productIndex] - 1;
                }
              });
              Utils.toastMessage(message: "Cart Not Updated");
            }
          });
    }
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
          showLoader: true,
          parameters: body,
          success: (sucess) {
            // Utils.toastMessage(message: sucess["msg"]);
            sendBroadcast(Const.getCartInfo);
          },
          failure: (error) {
            if (productIndex == -99) {
              setState(() {
                if (count != 0) {
                  count = count + 1;
                }
              });
            } else {
              setState(() {
                if (countArray[productIndex] != 0) {
                  countArray[productIndex] = countArray[productIndex] + 1;
                }
              });
              Utils.toastMessage(message: "Cart Not Updated");
            }
          });
    }
  }

  Widget carouselSliderWidget(List<String> imageListData) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * .33,
          enableInfiniteScroll: true,
          autoPlay: true,
          viewportFraction: 1,
          animateToClosest: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: true,
          aspectRatio: 16 / 9,
          onPageChanged: (index, reason) {
            // Do something when the current page changes
          },
        ),
        items: imageListData.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,

                  //   fit: BoxFit.fill,
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
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget carouselSliderWithIndicators(List<String> imageListData,
      CarouselController controller, int currentIndex) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10),
          child: CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * .33,
              enableInfiniteScroll: true,
              autoPlay: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
              aspectRatio: 16 / 9,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: imageListData.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
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
                  );
                },
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imageListData.length, (index) {
            return GestureDetector(
              onTap: () {
                //controller.animateToPage(index); // Go to the tapped index
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? AppColors.pink // Active indicator color
                      : Colors.grey, // Inactive indicator color
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
