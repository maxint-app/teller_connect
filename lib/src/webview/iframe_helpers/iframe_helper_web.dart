// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:teller_connect/teller_connect.dart';

@JS('TellerConnect')
extension type TellerConnect._(JSObject _) implements JSObject {
  external static TellerConnect setup(JSObject options);
  external void open(JSObject? params);
  external void close();
  external void destroy();
}

abstract class TellerWebHelper {
  static bool _initialized = false;
  static TellerConnect? _tellerConnect;

  static setup(
    TellerConfig tellerConfig, {
    void Function(TellerData data)? onSuccess,
    VoidCallback? onExit,
  }) {
    if (_initialized) {
      throw Exception('Teller Web is already set up. Destroy it first');
    }

    _tellerConnect = TellerConnect.setup({
      ...tellerConfig.toJsMap(),
      "onSuccess": (JSObject enrollment) {
        final data = jsonDecode(jsonEncode(enrollment.dartify()));
        onSuccess?.call(TellerData.fromJson(data));
      }.toJS,
      "onExit": () {
        onExit?.call();
      }.toJS,
    }.jsify() as JSObject);

    _initialized = true;
  }

  static void open() {
    if (!_initialized) {
      throw Exception('Teller Web is not set up');
    }

    _tellerConnect!.open(null);
  }

  static void destroy() {
    if (!_initialized) {
      throw Exception('Teller Web is not set up');
    }

    _tellerConnect!.destroy();
    _initialized = false;
  }
}
