# Adjust

Herald's Adjust module sends attribution events to Adjust. Adjust only gets the events you choose:
an event reaches Adjust only if it has a token from your Adjust dashboard. Purchases carry revenue, and ad
impressions go through Adjust's ad-revenue API.

| SDK | Package |
| --- | --- |
| Android | `io.github.mkhytarmkhoian:herald-adjust` |
| Flutter | [`herald_adjust`](https://pub.dev/packages/herald_adjust), over `adjust_sdk` |

## Setup

You build the `AdjustConfig`: environment, data residency, log level, attribution callbacks.
Herald's `start()` passes it to `initSdk`, so don't call `initSdk` yourself.

=== "Kotlin"

    ```kotlin
    --8<-- "samples/vendors/AdjustSetup.kt:provider"
    ```

=== "Dart"

    The Adjust plugin is static functions, so Herald's Flutter classes take no Adjust object.

    ```dart
    --8<-- "docs_samples/lib/vendors/adjust_setup.dart:provider"
    ```

## What reaches Adjust

| Herald | Adjust |
| --- | --- |
| an event with a token | `trackEvent(AdjustEvent(token))`, with parameters as callback parameters (text) |
| an event without a token | nothing |
| an `AdjustRevenueEvent` | the same tokened event, plus `setRevenue(revenue, currency)` and `setDeduplicationId` |
| an `AdjustAdRevenueEvent` | `trackAdRevenue(AdjustAdRevenue(source))`, no token needed |
| a property | `addGlobalCallbackParameter(name, value)`, sent with every later event |
| `identify` / `reset` | a `user_id` global callback parameter / removing it |
| `start` | `disable()`, then `initSdk(config)` |
| `setEnabled` | `enable()` / `disable()` |

## Factories and revenue types

| Factory | Handles |
| --- | --- |
| `TokenAdjustEventTrackerFactory(tokens, adjust)`; `(tokens)` on Flutter | events whose name has a token in the map |
| `RequireMappedAdjustEventTrackerFactory` | nothing: throws for any event that reaches it |
| `GenericAdjustPropertySetterFactory` | every property |

There is no generic event factory: an Adjust event without a token doesn't exist.

Revenue types, which your Adjust factory maps your events to (see [Revenue](../guides/revenue.md)):

- **`AdjustRevenueEvent`:** `revenue`, `currency`, and an optional `deduplicationId`. Send it with
  `RevenueEventTracker(revenueEvent, token, adjust)`, or `RevenueAdjustEventTracker(revenueEvent,
  token)` on Flutter; the factory passes the token, so the event needs no entry in
  `TokenAdjustEventTrackerFactory`.
- **`AdjustAdRevenueEvent`:** `source`, such as `applovin_max_sdk`; `revenue`; `currency`; and
  optional impression count, network, unit and placement. Send it with `AdRevenueEventTracker`, or
  `AdRevenueAdjustEventTracker` on Flutter.

## Consent

**A fresh install stays silent.** `start()` calls `disable()` *before* `initSdk()`, so a disabled
state is the SDK's starting state. The order matters: a `disable()` issued after `initSdk` loses
the race with the first session, which then reaches Adjust's servers.

Adjust persists its enabled flag, but `start()` sets it to disabled on every launch. So re-apply
the stored decision after start-up, as in [Consent](../guides/consent.md). Third-party sharing and
other granular consent is set on the Adjust SDK directly.

## Identity

`identify` writes the user id as the `user_id` global callback parameter; pass `identityParameter`
to `AdjustAnalyticsService` to use another key. It must match a callback parameter configured in
your Adjust dashboard. Don't give any property that name: it would overwrite the identity, and
`reset` would then remove the property.

## Watch out for

- **Callback parameters are text.** Typed values are flattened with `asString`.
- **On Flutter, Herald can't see Adjust's own failures.** The Adjust plugin doesn't wait for its
  native side, so an error there never reaches your error reporter.
- **Tokens are dashboard configuration,** keyed by event name, so a renamed event silently loses
  its token. Keep token maps next to the events they map.
