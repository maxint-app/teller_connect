import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:alfred/alfred.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as html;
import 'package:teller_connect/src/models/teller_config.dart';

typedef TellerServerHandle = ({String endpoint, HttpServer serverHandle});
typedef TokenFn = ValueChanged<({String source, String token})>;

class Teller {
  static Future<TellerServerHandle> startServer({
    required TellerConfig tellerConfig,
    TokenFn? onToken,
    VoidCallback? onExit,
  }) async {
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
      final dom = html.parse(htmlContent);
      dom.head?.append(
        html.Element.html(
          """
            <script>
              window.ENV = {
                isWebView: true,
                teller: ${jsonEncode(tellerConfig.toJson())},
              };
            </script>
            """,
        ),
      );
      return dom.outerHtml;
    });

    app.post("/token", (req, res) async {
      final body = await req.bodyAsJsonMap;

      onToken?.call((source: body["source"], token: body["token"]));

      res.send("OK");
    });

    app.delete("/teller", (req, res) {
      onExit?.call();
      res.send("OK");
    });

    final serverHandle = await app.listen(port);

    return (
      endpoint: "http://localhost:$port/teller",
      serverHandle: serverHandle,
    );
  }
}
