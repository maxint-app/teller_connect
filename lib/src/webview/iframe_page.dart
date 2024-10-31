import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teller_connect/src/service/server.dart';
import 'package:teller_connect/src/teller.dart';
import 'package:teller_connect/src/webview/iframe_helpers/iframe_helper.dart';

class IframePage extends StatefulWidget {
  final VoidCallback? onExit;
  final EnrollmentFn? onEnrollment;

  const IframePage({
    super.key,
    this.onExit,
    this.onEnrollment,
  });

  @override
  State<IframePage> createState() => _IframePageState();
}

class _IframePageState extends State<IframePage> {
  List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    if (!isInitialized) {
      throw Exception(
        "Teller is not initialized\n"
        "Please call Teller.initialize() in main function before using Teller.",
      );
    }

    openTellerConnect();

    _subscriptions = [
      tellerSuccessStream.listen((data) {
        widget.onEnrollment?.call(data);
      }),
      tellerExitStream.listen((_) {
        widget.onExit?.call();
      }),
    ];
  }

  @override
  dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    closeTellerConnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
