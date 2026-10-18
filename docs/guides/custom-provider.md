# Custom providers

A provider is anything that implements one or more of Herald's five interfaces. Herald's vendor
modules build theirs from factory chains, but a provider can be much simpler.

## Your own backend

To send events to your own collection endpoint, implement `EventTrackerService`:

=== "Android"

    ```kotlin
    --8<-- "samples/guides/CustomProvider.kt:backend"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/CustomProvider.swift:backend"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/guides/custom_provider.dart:backend"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/guides/custom-provider.ts:backend"
    ```

Register it like any vendor, with only the interfaces it implements. It's called with the others,
and its failures are caught and reported like theirs.

!!! note "iOS"
    Herald calls each provider on your thread and waits for it to return, so a provider must return
    quickly. Do slow work, such as this network request, in a `Task`, and report a failure there
    with `Herald.reportFailure`. Herald still knows which provider and call it belongs to. Don't
    report from a completion handler on another queue: Herald can't tell where that report came
    from.

## Wrapping a provider

`EventTrackerService` has a single method, so wrapping one takes a few lines. That's the place for
rules that depend on the situation rather than on the event: sampling, a runtime switch, skipping
repeated events, keeping personal data on the device.

=== "Android"

    ```kotlin
    --8<-- "samples/guides/CustomProvider.kt:decorators"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/CustomProvider.swift:decorators"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/guides/custom_provider.dart:decorators"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/guides/custom-provider.ts:decorators"
    ```

Then register the wrapped tracker instead of the original:

=== "Android"

    ```kotlin
    --8<-- "samples/guides/CustomProvider.kt:register"
    ```

=== "iOS"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/CustomProvider.swift:register"
    ```

=== "Flutter"

    ```dart
    --8<-- "docs_samples/lib/guides/custom_provider.dart:register"
    ```

=== "React Native"

    ```ts
    --8<-- "docs-samples/src/guides/custom-provider.ts:register"
    ```

Herald has no filtering or sampling of its own, on purpose. Wrappers can be combined, work with any
provider, and need nothing new from Herald.

## A full vendor module

For a vendor you'll use seriously, with its own types, consent and identity, write a module shaped
like Herald's own:

- factory interfaces, and composites that check the generic factory comes last;
- a generic factory and a required-mapping factory, like `GenericFirebaseEventTrackerFactory` and
  `RequireMappedFirebaseEventTrackerFactory`;
- one tracker per distinct vendor call;
- services for lifecycle, identity and consent.

Each SDK's checklist for a new vendor lists every piece:
[Android](https://github.com/MkhytarMkhoian/herald/blob/main/CONTRIBUTING.md#a-new-vendor-module),
[Flutter](https://github.com/MkhytarMkhoian/herald-flutter/blob/main/CONTRIBUTING.md#a-new-vendor-package),
[React Native](https://github.com/MkhytarMkhoian/herald-react-native/blob/main/CONTRIBUTING.md#a-new-vendor-package).
On iOS, copy one of the vendor packages, such as
[`herald-ios-mixpanel`](https://github.com/MkhytarMkhoian/herald-ios-mixpanel). They're written for
vendors added to Herald, but work the same for one that lives in your app.
