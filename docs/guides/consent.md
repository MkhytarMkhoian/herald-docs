# Consent

In Herald, consent is a single yes or no: may this app collect analytics? `ConsentService` turns
every vendor on or off together.

It's a single yes or no on purpose, because that's the only consent switch every vendor has.
Anything more detailed looks different for each vendor, so you set it on the vendor SDK yourself:

- Firebase Consent Mode is a map of four keys;
- Adjust's third-party sharing is keyed by partner;
- AppsFlyer's DMA consent is its own object;
- Mixpanel has none at all.

## Before consent arrives

A fresh install shouldn't collect anything before the user answers. Herald's Adjust and AppsFlyer
modules take care of that for you. Firebase, Mixpanel and Amplitude collect by default, and their
off switch is a setting on the vendor object you create. Meta's switch is in your app's native
settings, and covers only the events Meta logs by itself:

| Vendor | A fresh install collects? |
| --- | --- |
| Adjust | no: Herald calls `disable()` before `initSdk()` |
| AppsFlyer | no: Herald's `start()` only stops the SDK, which starts on consent |
| Meta | its own events, such as installs, **yes**, until you turn them off. Events your app sends always reach it: Meta has no switch for them |
| Firebase, Mixpanel, Amplitude | **yes**, until you turn it off |

Turn the others off where you create them:

=== "Android"

    | Vendor | Turn it off where |
    | --- | --- |
    | Firebase | `firebase_analytics_collection_enabled=false` in `AndroidManifest.xml` |
    | Mixpanel | `MixpanelOptions.Builder().optOutTrackingDefault(true)` |
    | Amplitude | `Configuration(apiKey, context, optOut = true)` |
    | Meta | `AutoInitEnabled`, `AutoLogAppEventsEnabled` and `AdvertiserIDCollectionEnabled` set to `false` in `AndroidManifest.xml`, as [Meta](../vendors/meta.md#setup) shows |

=== "iOS"

    | Vendor | Turn it off where |
    | --- | --- |
    | Firebase | `FIREBASE_ANALYTICS_COLLECTION_ENABLED` set to `NO` in `Info.plist` |
    | Mixpanel | `Mixpanel.initialize(token:trackAutomaticEvents:optOutTrackingByDefault: true)` |
    | Amplitude | `Configuration(apiKey: apiKey, optOut: true)` |
    | Meta | `FacebookAutoLogAppEventsEnabled` and `FacebookAdvertiserIDCollectionEnabled` set to `NO` in `Info.plist`, as [Meta](../vendors/meta.md#setup) shows |

=== "Flutter"

    | Vendor | Turn it off where |
    | --- | --- |
    | Firebase | `firebase_analytics_collection_enabled=false` in `AndroidManifest.xml`, and `FIREBASE_ANALYTICS_COLLECTION_ENABLED` set to `false` in iOS's `Info.plist` |
    | Mixpanel | `Mixpanel.init(token, optOutTrackingDefault: true, ...)` |
    | Amplitude | `Configuration(apiKey: apiKey, optOut: true)` |
    | Meta | in `AndroidManifest.xml` and iOS's `Info.plist`, as [Meta](../vendors/meta.md#setup) shows |

=== "React Native"

    | Vendor | Turn it off where |
    | --- | --- |
    | Firebase | `"analytics_auto_collection_enabled": false` in `firebase.json` |
    | Mixpanel | `Mixpanel.init(token, trackAutomaticEvents, true)` |
    | Amplitude | `amplitude.init(apiKey, undefined, { optOut: true })` |
    | Meta | the `react-native-fbsdk-next` Expo config plugin, which turns it off by default, or the native settings, as [Meta](../vendors/meta.md#setup) shows |

Herald can do it for Adjust and AppsFlyer because their switch is just a flag. For the others it
would do harm:

- Mixpanel's `optOutTracking()` deletes unflushed events and the stored identity, so calling it on
  every launch would throw away the last session of a user who had already agreed. On iOS it also
  deletes the identified user's People profile;
- Firebase and Meta read their switches from the app's native settings before any Herald code
  runs.

## Recording the decision

Save the user's answer yourself, then apply it to every vendor. For example, from the ViewModel of
your privacy settings screen:

=== "Android"

    ```kotlin
    --8<-- "samples/guides/Consent.kt:record"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/Consent.swift:record"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/guides/consent.dart:record"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/guides/consent.ts:record"
    ```

## Re-applying it on every launch

Vendors differ in whether they remember the decision:

| Vendor | Remembers across launches? |
| --- | --- |
| Firebase, Mixpanel, Meta | yes |
| Adjust | yes, but Herald's `start()` turns it off again every launch |
| AppsFlyer, Amplitude | no |

So one rule works for all of them: **after `start()`, re-apply the stored decision.** Do
it right where you start Herald, as [Set up your app](../getting-started/app-setup.md#start-it)
shows:

=== "Android"

    ```kotlin
    --8<-- "samples/guides/Consent.kt:restore"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/Consent.swift:restore"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/guides/consent.dart:restore"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/guides/consent.ts:restore"
    ```

For AppsFlyer this is also the moment it actually starts. With consent stored, `setEnabled(true)`
resumes the SDK and sends the launch.

## Revoking

`setEnabled(false)` stops every vendor. Two details:

- **Mixpanel** flushes what it has queued, then opts out.
- **Amplitude** stops accepting new events. Events recorded before the revoke, while consent was
  given, may still upload.

## Granular consent

Set it on the vendor objects, next to their other configuration:

- Firebase `setConsent`;
- AppsFlyer `setConsentData` and `anonymizeUser`;
- Meta's Limited Data Use, `setDataProcessingOptions`;
- Adjust's third-party sharing.

Herald's yes or no then works on top of it.
