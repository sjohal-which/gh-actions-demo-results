#!/usr/bin/env bash

echo "## Release Notes" > release-notes.md
echo "" >> release-notes.md

LATEST_COMMITS=$(git log "$(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)"..HEAD \
--pretty=format:"- [%h](https://github.com/${GITHUB_REPOSITORY}/commit/%H) %s")

# Initialize sections
BREAKING_CHANGES=""
FEATURES=""
FIXES=""
DOCUMENTATION=""

while IFS= read -r commit; do
  if [[ "$commit" =~ feat!:|fix!:|BREAKING[[:space:]]CHANGE ]]; then
    BREAKING_CHANGES+="$commit"$'\n'
  elif [[ "$commit" =~ feat ]]; then
    FEATURES+="$commit"$'\n'
  elif [[ "$commit" =~ fix ]]; then
    FIXES+="$commit"$'\n'
  elif [[ "$commit" =~ docs ]]; then
    DOCUMENTATION+="$commit"$'\n'
  fi
done <<< "$LATEST_COMMITS"

# Breaking Changes
echo "### Breaking Changes 🚨" >> release-notes.md
if [[ -n "$BREAKING_CHANGES" ]]; then
  echo "$BREAKING_CHANGES" >> release-notes.md
else
  echo "No breaking changes in this release." >> release-notes.md
fi
echo "" >> release-notes.md

# Features
echo "### Features ✨" >> release-notes.md
if [[ -n "$FEATURES" ]]; then
  echo "$FEATURES" >> release-notes.md
else
  echo "No features in this release." >> release-notes.md
fi
echo "" >> release-notes.md

# Fixes
echo "### Fixes 🐛" >> release-notes.md
if [[ -n "$FIXES" ]]; then
  echo "$FIXES" >> release-notes.md
else
  echo "No fixes in this release." >> release-notes.md
fi
echo "" >> release-notes.md

# Documentation
echo "### Documentation Updates 📚" >> release-notes.md
if [[ -n "$DOCUMENTATION" ]]; then
  echo "$DOCUMENTATION" >> release-notes.md
else
  echo "No documentation updates in this release." >> release-notes.md
fi
