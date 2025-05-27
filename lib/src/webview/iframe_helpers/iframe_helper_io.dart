import 'package:flutter/material.dart';
import 'package:teller_connect/teller_connect.dart';

abstract class TellerWebHelper {
  static void setup(
    TellerConfig tellerConfig, {
    void Function(TellerData data)? onSuccess,
    VoidCallback? onExit,
  }) {}

  static void open() {}

  static void destroy() {}
}
