# Troubleshooting
1. Remove any malformed tags e.g. `v1.0.0-rc1` and restart workflow.

# Test
```bash
cd-gitroot && touch fake-commit
git checkout main &&
echo "" >> fake-commit && git add -A && git commit -m 'feat!: first release|major' &&
echo "" >> fake-commit && git add -A && git commit -m 'fix: add new roles|patch' &&
echo "" >> fake-commit && git add -A && git commit -m 'feat: add a new tf module|minor' &&
git push origin main &&
echo "" >> fake-commit && git add -A && git commit -m 'feat!: snowflake terraform provider upgrade|major' &&
echo "" >> fake-commit && git add -A && git commit -m 'refactor: update internal structure|none' &&
echo "" >> fake-commit && git add -A && git commit -m 'feat(gh-action): improved gh action|minor' &&
git push origin main &&
echo "" >> fake-commit && git add -A && git commit -m 'docs: update README|patch' &&
echo "" >> fake-commit && git add -A && git commit -m 'aesthetic change |none'
```