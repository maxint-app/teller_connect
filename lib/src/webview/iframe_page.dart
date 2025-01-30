import 'package:flutter/material.dart';
import 'package:teller_connect/src/service/server.dart';
import 'package:teller_connect/src/webview/iframe_helpers/iframe_helper.dart';
import 'package:teller_connect/teller_connect.dart';

class IframePage extends StatefulWidget {
  final VoidCallback? onExit;
  final EnrollmentFn? onEnrollment;
  final TellerConfig config;

  const IframePage({
    super.key,
    required this.config,
    this.onExit,
    this.onEnrollment,
  });

  @override
  State<IframePage> createState() => _IframePageState();
}

class _IframePageState extends State<IframePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        TellerWebHelper.setup(
          widget.config,
          onExit: widget.onExit,
          onSuccess: widget.onEnrollment,
        );
        TellerWebHelper.open();
      },
    );
  }

  @override
  dispose() {
    TellerWebHelper.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
