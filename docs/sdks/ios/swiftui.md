# Tracking from SwiftUI

`HeraldSwiftUI` is an optional module for tracking from SwiftUI views: screen views each time a
screen becomes visible, impressions when something is really on screen, and taps in small views
that have no view model. It's the SwiftUI counterpart of the Android SDK's
[Compose](../android/compose.md) helpers and Flutter's [widgets](../flutter/widgets.md).

It's in the `herald-ios` package, so there's nothing new to install: add the `HeraldSwiftUI` module
to your app target. It needs only SwiftUI.

## Do you need it?

Not to use Herald. A view model can track its own events, screen views included, through
`EventTrackerService`, as on every other page of this site:

```swift
--8<-- "Samples/Sources/Samples/Guides/SwiftUIHelpers.swift:plain"
```

That counts a screen once each time it opens. Use `HeraldSwiftUI` when tracking from the view is
the simpler fit, such as counting a screen each time the user comes back to it.

## Set it up once

`.eventTracker(_:)` gives the tracker to every view inside it, through SwiftUI's environment:

```swift
--8<-- "Samples/Sources/Samples/Guides/SwiftUIHelpers.swift:setup"
```

## The helpers

They follow the same rule as the Compose helpers: **track when a screen is shown or hidden, or when
something is really on screen, never when a view is drawn.** SwiftUI redraws views all the time,
and the user did nothing to cause it.

| Helper | Tracks | Answers |
| --- | --- | --- |
| `.trackScreenView(_:)` | each time the screen becomes visible: first show, coming back to it, the app returning from the background | how often is this screen looked at? |
| `.track(_:on:)` | each time the screen is `.visible` or `.hidden` | the same, for any event: `.hidden` for "left the screen" |
| `@Environment(\.eventTracker)` | when you call `track` on it | a tap in a small view with no view model |
| `.trackImpression(_:threshold:minVisibleDuration:)` | once per appearance, when that share of the view has been visible that long | was this actually seen? |

Sheets and alerts over a screen don't hide it, and the app briefly losing focus, as under Control
Center, doesn't either. A tab counts each time it's selected.

### Screen views

Put it on the screen's root view:

```swift
--8<-- "Samples/Sources/Samples/Guides/SwiftUIHelpers.swift:screen-view"
```

To track when the user leaves a screen:

```swift
--8<-- "Samples/Sources/Samples/Guides/SwiftUIHelpers.swift:on-screen"
```

### Taps

```swift
--8<-- "Samples/Sources/Samples/Guides/SwiftUIHelpers.swift:tap"
```

Events that come from your app's logic belong in its view model. This is for small views that have
none.

### Impressions

```swift
--8<-- "Samples/Sources/Samples/Guides/SwiftUIHelpers.swift:impression"
```

- **Once per appearance.** An item that scrolls out of the list and back in counts again, which is
  what an impression is. "Each offer once per session" is your app's rule, so it belongs in your
  code.
- **Events must be `Equatable`.** A different event starts the count again, and the compiler
  checks that events can be compared. For a struct, adding `Equatable` is enough.
- **"On screen" means inside the window.** On iOS 18 and newer, it also means inside the view's
  scroll view, so a card cut off by a small carousel counts only for its visible part, and the
  part of a view under a navigation or tab bar doesn't count.

## UIKit

UIKit needs no extra module. `viewDidAppear` runs each time a screen becomes visible, so track the
screen view there:

```swift
--8<-- "Samples/Sources/Samples/Guides/SwiftUIHelpers.swift:uikit"
```

## Limits

- **A full-screen cover doesn't hide the screen under it.** SwiftUI doesn't tell the screen below,
  so it isn't counted again when the cover closes. The cover's own `.trackScreenView` still counts.
- **Going back shows the screen first.** SwiftUI shows the screen you return to just before it
  hides the one you leave, so its screen view comes a moment before the other's `.hidden` event.
- **Notification Center counts as leaving.** It covers the whole screen and sends the app to the
  background, so the screen counts again when it closes. Control Center doesn't.

## Tests and previews

In Xcode Previews, the helpers track nothing, so a preview needs no setup:

```swift
--8<-- "Samples/Sources/Samples/Guides/SwiftUIHelpers.swift:preview"
```

To check what a view tracks, host it in a test with `.eventTracker(analytics)` and a
`FakeAnalyticsProvider` from `HeraldTesting`, as in [Testing](../../guides/testing.md). Events from
your app's logic are simpler to check in its view model's tests.

A view without a tracker stops a debug build at its first event, with a message saying to add
`.eventTracker(_:)`. A release build drops the event.
