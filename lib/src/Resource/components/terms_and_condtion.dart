// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';

// import '../../Data/Network/base_api_services.dart';
// import '../../Data/Network/network_api_services.dart';
// import '../../Resource/const/api.dart';

// class TermsAndCondtion extends StatefulWidget {
//   const TermsAndCondtion({super.key});

//   @override
//   State<TermsAndCondtion> createState() => _TermsAndCondtionState();
// }

// class _TermsAndCondtionState extends State<TermsAndCondtion> {
//   final BaseAPiServices _apiServices = NetworkApiService();
//   String termsAndCondtion = "";
//   @override
//   void initState() {
//     getTermsAndCondtions();
//     super.initState();
//   }

//   getTermsAndCondtions() async {
//     try {
//       _apiServices.httpGet(
//           api: API.termsAndCondtion,
//           showLoader: true,
//           success: (value) {
//             setState(() {
//               termsAndCondtion = value["message"];
//             });
//             if (kDebugMode) {
//               print("response is thsi $value");
//             }
//           },
//           failure: (error) {
//             if (kDebugMode) {
//               print("error is $error");
//             }
//           });
//     } catch (e) {
//       if (kDebugMode) {
//         print("error $e");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Terms & Condtions"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.all(17),
//           child: Html(
//             data: termsAndCondtion,
//           ),
//         ),
//       ),
//     );
//   }
// }
