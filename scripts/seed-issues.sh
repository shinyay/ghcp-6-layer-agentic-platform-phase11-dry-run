#!/usr/bin/env bash
# seed-issues.sh — Step 0 mini-triage 用の seed Issue 3 件を冪等に作成する
#
# Usage:
#   ./scripts/seed-issues.sh                # 現在の repo に作成
#   ./scripts/seed-issues.sh -R owner/repo  # 別 repo を指定
#
# 同タイトルの open Issue が既に存在する場合は skip する (冪等)。
# 出典: docs/planning/poc/E1-mcp/PROCEDURE.md Step B
#
# Phase: 03 (Step 0 教材化) / Commit: C2

set -euo pipefail

# ---- prerequisites -----------------------------------------------------------
command -v gh >/dev/null || { echo "ERROR: gh CLI not found" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "ERROR: gh not authenticated. Run 'gh auth login'." >&2; exit 1; }

# ---- repo target -------------------------------------------------------------
REPO_ARGS=()
if [[ "${1:-}" == "-R" && -n "${2:-}" ]]; then
  REPO_ARGS=(-R "$2")
  TARGET="$2"
else
  TARGET="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
fi
echo "==> seeding issues into: ${TARGET}"

# ---- seed payloads -----------------------------------------------------------
TITLES=(
  "App crashes on startup"
  "Add dark mode"
  "How do I configure auth?"
)
BODIES=(
  "When I run \`npm start\`, the process exits with code 1 and no log."
  "Please add a dark mode toggle to settings."
  "I cannot find docs on JWT setup."
)

# ---- existing open titles (idempotency) --------------------------------------
EXISTING="$(gh issue list "${REPO_ARGS[@]}" --state open --limit 200 --json title -q '.[].title' || true)"

CREATED=0
SKIPPED=0
for i in "${!TITLES[@]}"; do
  title="${TITLES[$i]}"
  body="${BODIES[$i]}"
  if grep -Fxq -- "${title}" <<<"${EXISTING}"; then
    echo "  - skip (already exists): ${title}"
    SKIPPED=$((SKIPPED+1))
    continue
  fi
  url="$(gh issue create "${REPO_ARGS[@]}" --title "${title}" --body "${body}")"
  echo "  + created: ${url}"
  CREATED=$((CREATED+1))
done

echo "==> done. created=${CREATED} skipped=${SKIPPED}"
