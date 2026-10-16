# Herald docs

The source of the [Herald website](https://mkhytarmkhoian.github.io/herald-docs/), for every SDK:
[Herald for Android](https://github.com/MkhytarMkhoian/herald),
[Herald for Flutter](https://github.com/MkhytarMkhoian/herald-flutter),
[Herald for iOS](https://github.com/MkhytarMkhoian/herald-ios) and
[Herald for React Native](https://github.com/MkhytarMkhoian/herald-react-native).

The site is [MkDocs](https://www.mkdocs.org) with the
[Material theme](https://squidfunk.github.io/mkdocs-material/). The pages are here, in `docs/`.
The code on them comes from the SDK repositories, where it is compiled and tested:
`docs-samples` in herald, `docs_samples` in herald-flutter, `Samples` in herald-ios and
`docs-samples` in herald-react-native.

## Building

Clone the SDK repositories next to this one (`herald`, `herald-flutter`, `herald-ios`,
`herald-kmp` and `herald-react-native`), then:

```bash
scripts/build_docs.sh          # build into site/, failing on any broken link or missing snippet
scripts/build_docs.sh serve    # preview at http://localhost:8000
```

It needs JDK 17 and an Android SDK for the Android API reference, Node.js 24 for the React Native
one, and Python 3 for MkDocs, which it installs into `build/docs-venv`. Set `HERALD_ANDROID`,
`HERALD_FLUTTER`, `HERALD_IOS`, `HERALD_KMP` or `HERALD_REACT_NATIVE` to use clones somewhere else. The local build uses your clones as they are, so you can preview pages for
features that aren't released yet.

## Publishing

The **Docs** workflow builds every pull request. It deploys to GitHub Pages on a push to `main`,
when an SDK releases, or when run by hand (Actions → Docs → Run workflow).

The site documents what Maven Central, pub.dev, the Swift Package Index and npm serve. So CI checks
out each SDK at its latest release tag, the newest stable `v*` tag or, before the first stable one,
the newest pre-release, and takes the samples, the Android and React Native API references and the
change logs from there. Each SDK's
publish workflow triggers a redeploy when it releases.

See [CONTRIBUTING.md](CONTRIBUTING.md) to contribute.

## License

Apache License 2.0. See [LICENSE](LICENSE).
