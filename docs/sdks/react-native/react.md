# Tracking from React

`@herald-analytics/react` is an optional package for tracking from React Native components: screen
views each time a screen becomes visible, impressions when a list item is really on screen, and
taps in small components that have no view model. It's the React counterpart of the Android SDK's
[Compose](../android/compose.md) helpers, Flutter's [widgets](../flutter/widgets.md) and the iOS
SDK's [SwiftUI](../ios/swiftui.md) helpers.

```bash
npm install @herald-analytics/react
```

## Do you need it?

Not to use Herald. A view model can track its own events, screen views included, through
`EventTrackerService`, as on every other page of this site. A screen can also track its own screen
view when it opens:

```tsx
--8<-- "docs-samples/src/guides/react.tsx:plain"
```

That counts a screen once each time it opens. Use `@herald-analytics/react` when tracking from
components is the simpler fit, such as counting a screen each time the user comes back to it.

## React Navigation or Expo Router

Import from the path that matches your app's navigation. Everything has the same name in both.

| Your app uses | Import from |
| --- | --- |
| [React Navigation](https://reactnavigation.org) 7 | `@herald-analytics/react` |
| [Expo Router](https://docs.expo.dev/router/introduction/) 57 or newer | `@herald-analytics/react/expo-router` |

Expo Router has its own copy of React Navigation inside, so a screen hook from the wrong path can't
see the screen it's in. Neither navigation library is installed for you: each path uses only the
one your app already has.

## Set it up once

`HeraldScope` gives the components inside it the tracker. With React Navigation, put it around the
`NavigationContainer`:

```tsx
--8<-- "docs-samples/src/guides/react.tsx:setup"
```

With Expo Router, put it in the root layout:

```tsx
--8<-- "docs-samples/src/guides/react-expo-router.tsx:setup"
```

## The hooks

They follow the same rule as the Compose helpers: **track when a screen is shown or hidden, or when
something is really on screen, never when a component renders.** React re-renders components all
the time, and the user did nothing to cause it.

| Hook | Tracks | Answers |
| --- | --- | --- |
| `useTrackScreenView(event)` | each time its screen becomes visible: first show, coming back to it, the app returning from the background | how often is this screen looked at? |
| `useTrackOnScreen(event, on)` | each time its screen is `'shown'` or `'hidden'` | the same, for any event: `'hidden'` for "left the screen" |
| `useAnalytics()` | when you call `track` on it | a tap in a small component with no view model |
| `useImpressions(eventFor, { threshold, minVisibleMs })` | once per appearance, when that share of a list item has been visible that long | was this actually seen? |

Switching tabs counts like any other screen change. A `Modal` over the screen doesn't hide it, and
neither does iOS briefly taking focus, as for Control Centre or a system alert. On iOS the
notification centre sends the app to the background, so it hides the screen.

### Screen views

```tsx
--8<-- "docs-samples/src/guides/react.tsx:screen-view"
```

To track when the user leaves a screen:

```tsx
--8<-- "docs-samples/src/guides/react.tsx:on-screen"
```

The event of the latest render is the one sent.

### Taps

```tsx
--8<-- "docs-samples/src/guides/react.tsx:tap"
```

Events that come from your app's logic belong in its view model. This is for small components that
have none.

### Impressions

`useImpressions` returns the props for a `FlatList`, `SectionList` or `VirtualizedList`:

```tsx
--8<-- "docs-samples/src/guides/react.tsx:impression"
```

- **Once per appearance.** An item that leaves the screen completely and comes back counts again,
  which is what an impression is. "Each offer once per session" is your app's rule, so it belongs
  in your code. Items are told apart by the list's keys.
- **The options are read once,** because a list can't change them later.
- **At the slow end of a fling,** an item can count while it is still moving out of view: with
  `minVisibleMs`, React Native's list checks it again only when the time is up.

## Limits

- **Development builds with React's Strict Mode** run effects twice, so a screen view can be
  tracked twice there. Release builds aren't affected.
- **Impressions outside lists** aren't supported yet: React Native's way to tell when any view is on
  screen is still switched off by default. A carousel can be a horizontal `FlatList`.

## Tests

Wrap the component in a `HeraldScope` with a `FakeAnalyticsProvider` from
`@herald-analytics/testing`, as in [Testing](../../guides/testing.md). Screens also need their
navigator around them.
