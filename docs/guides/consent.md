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
modules take care of that for you. The other three vendors collect by default, and their off
switch is a setting on the vendor object you create:

| Vendor | A fresh install collects? |
| --- | --- |
| Adjust | no: Herald calls `disable()` before `initSdk()` |
| AppsFlyer | no: Herald's `start()` only stops the SDK, which starts on consent |
| Firebase, Mixpanel, Amplitude | **yes**, until you turn it off |

Turn the other three off where you create them:

=== "Kotlin"

    | Vendor | Turn it off where |
    | --- | --- |
    | Firebase | `firebase_analytics_collection_enabled=false` in `AndroidManifest.xml` |
    | Mixpanel | `MixpanelOptions.Builder().optOutTrackingDefault(true)` |
    | Amplitude | `Configuration(apiKey, context, optOut = true)` |

=== "Dart"

    | Vendor | Turn it off where |
    | --- | --- |
    | Firebase | `firebase_analytics_collection_enabled=false` in `AndroidManifest.xml`, and `FIREBASE_ANALYTICS_COLLECTION_ENABLED` set to `false` in iOS's `Info.plist` |
    | Mixpanel | `Mixpanel.init(token, optOutTrackingDefault: true, ...)` |
    | Amplitude | `Configuration(apiKey: apiKey, optOut: true)` |

Herald can do it for Adjust and AppsFlyer because their switch is just a flag. For the others it
would do harm:

- Mixpanel's `optOutTracking()` deletes unflushed events and the stored identity, so calling it on
  every launch would throw away the last session of a user who had already agreed;
- Firebase reads its switch from the app's native settings before any Herald code runs.

## Recording the decision

Save the user's answer yourself, then apply it to every vendor. For example, from the ViewModel of
your privacy settings screen:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/guides/Consent.kt:record"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/guides/consent.dart:record"
    ```

## Re-applying it on every launch

Vendors differ in whether they remember the decision:

| Vendor | Remembers across launches? |
| --- | --- |
| Firebase, Mixpanel | yes |
| Adjust | yes, but Herald's `start()` turns it off again every launch |
| AppsFlyer, Amplitude | no |

So one rule works for all of them: **after `start()`, re-apply the stored decision.** Do
it right where you start Herald, as [Set up your app](../getting-started/app-setup.md#start-it)
shows:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/guides/Consent.kt:restore"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/guides/consent.dart:restore"
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
- Adjust's third-party sharing.

Herald's yes or no then works on top of it.
