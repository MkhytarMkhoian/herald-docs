# Capabilities

Herald splits analytics into five small interfaces, called capabilities. Each covers one job a
class might have, and a class asks only for the ones it uses.

| Interface | Methods | Typical caller |
| --- | --- | --- |
| `EventTrackerService` | `track(event)` | ViewModels, use cases, composables |
| `PropertyTrackerService` | `set(property)` | whatever learns the attribute: settings, purchase flow |
| `IdentifiableUserService` | `identify(identity)`, `reset()` | sign-in and sign-out |
| `AnalyticsLifecycleService` | `start()`, `flush()` | app start-up, going to background |
| `ConsentService` | `setEnabled(enabled)` | the privacy or consent screen |

In Kotlin they're `suspend` functions, and Herald runs the vendor calls off the main thread. In
Dart they return a `Future`. See [Threads](herald.md#threads).

## Ask only for what you use

=== "Kotlin"

    ```kotlin
    --8<-- "samples/concepts/Capabilities.kt:consumers"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/concepts/capabilities.dart:consumers"
    ```

=== "Swift"

    ```swift
    --8<-- "Samples/Sources/Samples/Concepts/Capabilities.swift:consumers"
    ```

A paywall that tracks events can't sign the user out or turn analytics off, and the consent screen
can't track anything. Each class's constructor shows exactly what it does with analytics, so a
reviewer sees it at a glance.

The split follows who calls what, and when:

- start-up runs once, when the app starts;
- consent can change at any moment, from a settings screen;
- identity changes at sign-in and sign-out.

With one big interface, every screen could restart every vendor.

## One object, five names

`Herald` implements all five. Your DI setup binds that one instance to each interface, so every
class gets the same `Herald`, seen through the interface it asked for. See
[Set up your app](../getting-started/app-setup.md#give-it-to-your-classes).

## A fake is a few lines

`EventTrackerService` and `PropertyTrackerService` have a single method, so a fake in a unit test
is tiny. In Kotlin they're `fun interface`s, so the fake is a lambda; in Dart it's a small class:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/concepts/Capabilities.kt:fake"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/concepts/capabilities.dart:fake"
    ```

=== "Swift"

    ```swift
    --8<-- "Samples/Sources/Samples/Concepts/Capabilities.swift:fake"
    ```

For tests that use several interfaces, or check the order of calls, use `FakeAnalyticsProvider`. See [Testing](../guides/testing.md).

## Next

[How Herald passes calls on](herald.md): what happens after a class calls `track`.
