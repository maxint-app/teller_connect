import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:teller_connect/src/service/server.dart';
import 'package:teller_connect/src/models/teller_config.dart';

class WebviewPage extends StatefulWidget {
  final VoidCallback? onExit;
  final EnrollmentFn? onEnrollment;
  final TellerConfig config;
  final WebViewEnvironment? webViewEnvironment;

  const WebviewPage({
    super.key,
    this.onExit,
    this.onEnrollment,
    this.webViewEnvironment,
    required this.config,
  });

  @override
  State<WebviewPage> createState() => WebviewPageState();
}

class WebviewPageState extends State<WebviewPage> {
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    TellerServerHandler.setup(
      config: widget.config,
      onToken: widget.onEnrollment,
      onExit: widget.onExit,
    );
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    TellerServerHandler.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TellerServerHandler.endpointFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        return InAppWebView(
          initialSettings: InAppWebViewSettings(
            isInspectable: false,
          ),
          initialUrlRequest: URLRequest(
            url: WebUri(snapshot.data!),
          ),
          webViewEnvironment: widget.webViewEnvironment,
        );
      },
    );
  }
}
