// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/components/app_bar.dart';
import 'package:ecom_app/src/Resource/components/round_button.dart';
import 'package:ecom_app/src/module/home/models/my_order_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail({super.key, required this.order});
  Order order;
  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  String formatDateTime(String originalDateTimeStr) {
    DateTime dateTime = DateTime.parse(originalDateTimeStr);

    String formattedDateTime =
        "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}";

    return formattedDateTime;
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("this is log ${widget.order.status}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Order Detail"),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.order.status.toLowerCase().contains("created"))
                      ? Text(
                          (widget.order.status
                                  .toLowerCase()
                                  .contains("created"))
                              ? "Expected Delivery Time"
                              : "",
                          style: const TextStyle(fontSize: 18),
                        )
                      : SizedBox(),
                  Text(
                    widget.order.status.toLowerCase().contains("created")
                        ? "Arriving in Few Minutes"
                        : widget.order.status.toLowerCase().contains("paid")
                            ? "Order Completed"
                            : "Your order has been Cancelled",
                    style: const TextStyle(
                      color: AppColors.pink,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              color: AppColors.dividerColour,
            ),
            Padding(
                padding: const EdgeInsets.all(11.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Order Detail",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    _detailWidget(
                        title: "Name", titleValue: widget.order.address.name),
                    _detailWidget(
                        title: "Order Number",
                        titleValue: widget.order.invoiceNumber),
                    _detailWidget(
                        title: "Order Date",
                        titleValue: formatDateTime(widget.order.createdAt)),
                    _detailWidget(
                        title: "Order Amount",
                        titleValue: "₹ ${widget.order.total}"),
                    _detailWidget(
                        title: "Payment Mode",
                        titleValue: widget.order.paymentMode),
                    Align(
                      heightFactor: 2,
                      alignment: Alignment.center,
                      child: RoundButton(
                        title: "Download Invoice",
                        onPress: () {
                          openPdfInExternalViewer(
                              "https://vezzie.in/invoice/${widget.order.id}/download");
                        },
                        radius: 10,
                        transprantButton: true,
                      ),
                    )
                  ],
                )),
            const Divider(
              thickness: 1,
              color: AppColors.dividerColour,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "(Items ${widget.order.products.length})",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              //color: AppColors.buttonColor.withOpacity(.1),
              //    height: MediaQuery.of(context).size.height * 68,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.order.products.length,
                  itemBuilder: (context, index) {
                    return orderCard(index: index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void openPdfInExternalViewer(String pdfUrl) async {
    // Attempt to launch the PDF URL in a browser or default app.
    if (await canLaunch(pdfUrl)) {
      await launch(pdfUrl);
    } else {
      // If the direct URL scheme doesn't work, try a generic PDF viewer URL scheme.
      final genericPdfViewerUrl = 'pdfviewer:$pdfUrl';
      if (await canLaunch(genericPdfViewerUrl)) {
        await launch(genericPdfViewerUrl);
      } else {
        // If neither works, handle the error.
        throw 'Could not launch $pdfUrl';
      }
      simp(url) async {
        try {
          if (await canLaunch(pdfUrl)) {
            await launch(pdfUrl);
          } else {
            throw 'Could not launch $pdfUrl';
          }
        } catch (e) {
          print(e);
        }
      }
    }
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
                  imageUrl: widget.order.products[index].product.images.first,
                  width: 40,
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
                    widget.order.products[index].product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      "₹ ${widget.order.products[index].product.price}",
                      style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Qty: ${widget.order.products[index].qty}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailWidget({required String title, required titleValue}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.dividerColour),
              ),
              Text(
                titleValue,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          color: AppColors.dividerColour,
        ),
      ],
    );
  }
}
