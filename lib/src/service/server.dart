import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:alfred/alfred.dart';
import 'package:flutter/services.dart';
import 'package:teller_connect/teller_connect.dart';

typedef EnrollmentFn = FutureOr<void> Function(TellerData data);

abstract class TellerServerHandler {
  static Completer<String> _endpointCompleter = Completer();
  static HttpServer? _serverHandle;
  static bool _initialized = false;

  static Future<String> get endpointFuture => _endpointCompleter.future;

  static Future<void> setup({
    required TellerConfig config,
    bool isDark = false,
    EnrollmentFn? onToken,
    VoidCallback? onExit,
  }) async {
    if (_initialized) {
      throw Exception("Teller Server is already set up. Destroy it first");
    }

    final port = Random().nextInt(10000) + 10000;
    final app = Alfred();

    app.all(
      "*",
      cors(origin: "localhost"),
    );

    app.get("/teller", (req, res) async {
      res.headers.contentType = ContentType.html;
      final htmlContent = await rootBundle.loadString(
        "packages/teller_connect/assets/web/teller.html",
      );
      final envScript = '''
        <script>
          window.ENV = {
            isWebView: true,
            isDark: $isDark,
            teller: ${jsonEncode(config.toJsMap())},
          };
        </script>
      ''';
      final modifiedHtml = htmlContent.replaceFirst('</head>', '$envScript\n</head>');
      return modifiedHtml;
    });

    app.post("/token", (req, res) async {
      try {
        final rawBody = await req.body;
        final Map<String, dynamic> body = switch (rawBody) {
          String value => jsonDecode(value) as Map<String, dynamic>,
          Map value => value.map(
              (key, value) => MapEntry(key.toString(), value),
            ),
          _ => throw const FormatException('Invalid /token request payload'),
        };

        await onToken?.call(TellerData.fromJson(body));
        res.send("OK");
      } catch (e) {
        res.statusCode = HttpStatus.internalServerError;
        res.send(e.toString());
      }
    });

    app.delete("/teller", (req, res) {
      onExit?.call();
      res.send("OK");
    });

    final serverHandle = await app.listen(port);

    _initialized = true;
    _endpointCompleter.complete("http://localhost:$port/teller");
    _serverHandle = serverHandle;
  }

  static void destroy() {
    if (!_initialized) {
      throw Exception("Teller Server is not set up");
    }

    _serverHandle?.close(force: true);
    _initialized = false;
    _endpointCompleter = Completer();
  }
}
