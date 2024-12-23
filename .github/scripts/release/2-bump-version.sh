#!/usr/bin/env bash

# Extract current version numbers
CURRENT_VERSION="$1"
CURRENT_VERSION=${CURRENT_VERSION#v} # Remove the leading 'v'
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Bump version based on commit types
case "$2" in
  major)
    NEW_VERSION="$((MAJOR + 1)).0.0"
    ;;
  minor)
    NEW_VERSION="${MAJOR}.$((MINOR + 1)).0"
    ;;
  patch)
    NEW_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))"
    ;;
esac

echo "NEW_VERSION=v${NEW_VERSION}" >> $GITHUB_OUTPUT
