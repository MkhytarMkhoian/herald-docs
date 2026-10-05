# Flutter SDK

Herald for Flutter is a set of Dart packages on pub.dev: the core, one package per vendor, a
logger and a fake for your tests. Each vendor package works over that vendor's official Flutter
plugin, so Herald adds no native code of its own.

[API reference](api.md){ .md-button } [Changelog](../../changelog/flutter.md){ .md-button } [Source](https://github.com/MkhytarMkhoian/herald-flutter){ .md-button }

## Installation

Add the core and one package for each analytics service you use:

```bash
flutter pub add herald herald_firebase
flutter pub add dev:herald_testing
```

All packages share one version. Each vendor package pulls in `herald` and that vendor's plugin.

## Packages

--8<-- "README.md:packages"

Feature packages usually need only `herald`, plus the vendor package for each vendor they write a
[factory](../../concepts/factory-chain.md) for. The app, which
[sets up Herald](../../getting-started/app-setup.md), depends on every vendor package.

## Compatibility

--8<-- "README.md:compatibility"

## Dart specifics

--8<-- "README.md:differences"

## Example app

The [example app](https://github.com/MkhytarMkhoian/herald-flutter/tree/main/example) sends every
call to the log and to an on-screen timeline, and tests its analytics with `herald_testing`. It
tracks screen views both ways: some screens with [`herald_widgets`](widgets.md), one from its own
code.
