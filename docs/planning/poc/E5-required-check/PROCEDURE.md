# E5 Procedure — Custom Agent Required Check 検証 (手動 + 実験)

> **対象**: 最先端機能のため実験的色合いが強い。3 つの Path を順に試して成立する最初のものを採用する。

---

## 1. 目的

`.github/agents/<name>.agent.md` を **PR の Required Check** として動かし、PR マージのゲートにできるかを確認する。これが成立すれば Step 6b で「Custom Agent を Required Check に」を教えられる。

## 2. Path 一覧 (上から順に試す)

| Path | 概要 | 教材難易度 |
|---|---|---|
| **A** | Custom Agent を **直接** Required Check に登録 | 低 (理想) |
| **B** | Custom Agent を Actions ラッパー workflow から起動し、その workflow を Required Check に | 中 |
| **C** | Custom Agent は使わず **Copilot Code Review (Layer 6 メイン)** だけで Required Check 要件を満たす | 低 (縮退) |

## 3. 共通準備: review-pr Custom Agent

```bash
mkdir -p .github/agents
cat > .github/agents/review-pr.agent.md <<'EOF'
---
name: "Triage PR Reviewer"
description: "Reviews PRs that modify .github/skills/, .github/agents/, or .github/workflows/. Checks that SKILL.md frontmatter has both name and description, and that .agent.md and workflow .md files do not introduce destructive safe-outputs."
---

You are a careful reviewer of customizations. When invoked on a PR:

1. Inspect the diff for files under `.github/skills/`, `.github/agents/`, and `.github/workflows/`.
2. For SKILL.md changes: verify frontmatter contains both `name` and `description`. If missing, post a request-changes review.
3. For .agent.md changes: verify frontmatter contains both `name` and `description`.
4. For workflow .md changes: verify `safe-outputs` does not include destructive keys (e.g. `delete-issue`).
5. Otherwise, approve.
EOF

git add .github/agents/
git commit -m "Add review-pr custom agent"
git push
```

## 4. Path A: 直接 Required Check

### Step A1
1. Web UI: Settings → Branches → Add branch protection rule for `main`
2. "Require status checks to pass" を ON
3. status checks 一覧で `review-pr` のような Custom Agent 由来のチェックが選択可能か確認

### Step A2
- 選択可能 → ✅ Path A 成立、教材は Path A で書く
- 選択不可 → Path B へ

## 5. Path B: Actions ラッパー

### Step B1
```yaml
# .github/workflows/run-review-pr.yml
name: Run PR Review Agent
on:
  pull_request:
    paths:
      - '.github/skills/**'
      - '.github/agents/**'
      - '.github/workflows/**'
permissions:
  contents: read
  pull-requests: write
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Invoke Custom Agent
        run: |
          # NOTE: 公式 invocation 方法を E5 検証中に確定
          # 候補: gh copilot custom-agent run review-pr
          # 候補: gh aw を使った agent 起動
          echo "TODO: invoke .github/agents/review-pr.agent.md against this PR"
```

### Step B2
- 上記 workflow が動き、Required Check に登録できるなら → ✅ Path B 成立
- agent invocation 方法が未公開 / 動かない → Path C

## 6. Path C: 縮退 (Copilot Code Review のみ)

- Branch protection で **Copilot Code Review** をサポートする方法 (組織設定 / repo 設定) を確認
- Step 6 を「Copilot Code Review が Required になっていれば Layer 6 のミニマム達成」と再定義
- Custom Agent は **Code Review Agent と並んで動く** という説明に留める

## 7. 記録

- 試した Path
- 各 Step で何が見えたか / エラー
- 選定した Path とその理由

## 8. PASS 基準

- [ ] Path A / B / C のいずれかが教材化できる形で成立
- [ ] Step 6b で学習者に提示する具体的な手順が定まる

## 9. FAIL

3 Path 全滅は考えにくい (C が最低保証)。万一全滅 → Master Plan §6 R6 を発動: Step 6 全体を「Copilot Code Review だけ」に縮退して Custom Agent は Step 5 の発展ネタに移す。
