import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:alfred/alfred.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as html;
import 'package:teller_connect/src/models/teller_data.dart';
import 'package:teller_connect/src/teller.dart';

typedef TellerServerHandle = ({String endpoint, HttpServer serverHandle});
typedef EnrollmentFn = ValueChanged<TellerData>;

Future<TellerServerHandle> startServer({
  EnrollmentFn? onToken,
  VoidCallback? onExit,
}) async {
  if (!isInitialized) {
    throw Exception(
      "Teller is not initialized\n"
      "Please call Teller.initialize() in main function before using Teller.",
    );
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
    final dom = html.parse(htmlContent);
    dom.head?.append(
      html.Element.html(
        """
            <script>
              window.ENV = {
                isWebView: true,
                teller: ${jsonEncode(tellerConfig!.toJsMap())},
              };
            </script>
            """,
      ),
    );
    return dom.outerHtml;
  });

  app.post("/token", (req, res) async {
    final body = jsonDecode(await req.body as String);

    onToken?.call(TellerData.fromJson(body));

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
