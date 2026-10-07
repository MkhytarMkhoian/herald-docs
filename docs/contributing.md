# Contributing

Herald lives in these repositories:

| Repository | What's in it |
| --- | --- |
| [herald](https://github.com/MkhytarMkhoian/herald) | the Android SDK, and the Kotlin code shown on this site |
| [herald-flutter](https://github.com/MkhytarMkhoian/herald-flutter) | the Flutter SDK, and the Dart code shown on this site |
| [herald-ios](https://github.com/MkhytarMkhoian/herald-ios) | the iOS SDK's core, and the Swift code shown on this site; each iOS vendor package has a repository of its own |
| [herald-docs](https://github.com/MkhytarMkhoian/herald-docs) | this website's pages |

Each has a CONTRIBUTING file with its rules:
[Android](https://github.com/MkhytarMkhoian/herald/blob/main/CONTRIBUTING.md),
[Flutter](https://github.com/MkhytarMkhoian/herald-flutter/blob/main/CONTRIBUTING.md),
[iOS](https://github.com/MkhytarMkhoian/herald-ios/blob/main/CONTRIBUTING.md) and
[website](https://github.com/MkhytarMkhoian/herald-docs/blob/main/CONTRIBUTING.md).

## Where a change goes

- **A bug or a feature:** the SDK's repository, with its tests.
- **A code example:** the SDK's samples: `docs-samples` for Android, `docs_samples` for Flutter, or
  `Samples` in herald-ios.
  The SDK's build compiles them, so an example can't stop working without failing it.
- **The words on a page:** herald-docs. Pages describe released versions only, so a page about a
  new feature merges once the feature is released.

To report a problem, open an issue on GitHub, for
[Android](https://github.com/MkhytarMkhoian/herald/issues),
[Flutter](https://github.com/MkhytarMkhoian/herald-flutter/issues),
[iOS](https://github.com/MkhytarMkhoian/herald-ios/issues) or
[this website](https://github.com/MkhytarMkhoian/herald-docs/issues).
