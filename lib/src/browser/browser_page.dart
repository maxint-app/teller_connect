import 'package:flutter/material.dart';
import 'package:teller_connect/src/service/server.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BrowserPage extends StatefulWidget {
  final VoidCallback? onExit;
  final EnrollmentFn? onEnrollment;
  const BrowserPage({
    super.key,
    this.onExit,
    this.onEnrollment,
  });

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  TellerServerHandle? _serverHandle;

  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  Future<void> _asyncInitState() async {
    _serverHandle = await startServer(
      onToken: widget.onEnrollment,
      onExit: widget.onExit,
    );

    setState(() {});

    final endpoint = _serverHandle!.endpoint;

    await launchUrlString(endpoint);
  }

  @override
  void dispose() {
    _serverHandle?.serverHandle.close(force: true);
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
          if (_serverHandle != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isDark ? Colors.grey[850] : Colors.grey[200],
              ),
              child: Text(
                _serverHandle!.endpoint,
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
