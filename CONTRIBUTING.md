# Contributing

Thanks for helping with the Herald website. Changes to the SDKs themselves go to
[herald](https://github.com/MkhytarMkhoian/herald) or
[herald-flutter](https://github.com/MkhytarMkhoian/herald-flutter).

## Writing

- **Plain, simple words.** Short sentences, and the words a developer would use. Say what to do and
  why, not how the code got that way.
- **One page for both SDKs.** Herald works the same on Android and Flutter, so a page explains it
  once. Code that differs goes in a **Kotlin** and a **Dart** tab, in that order.
- **Only released features.** The site deploys from `main`, against each SDK's latest release, so
  a page about a new feature merges once that feature is released.

## Code on a page

Code comes from the SDK repositories, never written into a page. Each sample sits between
`// --8<-- [start:name]` and `// --8<-- [end:name]` markers, and a page includes it by file and
name:

```text
--8<-- "samples/QuickStart.kt:event"                 Android: docs-samples/src/main/kotlin
--8<-- "docs_samples/lib/quick_start.dart:event"     Flutter: the herald-flutter repository root
```

To show new code, add it to the SDK's samples first, where its build compiles and tests it. Section
names are shared between the repositories: renaming one means changing the page that uses it.

## Before you open a pull request

- [ ] `scripts/build_docs.sh` passes.
- [ ] New pages are in the `nav` of `mkdocs.yml`.
- [ ] Both tabs are there wherever the code differs between the SDKs.
