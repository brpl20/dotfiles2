#!/bin/bash
# Git Aliases for Arch Linux (Bash compatible)
# Source this file from your ~/.bashrc

# Helper functions (must be defined before aliases that use them)
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/heads/main refs/heads/trunk refs/heads/mainline refs/heads/default \
             refs/remotes/origin/main refs/remotes/origin/trunk refs/remotes/origin/mainline refs/remotes/origin/default \
             refs/remotes/upstream/main refs/remotes/upstream/trunk refs/remotes/upstream/mainline refs/remotes/upstream/default; do
    if command git show-ref -q --verify "$ref"; then
      echo "${ref##*/}"
      return
    fi
  done
  echo master
}

git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/heads/dev refs/heads/devel refs/heads/develop refs/heads/development \
             refs/remotes/origin/dev refs/remotes/origin/devel refs/remotes/origin/develop refs/remotes/origin/development \
             refs/remotes/upstream/dev refs/remotes/upstream/devel refs/remotes/upstream/develop refs/remotes/upstream/development; do
    if command git show-ref -q --verify "$ref"; then
      echo "${ref##*/}"
      return
    fi
  done
  echo develop
}

git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo "${ref#refs/heads/}"
}

current_branch() {
  git_current_branch
}

# Basic Git Commands
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias gap='git apply'
alias gapt='git apply --3way'

# Branch Management
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'

# Bisect
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# Commit
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcam='git commit -a -m'
alias gcas='git commit -a -s'
alias gcasm='git commit -a -s -m'
alias gcsm='git commit -s -m'
alias gcmsg='git commit -m'
alias gcs='git commit -S'

# Checkout
alias gcb='git checkout -b'
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'

# Config and Clone
alias gcf='git config --list'
alias gcl='git clone --recurse-submodules'

# Clean
alias gclean='git clean -id'
alias gpristine='git reset --hard && git clean -dffx'

# Count
alias gcount='git shortlog -sn'

# Cherry Pick
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# Diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'

# Fetch
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfg='git ls-files | grep'
alias gfo='git fetch origin'

# Help
alias ghh='git help'

# Ignore
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gunignore='git update-index --no-assume-unchanged'

# Log
alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

# Merge
alias gm='git merge'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias gma='git merge --abort'

# Push
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias gpv='git push -v'

# Pull
alias gpr='git pull --rebase'

# Remote
alias gr='git remote'
alias gra='git remote add'
alias grrm='git remote remove'
alias grmv='git remote rename'
alias grset='git remote set-url'
alias grup='git remote update'
alias grv='git remote -v'

# Rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbs='git rebase --skip'

# Reset
alias grh='git reset'
alias grhh='git reset --hard'
alias gru='git reset --'

# Remove
alias grm='git rm'
alias grmc='git rm --cached'

# Restore
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'

# Root
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# Revert
alias grev='git revert'

# Show
alias gsh='git show'
alias gsps='git show --pretty=short --show-signature'

# Status
alias gsb='git status -sb'
alias gss='git status -s'
alias gst='git status'

# Stash
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='git stash --include-untracked'
alias gstall='git stash --all'

# Submodule
alias gsi='git submodule init'
alias gsu='git submodule update'

# Switch
alias gsw='git switch'
alias gswc='git switch -c'

# Tag
alias gts='git tag -s'
alias gtv='git tag | sort -V'

# Update
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash -v'

# What changed
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'

# Apply patches
alias gam='git am'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gama='git am --abort'
alias gamscp='git am --show-current-patch'

# Dynamic commands using functions (unalias first to avoid conflicts)
unalias gcm gcd gmom gmum grbd grbm grbom gswm gswd glum gluc gupom groh ggp ggl ggu ggpush ggpull ggsup gpsup 2>/dev/null

function gcm { git checkout "$(git_main_branch)"; }
function gcd { git checkout "$(git_develop_branch)"; }
function gmom { git merge "origin/$(git_main_branch)"; }
function gmum { git merge "upstream/$(git_main_branch)"; }
function grbd { git rebase "$(git_develop_branch)"; }
function grbm { git rebase "$(git_main_branch)"; }
function grbom { git rebase "origin/$(git_main_branch)"; }
function gswm { git switch "$(git_main_branch)"; }
function gswd { git switch "$(git_develop_branch)"; }
function glum { git pull upstream "$(git_main_branch)"; }
function gluc { git pull upstream "$(git_current_branch)"; }
function gupom { git pull --rebase origin "$(git_main_branch)"; }
function groh { git reset "origin/$(git_current_branch)" --hard; }
function ggp { git push origin "$(current_branch)"; }
function ggl { git pull origin "$(current_branch)"; }
function ggu { git pull --rebase origin "$(current_branch)"; }
function ggpush { git push origin "$(git_current_branch)"; }
function ggpull { git pull origin "$(git_current_branch)"; }
function ggsup { git branch --set-upstream-to="origin/$(git_current_branch)"; }
function gpsup { git push --set-upstream origin "$(git_current_branch)"; }
