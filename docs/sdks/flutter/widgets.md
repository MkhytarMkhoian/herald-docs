# Tracking from widgets

`herald_widgets` is an optional package for tracking from the widget tree: screen views each time a
screen becomes visible, impressions when something is really on screen, and taps in small widgets
that have no bloc. It's the Flutter counterpart of the Android SDK's [Compose](../android/compose.md)
helpers.

```bash
flutter pub add herald_widgets
```

## Do you need it?

Not to use Herald. A screen, bloc or view model can track its own events, screen views included,
through `EventTrackerService`, as on every other page of this site:

```dart
--8<-- "docs_samples/lib/guides/screen_views.dart:plain"
```

That counts a screen once each time it opens. Use `herald_widgets` when tracking from the widget
tree is the simpler fit, such as counting a screen each time the user comes back to it.

## Set it up once

`HeraldScope` gives widgets below it the tracker, and `HeraldRouteObserver` tells them when their
screen is shown or hidden:

```dart
--8<-- "docs_samples/lib/guides/widgets.dart:setup"
```

## The widgets

They follow the same rule as the Compose helpers: **track when a screen is shown or hidden, or when
something is really on screen, never when a widget is built.** Flutter rebuilds widgets all the
time, and the user did nothing to cause it.

| Widget | Tracks | Answers |
| --- | --- | --- |
| `TrackScreenView(event: …)` | each time its screen becomes visible: first show, coming back to it, the app returning to view | how often is this screen looked at? |
| `TrackOnScreen(event: …, on: …)` | each time its screen is `shown` or `hidden` | the same, for any event: `hidden` for "left the screen" |
| `HeraldScope.of(context)` | when you call `track` on it | a tap in a small widget with no bloc |
| `TrackImpression(event: …, threshold: …, minVisibleDuration: …)` | once per appearance, when that share of the child has been visible that long | was this actually seen? |

A screen is a page, a `PageRoute`. Dialogs, bottom sheets and menus over it don't hide it, and the
app briefly losing focus, as under the notification shade, doesn't either.

### Screen views

```dart
--8<-- "docs_samples/lib/guides/widgets.dart:screen-view"
```

To track when the user leaves a screen:

```dart
--8<-- "docs_samples/lib/guides/widgets.dart:on-screen"
```

### Taps

```dart
--8<-- "docs_samples/lib/guides/widgets.dart:tap"
```

Events that come from your app's logic belong in its bloc or view model. This is for small widgets
that have none.

### Impressions

```dart
--8<-- "docs_samples/lib/guides/widgets.dart:impression"
```

- **Once per appearance.** An item that scrolls out of the list and back in counts again, which is
  what an impression is. "Each offer once per session" is your app's rule, so it belongs in your
  code.
- **Give events value equality.** A new, unequal event starts the count again, so an event without
  `==` restarts it on every rebuild.

## Limits

- **Tabs aren't screens.** Switching tabs doesn't push a page, so track it from the code that
  switches.
- **A nested `Navigator`**, such as go_router's shell route, needs a `HeraldRouteObserver` of its
  own, given to a `HeraldScope` around it.

## Tests and previews

Wrap the widget in a `HeraldScope` with a `FakeAnalyticsProvider` from `herald_testing`, as in
[Testing](../../guides/testing.md), and add a `HeraldRouteObserver` for screens. A widget preview
can do the same through `@Preview(wrapper: …)`.
