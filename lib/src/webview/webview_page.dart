import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:teller_connect/src/service/server.dart';
import 'package:teller_connect/src/utils/platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_windows/webview_windows.dart';

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
  WebviewController? _controller;
  final List<StreamSubscription> _subscriptions = [];
  String? _windowsWebviewUrl;
  HttpServer? _server;

  @override
  void initState() {
    super.initState();
    _urlRequest = startServer(
      // plaidConfig: widget.plaidConfig,
      onToken: widget.onEnrollment,
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
    final webviewVersion = await WebviewController.getWebViewVersion();

    if (webviewVersion == null && mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Failed to initialize webview'),
          content: const Text(
            'Could not find a compatible webview. '
            'Please install Microsoft Edge WebView2 Runtime.\n'
            'After installation, restart the app.',
          ),
          actions: [
            FilledButton.icon(
              onPressed: () async {
                await launchUrlString(
                  "https://developer.microsoft.com/en-us/microsoft-edge/webview2/",
                );
                widget.onExit?.call();
              },
              icon: const Icon(Icons.download),
              label: const Text('Install Edge WebView2 Runtime'),
            ),
          ],
        ),
      );
      return;
    }

    _controller = WebviewController();

    await _controller!.initialize();

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
            (kIsWindows && _controller?.value.isInitialized != true)) {
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
