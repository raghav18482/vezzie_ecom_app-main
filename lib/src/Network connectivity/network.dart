// // ignore_for_file: unused_field, unused_local_variable

// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// // ignore: constant_identifier_names
// enum NetworkState { CONNECTED, DISCONNECTED, UNKNOWN }

// class Network {
//   static var status = NetworkState.UNKNOWN;
//   static final Network _shared = Network();

//   Network({VoidCallback? onChange}) {
//     if (Network.status == NetworkState.UNKNOWN) {
//       Connectivity().checkConnectivity().then((ConnectivityResult result) {
//             if (result == ConnectivityResult.wifi ||
//                 result == ConnectivityResult.mobile) {
//               status = NetworkState.CONNECTED;
//             }
//           } as FutureOr Function(List<ConnectivityResult> value));
//     }

//     StreamSubscription<ConnectivityResult> subscription;

//     Connectivity connectivity = Connectivity();
//     subscription =
//         connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.mobile ||
//           result == ConnectivityResult.wifi) {
//         status = NetworkState.CONNECTED;
//       } else {
//         status = NetworkState.DISCONNECTED;
//       }

//       if (onChange != null) {
//         onChange();
//       }
//     } as void Function(List<ConnectivityResult> event)?)
//             as StreamSubscription<ConnectivityResult>;
//   }
// }
// import 'dart:async';
// import 'dart:developer' as developer;
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// enum NetworkState { CONNECTED, DISCONNECTED, UNKNOWN }

// class Network {
//   static var status = NetworkState.UNKNOWN;
//   static final Network _shared = Network._();
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//   List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

//   Network._() {
//     _initConnectivity();
//     _setupConnectivityStream();
//   }

//   factory Network({VoidCallback? onChange}) {
//     return _shared;
//   }

//   Future<void> _initConnectivity() async {
//     try {
//       _connectionStatus = await _connectivity.checkConnectivity();
//       _updateNetworkStatus(_connectionStatus);
//     } on PlatformException catch (e) {
//       developer.log('Couldn\'t check connectivity status', error: e);
//       status = NetworkState.UNKNOWN;
//     }
//   }

//   void _setupConnectivityStream() {
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   void _updateConnectionStatus(List<ConnectivityResult> results) {
//     _connectionStatus = results;
//     _updateNetworkStatus(results);
//   }

//   void _updateNetworkStatus(List<ConnectivityResult> results) {
//     if (results.contains(ConnectivityResult.mobile) ||
//         results.contains(ConnectivityResult.wifi) ||
//         results.contains(ConnectivityResult.ethernet) ||
//         results.contains(ConnectivityResult.vpn)) {
//       status = NetworkState.CONNECTED;
//     } else if (results.contains(ConnectivityResult.none)) {
//       status = NetworkState.DISCONNECTED;
//     } else {
//       status = NetworkState.UNKNOWN;
//     }
//     developer.log('Network status updated: $status');
//   }

//   void dispose() {
//     _connectivitySubscription.cancel();
//   }
// }
// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum NetworkState { CONNECTED, DISCONNECTED, UNKNOWN }

class Network {
  static NetworkState status = NetworkState.UNKNOWN;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  VoidCallback? _onChange;

  static final Network _instance = Network._internal();

  factory Network({VoidCallback? onChange}) {
    _instance._onChange = onChange;
    return _instance;
  }

  Network._internal() {
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      _connectionStatus = await _connectivity.checkConnectivity();
      _updateNetworkState(_connectionStatus);
    } on PlatformException catch (e) {
      developer.log('Could not check connectivity status', error: e);
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _connectionStatus = results;
    _updateNetworkState(results);
    if (_onChange != null) {
      _onChange!();
    }
  }

  void _updateNetworkState(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn)) {
      status = NetworkState.CONNECTED;
    } else if (results.contains(ConnectivityResult.none)) {
      status = NetworkState.DISCONNECTED;
    } else {
      status = NetworkState.UNKNOWN;
    }
    developer.log('Network status updated: $status');
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}
