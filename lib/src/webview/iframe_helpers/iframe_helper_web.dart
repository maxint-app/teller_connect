// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:js_interop';

import 'package:teller_connect/src/teller.dart';
import 'package:teller_connect/src/webview/iframe_helpers/iframe_helper.dart';
import 'package:teller_connect/teller_connect.dart';

@JS('TellerConnect')
extension type TellerConnect._(JSObject _) implements JSObject {
  external static TellerConnect setup(JSObject options);
  external void open(JSObject? params);
  external void destroy();
}

TellerConnect? _tellerConnect;

void setupTellerWeb() {
  if (!isInitialized) {
    throw Exception('Teller is not initialized');
  }

  _tellerConnect = TellerConnect.setup({
    ...tellerConfig!.toJsMap(),
    "onSuccess": (JSObject enrollment) {
      final data = jsonDecode(jsonEncode(enrollment.dartify()));
      tellerSuccessStreamController.add(TellerData.fromJson(data));
    }.toJS,
    "onExit": () {
      tellerExitStreamController.add(null);
    }.toJS,
  }.jsify() as JSObject);
}

void openTellerConnect() {
  if (_tellerConnect == null) {
    throw Exception('Teller Connect is not set up');
  }
  _tellerConnect!.open(null);
}

void closeTellerConnect() {
  if (_tellerConnect == null) {
    throw Exception('Teller Connect is not set up');
  }

  _tellerConnect!.destroy();
}
