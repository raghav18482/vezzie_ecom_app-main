import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonWidgets {
  static Widget customTextFieldLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Exo",
            ),
          ),
          const Text(
            " *",
            style: TextStyle(
                color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  static Widget customTextFormField(
      {required String hintText,
      required TextEditingController textController,
      double height = 55,
      bool isPassowrdField = false,
      TextInputType keyboardType = TextInputType.text,
      ValueNotifier<bool>? passwordiconChnage,
      double width = 343,
      bool forMobileNumber = false,
      int? maxLength,
      FormState? formState,
      String? fieldKey,
      required String? Function(String?)? validate}) {
    return Column(
      children: [
        Container(
          height: height, // Customize height as needed
          width: width, // Customize width as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            keyboardType: keyboardType,
            //  maxLength: maxLength,
            //    validator: validate,
            inputFormatters: (forMobileNumber)
                ? [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : null,
            controller: textController,
            obscureText: (isPassowrdField) ? passwordiconChnage!.value : false,
            decoration: InputDecoration(
              border: InputBorder.none,
              alignLabelWithHint: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              hintText: hintText,
              suffixIcon: (isPassowrdField)
                  ? InkWell(
                      onTap: () {
                        passwordiconChnage.value = !passwordiconChnage.value;

                        if (kDebugMode) {
                          print("tap ${passwordiconChnage.value}");
                        }
                      },
                      child: Icon(passwordiconChnage!.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility))
                  : Container(
                      width: 1,
                    ),
            ),
          ),
        ),
        // if (validate != null)
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        //     child: Align(
        //       alignment: Alignment.topLeft,
        //       child: Text(
        //         validate(textController.text) ?? '',
        //         style: const TextStyle(color: Colors.red),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  // static showNativeStyleDialog(BuildContext dialougContext, String dialogText,
  //     {required Function onYesPressed, required Function onNoPressed}) {
  //   showDialog(
  //     context: dialougContext,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Confirmation'),
  //         content: Text(dialogText),
  //         actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0),
  //         actions: <Widget>[
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               foregroundColor:
  //                   Colors.black, // Set the text color of the button
  //             ),
  //             onPressed: () {
  //               Navigator.of(context, rootNavigator: true).pop();
  //               onNoPressed();
  //             },
  //             child: const Text('No'),
  //           ),
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               foregroundColor:
  //                   Colors.blue, // Set the text color of the button
  //             ),
  //             onPressed: () {
  //               Navigator.of(context, rootNavigator: true).pop();
  //               onYesPressed();
  //             },
  //             child: const Text('Yes'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  static Widget textFormFieldWithunderLineOnly({
    required TextEditingController controller,
    void Function(String)? onChanged,
    required String hintText,
    String? Function(String?)? validator,
    required TextInputType keyboardTextInputType,
    bool onlyNumber = false,
    required Widget prefixWidget,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black), // Black border at the bottom
        ),
      ),
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: prefixWidget),
          Expanded(
            child: TextFormField(
              validator: validator,
              onChanged: onChanged,
              controller: controller,
              inputFormatters: (onlyNumber)
                  ? [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : [],
              keyboardType: keyboardTextInputType,
              decoration: InputDecoration(
                border: InputBorder.none, // Hide the default border
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget textFormFieldBorder({
    required TextEditingController controller,
    void Function(String)? onChanged,
    required String hintText,
    bool isEditable = true,
    String? Function(String?)? validator,
    required TextInputType keyboardTextInputType,
    bool onlyNumber = false,
    required Widget prefixWidget,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Set the background color to grey
        border: Border.all(color: Colors.grey), // Add a grey border
        borderRadius: BorderRadius.circular(5), // Add border radius if desired
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: prefixWidget,
          ),
          Expanded(
            child: TextFormField(
              validator: validator,
              enabled: isEditable,
              onChanged: onChanged,
              controller: controller,
              inputFormatters: (onlyNumber)
                  ? [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : [],
              keyboardType: keyboardTextInputType,
              decoration: InputDecoration(
                border: InputBorder.none, // Hide the default border
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
