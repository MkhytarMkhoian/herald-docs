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
    <meta-data android:name="com.facebook.sdk.AutoLogMetaDataEnabled" android:value="false" />
    <meta-data android:name="com.facebook.sdk.AutoLogProductImprovementEnabled" android:value="false" />
    ```

=== "iOS"

    In `Info.plist`:

    ```xml
    <key>FacebookAutoLogAppEventsEnabled</key>
    <false/>
    <key>FacebookAdvertiserIDCollectionEnabled</key>
    <false/>
    <key>FBSDKAutoLogMetaDataEnabled</key>
    <false/>
    <key>FBSDKAutoLogProductImprovementEnabled</key>
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
    | `setEnabled(true)` / `setEnabled(false)` | automatic events, advertiser id collection, event details, product improvement data and auto init on, then `fullyInitialize()` / the same five off |

=== "iOS"

    | Herald | Meta |
    | --- | --- |
    | an event a factory handles | `AppEvents.shared.logEvent(name, parameters:)`, with numbers as numbers and true/false as text |
    | a `MetaPurchaseEvent` | `logPurchase(amount:currency:parameters:)`, sent as `fb_mobile_purchase` |
    | `identify` / `reset` | `AppEvents.shared.userID = userId` / `nil` |
    | `flush` | `flush()` |
    | `start` | nothing: Meta's SDK starts from your app delegate |
    | `setEnabled` | `isAutoLogAppEventsEnabled`, `isAdvertiserIDCollectionEnabled`, `isMetaDataCollectionEnabled` and `isAutoLogProductImprovementEnabled` on `Settings.shared` |

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
and app opens, and the advertiser id. On Android and iOS they also cover what Meta's SDK 19 adds:
the screen title and app link it adds to events, and its product improvement data. **They don't stop the events your app logs**: an event a
factory sends reaches Meta with or without consent.

Call `setEnabled` with the stored decision after start-up, on every launch, as for every vendor.

### Dropping your events too

To stop your events while consent is off, wrap the tracker in a small class of your own. It
remembers the answer `setEnabled` gives it, drops events while that answer is no, and passes the
answer on to Meta's own switch:

=== "Android"

    ```kotlin
    --8<-- "samples/vendors/MetaSetup.kt:gate-class"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Vendors/MetaSetup.swift:gate-class"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/vendors/meta_setup.dart:gate-class"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/vendors/meta-setup.ts:gate-class"
    ```

Register it as both the provider's `events` and its `consent`:

=== "Android"

    ```kotlin
    --8<-- "samples/vendors/MetaSetup.kt:gate"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Vendors/MetaSetup.swift:gate"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/vendors/meta_setup.dart:gate"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/vendors/meta-setup.ts:gate"
    ```

It starts with consent off, so nothing reaches Meta until the first `setEnabled(true)`.

Meta's other privacy settings, such as Limited Data Use (`setDataProcessingOptions`) and, on iOS,
`setAdvertiserTrackingEnabled`, are set on Meta's SDK directly.

## Watch out for

- **Meta's SDK 19 collects more by itself.** It adds the screen title and app link to the events it
  sends, and has a product improvement setting. On Android and iOS, `setEnabled` switches both, and
  the setup above turns them off for a fresh install. The Flutter and React Native plugins use
  Meta's SDK 18, which has neither. If a React Native app raises Android to Meta's SDK 19 with
  `facebookSdkVersion`, `setEnabled` can't reach them: add the two `AutoLog…` lines from the Android
  setup to `AndroidManifest.xml`.
- **Flutter on iOS: keep `FacebookAutoInitEnabled`.** If `Info.plist` sets it to `false`, the
  plugin refuses every call until the SDK is started, and each refusal reaches Herald's error
  reporter.
- **iOS: Meta's SDK 19.** `herald-ios-meta` needs Meta's iOS SDK 19. If Xcode refuses 19.0.0 with
  "does not match previously recorded value", the Mac has a record of the tag from before Meta fixed
  it: delete the `facebook-ios-sdk-…json` file in `~/Library/org.swift.swiftpm/security/fingerprints`.
