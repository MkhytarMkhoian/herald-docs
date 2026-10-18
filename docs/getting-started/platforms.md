# Choose a platform

Herald works the same on every platform: the same events, factories, vendors and guides. What
differs is the language, how you install it, and the helpers around it.

| | Android | iOS | Flutter | React Native | Kotlin Multiplatform |
| --- | --- | --- | --- | --- | --- |
| Language | Kotlin | Swift | Dart | TypeScript | Kotlin, shared |
| Installed from | Maven Central | Swift Package Manager | pub.dev | npm | Maven Central |
| Needs | Android 6 (API 23) | iOS 15 | Flutter 3.47 | React Native 0.78, React 19 | the Android and iOS SDKs |
| Firebase, Adjust, Mixpanel, AppsFlyer, Amplitude, Meta | yes | yes | yes | yes | through the native SDKs |
| Log, for debug builds | yes | yes | yes | yes | through the native SDKs |
| Fake for tests | `herald-testing` | `HeraldTesting` | `herald_testing` | `@herald-analytics/testing` | — |
| Screen views and impressions from the UI | [Compose](../sdks/android/compose.md) | [SwiftUI](../sdks/ios/swiftui.md) | [Widgets](../sdks/flutter/widgets.md) | [React](../sdks/react-native/react.md) | the native helpers |
| API reference | [Dokka](../api/android/index.html) | [Swift Package Index](../sdks/ios/api.md) | [pub.dev](../sdks/flutter/api.md) | [TypeDoc](../api/react-native/index.html) | — |

## Which one?

- **A native app** uses its own platform's SDK.
- **A Flutter or React Native app** uses that SDK. Each one works over the vendors' Flutter or
  React Native packages, so it adds no native code of its own.
- **An app that shares Kotlin between Android and iOS** uses
  [Kotlin Multiplatform](../sdks/kmp/index.md) for its shared code: events and view models are
  written once, and each app sets Herald up with its native SDK.

Then follow the [quick start](quick-start/index.md) for your platform.
