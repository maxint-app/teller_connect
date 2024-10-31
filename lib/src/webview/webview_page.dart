import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:teller_connect/src/service/server.dart';

class WebviewPage extends StatefulWidget {
  final VoidCallback? onExit;
  final EnrollmentFn? onEnrollment;

  const WebviewPage({
    super.key,
    this.onExit,
    this.onEnrollment,
  });

  @override
  State<WebviewPage> createState() => WebviewPageState();
}

class WebviewPageState extends State<WebviewPage> {
  Future<TellerServerHandle>? _urlRequest;
  final List<StreamSubscription> _subscriptions = [];
  HttpServer? _server;

  @override
  void initState() {
    super.initState();
    _urlRequest = startServer(
      // plaidConfig: widget.plaidConfig,
      onToken: widget.onEnrollment,
      onExit: widget.onExit,
    );
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _server?.close(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _urlRequest,
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

        _server = snapshot.data!.serverHandle;

        return InAppWebView(
          initialSettings: InAppWebViewSettings(
            isInspectable: false,
          ),
          initialUrlRequest: URLRequest(
            url: WebUri(snapshot.data!.endpoint),
          ),
        );
      },
    );
  }
}
