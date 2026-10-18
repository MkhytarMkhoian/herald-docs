# Kotlin Multiplatform notes

Shared code works the same as on Android. These are the places where it differs.

## Values and revenue events

Two things differ from Android, because of Kotlin limits:

- A property's value is `AnalyticsValues.string("dark")`, not `AnalyticsValue.String("dark")`.
- A revenue event is made by the function named after its class, with a small first letter. It has
  the same parameters and defaults as the Android constructor:

```kotlin
--8<-- "herald-kmp/sample/shared/src/commonMain/kotlin/io/github/mkhytarmkhoian/herald/sample/Store.kt"
```

## Names in Swift

herald-ios has types with the same names as herald-kmp's, so Swift sees the Kotlin ones with
"Kotlin" in front: `KotlinEvent`, `KotlinAmplitudeRevenueEvent` and so on.

## Labels

A [label](../../guides/custom-markers.md) is an interface your events implement. Checks in shared
Kotlin and on Android work as usual:

```kotlin
--8<-- "herald-kmp/sample/shared/src/commonMain/kotlin/io/github/mkhytarmkhoian/herald/sample/Profile.kt"
```

A factory written in Swift checks the Kotlin event:

```swift
--8<-- "herald-kmp/sample/iosApp/App/NoPersonalDataLogFactory.swift"
```

## Errors

Vendor failures go to the error reporter each app sets up: in Kotlin on Android, in Swift on iOS,
on `Herald` and on `HeraldBridge`. To report them through shared Kotlin code, call it from Swift's
reporter:

```swift
let report: AnalyticsErrorReporter = { failure in
    AnalyticsFailuresKt.reportAnalyticsFailure(message: "\(failure)")
}
```
