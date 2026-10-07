# Mixpanel

Herald's Mixpanel module sends events to Mixpanel with typed properties. It covers both places
where Mixpanel keeps attributes:

- the **people profile**, which describes a person;
- **super properties**, which are sent with every event.

| SDK | Package |
| --- | --- |
| Android | `io.github.mkhytarmkhoian:herald-mixpanel` |
| Flutter | [`herald_mixpanel`](https://pub.dev/packages/herald_mixpanel), over `mixpanel_flutter` |
| iOS | [`herald-ios-mixpanel`](https://github.com/MkhytarMkhoian/herald-ios-mixpanel), module `HeraldMixpanel`, over `mixpanel-swift` |

## Setup

You create the `MixpanelAPI`, the `Mixpanel` on Flutter, or the `MixpanelInstance` on iOS: token, options, server URL for data
residency. Herald never changes them.

=== "Kotlin"

    ```kotlin
    --8<-- "samples/vendors/MixpanelSetup.kt:provider"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/vendors/mixpanel_setup.dart:provider"
    ```

=== "Swift"

    ```swift
    --8<-- "Samples/Sources/Samples/Vendors/MixpanelSetup.swift:provider"
    ```

## What reaches Mixpanel

=== "Kotlin"

    | Herald | Mixpanel |
    | --- | --- |
    | an event | `trackMap(name, properties)`, with each value as its own JSON type |
    | a `ScreenViewEvent` | `trackMap("screen_view")` with its name as `screen_name`, sent by `ScreenViewMixpanelEventTrackerFactory`; a screen view with its own `screen_name` parameter is refused and reported |
    | a `UserProperty` | `people.set(name, value)`: the person's profile |
    | any other property | a super property, sent with every later event |
    | `identify` / `reset` | `identify(userId, true)` / `reset()` |
    | `start` | nothing: set Mixpanel's logging on the `MixpanelAPI` yourself, as its docs describe |
    | `flush` | `flush()` |
    | `setEnabled(true)` / `setEnabled(false)` | `optInTracking()` / `flush()` then `optOutTracking()` |

=== "Dart"

    | Herald | Mixpanel |
    | --- | --- |
    | an event | `track(name, properties:)`, with each value as its own JSON type |
    | a `ScreenViewEvent` | `track('screen_view')` with its name as `screen_name`, sent by `ScreenViewMixpanelEventTrackerFactory`; a screen view with its own `screen_name` parameter is refused and reported |
    | a `UserProperty` | `getPeople().set(name, value)`: the person's profile |
    | any other property | `registerSuperProperties`: sent with every later event |
    | `identify` / `reset` | `identify(userId)` / `reset()` |
    | `start` | nothing: turn on Mixpanel's logging yourself, as its docs describe |
    | `flush` | `flush()` |
    | `setEnabled(true)` / `setEnabled(false)` | `optInTracking()` / `flush()` then `optOutTracking()` |

=== "Swift"

    | Herald | Mixpanel |
    | --- | --- |
    | an event | `track(event:properties:)`, with each value as its own type |
    | a `ScreenViewEvent` | `track(event: "screen_view")` with its name as `screen_name`, sent by `ScreenViewMixpanelEventTrackerFactory`; a screen view with its own `screen_name` parameter is refused and reported |
    | a `UserProperty` | `people.set(property:to:)`: the person's profile |
    | any other property | `registerSuperProperties`: sent with every later event |
    | `identify` / `reset` | `identify(distinctId: userId)` / `reset()` |
    | `start` | nothing: turn on Mixpanel's logging yourself, as its docs describe |
    | `flush` | `flush()` |
    | `setEnabled(true)` / `setEnabled(false)` | `optInTracking()` / `flush()` then `optOutTracking()` |

## Factories

| Factory | Handles |
| --- | --- |
| `ScreenViewMixpanelEventTrackerFactory` | every `ScreenViewEvent`, as one `screen_view` event broken down by screen |
| `GenericMixpanelEventTrackerFactory` | everything else; usually last in the chain |
| `UserPropertyMixpanelPropertySetterFactory` | every `UserProperty` |
| `GenericMixpanelPropertySetterFactory` | every property, as a super property |
| `RequireMappedMixpanelEventTrackerFactory`, `RequireMappedMixpanelPropertySetterFactory` | nothing: throws for anything that reaches it |

!!! warning "Order the property chain"
    `UserPropertyMixpanelPropertySetterFactory` must come **before** the generic setter. A
    `UserProperty` is also a `Property`, so the generic setter would take it first, and the
    profile would never be written. A `UserProperty` goes to the profile only. To put a value in
    both places, write a factory that answers with both setters.

## Consent

**A fresh install collects** unless Mixpanel is created opted out:
`MixpanelOptions.Builder().optOutTrackingDefault(true)` on Android,
`Mixpanel.init(token, optOutTrackingDefault: true, ...)` on Flutter, or
`Mixpanel.initialize(token:trackAutomaticEvents:optOutTrackingByDefault: true)` on iOS.

Herald can't opt out for you in `start()`. `optOutTracking()` deletes events not yet sent and the
stored user, so calling it on every launch would throw away the previous session and forget a user
who had already agreed. Once the user agrees, Mixpanel remembers it. On iOS, opting out also
deletes the identified user's People profile in Mixpanel: that's Mixpanel's own behaviour.

## Identity

To never identify users in Mixpanel, register the Mixpanel provider without `identity`.

## Watch out for

- **Mixpanel bills per event.** Screen views and high-frequency events add up. Drop what you don't
  need in Mixpanel's chain; [Routing](../guides/routing.md) shows how. [Moove](https://github.com/MkhytarMkhoian/Moove)
  drops screen views for Mixpanel entirely.
