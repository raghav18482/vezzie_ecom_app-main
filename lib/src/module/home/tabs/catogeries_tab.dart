import 'dart:convert';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app/src/module/product/product_listing.dart';
import 'package:flutter/material.dart';

import '../../../Data/Network/base_api_services.dart';
import '../../../Data/Network/network_api_services.dart';
import '../../../Resource/components/pink_cart.dart';
import '../../../Resource/const/api.dart';
import '../models/catogery.dart';

class CatogeriesTabScreen extends StatefulWidget {
  const CatogeriesTabScreen({super.key});

  @override
  State<CatogeriesTabScreen> createState() => _CatogeriesTabScreenState();
}

class _CatogeriesTabScreenState extends State<CatogeriesTabScreen> {
  List<Categories> catogeryList = [];
  final BaseAPiServices _apiServices = NetworkApiService();
  int indexcount = 0;
  getGatogery() {
    _apiServices.httpGet(
        api: API.getCatogery,
        showLoader: true,
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
    super.initState();
    getGatogery();
  }

  Future<void> _refreshData() async {
    // Simulate fetching new data
    await Future.delayed(const Duration(seconds: 2));

    await getGatogery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PinkCart(
        onTap: () {
          sendBroadcast("cartTabScreen");
        },
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                //     color: AppColors.buttonColor.withOpacity(.1),
                //    height: MediaQuery.of(context).size.height * 68,
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            childAspectRatio: 14 / 12),
                    itemCount: catogeryList.length,
                    itemBuilder: (context, index) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          indexcount = index;
                        });
                      });

                      return catogeryCard(index: index);
                    }),
              ),
            ),
          ],
        ),
      ),
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
        color: const Color(0xfffbecff),
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

                  width: double.infinity, // Take full width
                  //   height: double.infinity, // Take full height
                  // errorBuilder: (context, error, stackTrace) {
                  //   return const Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: Center(child: Icon(Icons.error)),
                  //     //   child: Image.asset(AppImages.catogeryproduct),
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
}
