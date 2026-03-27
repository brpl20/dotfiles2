#!/bin/bash
# prc-tree: Manage git worktrees for ProcStudio
# Usage:
#   prc-tree <branch-name>       Create a new worktree
#   prc-tree -l | --list         List all worktrees
#   prc-tree -r | --remove <name> Remove a worktree
#   prc-tree -p | --prune        Prune stale worktrees
#
# Port allocation (auto-incremented per worktree):
#   Main:       Rails 3000 | Vite 5174
#   Worktree 1: Rails 3001 | Vite 5175
#   Worktree 2: Rails 3002 | Vite 5176
#   ...
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
    echo "WORKTREE                                                      RAILS   VITE"
    echo "--------------------------------------------------------------------------"
    INDEX=0
    while IFS= read -r line; do
        RPORT=$((3000 + INDEX))
        VPORT=$((5174 + INDEX))
        printf "%-60s :%-6s :%-6s\n" "$line" "$RPORT" "$VPORT"
        INDEX=$((INDEX + 1))
    done < <(git -C "$PROCSTUDIO_ROOT" worktree list)
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
    "api/.env.development"
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

# --- Auto-assign ports ---
# Count existing worktrees (excluding the main one) to determine offset
WORKTREE_COUNT=$(git -C "$PROCSTUDIO_ROOT" worktree list | grep -cv "^${PROCSTUDIO_ROOT} ")
RAILS_PORT=$((3000 + WORKTREE_COUNT))
VITE_PORT=$((5174 + WORKTREE_COUNT))
ELECTRIC_PORT=$((RAILS_PORT + 1000))

echo ""
echo "Assigning ports: Rails=$RAILS_PORT | Vite=$VITE_PORT"

# Update api/.env.development (PORT and FRONTEND_URL)
ENV_DEV="$WORKTREE_PATH/api/.env.development"
if [[ -f "$ENV_DEV" ]]; then
    sed -i '' "s|^PORT=.*|PORT=${RAILS_PORT}|" "$ENV_DEV"
    sed -i '' "s|^FRONTEND_URL=.*|FRONTEND_URL=http://localhost:${VITE_PORT}|" "$ENV_DEV"
    echo "  api/.env.development → PORT=${RAILS_PORT}, FRONTEND_URL=:${VITE_PORT}"
fi

# Update frontend/.env (VITE_API_URL and VITE_ELECTRIC_URL)
FRONT_ENV="$WORKTREE_PATH/frontend/.env"
if [[ -f "$FRONT_ENV" ]]; then
    sed -i '' "s|^VITE_API_URL=.*|VITE_API_URL=http://localhost:${RAILS_PORT}|" "$FRONT_ENV"
    sed -i '' "s|^VITE_ELECTRIC_URL=.*|VITE_ELECTRIC_URL=http://localhost:${ELECTRIC_PORT}|" "$FRONT_ENV"
    echo "  frontend/.env → VITE_API_URL=:${RAILS_PORT}, VITE_ELECTRIC_URL=:${ELECTRIC_PORT}"
fi

# Update frontend/vite.config.ts (server port + proxy targets)
VITE_CONFIG="$WORKTREE_PATH/frontend/vite.config.ts"
if [[ -f "$VITE_CONFIG" ]]; then
    sed -i '' "s|port: [0-9]*,|port: ${VITE_PORT},|" "$VITE_CONFIG"
    sed -i '' "s|target: 'ws://localhost:[0-9]*'|target: 'ws://localhost:${RAILS_PORT}'|" "$VITE_CONFIG"
    sed -i '' "s|target: 'http://localhost:[0-9]*'|target: 'http://localhost:${RAILS_PORT}'|" "$VITE_CONFIG"
    echo "  frontend/vite.config.ts → port=${VITE_PORT}, proxy→:${RAILS_PORT}"
fi

# Update tests/e2e/.env (LOCAL_PAGE and LOCAL_API)
E2E_ENV="$WORKTREE_PATH/tests/e2e/.env"
if [[ -f "$E2E_ENV" ]]; then
    sed -i '' "s|^LOCAL_PAGE=.*|LOCAL_PAGE=http://localhost:${VITE_PORT}|" "$E2E_ENV"
    sed -i '' "s|^LOCAL_API=.*|LOCAL_API=http://localhost:${RAILS_PORT}/api/v1|" "$E2E_ENV"
    echo "  tests/e2e/.env → LOCAL_PAGE=:${VITE_PORT}, LOCAL_API=:${RAILS_PORT}"
fi

# Install backend dependencies
echo ""
echo "Installing backend dependencies..."
if [[ -f "$WORKTREE_PATH/api/Gemfile" ]]; then
    (cd "$WORKTREE_PATH/api" && bundle install)
    echo "  backend deps installed"
else
    echo "  skipped (no Gemfile found)"
fi

# Install frontend dependencies
echo ""
echo "Installing frontend dependencies..."
if [[ -f "$WORKTREE_PATH/frontend/package.json" ]]; then
    (cd "$WORKTREE_PATH/frontend" && npm install)
    echo "  frontend deps installed"
else
    echo "  skipped (no package.json found)"
fi

# Install customer-frontend dependencies if present
if [[ -f "$WORKTREE_PATH/customer-frontend/package.json" ]]; then
    echo ""
    echo "Installing customer-frontend dependencies..."
    (cd "$WORKTREE_PATH/customer-frontend" && npm install)
    echo "  customer-frontend deps installed"
fi

# Install e2e test dependencies if present
if [[ -f "$WORKTREE_PATH/tests/e2e/package.json" ]]; then
    echo ""
    echo "Installing e2e test dependencies..."
    (cd "$WORKTREE_PATH/tests/e2e" && npm install)
    echo "  e2e deps installed"
fi

echo ""
echo "========================================="
echo "  Worktree ready!"
echo "========================================="
echo "  Location:  $WORKTREE_PATH"
echo "  Rails API: http://localhost:${RAILS_PORT}"
echo "  Frontend:  http://localhost:${VITE_PORT}"
echo "========================================="
echo ""
echo "To start working:"
echo "  cd $WORKTREE_PATH"
