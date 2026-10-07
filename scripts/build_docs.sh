#!/usr/bin/env bash
#
# Builds the Herald website into site/, or serves it locally with live reload.
#
#   scripts/build_docs.sh          # build, failing on any broken link or missing snippet
#   scripts/build_docs.sh serve    # build the API reference once, then preview at localhost:8000
#
# The site is MkDocs with the Material theme. Its code samples, the Android API reference (Dokka)
# and the change logs come from the SDK repositories, at build/herald, build/herald-flutter and
# build/herald-ios. CI checks out their latest releases there. Locally the script links your clones
# as they are: ../herald, ../herald-flutter and ../herald-ios, or HERALD_ANDROID, HERALD_FLUTTER
# and HERALD_IOS if set.
#
# Pass extra Gradle arguments through GRADLE_ARGS, e.g. GRADLE_ARGS="-Pversion=1.1.0" so the API
# reference's source links point at that release tag. CI installs the Python packages itself;
# locally they go into build/docs-venv.

set -euo pipefail

cd "$(dirname "$0")/.."

# Links build/<name> to a local clone, unless CI has already checked the repository out there.
link_sdk() {
  local target="build/$1" clone="$2" marker="$3" variable="$4"
  if [ -d "$target" ] && [ ! -L "$target" ]; then
    return
  fi
  if [ ! -f "$clone/$marker" ]; then
    echo "$1 not found at $clone. Clone it there, or set $variable." >&2
    exit 1
  fi
  mkdir -p build
  ln -sfn "$(cd "$clone" && pwd)" "$target"
}
link_sdk herald "${HERALD_ANDROID:-../herald}" settings.gradle.kts HERALD_ANDROID
link_sdk herald-flutter "${HERALD_FLUTTER:-../herald-flutter}" pubspec.yaml HERALD_FLUTTER
link_sdk herald-ios "${HERALD_IOS:-../herald-ios}" Package.swift HERALD_IOS

# The Android API reference, from every published module. Flutter's is on pub.dev, and iOS's on
# the Swift Package Index.
(cd build/herald && ./gradlew :dokkaGeneratePublicationHtml ${GRADLE_ARGS:-})
rm -rf docs/api
mkdir -p docs/api
cp -R build/herald/build/dokka/html docs/api/android

mkdir -p docs/changelog
cp build/herald/CHANGELOG.md docs/changelog/android.md
cp build/herald-flutter/CHANGELOG.md docs/changelog/flutter.md
cp build/herald-ios/CHANGELOG.md docs/changelog/ios.md

if ! command -v mkdocs > /dev/null; then
  if [ ! -x build/docs-venv/bin/mkdocs ]; then
    python3 -m venv build/docs-venv
    build/docs-venv/bin/pip install --quiet -r requirements.txt
  fi
  PATH="$PWD/build/docs-venv/bin:$PATH"
fi

if [ "${1:-}" = "serve" ]; then
  mkdocs serve
else
  mkdocs build --strict
fi
