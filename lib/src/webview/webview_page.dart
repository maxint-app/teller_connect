import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:teller_connect/src/models/plaid_config.dart';
import 'package:teller_connect/src/models/teller_config.dart';
import 'package:teller_connect/src/teller.dart';
import 'package:teller_connect/src/utils/platform.dart';
import 'package:webview_windows/webview_windows.dart';

class WebviewPage extends StatefulWidget {
  final TellerConfig tellerConfig;
  final PlaidConfig plaidConfig;

  final VoidCallback? onExit;
  final TokenFn? onToken;

  const WebviewPage({
    super.key,
    required this.tellerConfig,
    required this.plaidConfig,
    this.onExit,
    this.onToken,
  });

  @override
  State<WebviewPage> createState() => WebviewPageState();
}

class WebviewPageState extends State<WebviewPage> {
  Future<TellerServerHandle>? _urlRequest;
  WebviewController? _controller;
  final List<StreamSubscription> _subscriptions = [];
  String? _windowsWebviewUrl;
  HttpServer? _server;

  @override
  void initState() {
    super.initState();
    _urlRequest = Teller.startServer(
      tellerConfig: widget.tellerConfig,
      // plaidConfig: widget.plaidConfig,
      onToken: widget.onToken,
      onExit: widget.onExit,
    );

    if (kIsWindows) {
      initializeWebview();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _server?.close(force: true);
    super.dispose();
  }

  void initializeWebview() async {
    _controller = WebviewController();

    await _controller!.initialize();
    await _controller!.openDevTools();

    _subscriptions.addAll([
      _controller!.url.listen((url) {
        _windowsWebviewUrl = url;
      }),
    ]);

    await _controller!.setBackgroundColor(Colors.transparent);
    await _controller!.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);

    if (!mounted) return;

    setState(() {});
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

        if (!snapshot.hasData ||
            (kIsWindows && !_controller!.value.isInitialized)) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (kIsWindows && _windowsWebviewUrl != snapshot.data!.endpoint) {
          _controller!.loadUrl(snapshot.data!.endpoint);
        }

        _server = snapshot.data!.serverHandle;

        if (kIsWindows) {
          return Webview(_controller!);
        }
        return InAppWebView(
          initialSettings: InAppWebViewSettings(
            isInspectable: kDebugMode,
          ),
          initialUrlRequest: URLRequest(
            url: WebUri(snapshot.data!.endpoint),
          ),
        );
      },
    );
  }
}
