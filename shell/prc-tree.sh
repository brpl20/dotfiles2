#!/bin/bash
# prc-tree: Manage git worktrees for ProcStudio
# Usage:
#   prc-tree <branch-name>       Create a new worktree
#   prc-tree -l | --list         List all worktrees
#   prc-tree -r | --remove <name> Remove a worktree
#   prc-tree -p | --prune        Prune stale worktrees
#
# Examples:
#   prc-tree main
#   prc-tree feature/new-feature
#   prc-tree -r ProcStudio-main
#   prc-tree -l

set -e

CODEF="${CODEF:-/Users/brpl/code}"
PROCSTUDIO_ROOT="${CODEF}/ProcStudio"

# --- List worktrees ---
if [[ "$1" == "-l" || "$1" == "--list" ]]; then
    git -C "$PROCSTUDIO_ROOT" worktree list
    exit 0
fi

# --- Prune stale worktrees ---
if [[ "$1" == "-p" || "$1" == "--prune" ]]; then
    echo "Pruning stale worktrees..."
    git -C "$PROCSTUDIO_ROOT" worktree prune -v
    exit 0
fi

# --- Remove a worktree ---
if [[ "$1" == "-r" || "$1" == "--remove" ]]; then
    TARGET="$2"
    if [[ -z "$TARGET" ]]; then
        echo "Usage: prc-tree --remove <worktree-dir-name>"
        echo "Example: prc-tree --remove ProcStudio-main"
        echo ""
        echo "Current worktrees:"
        git -C "$PROCSTUDIO_ROOT" worktree list
        exit 1
    fi

    # Accept full path or just the directory name
    if [[ "$TARGET" == /* ]]; then
        WORKTREE_PATH="$TARGET"
    else
        WORKTREE_PATH="${CODEF}/${TARGET}"
    fi

    echo "Removing worktree at $WORKTREE_PATH..."
    git -C "$PROCSTUDIO_ROOT" worktree remove "$WORKTREE_PATH"
    echo "Done."
    exit 0
fi

# --- Create a worktree ---
BRANCH="$1"

if [[ -z "$BRANCH" ]]; then
    echo "Usage: prc-tree <branch-name>"
    echo "       prc-tree -l | --list"
    echo "       prc-tree -r | --remove <name>"
    echo "       prc-tree -p | --prune"
    echo ""
    echo "Example: prc-tree main"
    exit 1
fi

# Sanitize branch name for directory (replace / with -)
DIR_NAME=$(echo "$BRANCH" | tr '/' '-')
WORKTREE_PATH="${CODEF}/ProcStudio-${DIR_NAME}"

# Check if worktree already exists
if [[ -d "$WORKTREE_PATH" ]]; then
    echo "Error: Worktree already exists at $WORKTREE_PATH"
    echo "To remove it: prc-tree --remove ProcStudio-${DIR_NAME}"
    exit 1
fi

# Create the worktree
echo "Creating worktree for branch '$BRANCH' at $WORKTREE_PATH..."
cd "$PROCSTUDIO_ROOT"
git worktree add "$WORKTREE_PATH" "$BRANCH"

# Copy necessary config files
echo "Copying config files..."

CONFIG_FILES=(
    "api/.env"
    "api/config/database.yml"
    "api/config/master.key"
    "frontend/.env"
    "frontend/.env.local"
    "customer-frontend/.env.local"
    "tests/e2e/.env"
)

for cfg in "${CONFIG_FILES[@]}"; do
    if [[ -f "$PROCSTUDIO_ROOT/$cfg" ]]; then
        # Ensure target directory exists
        mkdir -p "$(dirname "$WORKTREE_PATH/$cfg")"
        cp "$PROCSTUDIO_ROOT/$cfg" "$WORKTREE_PATH/$cfg"
        echo "  copied $cfg"
    fi
done

echo ""
echo "Worktree created successfully!"
echo "Location: $WORKTREE_PATH"
echo ""
echo "Next steps:"
echo "  cd $WORKTREE_PATH"
echo "  cd api && bundle install"
echo "  cd frontend && npm install"
