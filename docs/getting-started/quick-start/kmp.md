# Quick start: Kotlin Multiplatform

Herald for Kotlin Multiplatform lets you write events once, in shared Kotlin, and track them from
shared view models. It runs on top of the native SDKs, so each app sets Herald up as a native app
does, then gives it to the shared code.

## 1. Add the core to your shared module

Add `herald-kmp-core`, and export it so Swift can use it:

```kotlin
kotlin {
    listOf(iosArm64(), iosSimulatorArm64()).forEach { target ->
        target.binaries.framework {
            baseName = "Shared"
            export("io.github.mkhytarmkhoian:herald-kmp-core:1.1.0")
        }
    }
    sourceSets {
        commonMain.dependencies {
            api("io.github.mkhytarmkhoian:herald-kmp-core:1.1.0")
        }
    }
}
```

## 2. Write your events in shared code

Events and view models are the same Kotlin as on Android:

```kotlin
--8<-- "herald-kmp/sample/shared/src/commonMain/kotlin/io/github/mkhytarmkhoian/herald/sample/Checkout.kt"
```

## 3. Set Herald up in each app

- **Android:** create Herald as in the [Android quick start](android.md#2-create-herald), and pass
  it to your shared view models.
- **iOS:** create Herald as in the [iOS quick start](ios.md#2-create-herald), then connect it to
  your shared code through `HeraldInterop`, as the
  [Kotlin Multiplatform page](../../sdks/kmp/index.md#ios) shows.

Each app's log then shows the events your shared code tracked.

## Next

- [Kotlin Multiplatform](../../sdks/kmp/index.md): the modules, and the iOS bridge in full.
- [Platform notes](../../sdks/kmp/notes.md): where shared Kotlin differs from Android.
- [Set up your app](../app-setup.md): several services, error reporting and dependency injection.
