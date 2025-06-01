library teller_connect;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:teller_connect/src/browser/browser_page.dart';
import 'package:teller_connect/src/models/teller_config.dart';
import 'package:teller_connect/src/service/server.dart';
import 'package:teller_connect/src/utils/platform.dart';
import 'package:teller_connect/src/webview/iframe_page.dart';
import 'package:teller_connect/src/webview/webview_page.dart';


export 'package:flutter_inappwebview/flutter_inappwebview.dart';
export 'src/models/teller_config.dart';
export 'src/models/teller_data.dart';

class TellerConnect extends StatelessWidget {
  final VoidCallback? onExit;
  final EnrollmentFn? onEnrollment;
  final TellerConfig config;
  final WebViewEnvironment? webViewEnvironment;

  const TellerConnect({
    super.key,
    required this.config,
    this.onExit,
    this.onEnrollment,
    this.webViewEnvironment,
  });

  @override
  Widget build(context) {
    if (kIsWeb) {
      return IframePage(
        config: config,
        onExit: onExit,
        onEnrollment: onEnrollment,
      );
    }

    if (kIsLinux) {
      // Windows 10 1809
      return BrowserPage(
        config: config,
        onExit: onExit,
        onEnrollment: onEnrollment,
      );
    }

    return WebviewPage(
      config: config,
      onExit: onExit,
      onEnrollment: onEnrollment,
      webViewEnvironment: webViewEnvironment,
    );
  }
}
