// import 'package:ecom_app/src/Resource/color/colors.dart';
// import 'package:ecom_app/src/Resource/components/round_button.dart';
// import 'package:ecom_app/src/Resource/images/app_images.dart';
// import 'package:ecom_app/src/module/detail_address/model/address_list_model.dart';
// import 'package:ecom_app/src/module/home/dashboard.dart';
// import 'package:flutter/material.dart';

// import '../../Resource/components/app_bar.dart';

// class OrderConfimrScreen extends StatefulWidget {
//   const OrderConfimrScreen(
//       {super.key, required this.address, required this.totalAmount});
//   final String totalAmount;
//   final Address address;
//   @override
//   State<OrderConfimrScreen> createState() => _OrderConfimrScreenState();
// }

// class _OrderConfimrScreenState extends State<OrderConfimrScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//           builder: (context) {
//             return const Dashboard();
//           },
//         ), (route) => false);
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           appBar: CustomAppBar(
//             title: "Order",
//             onTapHome: () {
//               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//                 builder: (context) {
//                   return const Dashboard();
//                 },
//               ), (route) => false);
//             },
//           ),
//           body: ListView(
//             children: [
//               Container(
//                 margin: const EdgeInsets.all(24),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.check_circle_rounded,
//                       color: AppColors.pink,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(
//                         "Your Order has been Placed.",
//                         style: TextStyle(
//                             color: AppColors.pink,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 22),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Center(
//                 child: Image.asset(
//                   AppImages.gifData,
//                   height: 125.0,
//                   width: 125.0,
//                 ),
//               ),
//               const Text(
//                 textAlign: TextAlign.center,
//                 "Thank you for shopping with Vezzie.\nConfirmation will be sent to your mobile number.",
//                 style: TextStyle(
//                     color: AppColors.blackColor,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 17),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * .06,
//               ),
//               // const Divider(
//               //   thickness: 1,
//               //   color: AppColors.dividerColour,
//               // ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Card(
//                   elevation: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Delivery Address",
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 color: AppColors.dividerColour,
//                                 fontStyle: FontStyle.normal,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             widget.address.name,
//                             style: const TextStyle(
//                                 fontSize: 16,
//                                 color: AppColors.blackColor,
//                                 fontStyle: FontStyle.normal,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                   "${widget.address.addressLineOne} ${widget.address.addressLineTwo},\nAntyodiya Nagar,${widget.address.city},\n${widget.address.state} - ${widget.address.pinCode}"),
//                               Text("Mob. - ${widget.address.mobile}"),

//                               // const Text(
//                               //   "Email - info.vizze@gmail.com",
//                               //   style: TextStyle(color: Colors.black),
//                               // ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * .02,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // const Divider(
//               //   thickness: 1,
//               //   color: AppColors.dividerColour,
//               // ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Card(
//                   elevation: 5,
//                   child: Container(
//                     margin: const EdgeInsets.all(14),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "Total amount",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 18),
//                             ),
//                             Text(
//                               "₹ ${widget.totalAmount}",
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 18),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
//                 child: RoundButton(
//                   title: "Home",
//                   transprantButton: false,
//                   onPress: () {
//                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//                       builder: (context) {
//                         return const Dashboard();
//                       },
//                     ), (route) => false);
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/components/round_button.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:ecom_app/src/module/detail_address/model/address_list_model.dart';
import 'package:ecom_app/src/module/home/dashboard.dart';
import 'package:flutter/material.dart';

import '../../Resource/components/app_bar.dart';

class OrderConfirmScreen extends StatefulWidget {
  const OrderConfirmScreen({
    super.key,
    required this.address,
    required this.totalAmount,
  });

  final String totalAmount;
  final Address address;

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToDashboard();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Order Confirmation",
            onTapHome: _navigateToDashboard,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                /// Order Success Message
                _buildOrderSuccessMessage(),

                /// Order Confirmation GIF
                _buildOrderConfirmationImage(),

                /// Thank You Text
                _buildThankYouText(),

                /// Delivery Address Card
                _buildAddressCard(),

                /// Total Amount Card
                _buildTotalAmountCard(),

                /// Home Button
                _buildHomeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigate to Dashboard (Home Screen)
  void _navigateToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
      (route) => false,
    );
  }

  /// Order Success Message Widget
  Widget _buildOrderSuccessMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.pink,
            size: 28,
          ),
          const SizedBox(width: 10),
          const Text(
            "Your Order has been Placed!",
            style: TextStyle(
              color: AppColors.pink,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// Order Confirmation Image (GIF)
  Widget _buildOrderConfirmationImage() {
    return Center(
      child: Image.asset(
        AppImages.gifData,
        height: 120.0,
        width: 120.0,
      ),
    );
  }

  /// Thank You Text
  Widget _buildThankYouText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Text(
        "Thank you for shopping with Vezzie.\n"
        "A confirmation will be sent to your mobile number.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Delivery Address Card
  Widget _buildAddressCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            const Text(
              "Delivery Address",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.dividerColour,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),

            /// Address Details
            Text(
              widget.address.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${widget.address.addressLineOne}, ${widget.address.addressLineTwo},\n"
              "Antyodiya Nagar, ${widget.address.city}, ${widget.address.state} - ${widget.address.pinCode}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "Mob: ${widget.address.mobile}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// Total Amount Card
  Widget _buildTotalAmountCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Amount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              "₹ ${widget.totalAmount}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// Home Button
  Widget _buildHomeButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        child: RoundButton(
          title: "Go to Home",
          transprantButton: false,
          onPress: _navigateToDashboard,
        ),
      ),
    );
  }
}
