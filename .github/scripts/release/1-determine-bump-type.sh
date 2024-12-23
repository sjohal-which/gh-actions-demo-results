#!/usr/bin/env bash

# Get the latest commit message since the last tag
LATEST_COMMIT=$(git log "$(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)"..HEAD --pretty=format:"%s" -n 1)

# Initialize bump type as none
BUMP_TYPE="none"

# Define a lookup array for conventional commit prefixes and their corresponding bump types
declare -A BUMP_MAP=(
  ["feat!"]=major
  ["fix!"]=major
  ["BREAKING CHANGE"]=major
  ["feat"]=minor
  ["fix"]=patch
  ["docs"]=patch
)

# Check the latest commit message and determine bump type based on conventional commit syntax
while IFS= read -r commit; do
  for prefix in "${!BUMP_MAP[@]}"; do
    if [[ "$commit" == "$prefix"* ]]; then
      if [[ ${BUMP_MAP[$prefix]} == "major" ]]; then
        BUMP_TYPE="major"
        break 2
      elif [[ ${BUMP_MAP[$prefix]} == "minor" && $BUMP_TYPE != "major" ]]; then
        BUMP_TYPE="minor"
      elif [[ ${BUMP_MAP[$prefix]} == "patch" && $BUMP_TYPE == "none" ]]; then
        BUMP_TYPE="patch"
      fi
    fi
  done
done <<< "$LATEST_COMMIT"

# Output bump type only if it is not none
if [[ $BUMP_TYPE != "none" ]]; then
  echo "BUMP_TYPE=${BUMP_TYPE}" >> $GITHUB_OUTPUT
else
  echo "No valid conventional commits found. Skipping tag creation."
  echo "BUMP_TYPE=none" >> $GITHUB_OUTPUT # Default to v0.0.0 if no valid commits found on initial release
fi