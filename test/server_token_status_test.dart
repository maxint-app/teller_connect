import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:teller_connect/src/models/teller_config.dart';
import 'package:teller_connect/src/service/server.dart';

void main() {
  final config = const TellerConfig(
    appId: 'test_app',
    environment: TellerEnvironment.sandbox,
  );

  const payload = {
    'accessToken': 'access-token',
    'signatures': ['sig-1'],
    'user': {'id': 'user-1'},
    'enrollment': {
      'id': 'enroll-1',
      'institution': {'name': 'Test Bank'}
    },
  };

  tearDown(() {
    try {
      TellerServerHandler.destroy();
    } catch (_) {}
  });

  test('POST /token returns 200 when enrollment callback succeeds', () async {
    await TellerServerHandler.setup(
      config: config,
      onToken: (_) async {},
    );

    final endpoint = await TellerServerHandler.endpointFuture;
    final tokenUri = Uri.parse(endpoint.replaceFirst('/teller', '/token'));

    final client = HttpClient();
    try {
      final request = await client.postUrl(tokenUri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(payload));

      final response = await request.close();
      expect(response.statusCode, HttpStatus.ok);
    } finally {
      client.close(force: true);
    }
  });

  test('POST /token returns 500 when enrollment callback throws', () async {
    await TellerServerHandler.setup(
      config: config,
      onToken: (_) async {
        throw Exception('enrollment failed');
      },
    );

    final endpoint = await TellerServerHandler.endpointFuture;
    final tokenUri = Uri.parse(endpoint.replaceFirst('/teller', '/token'));

    final client = HttpClient();
    try {
      final request = await client.postUrl(tokenUri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(payload));

      final response = await request.close();
      final responseBody = await utf8.decodeStream(response);

      expect(response.statusCode, HttpStatus.internalServerError);
      expect(responseBody, contains('enrollment failed'));
    } finally {
      client.close(force: true);
    }
  });
}
