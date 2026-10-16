# React Native SDK

Herald for React Native is a set of npm packages: the core, one package per vendor, optional React
hooks, a logger and a fake for your tests. Each vendor package works over that vendor's official
React Native package. It's written in TypeScript, and works with Expo and with plain React Native.

[API reference](../../api/react-native/index.html){ .md-button } [Changelog](../../changelog/react-native.md){ .md-button } [Source](https://github.com/MkhytarMkhoian/herald-react-native){ .md-button }

## Installation

Install the core, and one package for each analytics service you use, next to that service's own
React Native package. For Firebase:

```bash
npx expo install @react-native-firebase/app @react-native-firebase/analytics
npm install @herald-analytics/core @herald-analytics/firebase
npm install --save-dev @herald-analytics/testing
```

Install the vendor's own package yourself, as on the first line. npm would bring it in on its own,
but without adding it to your `package.json`, and React Native only links the native code of
packages listed there. Without Expo, use `npm install` for it too. For tracking from screens and
lists, add [`@herald-analytics/react`](react.md).

All packages share one version.

## Packages

--8<-- "herald-react-native/README.md:packages"

Feature code usually needs only `@herald-analytics/core`, plus the vendor package for each vendor
it writes a [factory](../../concepts/factory-chain.md) for. The app, which
[sets up Herald](../../getting-started/app-setup.md), depends on every vendor package.

## Compatibility

--8<-- "herald-react-native/README.md:compatibility"

## TypeScript specifics

--8<-- "herald-react-native/README.md:differences"
