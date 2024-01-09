library teller_connect;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teller_connect/src/browser/browser_page.dart';
import 'package:teller_connect/src/service/server.dart';
import 'package:teller_connect/src/teller.dart';
import 'package:teller_connect/src/utils/platform.dart';
import 'package:teller_connect/src/webview/iframe_page.dart';
import 'package:teller_connect/src/webview/webview_page.dart';

export 'src/models/plaid_config.dart';
export 'src/models/teller_config.dart';
export 'src/models/teller_data.dart';
export 'src/teller.dart' show Teller;

class TellerConnect extends StatelessWidget {
  final VoidCallback? onExit;
  final EnrollmentFn? onEnrollment;

  const TellerConnect({
    super.key,
    this.onExit,
    this.onEnrollment,
  });

  @override
  Widget build(context) {
    if (kIsWeb) {
      return IframePage(
        onExit: onExit,
        onEnrollment: onEnrollment,
      );
    }

    if (kIsLinux || (windowsInfo != null && windowsInfo!.buildNumber < 17763)) { // Windows 10 1809 
      return BrowserPage(
        onExit: onExit,
        onEnrollment: onEnrollment,
      );
    }

    return WebviewPage(
      onExit: onExit,
      onEnrollment: onEnrollment,
    );
  }
}
