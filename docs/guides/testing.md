# Testing

Analytics breaks quietly. A renamed parameter, or a double tap that sends an event twice, shows up
weeks later as a wrong number on a dashboard. Herald's testing module lets you check it in tests.
Add `herald-testing`, or `herald_testing` on Flutter:

=== "Kotlin"

    ```kotlin
    testImplementation("io.github.mkhytarmkhoian:herald-testing:1.1.0")
    ```

=== "Groovy"

    ```groovy
    testImplementation 'io.github.mkhytarmkhoian:herald-testing:1.1.0'
    ```

=== "Dart"

    ```bash
    flutter pub add dev:herald_testing
    ```

The examples on this page are real tests, run on every Herald build.

## FakeAnalyticsProvider

`FakeAnalyticsProvider` is a fake vendor that records every call instead of sending it. It
implements all five interfaces, so you register it with a real `Herald`, and the test runs through
the same setup you ship: your factories and your wrappers.

=== "Kotlin"

    ```kotlin
    --8<-- "samples/testing/CheckoutAnalyticsTest.kt:fake-provider"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/test/testing/checkout_analytics_test.dart:fake-provider"
    ```

- **`assertTracked` expects exactly one match.** A double tap that sends an event twice fails the
  test instead of passing quietly. Use `assertTrackedTimes` when a repeat is expected.
- **Parameters are checked by type.** `"3"` sent as text fails against `param("seats", 3)`,
  because vendors receive the two differently.
- **`assertNothingElseTracked()`** fails on any event no earlier assertion mentioned. That's what
  catches a duplicate, or an event sneaking in from another feature.
- **A failure prints everything that was recorded,** which usually explains it:

  ```text
  Expected an event named 'checkout_pay_tapped', but it was never tracked.

  Recorded:
    1. property plan = pro
    2. event    checkout_pay_pressed { plan = pro }
  ```

The other assertions are `assertNotTracked`, `assertNothingTracked`, `assertPropertySet` and
`assertIdentified`. On Android, assertions throw a plain `AssertionError`, so any test framework
works. On Flutter they throw a `TestFailure`, which `package:test` and `flutter_test` report like
any failed `expect`.

## Order between calls

`records` holds every call in order: events, properties, sign-in, consent and start-up. Use it
when the order matters, such as a property that must be set before the event that should carry it:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/testing/CheckoutAnalyticsTest.kt:order"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/test/testing/checkout_analytics_test.dart:order"
    ```

## A smaller fake for one interface

A class that only tracks events doesn't need a `Herald`:

=== "Kotlin"

    A lambda is the fake, with no extra dependency:

    ```kotlin
    --8<-- "samples/testing/CheckoutAnalyticsTest.kt:lambda"
    ```

=== "Dart"

    `FakeAnalyticsProvider` is every interface, so pass it to the class directly:

    ```dart
    --8<-- "docs_samples/test/testing/checkout_analytics_test.dart:single-capability"
    ```

Go through a real `Herald` when the test uses several interfaces or should run your factories.

## Testing a factory

A feature's factory takes an event and returns a `Resolution`, with nothing else involved, so you
can test it directly:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/testing/CheckoutAnalyticsTest.kt:factory"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/test/testing/checkout_analytics_test.dart:factory"
    ```

To assert what a tracker sends, mock the vendor SDK and verify the call. Build real events rather
than mocked ones.

## More examples on Flutter

These test a small view model:

```dart
--8<-- "docs_samples/test/testing/showcase_test.dart:app"
```

Values are compared by type, and `assertTracked` expects exactly one such event:

```dart
--8<-- "docs_samples/test/testing/showcase_test.dart:parameters"
```

```dart
--8<-- "docs_samples/test/testing/showcase_test.dart:counting"
```

For a property, the last value counts:

```dart
--8<-- "docs_samples/test/testing/showcase_test.dart:properties"
```

Sign-in and sign-out are recorded too:

```dart
--8<-- "docs_samples/test/testing/showcase_test.dart:identity"
```

For checks of your own, read the recorded events and properties:

```dart
--8<-- "docs_samples/test/testing/showcase_test.dart:custom-checks"
```

`clear()` forgets everything recorded so far, for tests with several steps:

```dart
--8<-- "docs_samples/test/testing/showcase_test.dart:clear"
```

!!! note "Kotlin"
    With MockK, never stub a getter that returns an `AnalyticsValue`. It's a value class, and such
    stubs fail at random, depending on the JVM's state.
