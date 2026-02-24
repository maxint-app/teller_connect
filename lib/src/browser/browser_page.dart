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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You'll be redirected to your default browser.",
              style: TextStyle(color: colorScheme.onSurface),
            ),
            if (endpoint != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.surfaceContainer,
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Text(
                  endpoint!,
                  style: TextStyle(color: colorScheme.primary),
                ),
              )
            else
              const CircularProgressIndicator.adaptive()
          ],
        ),
      ),
    );
  }
}
