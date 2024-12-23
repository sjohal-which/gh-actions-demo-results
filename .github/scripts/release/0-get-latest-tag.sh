#!/usr/bin/env bash

# Get the latest tag, default to v0.0.0 if none exists
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "LATEST_TAG=${LATEST_TAG}" >> $GITHUB_OUTPUT
