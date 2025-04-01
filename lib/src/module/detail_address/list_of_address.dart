// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:ecom_app/src/Resource/const/api.dart';
import 'package:ecom_app/src/Utils/genral/util.dart';
import 'package:ecom_app/src/module/payment/payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../Resource/components/app_bar.dart';
import '../../Resource/components/auth_popup.dart';
import '../../Resource/components/round_button.dart';
import '../../Resource/const/const.dart';
import 'detail_address_form_screen.dart';
import 'model/address_list_model.dart';

class AddressList extends StatefulWidget {
  AddressList({super.key, this.totalAmount = ""});
  String totalAmount;
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> with AutoCancelStreamMixin {
  final BaseAPiServices apiServices = NetworkApiService();
  List<Address> addresses = [];
  getAddressList() {
    apiServices.httpGet(
        api: API.addressList,
        showLoader: true,
        offlineSupport: true,
        offlineData: (data) {
          setState(() {
            final addressListModel = addressListModelFromJson(jsonEncode(data));
            addresses = addressListModel.address;

            /// If only one address exists, auto-select it
            if (addresses.length == 1) {
              addresses[0].isSelected = true;
            }
          });
        },
        success: (response) {
          setState(() {
            final addressListModel =
                addressListModelFromJson(jsonEncode(response));
            addresses = addressListModel.address;

            /// If only one address exists, auto-select it
            if (addresses.length == 1) {
              addresses[0].isSelected = true;
            }
          });
        },
        failure: (error) {});
  }

  @override
  void initState() {
    getAddressList();
    super.initState();
  }

  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver([
      Const.getAddresList,
    ]).listen((intent) {
      switch (intent.action) {
        case Const.getAddresList:
          getAddressList();
          break;
      }
    });
  }

  void cupertionsucessDialoug() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext x) {
        // Create the AccountRequiredPopup widget with desired properties
        return AccountRequiredPopup(
          mainContext: context,
          showCancel: false,
          body: "You have not selected any Address yet!",
          title: "Select Address",
          onPressed: () {
            // If the user presses the button, pop the dialog and return true
            Navigator.of(context).pop(true);
          },
        );
      },
    ).then((value) {
      // The dialog has been dismissed, if value is null, return false
      if (value == null) {
        return false;
      } else {
        return true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cupertionsucessDialoug();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Select Address",
            onTapHome: () {
              Navigator.pop(context);
            },
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            isThreeLine: true,
                            subtitle: Text(
                                "${addresses[index].state}, ${addresses[index].city}, ${addresses[index].pinCode}"),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  addresses[index].addressLineOne,
                                  style: const TextStyle(fontSize: 16.0),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  addresses[index].addressLineTwo,
                                  style: const TextStyle(fontSize: 16.0),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: Radio(
                              value: index,
                              groupValue: addresses
                                  .indexWhere((element) => element.isSelected),
                              onChanged: (value) {
                                setState(() {
                                  for (var element in addresses) {
                                    element.isSelected = false;
                                  }
                                  addresses[value!].isSelected = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: widget.totalAmount.isEmpty
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween, // Better alignment
                  children: [
                    /// Add New Address Button
                    Expanded(
                      child: SizedBox(
                        height: 40, // Consistent height
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.pinkAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailAddressScreenForm(
                                  mobileNumber: "",
                                  forUpdate: true,
                                  addNewAddress: true,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Add New Address",
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16), // Space between buttons

                    /// Select Button (only if totalAmount is not empty)
                    if (widget.totalAmount.isNotEmpty)
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              int selectedAddressIndex = addresses
                                  .indexWhere((element) => element.isSelected);

                              if (selectedAddressIndex != -1) {
                                Address selectedAddress =
                                    addresses[selectedAddressIndex];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      address: selectedAddress,
                                      totalAmount: widget.totalAmount,
                                    ),
                                  ),
                                );

                                if (kDebugMode) {
                                  print('Selected address: $selectedAddress');
                                }
                              } else {
                                Utils.flushBarErrorMessage(
                                  postion: FlushbarPosition.TOP,
                                  message: "Please Select an Address",
                                  context: context,
                                );
                              }
                            },
                            child: const Text(
                              "Select",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
