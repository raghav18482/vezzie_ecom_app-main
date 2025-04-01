// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:action_broadcast/action_broadcast.dart';

import '../const/const.dart';
import 'loader.dart';

class HTTPLoader extends StatefulWidget {
  Widget child;

  HTTPLoader({Key? key, required this.child}) : super(key: key);

  @override
  createState() => _HTTPLoaderState();
}

class _HTTPLoaderState extends State<HTTPLoader> with AutoCancelStreamMixin {
 
  final ValueNotifier<bool> _showLoader = ValueNotifier<bool>(false);

  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver([Const.showLoader, Const.hideLoader])
        .listen((intent) {
      switch (intent.action) {
        case Const.showLoader:
      

          _showLoader.value = true;

          break;
        case Const.hideLoader:
          _showLoader.value = false;

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          widget.child,
          ValueListenableBuilder(
            valueListenable: _showLoader,
            builder: (context, value, child) {
              return Visibility(
                  visible: _showLoader.value, child: const Loader());
            },
          )
        ],
      ),
    );
  }
}
