# Custom markers

A marker is an interface that says what an event means. Herald ships two, `ScreenViewEvent` and
`UserProperty`, and nothing tied to a type of business. You can write your own, and it takes three
things:

- the marker interface;
- a tracker for each vendor that should treat it differently;
- a factory for it in that vendor's chain.

There are two good reasons to write one:

1. **A vendor has a special API for your concept.** Your app knows what a refund is, and GA4 has
   its own `refund` event.
2. **You want a rule the compiler enforces,** such as how event names are built.

## A marker a vendor API needs

=== "Kotlin"

    ```kotlin
    --8<-- "samples/guides/CustomMarkers.kt:marker"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/guides/custom_markers.dart:marker"
    ```

=== "Swift"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/CustomMarkers.swift:marker"
    ```

Only vendors that treat a refund specially need a tracker. Here GA4 gets its `refund` event, and
every other vendor still sends `ticket_refunded` through its generic factory.

=== "Kotlin"

    ```kotlin
    --8<-- "samples/guides/CustomMarkers.kt:marker-tracker"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/guides/custom_markers.dart:marker-tracker"
    ```

=== "Swift"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/CustomMarkers.swift:marker-tracker"
    ```

Put the factory before Herald's own factories in the Firebase chain, so yours is asked first.

A **parameter** says what a value *is*; a **marker** says what the event *means*. A `Double`
parameter named `amount` is just a number to a vendor module. `RefundEvent` is what tells the
Firebase module to call a different API.

## A marker for a naming rule

If every event name is built from where it happened, two modules can't end up using the same name,
because nobody types names by hand. No vendor asks for this, which is exactly why it belongs in your
app, not in Herald:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/guides/CustomMarkers.kt:structured"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/guides/custom_markers.dart:structured"
    ```

=== "Swift"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/CustomMarkers.swift:structured"
    ```

Because `name` is built for you, every vendor already gets the right name with no tracker at all:
the generic factories send `checkout_pay_button_tap`.

Write a tracker only when you want the parts sent *as separate parameters* instead of joined into
the name. That's where your app makes choices a library shouldn't make for it:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/guides/CustomMarkers.kt:structured-tracker"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/guides/custom_markers.dart:structured-tracker"
    ```

=== "Swift"

    ```swift
    --8<-- "Samples/Sources/Samples/Guides/CustomMarkers.swift:structured-tracker"
    ```

GA4 allows 25 parameters per event and 40 characters per name, and the lines marked above are where
your app trades one against the other. Choices like that are why this marker lives in your code,
not in Herald's core.

## A marker for list values

Herald's values are single values: text, whole numbers, decimals and true/false. There is no list,
because most vendors can't take one: Firebase and Adjust accept single values only. When a vendor
that can, such as Mixpanel or Amplitude, should receive a list, a marker carries it:

- **The marker,** for example `ListPropertiesEvent`, adds a map from name to list, such as
  `decks` to `["animals", "movies"]`. The lists stay out of `parameters`, so vendors that can't
  take them never see them.
- **A tracker for that vendor** sends the parameters and the lists together. It throws if a list
  has the same name as a parameter, so neither silently replaces the other.
- **Its factory** goes first in that vendor's chain.

Every other vendor sends the event through its generic factory, parameters only. The log provider
prints only `parameters` too, so in tests check the lists on the event itself, in
`FakeAnalyticsProvider.events`.

## Markers are yours, not the vendors'

A marker is your concept, in your words: `RefundEvent`, not a Firebase type. Your events never
implement a type from a vendor module.

The vendor modules do ship types in their vendor's terms, such as `AppsFlyerPurchaseEvent` and
`AmplitudeRevenueEvent`. They're final classes your events can't implement or extend: the vendor module's
trackers take them, and the vendor's factory maps your event to them. See [Revenue](revenue.md) and
[Events know no vendors](../philosophy.md#events-know-no-vendors).
