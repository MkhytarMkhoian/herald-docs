#!/usr/bin/env bash
#
# Prints a repository's latest release tag: the newest stable `v*` tag, or the newest pre-release
# while there is no stable one yet. Prints nothing when the repository has no release.
#
#   scripts/latest_release.sh https://github.com/MkhytarMkhoian/herald-flutter

set -euo pipefail

# versionsort.suffix sorts v1.0.0-dev.1 before v1.0.0, as semantic versioning does.
tags=$(git -c versionsort.suffix=- ls-remote --tags --refs --sort=-v:refname "$1" 'v*' |
  sed 's|.*refs/tags/||')

stable=$(grep -v -- '-' <<< "$tags" | head -n 1 || true)
echo "${stable:-$(head -n 1 <<< "$tags")}"
