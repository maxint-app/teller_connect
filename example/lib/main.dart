import 'package:example/collection/env.dart';
import 'package:flutter/material.dart';
import 'package:teller_connect/teller_connect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: WebviewPage(
          plaidConfig: const PlaidConfig(
            token: Env.plaidLinkToken,
            env: PlaidEnvironment.sandbox,
          ),
          tellerConfig: const TellerConfig(
            appId: Env.tellerAppId,
            environment: TellerEnvironment.sandbox,
          ),
          onExit: () {
            // pop the page maybe?
            // Navigator.of(context).pop();
          },
          onToken: (token) {
            print(token);
          },
        ),
      ),
    );
  }
}
