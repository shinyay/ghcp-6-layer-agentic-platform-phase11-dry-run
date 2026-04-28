---
on:
  issues:
    types: [opened]
  workflow_dispatch:
    inputs:
      issue_number:
        required: true
        type: string

permissions:
  contents: read
  issues: read

safe-outputs:
  add-labels:
    allowed: [bug, enhancement, question, documentation]
    target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
  add-comment:
    target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
---

You are a triage agent for an open-source repository.

When invoked, you will triage an issue. There are TWO trigger paths:

1. `on: issues.opened` — the new issue's full payload (title, body, author, etc.)
   is available in the event context.
2. `on: workflow_dispatch` with `inputs.issue_number` — only the issue number is
   provided. You MUST read that issue from the current repository (using the
   `issues: read` permission) before classifying it. **Do not classify from the
   issue number alone.**

Your job:

1. Read the issue title and body.
2. Classify the issue into exactly ONE of the allowed labels:
   - `bug` — a defect in existing functionality
   - `enhancement` — a feature request or improvement proposal
   - `question` — a request for clarification or help
   - `documentation` — missing or incorrect documentation
3. Post a brief comment (2-3 sentences) summarizing your reasoning so the
   maintainer can verify the classification. **The comment MUST reference
   concrete content from the issue's title or body** (so it is clear you read
   the issue, not just labeled it from the number).

Be concise. Do NOT post implementation suggestions in this triage comment —
that is for a later workflow.

<!--
================================================================================
CANONICAL SAMPLE WORKFLOW — Step 4 of the 6-Layer Agentic Platform Workshop
================================================================================
NOTE: This trailing HTML comment must remain AFTER the YAML frontmatter and
prompt body. `gh aw` requires `---` on line 1 of the file, so any author
notes go here at the end (they do not affect compile or runtime).

USAGE
-----
Copy this file (preserving the leading `---` frontmatter) into your
**playground repo** as `.github/workflows/triage-issue.md`. Then run
`gh aw compile` to generate the paired `.lock.yml`. See Step 4 README
§3.A〜§3.C for the full procedure.

KEY DESIGN POINTS
-----------------
1. `on:` declares BOTH `issues.opened` (auto-trigger) and
   `workflow_dispatch.inputs.issue_number` (manual specific-issue re-run).
   The `safe-outputs.*.target` expression resolves both trigger paths in one
   line via `||` short-circuit.

2. `permissions:` is read-only. `issues: read` is REQUIRED so the agentic
   job can read the target issue's title/body — especially on the
   `workflow_dispatch` path where the event payload contains only
   `inputs.issue_number` (not the full issue object). `issues: read` is NOT
   a write permission, so it does NOT violate gh aw strict mode.

3. `safe-outputs.add-labels.allowed:` is the canonical label allowlist for
   this workshop: `[bug, enhancement, question, documentation]`. These match
   GitHub's default labels and are consistent with Step 2 / Step 3
   vocabulary. (The PoC RESULT used `[bug, feature, question, docs]` —
   that was a PoC-only vocabulary; the workshop standardizes on this version.)

4. The prompt body explicitly handles BOTH trigger paths so the agent
   fetches the target issue when invoked via `workflow_dispatch`.

REFERENCES
----------
- Step 4 README §3.C: ../README.md (final workflow + compile-before-commit)
- VERSIONS.md §4.1: ../../../docs/planning/VERSIONS.md
- E3 RESULT (PoC SoT): ../../../docs/planning/poc/E3-gh-aw/RESULT.md
================================================================================
-->
