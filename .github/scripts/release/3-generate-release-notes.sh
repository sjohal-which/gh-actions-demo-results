#!/usr/bin/env bash

# Clear and initialize release notes file
echo "## Release Notes" > release-notes.md
echo "" >> release-notes.md

LATEST_COMMITS=$(git log "$(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)"..HEAD \
--pretty=format:"- [%h](https://github.com/${GITHUB_REPOSITORY}/commit/%H) %s")

# Breaking Changes
echo "### Breaking Changes 🚨" >> release-notes.md
if echo "$LATEST_COMMITS" | grep -E 'feat!:|fix!:|BREAKING CHANGE' >> release-notes.md; then
  echo "" >> release-notes.md
else
  echo "No breaking changes in this release." >> release-notes.md
  echo "" >> release-notes.md
fi

# Features
echo "### Features ✨" >> release-notes.md
if echo "$LATEST_COMMITS" | grep -E 'feat' >> release-notes.md; then
  echo "" >> release-notes.md
else
  echo "No features in this release." >> release-notes.md
  echo "" >> release-notes.md
fi

# Fixes
echo "### Fixes 🐛" >> release-notes.md
if echo "$LATEST_COMMITS" | grep -E 'fix' >> release-notes.md; then
  echo "" >> release-notes.md
else
  echo "No fixes in this release." >> release-notes.md
  echo "" >> release-notes.md
fi

# Documentation Updates
echo "### Documentation Updates 📚" >> release-notes.md
if echo "$LATEST_COMMITS" | grep -E 'docs' >> release-notes.md; then
  echo "" >> release-notes.md
else
  echo "No documentation updates in this release." >> release-notes.md
  echo "" >> release-notes.md
fi
