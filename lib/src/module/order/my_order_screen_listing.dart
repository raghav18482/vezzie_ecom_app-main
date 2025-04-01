import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app/src/Resource/components/app_bar.dart';
import 'package:ecom_app/src/Resource/const/api.dart';
import 'package:flutter/material.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../Resource/color/colors.dart';
import '../home/models/my_order_model.dart';
import 'order_detail.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final BaseAPiServices _apiServices = NetworkApiService();
  List<Order> orders = [];
  getMyOrderLisitng() {
    _apiServices.httpGet(
        api: API.myOrderListing,
        showLoader: true,
        success: (sucess) {
          log(json.encode(sucess));
          final myOrderListing = MyOrderListing.fromJson(sucess);
          setState(() {
            orders = myOrderListing.orders;
          });
        },
        failure: (error) {
          //    print("error while mapping $error");
        });
  }

  @override
  void initState() {
    getMyOrderLisitng();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "My Orders"),
        body: (orders.isEmpty)
            ? const Center(
                child: Text(
                  "No Orders Found Buy Somthing !",
                  style:
                      TextStyle(color: AppColors.commonTextColor, fontSize: 18),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: AppColors.buttonColor.withOpacity(.1),
                      //    height: MediaQuery.of(context).size.height * 68,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return orderCard(index: index);
                          }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget orderCard({required int index}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      //  height: MediaQuery.of(context).size.height * .14,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Card(
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CachedNetworkImage(
                  imageUrl: orders[index].products.first.product.images.first,
                  width: 30,
                  errorWidget: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹ ${orders[index].total}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      (orders[index].status.toLowerCase().contains("created"))
                          ? "Arriving in a few minutes"
                          : (orders[index]
                                  .status
                                  .toLowerCase()
                                  .contains("paid"))
                              ? "Order completed"
                              : "Your order has been cancelled",
                      style: const TextStyle(
                        color: AppColors.dividerColour,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "(${orders[index].products.length} itmes)",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () async {
                  log(orders[index].status);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetail(
                          order: orders[index],
                        ),
                      ));
                },
                icon: const RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.buttonColor,
                    size: 18,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
