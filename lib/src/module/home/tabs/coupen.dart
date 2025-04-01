// import 'dart:convert';

// import 'package:action_broadcast/action_broadcast.dart';
// import 'package:ecom_app/src/Data/Network/base_api_services.dart';
// import 'package:ecom_app/src/Data/Network/network_api_services.dart';
// import 'package:ecom_app/src/Resource/color/colors.dart';
// import 'package:ecom_app/src/Resource/const/api.dart';
// import 'package:ecom_app/src/Resource/const/const.dart';
// import 'package:ecom_app/src/Resource/images/app_images.dart';
// import 'package:ecom_app/src/Utils/genral/util.dart';
// import 'package:flutter/material.dart';

// import '../../detail_address/model/coupens_model.dart';

// class CouponScreen extends StatefulWidget {
//   CouponScreen({super.key, required this.couponId});
//   Map<String, dynamic> couponId;

//   @override
//   _CouponScreenState createState() => _CouponScreenState();
// }

// class _CouponScreenState extends State<CouponScreen> {
//   Map<String, dynamic> couponCode = {};
//   TextEditingController searchValue = TextEditingController();
//   bool coupenVisibility = false;
//   final BaseAPiServices _apiServices = NetworkApiService();
//   List<AvailableCoupon> coupons = [];
//   getCoupens() {
//     _apiServices.httpGet(
//         api: API.coupensAPI,
//         success: (data) {
//           try {
//             final couponCodeModel = couponCodeModelFromJson(json.encode(data));
//             setState(() {
//               coupons = couponCodeModel.availableCoupons;
//               couponCode = widget.couponId;
//               if (couponCode.isNotEmpty) {
//                 coupenVisibility = true;
//               }
//             });

//             // for (var i = 0; i < coupons.length; i++) {
//             //   print("id1 ${widget.couponId} id2 ${coupons[i].id}");
//             //   if (widget.couponId == coupons[i].id) {
//             //     print("Coupen Match");
//             //     setState(() {
//             //       couponCode = coupons[i].code;
//             //       coupenVisibility = true;
//             //     });
//             //   } else {}
//             // }
//           } catch (e) {
//             Utils.toastMessage(
//                 message: "Somthing Went wrong while adding the Coupen");
//           }
//         });
//   }

//   @override
//   void initState() {
//     getCoupens();

//     super.initState();
//   }

//   applyCoupen({
//     required String coupenCode,
//   }) {
//     _apiServices.httpGet(
//         api: "${API.applyCoupens}$coupenCode",
//         showLoader: true,
//         success: (sucess) {
//           couponCode["code"] = coupenCode;
//           coupenVisibility = true;
//           setState(() {});
//           sendBroadcast(Const.updateCart);
//           Navigator.pop(context);
//           searchValue.clear();
//         },
//         failure: (error) {
//           Utils.toastMessage(message: "Coupone Not Availabe");

//           searchValue.clear();
//           setState(() {});
//         });
//   }

//   removeCoupen({
//     required String coupenCode,
//   }) {
//     _apiServices.httpGet(
//         api: "${API.removeCoupens}$coupenCode",
//         showLoader: true,
//         success: (sucess) {
//           // couponCode = coupenCode;
//           coupenVisibility = false;
//           setState(() {});
//           sendBroadcast(Const.updateCart);
//           // Navigator.pop(context);
//           searchValue.clear();
//         },
//         failure: (error) {
//           Utils.toastMessage(message: "Coupone Not Availabe");

//           searchValue.clear();
//           setState(() {});
//         });
//   }

//   void _showCouponBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: searchValue,
//                 decoration: InputDecoration(
//                   labelText: 'Add Coupons',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.add),
//                     onPressed: () {
//                       applyCoupen(coupenCode: searchValue.text.trim());

//                       // Implement adding custom coupon logic
//                     },
//                   ),
//                 ),
//                 onChanged: (value) {
//                   // Implement search logic here
//                 },
//               ),
//               const SizedBox(height: 20),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: coupons.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: ListTile(
//                       leading: const Icon(Icons.local_offer),
//                       title: Text(coupons[index].title),
//                       subtitle: Text(coupons[index].description),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.add),
//                         onPressed: () {
//                           // Apply the coupon logic here
//                           // Close the bottom sheet
//                           applyCoupen(coupenCode: coupons[index].code);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: InkWell(
//         onTap: () {
//           _showCouponBottomSheet();
//         },
//         child: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Image.asset(
//                   AppImages.offer, // Replace with actual image path
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all((coupenVisibility) ? 0 : 8.0),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4),
//                           child: Text(
//                             (coupenVisibility)
//                                 ? "Coupon Applied"
//                                 : "Apply Coupon",
//                             style: TextStyle(
//                               color: (coupenVisibility)
//                                   ? Colors.black
//                                   : Colors.pink,
//                               fontSize: 22,
//                             ),

//                           ),
//                         ),
//                       ),
//                       Visibility(
//                         visible: coupenVisibility,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: Text(
//                             couponCode["code"] ?? "",
//                             style: const TextStyle(
//                                 color: AppColors.buttonColor,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         heightFactor: 2,
//                         child: Visibility(
//                           visible: !coupenVisibility,
//                           child: Icon(
//                             Icons.play_circle_fill_outlined,
//                             color: AppColors.buttonColor.withOpacity(.7),
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           removeCoupen(coupenCode: couponCode["code"]);
//                         },
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           heightFactor: 2,
//                           child: Visibility(
//                               visible: coupenVisibility,
//                               child: const Center(
//                                   child: Text(
//                                 "Remove Coupen",
//                               ))),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:action_broadcast/action_broadcast.dart';
import 'package:ecom_app/src/Data/Network/base_api_services.dart';
import 'package:ecom_app/src/Data/Network/network_api_services.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/const/api.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:ecom_app/src/Utils/genral/util.dart';
import 'package:flutter/material.dart';

import '../../detail_address/model/coupens_model.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key, required this.couponId});
  final Map<String, dynamic> couponId;

  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  Map<String, dynamic> couponCode = {};
  TextEditingController searchValue = TextEditingController();
  bool coupenVisibility = false;
  final BaseAPiServices _apiServices = NetworkApiService();
  List<AvailableCoupon> coupons = [];

  @override
  void initState() {
    super.initState();
    getCoupens();
  }

  getCoupens() {
    _apiServices.httpGet(
      api: API.coupensAPI,
      success: (data) {
        try {
          final couponCodeModel = couponCodeModelFromJson(json.encode(data));
          setState(() {
            coupons = couponCodeModel.availableCoupons;
            couponCode = widget.couponId;
            coupenVisibility = couponCode.isNotEmpty;
          });
        } catch (e) {
          Utils.toastMessage(
              message: "Something went wrong while fetching coupons.");
        }
      },
    );
  }

  applyCoupen({required String coupenCode}) {
    _apiServices.httpGet(
      api: "${API.applyCoupens}$coupenCode",
      showLoader: true,
      success: (success) {
        setState(() {
          couponCode["code"] = coupenCode;
          coupenVisibility = true;
        });
        sendBroadcast(Const.updateCart);
        Navigator.pop(context);
        searchValue.clear();
      },
      failure: (error) {
        Utils.toastMessage(message: "Coupon Not Available");
        searchValue.clear();
      },
    );
  }

  removeCoupen({required String coupenCode}) {
    _apiServices.httpGet(
      api: "${API.removeCoupens}$coupenCode",
      showLoader: true,
      success: (success) {
        setState(() {
          coupenVisibility = false;
        });
        sendBroadcast(Const.updateCart);
        searchValue.clear();
      },
      failure: (error) {
        Utils.toastMessage(message: "Coupon Not Available");
        searchValue.clear();
      },
    );
  }

  void _showCouponBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Search Input Field
              TextField(
                controller: searchValue,
                decoration: InputDecoration(
                  labelText: 'Enter Coupon Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add, color: Colors.pink),
                    onPressed: () {
                      applyCoupen(coupenCode: searchValue.text.trim());
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// List of Available Coupons
              if (coupons.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: coupons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading:
                            const Icon(Icons.local_offer, color: Colors.pink),
                        title: Text(coupons[index].title),
                        subtitle: Text(coupons[index].description),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            applyCoupen(coupenCode: coupons[index].code);
                          },
                          child: const Text("Apply",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    );
                  },
                )
              else
                const Center(child: Text("No Coupons Available")),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: _showCouponBottomSheet,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Coupon Image
                Image.asset(
                  AppImages.offer,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(width: 12),

                /// Coupon Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          coupenVisibility ? "Coupon Applied" : "Apply Coupon",
                          style: TextStyle(
                            color:
                                coupenVisibility ? Colors.black : Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (coupenVisibility)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              couponCode["code"] ?? "",
                              style: const TextStyle(
                                color: AppColors.buttonColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                /// Remove Coupon Button
                if (coupenVisibility)
                  InkWell(
                    onTap: () {
                      removeCoupen(coupenCode: couponCode["code"]);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Remove",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
