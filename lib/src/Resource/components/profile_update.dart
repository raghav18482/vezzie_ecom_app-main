// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:ecom_app/src/Resource/const/api.dart';
import 'package:ecom_app/src/Resource/const/const.dart';
import 'package:ecom_app/src/Utils/genral/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:image_picker/image_picker.dart';

import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import 'package:http/http.dart' as http;

final BaseAPiServices apiServices = NetworkApiService();

class PofileUpdate {
  void showImageDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Uplaode Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoDialogAction(
                onPressed: () async {
                  String? base64Image = await pickImageFromGallery();
                  if (base64Image != null) {
                    routeAndAPIcall(base64Image, context);
                  } else {
                    // Utils.flushBarErrorMessage(
                    //     message: "Somthing went !", context: context);
                  }
                },
                child: const Text('Gallery 🖼'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  String? base64Image = await pickImageFromCamera();
                  if (base64Image != null) {
                    routeAndAPIcall(base64Image, context);
                  } else {
                    // Utils.flushBarErrorMessage(
                    //     message: "Somthing went !", context: context);
                  }
                },
                child: const Text('Camera 📸'),
              ),
            ],
          ),
        );
      },
    );
  }

  routeAndAPIcall(base64Image, context) {
    Navigator.of(context).pop();
    if (base64Image != null) {
      uplaodeProfile(base64Image, context);
      FocusScope.of(context).unfocus();
      // Call your success callback with the base64 image
    } else {
      // Call your failure callback
      FocusScope.of(context).unfocus();
    }
  }

  Future<String?> pickImageFromCamera() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      return imageFile.path;
    } else {
      return null;
    }
  }

  pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      return imageFile.path;
    } else {
      return null;
    }
  }

  uplaodeProfile(filePath, context) async {
    sendBroadcast(Const.showLoader);
    String token = await Pref.getToken();
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.MultipartRequest('POST', Uri.parse(API.uplaodeProfilePic));
    request.files.add(await http.MultipartFile.fromPath('avatar', filePath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(await response.stream.bytesToString());
      }
      sendBroadcast(Const.hideLoader);
      Utils.toastMessage(message: "Profile Picture Saved Success!");
    } else {
      Utils.flushBarErrorMessage(
          context: context, message: "Somthing went wrong");
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }
}
