import 'package:example/collection/env.dart';
import 'package:example/pages/connect_bank.dart';
import 'package:flutter/material.dart';
import 'package:teller_connect/teller_connect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Teller.initialize(
    config: const TellerConfig(
      appId: Env.tellerAppId,
      environment: TellerEnvironment.sandbox,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Let's connect a bank!",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Connect Bank"),
                    onPressed: () async {
                      final token = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConnectBankPage(),
                        ),
                      );

                      if (token != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Token: $token"),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
