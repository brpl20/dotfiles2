#!/bin/bash
# prc-tree: Create a git worktree for ProcStudio with all necessary config files
# Usage: prc-tree <branch-name>
# Example: prc-tree main, prc-tree feature/new-feature

set -e

PROCSTUDIO_ROOT="${CODEF:-/Users/brpl20/code}/ProcStudio"
BRANCH="$1"

if [[ -z "$BRANCH" ]]; then
    echo "Usage: prc-tree <branch-name>"
    echo "Example: prc-tree main"
    exit 1
fi

# Sanitize branch name for directory (replace / with -)
DIR_NAME=$(echo "$BRANCH" | tr '/' '-')
WORKTREE_PATH="${CODEF:-/Users/brpl20/code}/ProcStudio-${DIR_NAME}"

# Check if worktree already exists
if [[ -d "$WORKTREE_PATH" ]]; then
    echo "Error: Worktree already exists at $WORKTREE_PATH"
    echo "To remove it: git worktree remove $WORKTREE_PATH"
    exit 1
fi

# Create the worktree
echo "Creating worktree for branch '$BRANCH' at $WORKTREE_PATH..."
cd "$PROCSTUDIO_ROOT"
git worktree add "$WORKTREE_PATH" "$BRANCH"

# Copy necessary config files
echo "Copying config files..."

# api/.env
if [[ -f "$PROCSTUDIO_ROOT/api/.env" ]]; then
    cp "$PROCSTUDIO_ROOT/api/.env" "$WORKTREE_PATH/api/.env"
    echo "  ✓ api/.env"
fi

# api/config/database.yml
if [[ -f "$PROCSTUDIO_ROOT/api/config/database.yml" ]]; then
    cp "$PROCSTUDIO_ROOT/api/config/database.yml" "$WORKTREE_PATH/api/config/database.yml"
    echo "  ✓ api/config/database.yml"
fi

# api/config/master.key
if [[ -f "$PROCSTUDIO_ROOT/api/config/master.key" ]]; then
    cp "$PROCSTUDIO_ROOT/api/config/master.key" "$WORKTREE_PATH/api/config/master.key"
    echo "  ✓ api/config/master.key"
fi

# customer-frontend/.env.local
if [[ -f "$PROCSTUDIO_ROOT/customer-frontend/.env.local" ]]; then
    cp "$PROCSTUDIO_ROOT/customer-frontend/.env.local" "$WORKTREE_PATH/customer-frontend/.env.local"
    echo "  ✓ customer-frontend/.env.local"
fi

# tests/e2e/.env
if [[ -f "$PROCSTUDIO_ROOT/tests/e2e/.env" ]]; then
    cp "$PROCSTUDIO_ROOT/tests/e2e/.env" "$WORKTREE_PATH/tests/e2e/.env"
    echo "  ✓ tests/e2e/.env"
fi

echo ""
echo "Worktree created successfully!"
echo "Location: $WORKTREE_PATH"
echo ""
echo "Next steps:"
echo "  cd $WORKTREE_PATH"
echo "  cd api && bundle install"
echo "  cd frontend && npm install"
