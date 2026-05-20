#!/usr/bin/env sh
set -eu

REPO_URL="${KAFFEINE_REPO_URL:-https://github.com/yeonghan/kaffeine.git}"
BRANCH="${KAFFEINE_BRANCH:-main}"
FALLBACK_BRANCH="codex/kyler-mock"

if [ -n "${KAFFEINE_CACHE_DIR:-}" ]; then
  CACHE_ROOT="$KAFFEINE_CACHE_DIR"
elif [ -n "${XDG_CACHE_HOME:-}" ]; then
  CACHE_ROOT="$XDG_CACHE_HOME/kaffeine-mock"
else
  CACHE_ROOT="$HOME/.cache/kaffeine-mock"
fi

REPO_DIR="$CACHE_ROOT/kaffeine"
HTML_FILE="$REPO_DIR/kyler_mock/index.html"

if ! command -v git >/dev/null 2>&1; then
  echo "[error] Git is required. Install Git first: https://git-scm.com/downloads" >&2
  exit 1
fi

checkout_branch() {
  target_branch="$1"
  git -C "$REPO_DIR" remote set-url origin "$REPO_URL"
  git -C "$REPO_DIR" fetch --prune origin
  git -C "$REPO_DIR" checkout "$target_branch" 2>/dev/null \
    || git -C "$REPO_DIR" checkout -B "$target_branch" "origin/$target_branch"
  git -C "$REPO_DIR" pull --ff-only origin "$target_branch"
}

mkdir -p "$CACHE_ROOT"

if [ -d "$REPO_DIR/.git" ]; then
  echo "[1/3] Updating $REPO_DIR"
  if ! checkout_branch "$BRANCH"; then
    if [ "$BRANCH" = "$FALLBACK_BRANCH" ]; then
      echo "[error] Could not update $REPO_URL" >&2
      exit 1
    fi
    echo "[info] Falling back to $FALLBACK_BRANCH until the pull request is merged."
    BRANCH="$FALLBACK_BRANCH"
    checkout_branch "$BRANCH"
  fi
else
  if [ -e "$REPO_DIR" ]; then
    echo "[error] Cache path exists but is not a Git repository: $REPO_DIR" >&2
    exit 1
  fi
  echo "[1/3] Cloning $REPO_URL"
  git clone --branch "$BRANCH" --depth 1 "$REPO_URL" "$REPO_DIR"
fi

if [ ! -f "$HTML_FILE" ] && [ "$BRANCH" != "$FALLBACK_BRANCH" ]; then
  echo "[info] Falling back to $FALLBACK_BRANCH until the pull request is merged."
  BRANCH="$FALLBACK_BRANCH"
  checkout_branch "$BRANCH"
fi

if [ ! -f "$HTML_FILE" ]; then
  echo "[error] HTML file not found: $HTML_FILE" >&2
  exit 1
fi

echo "[2/3] Demo ready: $HTML_FILE"
if [ "${KAFFEINE_SKIP_OPEN:-}" = "1" ]; then
  exit 0
fi

echo "[3/3] Opening browser"
open "$HTML_FILE"
