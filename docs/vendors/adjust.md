# Adjust

Herald's Adjust module sends attribution events to Adjust. Adjust only gets the events you choose:
an event reaches Adjust only if it has a token from your Adjust dashboard. Purchases carry revenue, and ad
impressions go through Adjust's ad-revenue API.

| SDK | Package |
| --- | --- |
| Android | `io.github.mkhytarmkhoian:herald-adjust` |
| Flutter | [`herald_adjust`](https://pub.dev/packages/herald_adjust), over `adjust_sdk` |
| iOS | [`herald-ios-adjust`](https://github.com/MkhytarMkhoian/herald-ios-adjust), module `HeraldAdjust`, over Adjust's iOS SDK |
| React Native | [`@herald-analytics/adjust`](https://www.npmjs.com/package/@herald-analytics/adjust), over `react-native-adjust` |

## Setup

You build the `AdjustConfig` (`ADJConfig` on iOS): environment, data residency, log level, attribution callbacks.
Herald's `start()` passes it to `initSdk`, so don't call `initSdk` yourself.

=== "Android"

    ```kotlin
    --8<-- "samples/vendors/AdjustSetup.kt:provider"
    ```

=== "iOS"

    Adjust's iOS SDK is static functions too, so Herald's iOS classes take no Adjust object. The
    service takes your `ADJConfig`.

    ```swift
    --8<-- "Samples/Sources/Samples/Vendors/AdjustSetup.swift:provider"
    ```

=== "Flutter"

    The Adjust plugin is static functions, so Herald's Flutter classes take no Adjust object.

    ```dart
    --8<-- "docs_samples/lib/vendors/adjust_setup.dart:provider"
    ```

=== "React Native"

    The Adjust package is static functions too, so Herald's React Native classes take no Adjust
    object. The service takes your `AdjustConfig`.

    ```ts
    --8<-- "docs-samples/src/vendors/adjust-setup.ts:provider"
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
| `TokenAdjustEventTrackerFactory(tokens, adjust)`; `(tokens)` on Flutter and React Native; `(tokens:)` on iOS | events of a type that has an `AdjustToken` in the list |
| `RequireMappedAdjustEventTrackerFactory` | nothing: throws for any event that reaches it |
| `GenericAdjustPropertySetterFactory` | every property |

There is no generic event factory: an Adjust event without a token doesn't exist.

Revenue types, which your Adjust factory maps your events to (see [Revenue](../guides/revenue.md)):

- **`AdjustRevenueEvent`:** `revenue`, `currency`, and an optional `deduplicationId`. Send it with
  `RevenueEventTracker(revenueEvent, token, adjust)`, or `RevenueAdjustEventTracker(revenueEvent,
  token)` on Flutter, iOS and React Native; the factory passes the token, so the event needs no entry in
  `TokenAdjustEventTrackerFactory`.
- **`AdjustAdRevenueEvent`:** `source`, such as `applovin_max_sdk`; `revenue`; `currency`; and
  optional impression count, network, unit and placement. Send it with `AdRevenueEventTracker`, or
  `AdRevenueAdjustEventTracker` on Flutter, iOS and React Native.

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
- **On Flutter and React Native, Herald can't see Adjust's own failures.** The Adjust package
  doesn't wait for its native side, so an error there never reaches your error reporter.
- **On iOS, an empty token or ad revenue source is reported.** Adjust itself would drop the event
  with only a log line, so Herald refuses it and tells your error reporter.
- **Each `AdjustToken` pairs a token with an event type, not a name,** so the compiler checks the
  list and a renamed event keeps its token. An event that extends the type uses its token too:

    | SDK | An `AdjustToken` |
    | --- | --- |
    | Android | `AdjustToken<SignUpCompleted>("abc123")` |
    | Flutter | `AdjustToken<SignUpCompleted>('abc123')` |
    | iOS | `AdjustToken(SignUpCompleted.self, "abc123")` |
    | React Native | `new AdjustToken(SignUpCompleted, 'abc123')` |
