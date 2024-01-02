import 'package:flutter/material.dart';
import 'package:teller_connect/teller_connect.dart';

class ConnectBankPage extends StatelessWidget {
  const ConnectBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TellerConnect(
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
