# Kotlin Multiplatform

Herald for Kotlin Multiplatform lets you write your events once, in shared Kotlin, and track them
from shared view models. It wraps the two native SDKs, so each platform keeps its own setup and
vendors:

- on Android, the [Android SDK](../android/index.md): events from shared code *are* Android Herald
  events;
- on iOS, the [iOS SDK](../ios/index.md), through its `HeraldInterop` bridge.

[Changelog](../../changelog/kmp.md){ .md-button } [Source](https://github.com/MkhytarMkhoian/herald-kmp){ .md-button }

| herald-kmp | Android SDK | iOS SDK |
| --- | --- | --- |
| 1.0.0 | 1.2.0 | 1.1.0 |

Use it when your app shares Kotlin code between Android and iOS. A native app keeps using its own
SDK.

## Installation

In your shared module, add `herald-kmp-core`, and export it so Swift can use it:

```kotlin
kotlin {
    listOf(iosArm64(), iosSimulatorArm64()).forEach { target ->
        target.binaries.framework {
            baseName = "Shared"
            export("io.github.mkhytarmkhoian:herald-kmp-core:1.0.0")
        }
    }
    sourceSets {
        commonMain.dependencies {
            api("io.github.mkhytarmkhoian:herald-kmp-core:1.0.0")
        }
    }
}
```

| Module | What it is |
| --- | --- |
| `herald-kmp-core` | Events, properties and the five capabilities, for shared code. |
| `herald-kmp-amplitude` | Amplitude's revenue event. |
| `herald-kmp-adjust` | Adjust's revenue and ad revenue events. |
| `herald-kmp-appsflyer` | AppsFlyer's purchase, subscription and ad revenue events. |

Add a vendor's module only for its revenue events, and export it too. Every other event works with
the core alone.

## Shared code

Events and view models are the same Kotlin as on Android:

```kotlin
--8<-- "herald-kmp/sample/shared/src/commonMain/kotlin/io/github/mkhytarmkhoian/herald/sample/Checkout.kt"
```

Two things differ from Android, because of Kotlin limits:

- A property's value is `AnalyticsValues.string("dark")`, not `AnalyticsValue.String("dark")`.
- A revenue event is made by the function named after its class, with a small first letter. It has
  the same parameters and defaults as the Android constructor:

```kotlin
--8<-- "herald-kmp/sample/shared/src/commonMain/kotlin/io/github/mkhytarmkhoian/herald/sample/Store.kt"
```

## Android

Nothing extra. [Set Herald up](../../getting-started/app-setup.md) as in any Android app, and give
it to your shared code:

```kotlin
val herald = Herald {
    provider("amplitude", events = amplitudeTracker /* … */)
}
CheckoutViewModel(analytics = herald)
```

## iOS

1. In Xcode, add `herald-ios` with its `HeraldCore` and `HeraldInterop` modules, and your vendors'
   packages, as for any iOS app.
2. Copy two files into your app, once. They can't ship in a package, because they import your
   app's own shared framework.
3. [Set herald-ios up](../../getting-started/app-setup.md) as in any iOS app, then connect it to
   your shared code:

```swift
let herald = Herald(providers: [amplitudeProvider(amplitude)])
let bridge = HeraldBridge(herald, translate: revenueEvent, errorReporter: report)
let viewModel = CheckoutViewModel(analytics: IosAnalytics(bridge: HeraldKmpBridge(bridge)))
```

??? example "HeraldKmpBridge.swift: copy it as is"

    ```swift
    --8<-- "herald-kmp/sample/iosApp/App/HeraldKmpBridge.swift"
    ```

??? example "RevenueTranslation.swift: keep the blocks for your vendors"

    ```swift
    --8<-- "herald-kmp/sample/iosApp/App/RevenueTranslation.swift"
    ```

If `RevenueTranslation.swift` misses a revenue event, the bridge reports it to `errorReporter`
instead of letting the revenue disappear without a word.

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
