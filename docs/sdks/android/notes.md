# Android notes

Herald works the same on every platform. These are the places where Android differs.

## Kotlin

- **Calls are `suspend` functions.** Herald runs them on a coroutine dispatcher,
  `Dispatchers.Default` unless you choose another. Two calls from the same coroutine reach a vendor
  in the order you made them. See [Threads and order](../../getting-started/app-setup.md#threads-and-order).
- **Parameter values are `AnalyticsValue`s,** a sealed interface whose variants are `@JvmInline`
  value classes, so they cost no extra object.
- **`EventTrackerService` and `PropertyTrackerService` are `fun interface`s,** so a fake in a unit
  test can be a lambda. For factories and trackers in your app, the docs use named classes, which
  are easier to find and test.

## Providers

- **`Herald.Provider`** is a provider. Build them in place with `provider(...)`, or build them
  yourself and pass them with `providers(...)`, for example when DI collects them.
- **Two providers may share a name.** Herald doesn't refuse it, but a failure report can't tell
  them apart, so give each its own.

## Failures

- **The error reporter gets three arguments:** the provider's name, the `AnalyticsOperation` and
  the exception, such as `UnhandledEventException` for an event nobody mapped.
- **Cancelling the caller isn't an error.** If the coroutine that called Herald is cancelled, the
  cancellation carries on as usual and nothing is reported.

## R8 and ProGuard

Herald needs no keep rules of its own, and vendor SDKs bring their own. Herald's error messages
name classes, so in an obfuscated build they show obfuscated names; map them back with your mapping
file.
