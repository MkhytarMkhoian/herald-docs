# Meta

Herald's Meta module sends conversion events to Meta's App Events, for Meta's ads. Meta only gets
the events you choose: your conversions, under Meta's standard names such as
`fb_mobile_complete_registration`, and purchases as `fb_mobile_purchase`. It sends events only,
because Meta keeps no user attributes.

| SDK | Package |
| --- | --- |
| Android | `io.github.mkhytarmkhoian:herald-meta`, over Meta's Android SDK |
| Flutter | [`herald_meta`](https://pub.dev/packages/herald_meta), over `facebook_app_events` |
| iOS | [`herald-ios-meta`](https://github.com/MkhytarMkhoian/herald-ios-meta), module `HeraldMeta`, over Meta's iOS SDK |
| React Native | [`@herald-analytics/meta`](https://www.npmjs.com/package/@herald-analytics/meta), over `react-native-fbsdk-next` |

`facebook_app_events` and `react-native-fbsdk-next` are community packages over Meta's own SDKs:
Meta has no Flutter or React Native SDK.

## Setup

Set Meta's app id and client token as Meta's guide shows, and turn its automatic collection off,
so Meta collects nothing by itself before consent:

=== "Android"

    In `AndroidManifest.xml`:

    ```xml
    <meta-data android:name="com.facebook.sdk.AutoInitEnabled" android:value="false" />
    <meta-data android:name="com.facebook.sdk.AutoLogAppEventsEnabled" android:value="false" />
    <meta-data android:name="com.facebook.sdk.AdvertiserIDCollectionEnabled" android:value="false" />
    ```

=== "iOS"

    In `Info.plist`:

    ```xml
    <key>FacebookAutoLogAppEventsEnabled</key>
    <false/>
    <key>FacebookAdvertiserIDCollectionEnabled</key>
    <false/>
    ```

=== "Flutter"

    In both native projects: the Android lines in `android/app/src/main/AndroidManifest.xml`, and
    the iOS lines in `ios/Runner/Info.plist`.

    ```xml
    <meta-data android:name="com.facebook.sdk.AutoInitEnabled" android:value="false" />
    <meta-data android:name="com.facebook.sdk.AutoLogAppEventsEnabled" android:value="false" />
    <meta-data android:name="com.facebook.sdk.AdvertiserIDCollectionEnabled" android:value="false" />
    ```

    ```xml
    <key>FacebookAutoLogAppEventsEnabled</key>
    <false/>
    <key>FacebookAdvertiserIDCollectionEnabled</key>
    <false/>
    ```

=== "React Native"

    With Expo, the package's config plugin in `app.json` already turns them off: leave
    `isAutoInitEnabled`, `autoLogAppEventsEnabled` and `advertiserIDCollectionEnabled` out, or
    `false`.

    ```json
    ["react-native-fbsdk-next", { "appID": "YOUR_APP_ID", "clientToken": "YOUR_CLIENT_TOKEN" }]
    ```

    Without Expo, add the Android lines to `AndroidManifest.xml` and the iOS lines to `Info.plist`:

    ```xml
    <meta-data android:name="com.facebook.sdk.AutoInitEnabled" android:value="false" />
    <meta-data android:name="com.facebook.sdk.AutoLogAppEventsEnabled" android:value="false" />
    <meta-data android:name="com.facebook.sdk.AdvertiserIDCollectionEnabled" android:value="false" />
    ```

    ```xml
    <key>FacebookAutoLogAppEventsEnabled</key>
    <false/>
    <key>FacebookAdvertiserIDCollectionEnabled</key>
    <false/>
    ```

Then build the provider. It has no `properties`, because Meta keeps no user attributes, and no
generic factory at the end, so only the conversions a factory handles reach Meta:

=== "Android"

    ```kotlin
    --8<-- "samples/vendors/MetaSetup.kt:provider"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Vendors/MetaSetup.swift:provider"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/vendors/meta_setup.dart:provider"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/vendors/meta-setup.ts:provider"
    ```

## What reaches Meta

=== "Android"

    | Herald | Meta |
    | --- | --- |
    | an event a factory handles | `logEvent(name, bundle)`, with numbers as numbers and true/false as text |
    | a `MetaPurchaseEvent` | `logPurchase(amount, currency, bundle)`, sent as `fb_mobile_purchase` |
    | `identify` / `reset` | `AppEventsLogger.setUserID(userId)` / `clearUserID()` |
    | `flush` | `flush()` |
    | `start` | nothing: Meta's SDK starts itself |
    | `setEnabled(true)` / `setEnabled(false)` | automatic events, advertiser id collection and auto init on, then `fullyInitialize()` / the same three off |

=== "iOS"

    | Herald | Meta |
    | --- | --- |
    | an event a factory handles | `AppEvents.shared.logEvent(name, parameters:)`, with numbers as numbers and true/false as text |
    | a `MetaPurchaseEvent` | `logPurchase(amount:currency:parameters:)`, sent as `fb_mobile_purchase` |
    | `identify` / `reset` | `AppEvents.shared.userID = userId` / `nil` |
    | `flush` | `flush()` |
    | `start` | nothing: Meta's SDK starts from your app delegate |
    | `setEnabled` | `isAutoLogAppEventsEnabled` and `isAdvertiserIDCollectionEnabled` on `Settings.shared` |

=== "Flutter"

    | Herald | Meta |
    | --- | --- |
    | an event a factory handles | `logEvent(name:, parameters:)`, with numbers as numbers and true/false as text |
    | a `MetaPurchaseEvent` | `logPurchase(amount:, currency:, parameters:)`, sent as `fb_mobile_purchase` |
    | `identify` / `reset` | `setUserID(userId)` / `clearUserID()` |
    | `flush` | `flush()` |
    | `start` | nothing: the plugin starts Meta's SDK when the app launches |
    | `setEnabled(true)` / `setEnabled(false)` | `initializeSdk()`, then automatic events and advertiser id collection on / the same two off |

=== "React Native"

    | Herald | Meta |
    | --- | --- |
    | an event a factory handles | `AppEventsLogger.logEvent(name, parameters)`, with numbers as numbers and true/false as text |
    | a `MetaPurchaseEvent` | `logPurchase(amount, currency, parameters)`, sent as `fb_mobile_purchase` |
    | `identify` / `reset` | `setUserID(userId)` / `setUserID(null)` |
    | `flush` | `flush()` |
    | `start` | nothing: Meta's SDK starts when the app launches |
    | `setEnabled(true)` / `setEnabled(false)` | `Settings.initializeSDK()`, then automatic events and advertiser id collection on / the same two off |

## Your conversions

Most Meta events are your own conversions under Meta's standard names. Write a tracker and a
factory per event in the feature that owns it, as the
[factory chain](../concepts/factory-chain.md) describes. The names are in `AppEventsConstants` on
Android, `AppEvents.Name` on iOS, `FacebookAppEvents` on Flutter and `AppEventsLogger.AppEvents`
on React Native.

For a purchase, map your event to a `MetaPurchaseEvent` and send it with the purchase tracker:
`PurchaseEventTracker` on Android, `PurchaseMetaEventTracker` on the others. A conversion of your
own calls Meta directly, with `toMetaParameters()` for its parameters:

=== "Android"

    ```kotlin
    --8<-- "samples/vendors/MetaSetup.kt:conversions"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Vendors/MetaSetup.swift:conversions"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/vendors/meta_setup.dart:conversions"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/vendors/meta-setup.ts:conversions"
    ```

See [Revenue](../guides/revenue.md).

## Consent

`setEnabled` turns Meta's own switches on or off: the events Meta logs by itself, such as installs
and app opens, and the advertiser id. **They don't stop the events your app logs**: an event a
factory sends reaches Meta with or without consent.

Call `setEnabled` with the stored decision after start-up, on every launch, as for every vendor.

Meta's other privacy settings, such as Limited Data Use (`setDataProcessingOptions`) and, on iOS,
`setAdvertiserTrackingEnabled`, are set on Meta's SDK directly.

## Watch out for

- **Android: more event details from 31 October 2026.** Meta's Android SDK 19 adds the screen title
  and app link to the events it sends, and sends samples of your screens' layout. Turn them off in
  `AndroidManifest.xml` or in Events Manager, as
  [Meta's change log](https://github.com/facebook/facebook-android-sdk/blob/main/CHANGELOG.md)
  shows.
- **Flutter on iOS: keep `FacebookAutoInitEnabled`.** If `Info.plist` sets it to `false`, the
  plugin refuses every call until the SDK is started, and each refusal reaches Herald's error
  reporter.
- **iOS: Meta's SDK 18.** Meta's SDK 19 for iOS doesn't install through Swift Package Manager yet,
  so `herald-ios-meta` uses 18.
