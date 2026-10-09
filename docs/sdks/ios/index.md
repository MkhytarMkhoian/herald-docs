# iOS SDK

Herald for iOS is a set of Swift packages: the core, one package per vendor, optional SwiftUI
helpers, a logger and a fake for your tests. Each vendor package works over that vendor's official
iOS SDK.

[API reference](api.md){ .md-button } [Changelog](../../changelog/ios.md){ .md-button } [Source](https://github.com/MkhytarMkhoian/herald-ios){ .md-button }

## Installation

In Xcode, choose File → Add Package Dependencies, and add `herald-ios` and one package for each
analytics service you use. In a `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/MkhytarMkhoian/herald-ios", from: "1.0.0"),
    .package(url: "https://github.com/MkhytarMkhoian/herald-ios-firebase", from: "1.0.0"),
]
```

Then add the modules to your targets: `HeraldCore` and the vendor modules to your app, and
`HeraldTesting` to your test target only. For tracking from SwiftUI views, add
[`HeraldSwiftUI`](swiftui.md) to your app too.

All packages share one version. Each vendor package is its own repository, so an app downloads only
the vendor SDKs it uses.

## Packages

--8<-- "herald-ios/README.md:packages"

Feature modules usually need only `HeraldCore`, plus the vendor module for each vendor they write a
[factory](../../concepts/factory-chain.md) for. The app, which
[sets up Herald](../../getting-started/app-setup.md), depends on every vendor package.

## Compatibility

--8<-- "herald-ios/README.md:compatibility"

## Swift specifics

--8<-- "herald-ios/README.md:differences"
