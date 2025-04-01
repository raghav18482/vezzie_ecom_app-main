// // ignore_for_file: must_be_immutable, must_call_super

// import 'dart:async';
// import 'package:ecom_app/src/Resource/Loader/http_loader.dart';
// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class NetworkChange extends StatefulWidget {
//   Widget child;
//   NetworkChange({Key? key, required this.child}) : super(key: key);

//   @override
//   createState() => NetworkChangeState();
// }

// class NetworkChangeState extends State<NetworkChange> {
//   bool timeOverHideTheWidget = false;
//   bool startUpdatingLayoutAccordingToStatus = false;
//   bool isAppLaunchesFirstTime = true;

//   late Connectivity connectivity;
//   late ConnectivityResult connectivityResult;

//   @override
//   void initState() {
//     super.initState();
//     connectivity = Connectivity();
//     initConnectivity();

//     // Subscribe to connectivity changes
//     connectivity.onConnectivityChanged
//         .listen((List<ConnectivityResult> results) {
//       updateConnectionStatus(results);
//     });

//     Timer(const Duration(seconds: 5), () {
//       isAppLaunchesFirstTime = false;
//       if (connectivityResult != ConnectivityResult.mobile &&
//           connectivityResult != ConnectivityResult.wifi) {
//         setState(() {});
//       }
//     });
//   }

//   Future<void> initConnectivity() async {
//     ConnectivityResult result;
//     try {
//       result = (await connectivity.checkConnectivity()) as ConnectivityResult;
//     } catch (e) {
//       result = ConnectivityResult.none;
//     }

//     if (!mounted) {
//       return Future.value(null);
//     }

//     setState(() {
//       connectivityResult = result;
//     });

//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       timeOverHideTheWidget = false;
//     }
//     startUpdatingLayoutAccordingToStatus = true;
//   }

//   void updateConnectionStatus(List<ConnectivityResult> results) {
//     // Handle the list of results
//     // You can check if any result indicates connectivity:
//     if (results.contains(ConnectivityResult.wifi) ||
//         results.contains(ConnectivityResult.mobile) ||
//         results.contains(ConnectivityResult.ethernet) ||
//         results.contains(ConnectivityResult.vpn)) {
//       timeOverHideTheWidget = false;
//       // Connected
//       startUpdatingLayoutAccordingToStatus = true;
//       setState(() {});
//     } else {
//       startUpdatingLayoutAccordingToStatus = true;
//       setState(() {});
//       // Not connected
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return HTTPLoader(
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           body: Column(
//             children: [
//               Expanded(child: widget.child),
//               if (connectivityResult != ConnectivityResult.mobile &&
//                   connectivityResult != ConnectivityResult.wifi) ...[
//                 _networkNotAvailable()
//               ] else ...[
//                 _networkAvailable()
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _networkAvailable() {
//     if (startUpdatingLayoutAccordingToStatus == false ||
//         isAppLaunchesFirstTime == true) {
//       return Container();
//     }

//     if (timeOverHideTheWidget == false) {
//       Timer(const Duration(seconds: 3), () {
//         if (mounted) {
//           setState(() {
//             timeOverHideTheWidget = true;
//           });
//         }
//       });
//     } else {
//       return Container();
//     }

//     return Container(
//       width: double.maxFinite,
//       height: 22,
//       color: Colors.green,
//       child: Center(
//         child: Text(
//           "Back online",
//           style: Theme.of(context)
//               .textTheme
//               .bodyText2!
//               .copyWith(color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Widget _networkNotAvailable() {
//     if (isAppLaunchesFirstTime == true) {
//       return Container();
//     }

//     return Container(
//       width: double.maxFinite,
//       height: 22,
//       color: Colors.black,
//       child: Center(
//         child: Text(
//           "No connection",
//           style: Theme.of(context)
//               .textTheme
//               .bodyText2!
//               .copyWith(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: must_be_immutable, must_call_super

import 'dart:async';
import 'package:ecom_app/src/Resource/Loader/http_loader.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChange extends StatefulWidget {
  Widget child;
  NetworkChange({Key? key, required this.child}) : super(key: key);

  @override
  createState() => NetworkChangeState();
}

class NetworkChangeState extends State<NetworkChange> {
  bool timeOverHideTheWidget = false;
  bool startUpdatingLayoutAccordingToStatus = false;
  bool isAppLaunchesFirstTime = true;

  final Connectivity connectivity = Connectivity();
  // Initialize with a default value instead of using late
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    // Subscribe to connectivity changes
    connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        // Take the first result as the primary connection
        updateConnectionStatus(results);
      }
    });

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          isAppLaunchesFirstTime = false;
          if (connectivityResult != ConnectivityResult.mobile &&
              connectivityResult != ConnectivityResult.wifi) {
            // Update UI for no connection
          }
        });
      }
    });
  }

  Future<void> initConnectivity() async {
    try {
      final results = await connectivity.checkConnectivity();
      if (!mounted) return;

      setState(() {
        // Take the first result if available, otherwise keep as none
        connectivityResult =
            results.isNotEmpty ? results.first : ConnectivityResult.none;
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          timeOverHideTheWidget = false;
        }
        startUpdatingLayoutAccordingToStatus = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        connectivityResult = ConnectivityResult.none;
        startUpdatingLayoutAccordingToStatus = true;
      });
    }
  }

  void updateConnectionStatus(List<ConnectivityResult> results) {
    if (!mounted) return;

    setState(() {
      connectivityResult = results.first; // Take the primary connection
      if (results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.vpn)) {
        timeOverHideTheWidget = false;
        startUpdatingLayoutAccordingToStatus = true;
      } else {
        startUpdatingLayoutAccordingToStatus = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HTTPLoader(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Column(
            children: [
              Expanded(child: widget.child),
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi) ...[
                _networkNotAvailable()
              ] else ...[
                _networkAvailable()
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _networkAvailable() {
    if (startUpdatingLayoutAccordingToStatus == false ||
        isAppLaunchesFirstTime == true) {
      return Container();
    }

    if (timeOverHideTheWidget == false) {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            timeOverHideTheWidget = true;
          });
        }
      });
    } else {
      return Container();
    }

    return Container(
      width: double.maxFinite,
      height: 22,
      color: Colors.green,
      child: Center(
        child: Text(
          "Back online",
          style: Theme.of(context)
              .textTheme
              .bodyMedium // Updated from bodyText2
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _networkNotAvailable() {
    if (isAppLaunchesFirstTime == true) {
      return Container();
    }

    return Container(
      width: double.maxFinite,
      height: 22,
      color: Colors.black,
      child: Center(
        child: Text(
          "No connection",
          style: Theme.of(context)
              .textTheme
              .bodyMedium // Updated from bodyText2
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
