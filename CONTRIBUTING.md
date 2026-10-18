# Contributing

Thanks for helping with the Herald website. Changes to the SDKs themselves go to
[herald](https://github.com/MkhytarMkhoian/herald),
[herald-flutter](https://github.com/MkhytarMkhoian/herald-flutter),
[herald-ios](https://github.com/MkhytarMkhoian/herald-ios) or
[herald-react-native](https://github.com/MkhytarMkhoian/herald-react-native).

## Writing

- **Plain, simple words.** Short sentences, and the words a developer would use. Say what to do and
  why, not how the code got that way.
- **One page for every SDK.** Herald works the same everywhere, so a page explains it once. Code
  that differs goes in an **Android**, an **iOS**, a **Flutter** and a **React Native** tab, in
  that order.
- **Shared pages stay platform-neutral.** Something true on one platform only goes in that
  platform's tab, in a note titled with the platform, or in its notes page under Platforms. Avoid
  sentences like "on Flutter and iOS, …" in shared text.
- **Each platform has the same pages:** overview, UI helpers, notes, API reference and change log,
  and a quick start under Get started.
- **Only released features.** The site deploys from `main`, against each SDK's latest release, so
  a page about a new feature merges once that feature is released.

## Code on a page

Code comes from the SDK repositories, never written into a page. Each sample sits between
`// --8<-- [start:name]` and `// --8<-- [end:name]` markers, and a page includes it by file and
name:

```text
--8<-- "samples/QuickStart.kt:event"                 Android: docs-samples/src/main/kotlin
--8<-- "docs_samples/lib/quick_start.dart:event"     Flutter: the herald-flutter repository root
--8<-- "docs-samples/src/quick-start.tsx:event"      React Native: the herald-react-native root
```

To show new code, add it to the SDK's samples first, where its build compiles and tests it. Section
names are shared between the repositories: renaming one means changing the page that uses it.

## Before you open a pull request

- [ ] `scripts/build_docs.sh` passes.
- [ ] New pages are in the `nav` of `mkdocs.yml`.
- [ ] Every tab is there wherever the code differs between the SDKs.
