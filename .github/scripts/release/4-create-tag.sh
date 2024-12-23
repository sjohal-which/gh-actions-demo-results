#!/usr/bin/env bash

NEW_TAG="$1"
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git tag -a "${NEW_TAG}" -m "Release ${NEW_TAG}"
git push origin "${NEW_TAG}"
