# Herald docs

The source of the [Herald website](https://mkhytarmkhoian.github.io/herald-docs/), for both SDKs:
[Herald for Android](https://github.com/MkhytarMkhoian/herald) and
[Herald for Flutter](https://github.com/MkhytarMkhoian/herald-flutter).

The site is [MkDocs](https://www.mkdocs.org) with the
[Material theme](https://squidfunk.github.io/mkdocs-material/). The pages are here, in `docs/`.
The code on them comes from the SDK repositories, where it is compiled and tested:
`docs-samples` in herald and `docs_samples` in herald-flutter.

## Building

Clone both SDKs next to this repository, then:

```bash
scripts/build_docs.sh          # build into site/, failing on any broken link or missing snippet
scripts/build_docs.sh serve    # preview at http://localhost:8000
```

It needs JDK 17 and an Android SDK for the Android API reference, and Python 3 for MkDocs, which it
installs into `build/docs-venv`. Set `HERALD_ANDROID` or `HERALD_FLUTTER` to use clones somewhere
else. The local build uses your clones as they are, so you can preview pages for features that
aren't released yet.

## Publishing

The **Docs** workflow builds every pull request. It deploys to GitHub Pages on a push to `main`,
when either SDK releases, or when run by hand (Actions → Docs → Run workflow).

The site documents what Maven Central and pub.dev serve. So CI checks out each SDK at its latest
release tag, the newest stable `v*` tag or, before the first stable one, the newest pre-release,
and takes the samples, the Android API reference and the change logs from there. Each SDK's
publish workflow triggers a redeploy when it releases.

See [CONTRIBUTING.md](CONTRIBUTING.md) to contribute.

## License

Apache License 2.0. See [LICENSE](LICENSE).
