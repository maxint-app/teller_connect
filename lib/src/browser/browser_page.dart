import 'package:flutter/material.dart';
import 'package:teller_connect/src/service/server.dart';
import 'package:teller_connect/teller_connect.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BrowserPage extends StatefulWidget {
  final VoidCallback? onExit;
  final EnrollmentFn? onEnrollment;
  final TellerConfig config;
  const BrowserPage({
    super.key,
    required this.config,
    this.onExit,
    this.onEnrollment,
  });

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  String? endpoint;

  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  Future<void> _asyncInitState() async {
    await TellerServerHandler.setup(
      config: widget.config,
      onToken: widget.onEnrollment,
      onExit: widget.onExit,
    );
    endpoint = await TellerServerHandler.endpointFuture;
    if (context.mounted) {
      setState(() {});
    }

    await launchUrlString(endpoint!);
  }

  @override
  void dispose() {
    TellerServerHandler.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You'll be redirected to your default browser."),
          if (endpoint != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isDark ? Colors.grey[850] : Colors.grey[200],
              ),
              child: Text(
                endpoint!,
                style: const TextStyle(color: Colors.blue),
              ),
            )
          else
            const CircularProgressIndicator.adaptive()
        ],
      ),
    );
  }
}
