# Firebase

Herald's Firebase module sends to Firebase Analytics (GA4). Firebase usually gets every event, with
typed parameters, and screen views arrive as GA4's own `screen_view` event.

| SDK | Package |
| --- | --- |
| Android | `io.github.mkhytarmkhoian:herald-firebase` |
| Flutter | [`herald_firebase`](https://pub.dev/packages/herald_firebase), over `firebase_analytics` |

## Setup

Firebase sets itself up from its config files: `google-services.json` on Android, and on Flutter
whatever `flutterfire configure` generated, once `Firebase.initializeApp()` has run. Herald takes the
`FirebaseAnalytics` instance and never changes its settings.

=== "Kotlin"

    ```kotlin
    --8<-- "samples/CompositionRoot.kt:firebase-provider"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/composition_root.dart:firebase-provider"
    ```

## What reaches Firebase

=== "Kotlin"

    | Herald | Firebase |
    | --- | --- |
    | an event | `logEvent(name, bundle)`: integers via `putLong`, reals via `putDouble`, text and booleans as strings |
    | a `ScreenViewEvent` | `logEvent("screen_view")` with `screen_name`, sent by `ScreenViewFirebaseEventTrackerFactory` |
    | a property, including a `UserProperty` | `setUserProperty(name, value)`, as text |
    | `identify` / `reset` | `setUserId(userId)` / `setUserId(null)` |
    | `setEnabled` | `setAnalyticsCollectionEnabled(enabled)` |
    | `start`, `flush` | nothing: Firebase starts and delivers on its own |

=== "Dart"

    | Herald | Firebase |
    | --- | --- |
    | an event | `logEvent(name:, parameters:)`: numbers as numbers, text and booleans as strings |
    | a `ScreenViewEvent` | `logScreenView(screenName: name, parameters:)`, sent by `ScreenViewFirebaseEventTrackerFactory`; a screen view with its own `screen_name` parameter is refused and reported |
    | a property, including a `UserProperty` | `setUserProperty(name:, value:)`, as text |
    | `identify` / `reset` | `setUserId(id: userId)` / `setUserId()` |
    | `setEnabled` | `setAnalyticsCollectionEnabled(enabled)` |
    | `start`, `flush` | nothing: Firebase starts and delivers on its own |

## Factories

| Factory | Handles |
| --- | --- |
| `ScreenViewFirebaseEventTrackerFactory` | every `ScreenViewEvent` |
| `GenericFirebaseEventTrackerFactory` | everything else; usually last in the chain |
| `RequireMappedFirebaseEventTrackerFactory` | nothing: throws for any event that reaches it |
| `GenericFirebasePropertySetterFactory`, `RequireMappedFirebasePropertySetterFactory` | the same, for properties |

To send one of GA4's [recommended events](https://developers.google.com/analytics/devguides/collection/ga4/reference/events)
(`purchase`, `refund`, `select_content`, …), either name your event after it with its parameters,
or write a tracker for it. See [Custom markers](../guides/custom-markers.md).

## Consent

**A fresh install collects** until your app says otherwise. Firebase's off switch is a native
setting, read before any Herald code runs. On Flutter, set it in both native projects:

```xml title="AndroidManifest.xml"
<meta-data android:name="firebase_analytics_collection_enabled" android:value="false" />
```

```xml title="ios/Runner/Info.plist (Flutter)"
<key>FIREBASE_ANALYTICS_COLLECTION_ENABLED</key>
<false/>
```

`setEnabled(true)` then turns collection on, and Firebase remembers the choice across launches.
Consent Mode (`setConsent`) is set on `FirebaseAnalytics` directly.

## Identity

To never send a user id to Firebase, pass `identificationEnabled = false` to
`FirebaseAnalyticsService` on Android. On Flutter, register the Firebase provider without
`identity`.

## Watch out for

- **GA4's limits.** GA4 truncates or drops data beyond them: 40-character event names, 25
  parameters per event, 100-character parameter values, and 24-character user property names with
  36-character values. Structured naming conventions hit these first.
- **Names GA4 keeps for itself.** GA4 reserves event names such as `app_remove` and prefixes such
  as `firebase_`, `google_` and `ga_`. Firebase drops an event that uses them; Herald doesn't.
