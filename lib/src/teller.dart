import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:teller_connect/src/webview/iframe_helpers/iframe_helper.dart';
import 'package:teller_connect/teller_connect.dart';

TellerConfig? tellerConfig;
bool get isInitialized => tellerConfig != null;
late WindowsDeviceInfo windowsInfo;

class Teller {
  static Future<void> initialize({
    required TellerConfig config,
  }) async {
    final deviceInfo = DeviceInfoPlugin();

    windowsInfo = await deviceInfo.windowsInfo;

    tellerConfig = config;
    if (kIsWeb) {
      setupTellerWeb();
    }
  }
}
