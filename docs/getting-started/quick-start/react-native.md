# Quick start: React Native

On this page you send your first event and see it in your app's log. You don't need an account
with any analytics service yet: you start with Herald's log module, which prints each event instead
of sending it. At the end you add Firebase.

Add the core library and the log module. The [React Native SDK](../../sdks/react-native/index.md)
page lists all the modules.

```bash
npm install @herald-analytics/core @herald-analytics/log
```

## 1. Describe what happened

An event is a small class in your app. It has a name, and parameters that describe what happened:

```tsx
--8<-- "docs-samples/src/quick-start.tsx:event"
```

Parameters keep their type. `seats` reaches every service as the number 3, not as the text `"3"`,
so you can still sum and filter by it there.

## 2. Create Herald

`Herald` is the object your app talks to. You give it the services to send to, and it passes every
event on to each of them. Herald calls these services **providers**.

Here there's one provider, the log module. It has two parts: a tracker that handles events and
user properties, and a service that handles everything else, such as start-up and sign-in.

```tsx
--8<-- "docs-samples/src/quick-start.tsx:herald"
```

Create Herald once for the whole app. [Set up your app](../app-setup.md) shows how to share it.

Start it in the app's entry file, which runs once each time the app starts. `start()` returns a
promise, because some services set themselves up in the background:

```tsx
--8<-- "docs-samples/src/quick-start.tsx:app"
```

With Expo Router, create Herald in a module of its own and start it there: the root layout
imports it, so it runs once when the app starts.

## 3. Track the event

Your classes don't use `Herald` directly. They ask for `EventTrackerService`, a small interface
with a single `track` function, and you pass `Herald` in its place. That keeps them easy to test:
in tests you pass a fake instead.

```tsx
--8<-- "docs-samples/src/quick-start.tsx:track"
```

Call `onCheckout('pro', 3)`, and the log shows the event as a real service would receive it:

```text title="Metro"
 LOG  [herald] start
 LOG  [herald] event   checkout_started
    ├─ plan  = pro
    └─ seats = 3
```

## 4. Add Firebase

First set up Firebase in your app the usual way, by following [React Native Firebase's guide](https://rnfirebase.io/analytics/usage). Then add
Herald's Firebase module:

```bash
npm install @herald-analytics/firebase
```

The Firebase provider is built the same way as the log one. Its factories send screen views as
GA4's own `screen_view` event, and every other event under its own name:

```ts
--8<-- "docs-samples/src/composition-root.ts:firebase-provider"
```

Add it to Herald next to the log provider:

```tsx
--8<-- "docs-samples/src/quick-start.tsx:add-firebase"
```

The same `CheckoutStarted` now goes to both the log and Firebase, and `CheckoutViewModel` didn't
change at all.

## Next

- [Set up your app](../app-setup.md): several services, error reporting and dependency injection.
- [React Native SDK](../../sdks/react-native/index.md): every module, and what's specific to React Native.
- [React](../../sdks/react-native/react.md): screen views and impressions from components.
- [Philosophy](../../philosophy.md): why Herald works the way it does.
