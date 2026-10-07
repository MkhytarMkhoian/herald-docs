# Log

The log provider prints every call to your log, Logcat, Flutter's debug console or Xcode's console,
instead of
sending it anywhere. Use it in debug builds
to see exactly what your app reports, and in what order: events, properties, sign-in, consent and
start-up.

| SDK | Package |
| --- | --- |
| Android | `io.github.mkhytarmkhoian:herald-log` |
| Flutter | [`herald_log`](https://pub.dev/packages/herald_log) |
| iOS | [`herald-ios`](https://github.com/MkhytarMkhoian/herald-ios), module `HeraldLog` |

## Setup

It writes through `AnalyticsLogger`, so it depends on no logging library. On Android it's a
one-method interface; on Flutter and iOS it's a function type, so `debugPrint` or
`{ message in print(message) }` fits as-is. On iOS, Apple's `Logger` works too, and shows the lines
in the Console app as well:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/QuickStart.kt:herald"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/quick_start.dart:herald"
    ```

=== "Swift"

    ```swift
    --8<-- "Samples/Sources/Samples/QuickStart.swift:herald"
    ```

Register it only in debug builds, next to your real vendors; on iOS, inside `#if DEBUG`.

## Output

```text title="Logcat"
D/analytics: [herald] start
D/analytics: [herald] enabled true
D/analytics: [herald] user    demo-user
D/analytics: [herald] event   fare_selected
D/analytics:     ├─ fare     = 1 Day Pass
D/analytics:     ├─ price    = 5.0
D/analytics:     └─ ryder_id = Adult
D/analytics: [herald] prop    tickets_purchased = 2
D/analytics: [herald] reset
```

Flutter prints the same lines, without Logcat's prefix. Parameters are sorted by name and aligned. A screen view is headed by its screen name.

## Factories

The log provider has the same factories as a vendor module:

- `ScreenViewLogEventTrackerFactory`;
- `GenericLogEventTrackerFactory` and `GenericLogPropertySetterFactory`;
- `RequireMappedLogEventTrackerFactory` and `RequireMappedLogPropertySetterFactory`.

End its chain with `RequireMappedLogEventTrackerFactory`, and a debug build reports every event that
nobody mapped.

!!! warning "Debug builds only"
    The log prints the user id and every value as-is. That's the point in a debug build, and a
    leak in a release build.
