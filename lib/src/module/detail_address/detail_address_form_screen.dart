// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:ecom_app/src/Resource/components/round_button.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/Utils/genral/util.dart';
import 'package:ecom_app/src/module/home/dashboard.dart';
import 'package:ecom_app/src/module/login/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../Resource/components/app_bar.dart';
import '../../Resource/components/auth_popup.dart';
import '../../Resource/const/api.dart';
import 'model/get_profile_model.dart';

class DetailAddressScreenForm extends StatefulWidget {
  DetailAddressScreenForm(
      {super.key,
      required this.mobileNumber,
      this.forUpdate = false,
      this.addNewAddress = false});
  String mobileNumber;
  bool forUpdate;
  bool addNewAddress;
  @override
  State<DetailAddressScreenForm> createState() =>
      _DetailAddressScreenFormState();
}

class _DetailAddressScreenFormState extends State<DetailAddressScreenForm> {
  final TextEditingController _mobileTextController = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _addressLine2 = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _email = TextEditingController();

  final TextEditingController _pinCode = TextEditingController();
  final TextEditingController _state = TextEditingController();
  // final TextEditingController _countery = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final BaseAPiServices apiServices = NetworkApiService();
  @override
  void initState() {
    if (widget.addNewAddress == false) {
      getProfileData();
    }

    super.initState();
  }

  getProfileData() async {
    await apiServices.httpGet(
        api: API.getProfileData,
        showLoader: true,
        success: (sucess) {
          final getProfileData = getProfileDataFromJson(json.encode(sucess));
          setState(() {
            _address.text = getProfileData.data.address;
            _fullName.text = getProfileData.data.name;
            _email.text = getProfileData.data.email;
            _mobileTextController.text = getProfileData.data.mobile.toString();
            _city.text = getProfileData.data.city;
            _state.text = getProfileData.data.state;
            _pinCode.text = getProfileData.data.pinCode;
          });
          if (widget.mobileNumber != "") {
            setState(() {
              _mobileTextController.text = widget.mobileNumber;
            });
          }
        },
        failure: (error) {
          if (widget.mobileNumber != "") {
            setState(() {
              _mobileTextController.text = widget.mobileNumber;
            });
          }

          // Utils.flushBarErrorMessage(
          //     messae: "Somthing went wrong Please connect with Admin",
          //     context: context);
        });
  }

  addNewAddress(Map<String, dynamic> body) {
    log("$body");

    apiServices.httpPost(
        api: API.addNewAddress,
        showLoader: true,
        parameters: body,
        failure: (error) {
          Utils.flushBarErrorMessage(
              message:
                  "Somthing went wrong while Adding new address Please connect with Admin",
              context: context);
        },
        success: (response) {
          Navigator.pop(context);
          sendBroadcast(Const.getAddresList);
          if (kDebugMode) {
            print("$response");
          }
        });
  }

  updateProfile(Map<String, dynamic> body) {
    apiServices.httpPost(
        api: API.updateProfileData,
        showLoader: true,
        parameters: body,
        success: (sucess) {
          Utils.toastMessage(message: "Your Profile is updated");
          Future.delayed(const Duration(seconds: 1), () {
            if (widget.addNewAddress) {
              Navigator.pop(context);
              sendBroadcast(Const.getAddresList);
            } else {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return const Dashboard();
                },
              ), (route) => false);
            }
          });
        },
        failure: (error) {
          // Utils.flushBarErrorMessage(
          //     message: "Somthing went wrong Please connect with Admin",
          //     context: context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          showIcons: false,
          showBackButton: true,
          title: "Account",
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            // height: MediaQuery.of(context).size.height,
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    //   autovalidateMode: AutovalidateMode.disabled,
                    onWillPop: () async {
                      cupertionsucessDialoug();
                      return false;
                    },
                    key: _formKey,
                    child: Column(
                      children: [
                        CommonWidgets.textFormFieldBorder(
                            controller: _fullName,
                            keyboardTextInputType: TextInputType.text,
                            onlyNumber: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill this field";
                              }
                              return null;
                            },
                            hintText: "Enter Your full name",
                            prefixWidget: Container()),
                        CommonWidgets.textFormFieldBorder(
                            isEditable: (widget.addNewAddress) ? true : false,
                            controller: _mobileTextController,
                            keyboardTextInputType: TextInputType.text,
                            onlyNumber: false,
                            validator: (string) {
                              if (string!.isEmpty) {
                                return "Please enter mobile number";
                              } else if (string.length > 10) {
                                return "Mobile number is not valid";
                              } else {
                                return null;
                              }
                            },
                            hintText: "Enter Your Mobile number",
                            prefixWidget: Container()),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .010,
                        ),
                        CommonWidgets.textFormFieldWithunderLineOnly(
                            controller: _email,
                            keyboardTextInputType: TextInputType.text,
                            onlyNumber: false,
                            hintText: "Email",
                            prefixWidget: Container()),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .030,
                        ),
                        CommonWidgets.textFormFieldWithunderLineOnly(
                            controller: _address,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* This filed is required";
                              }
                              return null;
                            },
                            keyboardTextInputType: TextInputType.text,
                            onlyNumber: false,
                            hintText: "Enter Your Address & LandMark",
                            prefixWidget: Container()),
                        Visibility(
                          visible: widget.addNewAddress,
                          child: CommonWidgets.textFormFieldWithunderLineOnly(
                              controller: _addressLine2,
                              keyboardTextInputType: TextInputType.text,
                              onlyNumber: false,
                              hintText: "Address Line 2",
                              prefixWidget: Container()),
                        ),
                        CommonWidgets.textFormFieldWithunderLineOnly(
                            controller: _pinCode,
                            keyboardTextInputType: TextInputType.number,
                            hintText: "Pin Code",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* This filed is required";
                              } else if (value.length > 6) {
                                return "Pin code should be less then 6 digit";
                              }
                              return null;
                            },
                            prefixWidget: Container()),
                        CommonWidgets.textFormFieldWithunderLineOnly(
                            keyboardTextInputType: TextInputType.text,
                            controller: _city,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* This filed is required";
                              }
                              return null;
                            },
                            hintText: "City",
                            prefixWidget: Container()),
                        CommonWidgets.textFormFieldWithunderLineOnly(
                            controller: _state,
                            keyboardTextInputType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* This filed is required";
                              }
                              return null;
                            },
                            hintText: "State",
                            prefixWidget: Container()),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .005),
                        RoundButton(
                            title: (widget.addNewAddress)
                                ? "Save Address"
                                : "Update Profile",
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                Map<String, dynamic> body = {
                                  "name": _fullName.text.trim(),
                                  "pinCode": _pinCode.text.trim(),
                                  "email": _email.text.trim(),
                                  "city": _city.text.trim(),
                                  "state": _state.text.trim(),
                                  "address": _address.text.trim()
                                };
                                Map<String, dynamic> bodyAddress = {
                                  "name": _fullName.text.trim(),
                                  "mobile": _mobileTextController.text.trim(),
                                  "addressLineOne": _address.text.trim(),
                                  "addressLineTwo": _addressLine2.text.trim(),
                                  "city": _city.text.trim(),
                                  "state": _state.text.trim(),
                                  "pinCode": _pinCode.text.trim(),
                                };
                                if (widget.addNewAddress) {
                                  addNewAddress(bodyAddress);
                                } else {
                                  updateProfile(body);
                                }
                              }
                            })
                      ],
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

  cupertionsucessDialoug() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext x) {
        return AccountRequiredPopup(
          mainContext: context,
          showCancel: false,
          body: "Are you sure you want to go back",
          title: "Confirmation",
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
