import 'package:example/collection/env.dart';
import 'package:flutter/material.dart';
import 'package:teller_connect/teller_connect.dart';

class ConnectBankPage extends StatelessWidget {
  const ConnectBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect Bank"),
      ),
      body: TellerConnect(
        config: const TellerConfig(
          appId: Env.tellerAppId,
          environment: TellerEnvironment.sandbox,
        ),
        onExit: () {
          // pop the page maybe?
          Navigator.of(context).pop();
        },
        onEnrollment: (token) {
          Navigator.of(context).pop(token.accessToken);
        },
      ),
    );
  }
}
