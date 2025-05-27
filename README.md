# Teller Connect for Flutter

Teller.io connect SDK for Flutter.

See [Sidecar documentation](https://blog.teller.io/blog/2023/10/19/sidecar/) and Teller first-party support for [React](https://github.com/tellerhq/teller-connect-react) and [other platforms](https://teller.io/docs/guides/connect#integrating-for-other-platforms) for instructions on how to integrate Teller Connect.


## Configurations

### Requirements
Fulfill 
- [`flutter_inappwebview` Requirements](https://pub.dev/packages/flutter_inappwebview#requirements)

### Web

Add following to your `web/index.html`'s `<head>` section

```html
<script defer type="application/javascript" src="/assets/packages/flutter_inappwebview_web/assets/web/web_support.js"></script>
<script defer type="application/javascript" src="https://cdn.teller.io/connect/connect.js"></script>
```

### Android

Follow [Android Setup](https://inappwebview.dev/docs/intro/#setup-android) to setup `flutter_inappwebview` for Android.

### iOS

Follow [iOS Setup](https://inappwebview.dev/docs/intro/#setup-ios) to setup `flutter_inappwebview` for iOS.

### macOS

Follow [macOS Setup](https://inappwebview.dev/docs/intro/#setup-macos) to setup `flutter_inappwebview` for macOS.


## Install

Add `teller_connect` via `pub`:

```bash
$ flutter pub add teller_connect
```


## Usage

```dart
import 'package:flutter/material.dart';
import 'package:teller_connect/teller_connect.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Teller Connect Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Teller Connect Demo'),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).push<TellerData>(
                MaterialPageRoute(
                  builder: (context) => const TellerConnect(
                    config: const TellerConfig(
                      appId: "your-app-id",
                      environment: TellerEnvironment.sandbox,
                    ),
                    onSuccess: (enrollment){
                      Navigator.pop(context, enrollment);
                    },
                    onError: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
              print(result);
            },
            child: const Text("Connect"),
          ),
        ),
      );
}
```

## Publisher

[Maxint.com](https://maxint.com)

## License

[MPL 2.0](/LICENSE)