# Quick start

On this page you send your first event and see it in your app's log. You don't need an account
with any analytics service yet: you start with Herald's log module, which prints each event instead
of sending it. At the end you add Firebase.

Add the core library and the log module. The [Android SDK](../sdks/android/index.md) and
[Flutter SDK](../sdks/flutter/index.md) pages list all the modules.

=== "Kotlin"

    ```kotlin
    dependencies {
        implementation("io.github.mkhytarmkhoian:herald-core:1.1.0")
        implementation("io.github.mkhytarmkhoian:herald-log:1.1.0")
    }
    ```

=== "Groovy"

    ```groovy
    dependencies {
        implementation 'io.github.mkhytarmkhoian:herald-core:1.1.0'
        implementation 'io.github.mkhytarmkhoian:herald-log:1.1.0'
    }
    ```

=== "Dart"

    ```bash
    flutter pub add herald herald_log
    ```

## 1. Describe what happened

An event is a small class in your app. It has a name, and parameters that describe what happened:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/QuickStart.kt:event"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/quick_start.dart:event"
    ```

Parameters keep their type. `seats` reaches every service as the number 3, not as the text `"3"`,
so you can still sum and filter by it there.

## 2. Create Herald

`Herald` is the object your app talks to. You give it the services to send to, and it passes every
event on to each of them. Herald calls these services **providers**.

Here there's one provider, the log module. It has two parts: a tracker that handles events and
user properties, and a service that handles everything else, such as start-up and sign-in.

=== "Kotlin"

    ```kotlin
    --8<-- "samples/QuickStart.kt:herald"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/quick_start.dart:herald"
    ```

Create Herald once for the whole app. [Set up your app](app-setup.md) shows how to share it.

Then start it where the vendors' own setup guides initialise their SDKs, on every start of your
app:

=== "Kotlin"

    Start it in `Application.onCreate()`, which also runs for starts without a screen, like a push
    notification. `start()` is a suspend function, because some services set themselves up in the
    background, so launch it in a scope that lives as long as the app:

    ```kotlin
    --8<-- "samples/QuickStart.kt:app"
    ```

    ??? tip "Starting from a ViewModel instead"
        An app with a single activity and no background work can start Herald from its first
        screen's ViewModel, using the ViewModel's own scope. The
        [Moove](https://github.com/MkhytarMkhoian/Moove) sample app does this. If your app can
        start without that screen, for example from a push notification or a WorkManager job, use
        the Application class instead.

        ```kotlin
        --8<-- "samples/QuickStart.kt:app-viewmodel"
        ```

=== "Dart"

    Start it in `main()`, before `runApp`. `start()` returns a `Future`, because some services set
    themselves up in the background:

    ```dart
    --8<-- "docs_samples/lib/quick_start.dart:app"
    ```

## 3. Track the event

Your classes don't use `Herald` directly. They ask for `EventTrackerService`, a small interface
with a single `track` function, and you pass `Herald` in its place. That keeps them easy to test:
in tests you pass a fake instead.

=== "Kotlin"

    ```kotlin
    --8<-- "samples/QuickStart.kt:track"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/quick_start.dart:track"
    ```

Call `onCheckout("pro", 3)`, and the log shows the event as a real service would receive it:

=== "Kotlin"

    ```text title="Logcat"
    D/analytics: [herald] start
    D/analytics: [herald] event   checkout_started
    D/analytics:     ├─ plan  = pro
    D/analytics:     └─ seats = 3
    ```

=== "Dart"

    ```text title="Debug console"
    [herald] start
    [herald] event   checkout_started
        ├─ plan  = pro
        └─ seats = 3
    ```

## 4. Add Firebase

First set up Firebase in your app the usual way, by following Firebase's guide for
[Android](https://firebase.google.com/docs/analytics/get-started?platform=android) or
[Flutter](https://firebase.google.com/docs/analytics/get-started?platform=flutter). Then add
Herald's Firebase module:

=== "Kotlin"

    ```kotlin
    implementation("io.github.mkhytarmkhoian:herald-firebase:1.1.0")
    ```

=== "Groovy"

    ```groovy
    implementation 'io.github.mkhytarmkhoian:herald-firebase:1.1.0'
    ```

=== "Dart"

    ```bash
    flutter pub add herald_firebase
    ```

The Firebase provider is built the same way as the log one. Its factories send screen views as
GA4's own `screen_view` event, and every other event under its own name:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/CompositionRoot.kt:firebase-provider"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/composition_root.dart:firebase-provider"
    ```

Add it to Herald next to the log provider:

=== "Kotlin"

    ```kotlin
    --8<-- "samples/QuickStart.kt:add-firebase"
    ```

=== "Dart"

    ```dart
    --8<-- "docs_samples/lib/quick_start.dart:add-firebase"
    ```

The same `CheckoutStarted` now goes to both the log and Firebase, and `CheckoutViewModel` didn't
change at all.

## Next

- [Set up your app](app-setup.md): several services, error reporting and dependency injection.
- [Philosophy](../philosophy.md): why Herald works the way it does.
