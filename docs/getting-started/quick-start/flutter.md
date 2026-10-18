# Quick start: Flutter

On this page you send your first event and see it in your app's log. You don't need an account
with any analytics service yet: you start with Herald's log module, which prints each event instead
of sending it. At the end you add Firebase.

Add the core library and the log module. The [Flutter SDK](../../sdks/flutter/index.md)
page lists all the modules.

```bash
flutter pub add herald herald_log
```

## 1. Describe what happened

An event is a small class in your app. It has a name, and parameters that describe what happened:

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

```dart
--8<-- "docs_samples/lib/quick_start.dart:herald"
```

Create Herald once for the whole app. [Set up your app](../app-setup.md) shows how to share it.

Start it in `main()`, before `runApp`. `start()` returns a `Future`, because some services set
themselves up in the background:

```dart
--8<-- "docs_samples/lib/quick_start.dart:app"
```

## 3. Track the event

Your classes don't use `Herald` directly. They ask for `EventTrackerService`, a small interface
with a single `track` function, and you pass `Herald` in its place. That keeps them easy to test:
in tests you pass a fake instead.

```dart
--8<-- "docs_samples/lib/quick_start.dart:track"
```

Call `onCheckout('pro', 3)`, and the log shows the event as a real service would receive it:

```text title="Debug console"
[herald] start
[herald] event   checkout_started
    ├─ plan  = pro
    └─ seats = 3
```

## 4. Add Firebase

First set up Firebase in your app the usual way, by following [Firebase's guide for Flutter](https://firebase.google.com/docs/analytics/get-started?platform=flutter). Then add
Herald's Firebase module:

```bash
flutter pub add herald_firebase
```

The Firebase provider is built the same way as the log one. Its factories send screen views as
GA4's own `screen_view` event, and every other event under its own name:

```dart
--8<-- "docs_samples/lib/composition_root.dart:firebase-provider"
```

Add it to Herald next to the log provider:

```dart
--8<-- "docs_samples/lib/quick_start.dart:add-firebase"
```

The same `CheckoutStarted` now goes to both the log and Firebase, and `CheckoutViewModel` didn't
change at all.

## Next

- [Set up your app](../app-setup.md): several services, error reporting and dependency injection.
- [Flutter SDK](../../sdks/flutter/index.md): every module, and what's specific to Flutter.
- [Widgets](../../sdks/flutter/widgets.md): screen views and impressions from widgets.
- [Philosophy](../../philosophy.md): why Herald works the way it does.
