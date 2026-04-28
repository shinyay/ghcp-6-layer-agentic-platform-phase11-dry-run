#!/usr/bin/env bash
# Phase 02 — Codespaces postCreate
# Installs `gh aw` (Agentic Workflows) extension pinned to GH_AW_VERSION,
# then runs a sanity check on all required CLI tools.
#
# This script is invoked by .devcontainer/devcontainer.json (postCreateCommand)
# and is also exercised in CI by .github/workflows/smoke.yml (L1 Smoke Test).

set -euo pipefail

GH_AW_VERSION="${GH_AW_VERSION:-v0.68.3}"

echo "::group::Install gh aw (${GH_AW_VERSION})"
if gh extension list 2>/dev/null | grep -q '^github/gh-aw\b'; then
  echo "gh-aw already installed, upgrading to pin ${GH_AW_VERSION}..."
  gh extension remove github/gh-aw || true
fi
# NOTE: github/gh-aw is a PUBLIC repo, but Codespaces' auto GH_TOKEN often
# lacks SAML-SSO authorization to the `github` org, which causes the release
# API call (`/repos/github/gh-aw/releases/...`) to return HTTP 403 with
# "Resource protected by organization SAML enforcement". Public repo release
# assets are accessible unauthenticated, so we unset GH_TOKEN/GITHUB_TOKEN
# for this single command to bypass the SAML check.
# Ref: phase-02-skeleton.md §7 R02-7
GH_TOKEN= GITHUB_TOKEN= gh extension install github/gh-aw --pin "${GH_AW_VERSION}"
echo "::endgroup::"

echo ""
echo "::group::Sanity check (required tools)"
echo "--- gh ---";       gh --version
echo "--- gh aw ---";    gh aw version
echo "--- jq ---";       jq --version
echo "--- git ---";      git --version
echo "--- curl ---";     curl --version | head -n1
echo "::endgroup::"

echo ""
echo "✅ postCreate complete. Open content/README.md to start the workshop."
