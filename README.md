# Teller Connect for Flutter

Teller.io connect SDK for Flutter.

See [Sidecar documentation](https://github.com/maxint-app/teller_connect/blob/main/Sidecar%20Documentation%20-%20Slab.pdf) and Teller first-party support for [React](https://github.com/tellerhq/teller-connect-react) and [other platforms](https://teller.io/docs/guides/connect#integrating-for-other-platforms) for instructions on how to integrate Teller Connect.


## Configurations

### Requirements
Fulfill 
- [`flutter_inappwebview` Requirements](https://pub.dev/packages/flutter_inappwebview#requirements)
- [`webview_windows` Requirements](https://pub.dev/packages/webview_windows#target-platform-requirements)

### Web

Add following to your `web/index.html`'s `<head>` section

```html
<script src="/assets/packages/teller_connect/assets/web/teller.js"></script>
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
