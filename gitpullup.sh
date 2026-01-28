#!/bin/bash
# gulp - Quick git pull + add + commit + push
# Usage: gulp [commit message]
# Default message: "auto-update"

set -e

if ! git rev-parse --git-dir &>/dev/null; then
  echo "Not a git repository."
  exit 1
fi

# Detect default branch
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$default_branch" ]; then
  if git show-ref --verify --quiet refs/heads/main; then
    default_branch="main"
  else
    default_branch="master"
  fi
fi

msg="${*:-auto-update}"

git pull origin "$default_branch" --rebase
git add .

if git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi

git commit -m "$msg"
git push origin "$default_branch"

echo "Done."
