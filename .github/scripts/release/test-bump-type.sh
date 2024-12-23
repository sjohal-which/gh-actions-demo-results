#!/usr/bin/env bash

# Test cases for commit message validation
# Format: "commit message|expected bump type"
TEST_CASES=(
  "fix!: first release|major"
  "fix: correct a bug|patch"
  "fix: correct another bug|patch"
  "docs: update README|patch"
  "aesthetic change |none"
  "BREAKING CHANGE: update core logic|major"
  "fix:add new roles|patch"
  "feat: add a new tf module|minor"
  "feat!: snowflake terraform provider upgrade|major"
  "refactor: update internal structure|none"
  "feat(gh-action): improved gh action|minor"
  "add new feature|none"
)

# Create a temporary mock git function
mock_git() {
  if [[ "$1" == "log" ]]; then
    echo "$MOCK_COMMIT"
  elif [[ "$1" == "describe" ]]; then
    echo "v1.0.0"  # Mock the last tag
  elif [[ "$1" == "rev-list" ]]; then
    echo "initial-commit-hash"  # Mock initial commit
  fi
}

# Export the mock function so it's available to the script we're testing
export -f mock_git

# Terminal colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Loop through all test cases
for test_case in "${TEST_CASES[@]}"; do
  # Extract commit message and expected outcome
  commit_msg=$(echo "$test_case" | cut -d"|" -f1)
  expected=$(echo "$test_case" | cut -d"|" -f2)

  # Set up the mock commit message
  export MOCK_COMMIT="$commit_msg"

  # Run the main script with git command replaced by our mock
  result=$(git() { mock_git "$@"; }; . ./1-determine-bump-type.sh)

  # Handle the case where script outputs nothing (which means "none")
  if [[ -z "$result" ]]; then
    actual="none"
  else
    actual=$(echo "$result" | grep "BUMP_TYPE=" | cut -d"=" -f2)
  fi

#  echo "Result: $result, Actual: $actual, Expected: $expected"

  # Compare results
  if [[ "$actual" == "$expected" ]]; then
    echo -e "${GREEN}✅ Test passed for commit: '$commit_msg' (Expected: $expected, Got: $actual)${NC}"
  else
    echo -e "${RED}❌ Test failed for commit: '$commit_msg' (Expected: $expected, Got: $actual)${NC}"
  fi
done

