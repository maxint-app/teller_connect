import 'package:flutter/foundation.dart';
import 'package:teller_connect/src/webview/iframe_helpers/iframe_helper.dart';
import 'package:teller_connect/teller_connect.dart';

TellerConfig? tellerConfig;
bool get isInitialized => tellerConfig != null;

class Teller {
  static Future<void> initialize({
    required TellerConfig config,
  }) async {
    tellerConfig = config;
    if (kIsWeb) {
      setupTellerWeb();
    }
  }
}
