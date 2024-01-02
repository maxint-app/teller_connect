// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'dart:js_util';

import 'package:teller_connect/src/models/teller_data.dart';
import 'package:teller_connect/src/teller.dart';
import 'package:teller_connect/src/webview/iframe_helpers/iframe_helper.dart';

void _onSuccess(String enrollment) {
  tellerSuccessStreamController
      .add(TellerData.fromJson(jsonDecode(enrollment)));
}

void _onExit() {
  tellerExitStreamController.add(null);
}

void setupTellerWeb() async {
  JsObject tellerObj = JsObject.jsify(<String, dynamic>{});

  tellerObj = setProperty(window, "teller", tellerObj);

  setProperty(tellerObj, "onSuccess", allowInterop(_onSuccess));
  setProperty(tellerObj, "onExit", allowInterop(_onExit));

  await context.callMethod(
    'setupTellerConnect',
    [JsObject.jsify(tellerConfig!.toJsMap())],
  );
}

Future<void> openTellerConnect() async {
  await context.callMethod('openTellerConnect', []);
}

Future<void> closeTellerConnect() async {
  await context.callMethod('closeTellerConnect', []);
}
