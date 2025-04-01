import 'dart:convert';
import 'dart:developer';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/components/pink_cart.dart';
import 'package:ecom_app/src/Resource/const/api.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:ecom_app/src/Utils/genral/common_functions.dart';
import 'package:ecom_app/src/module/home/models/catogery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Data/Network/base_api_services.dart';
import '../../../Data/Network/network_api_services.dart';
import '../../../Utils/genral/util.dart';
import '../../product/model/app_settings_model.dart';
import '../../product/model/carousle_url_model.dart';
import '../../product/model/product_list_model.dart';
import '../../product/product_listing.dart';
import '../../product/product_search_result.dart';

class HomeScreenTab extends StatefulWidget {
  const HomeScreenTab({Key? key}) : super(key: key);

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
  final BaseAPiServices _apiServices = NetworkApiService();
  int gridCound = 2;
  List<Categories> catogeryList = [];
  List<Product> productListing = [];
  AppSettings? _appSetting;
  List<int> count = [];
  getProduct() async {
    String userId = await Pref.getUserID();
    _apiServices.httpGet(
        api:
            "${API.getproduct}?category=64abd47a77cc1c048266d3be&userId=$userId",
        showLoader: false,
        offlineSupport: true,
        offlineData: (data) {
          String jsonString = json.encode(data);
          final getProduct = getProductFromJson(jsonString);
          setState(() {
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

  List<CarousleUrlModel> imageList = [];
  List<CarousleUrlModel> imageLisFreshvegies = [];
  final ScrollController _gridScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: _body(),
      ),
      bottomNavigationBar: PinkCart(
        onTap: () {
          sendBroadcast("cartTabScreen");
        },
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate fetching new data
    await Future.delayed(const Duration(seconds: 2));

    await getGatogery();
    await getProduct();
    await getAppSetting();
  }

  getGatogery() {
    _apiServices.httpGet(
        api: API.getCatogery,
        offlineSupport: true,
        offlineData: (data) {
          String jsonString = json.encode(data);
          final getCatogery = getCatogeryFromJson(jsonString);
          setState(() {
            catogeryList = getCatogery.categorys;
          });
        },
        success: (sucess) {
          String jsonString = json.encode(sucess);
          final getCatogery = getCatogeryFromJson(jsonString);
          setState(() {
            catogeryList = getCatogery.categorys;
          });
        },
        failure: (error) {});
  }

  @override
  void initState() {
    getGatogery();
    getProduct();
    getAppSetting();

    super.initState();
  }

  getAppSetting() async {
    await _apiServices.httpGet(
        api: API.appSettings,
        showLoader: false,
        offlineSupport: true,
        offlineData: (data) {
          setState(() {
            _appSetting = appSettingsFromJson(json.encode(data));

            //       imageList = _appSetting!.settings.carouselOneUrl;
            for (var i = 0;
                i < _appSetting!.settings.carouselOneUrl.length;
                i++) {
              imageList.add(CarousleUrlModel.fromJson({
                "image": _appSetting!.settings.carouselOneUrl[i],
                "id": _appSetting!.settings.carousel[i]
              }));
            }
            for (var i = 0;
                i < _appSetting!.settings.carouselTwoUrl.length;
                i++) {
              imageLisFreshvegies.add(CarousleUrlModel.fromJson({
                "image": _appSetting!.settings.carouselTwoUrl[i],
                "id": _appSetting!.settings.carousel2[i]
              }));
            }
            //   imageLisFreshvegies = _appSetting!.settings.carouselTwoUrl;
            log("setting data local  $data");
          });
          checkVersion();
        },
        success: (sucess) {
          setState(() {
            _appSetting = appSettingsFromJson(json.encode(sucess));

            //       imageList = _appSetting!.settings.carouselOneUrl;
            for (var i = 0;
                i < _appSetting!.settings.carouselOneUrl.length;
                i++) {
              imageList.add(CarousleUrlModel.fromJson({
                "image": _appSetting!.settings.carouselOneUrl[i],
                "id": _appSetting!.settings.carousel[i]
              }));
            }
            for (var i = 0;
                i < _appSetting!.settings.carouselTwoUrl.length;
                i++) {
              imageLisFreshvegies.add(CarousleUrlModel.fromJson({
                "image": _appSetting!.settings.carouselTwoUrl[i],
                "id": _appSetting!.settings.carousel2[i]
              }));
            }
            //   imageLisFreshvegies = _appSetting!.settings.carouselTwoUrl;
            log("setting data $sucess");
          });
          checkVersion();
        },
        failure: (error) {
          print("errorx $error");
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
        print("cart $body");
      }

      _apiServices.httpPost(
          api: API.addCart,
          showLoader: true,
          parameters: body,
          success: (sucess) {
            //     Utils.toastMessage(message: sucess["msg"]);
            sendBroadcast(Const.getCartInfo);
          },
          failure: (error) {
            setState(() {
              if (count[productIndex] != 0) {
                count[productIndex] = count[productIndex] - 1;
              }
            });
            Utils.toastMessage(message: "$error Cart Not Updated");
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
            //   Utils.toastMessage(message: sucess["msg"]);
            sendBroadcast(Const.getCartInfo);
          },
          failure: (error) {
            setState(() {
              if (count[productIndex] != 0) {
                count[productIndex] = count[productIndex] + 1;
              }
            });
            Utils.toastMessage(message: "Cart Not Updated");
          });
    }
  }

  // Helper method to scroll the ListView programmatically to the top
  void _scrollListViewToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 300), alignment: 0.0);
    });
  }

  // Future<String> getVersion() async {
  //   final String data = await rootBundle.loadString('pubspec.yaml');
  //   final List<String> lines = data.split('\n');
  //   for (String line in lines) {
  //     if (line.startsWith('version: ')) {
  //       return line.replaceAll('version: ', '').trim();
  //     }
  //   }
  //   return 'Unknown';
  // }

  checkVersion() async {
    try {
      if (_appSetting != null) {
        String version = _appSetting?.settings.appVersion ?? "";

        if (version != "") {
          final PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String appVersion =
              "${packageInfo.version}+${packageInfo.buildNumber}";
          print("versionx $version appv $appVersion");
          if (appVersion != version) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showUpdateAlert(context);
            });
          } else {
            return false;
          }
        }
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print("error in version manage $e");
      }
    }
  }

  //
  void launchStoreToUpdate(String appId) async {
    final url = 'https://play.google.com/store/apps/details?id=$appId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showUpdateAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Update Available'),
          content: const Text(
            'A new version of the app is available. Please update now!',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Later'),
              onPressed: () {
                // Add logic to handle the "Later" button click
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            CupertinoDialogAction(
              child: const Text('Update'),
              onPressed: () {
                launchStoreToUpdate("veziee_android.com");
                // Add logic to open the App Store for the update
                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _body() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            _gridScrollController.position.extentAfter == 0) {
          // User reached the end of the GridView
          // Scroll the ListView to make it scrollable again
          _scrollListViewToTop();
        }
        return false;
      },
      child: ListView(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppImages.deliveryBanner,
              ),
              Positioned(
                top: 20, // Adjust the top offset as needed
                child: Text(
                  (_appSetting != null)
                      ? _appSetting!.settings.banner.title
                      : "Delivering in 45 Mins",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5, // Adjust the top offset as needed
                child: Text(
                  (_appSetting != null)
                      ? _appSetting!.settings.banner.titleRight
                          .replaceAll('\n ', '\n')
                      : "Available \n Only In \n Bikaner"
                          .replaceAll('\n ', '\n'),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                  top: 5,
                  left: 5, // Adjust the top offset as needed
                  child: Text(
                    (3 == 4)
                        ? _appSetting!.settings.banner.titleLeft
                            .trim()
                            .replaceAll('\n', '\n')
                        : "Delivery\nFREE\nAbove ₹ 299",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
          carouselSliderWidget(imageList),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "CATEGORIES",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                    onTap: () {
                      sendBroadcast("CatogeriesTabScreen");
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(color: AppColors.pink),
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            //   color: AppColors.buttonColor.withOpacity(.1),
            child: GridView.builder(
                shrinkWrap: true,
                controller: _gridScrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 14 / 12
                    // crossAxisSpacing: 40,
                    // mainAxisSpacing: 20,
                    ),
                itemCount: catogeryList.length,
                itemBuilder: (context, index) {
                  return catogeryCard(index: index);
                }),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (_appSetting != null)
                      ? _appSetting!.settings.banner2.title
                      : "",
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // InkWell(
                //     onTap: () {},
                //     child: const Text(
                //       "See all",
                //       style: TextStyle(color: AppColors.pink),
                //     )),
              ],
            ),
          ),
          carouselSliderWidget(imageLisFreshvegies),
          if (_appSetting != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProductListing(
                          productCatogery:
                              _appSetting!.settings.banner2.routeId,
                        );
                      },
                    ));
                  },
                  child: CachedNetworkImage(
                      imageUrl: _appSetting!.settings.banner2.imgUrl)),
            )
          ],
          //bluCard(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const ProductListing(
                            productCatogery: "64abd47a77cc1c048266d3be",
                          );
                        },
                      ));
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(color: AppColors.pink),
                    )),
              ],
            ),
          ),
          _horizontalCardList(),
          SizedBox(
            height: MediaQuery.of(context).size.height * .02,
          ),
        ],
      ),
    );
  }

  Widget bluCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.lightblue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("BANNER"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Text((_appSetting != null)
                ? _appSetting!.settings.banner2.title
                : "Daily Offers for you ".toUpperCase()),
            Text((_appSetting != null)
                ? _appSetting!.settings.banner2.titleLeft
                : ""),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
          ]),
    );
  }

  Widget catogeryCard({required int index}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ProductListing(
              productCatogery: catogeryList[index].id,
            );
          },
        ));
      },
      child: Card(
        //   color: const Color(0xffF8E5F0),
        color: const Color(0xfffbecff),
        //  color: Colors.black,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10), // Adjust the radius as needed
        ),
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            // color: const Color(0xffF8E5F0),
            color: const Color(0xfffbecff),

            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: catogeryList[index].image,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: const Color(0xfffbecff),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity, // Square shimmer effect
                      color: Colors.grey[300],
                    ),
                  ),
                  width: double.infinity, // Take full width

                  // errorBuilder: (context, error, stackTrace) {
                  //   return const Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: Center(child: Icon(Icons.error)),
                  //   );
                  // },
                ),
              ),
              // Expanded(
              //   child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0),
              //         child: Text(catogeryList[index].name),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget carouselSliderWidget(List<CarousleUrlModel> imageListData) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150.0,
          enableInfiniteScroll: true,
          autoPlay: true,
          // viewportFraction: 1,
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProductListing(
                          productCatogery: imageUrl.id,
                        );
                      },
                    ));
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageUrl.imageUrl,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300], // Gray box effect
                      ),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.error,
                        color: AppColors.buttonColor,
                        size: 24,
                      ),
                    ),
                  ),
                  // child: Image.network(
                  //   imageUrl.imageUrl,
                  //   fit: BoxFit.fill,
                  //   errorBuilder: (context, error, stackTrace) {
                  //     return const SizedBox(
                  //       width: 100,
                  //       height: 100,
                  //       child: Icon(
                  //         Icons.error,
                  //         color: AppColors.buttonColor,
                  //         size: 24,
                  //       ),
                  //     );
                  //   },
                  // ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
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
                  alignment: Alignment.topLeft,
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
                          if (count[index] == 0) {
                            setState(() {
                              count[index] = count[index] + 1;
                              _addToCart(
                                  productIndex: index,
                                  productId: productListing[index].id,
                                  quantity: count[index]);
                            });
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
                                _addToCart(
                                    productIndex: index,
                                    productId: productListing[index].id,
                                    quantity: count[index]);
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
}
