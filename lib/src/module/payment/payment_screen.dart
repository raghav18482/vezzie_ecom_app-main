import 'package:ecom_app/src/Resource/components/app_bar.dart';
import 'package:ecom_app/src/Resource/components/round_button.dart';
import 'package:ecom_app/src/Resource/const/api.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:ecom_app/src/Utils/genral/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../Resource/color/colors.dart';
import '../detail_address/model/address_list_model.dart';
import 'order_confirm_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.address,
  });

  final String totalAmount;
  final Address address;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedAmount = -1;
  final BaseAPiServices _apiServices = NetworkApiService();

  /// Place Order API Call
  void placeOrder() {
    _apiServices.httpPost(
      api: API.placeOrder,
      success: (response) {
        if (kDebugMode) {
          print("Order placed: ${response["order"]["total"]}");
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmScreen(
              address: widget.address,
              totalAmount: response["order"]["total"].toString(),
            ),
          ),
        );
      },
      parameters: {
        "address": widget.address.id,
        "paymentMode": "COD",
        "tipAmount": selectedAmount != -1 ? selectedAmount : 0,
      },
      showLoader: true,
      failure: (error) {
        Utils.flushBarErrorMessage(
          message: "Order Not Placed. Please try again later.",
          context: context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Choose Payment Method",
          showIcons: false,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTotalAmountSection(),
                        const Divider(
                          thickness: 1,
                          color: AppColors.dividerColour,
                        ),
                        Image.asset(AppImages.upiImage),
                        _buildPaymentAcceptanceCard(),
                        _buildTipSelection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// Sticky Bottom Payment Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomPaymentBar(widget.totalAmount),
            ),
          ],
        ),
      ),
    );
  }

  /// Section to Show Total Payable Amount
  Widget _buildTotalAmountSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total amount Payable:",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        Text(
          "₹${widget.totalAmount}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  /// Payment Acceptance Card
  Widget _buildPaymentAcceptanceCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.commonTextColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Acceptance",
              style: TextStyle(
                color: AppColors.commonTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "If you want to pay online, you can scan the QR code with our delivery partner upon arrival.",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// Tip Selection for Delivery Partner
  Widget _buildTipSelection() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.commonTextColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Delivery Partner Tip",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.commonTextColor,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final tipAmount = (index + 1) * 10;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedAmount = tipAmount;
                      });
                    },
                    child: TipAmountCard(
                      amount: tipAmount,
                      isSelected: selectedAmount == tipAmount,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Sticky Bottom Payment Bar
  Widget _buildBottomPaymentBar(String totalAmount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.only(bottom: 0, top: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// "To Pay" Section (Left Side)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "To Pay",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "₹$totalAmount",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          /// "Pay by Cash/UPI" Button (Right Side)
          SizedBox(
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () {
                placeOrder();
              },
              child: const Text(
                "Pay by Cash/UPI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TipAmountCard extends StatelessWidget {
  final int amount;
  final bool isSelected;

  const TipAmountCard({
    super.key,
    required this.amount,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: (isSelected)
                    ? Colors.transparent
                    : AppColors.commonTextColor),
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? AppColors.buttonColor.withOpacity(.7)
                : AppColors.whileColor,
          ),
          // shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(10))),

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$amount Rs',
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.dividerColour,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
