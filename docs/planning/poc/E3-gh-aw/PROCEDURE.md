# E3 Procedure — gh aw 実機検証 (手動)

> **対象**: spec 確定済 (`RESULT.md` 参照)。本書は throwaway repo 上での実機 `gh aw run` 検証。
> **throwaway repo**: https://github.com/shinyay/test-ghcp-workshop-validation

---

## 1. 前提

- E1 完了 (Codespaces 起動、seed Issue 3 件存在)
- repo に Codespaces 開いた状態、ターミナル使用可能

## 2. 検証手順

### Step A. gh aw インストール

Codespaces ターミナルで:

```bash
curl -sL https://raw.githubusercontent.com/github/gh-aw/main/install-gh-aw.sh | bash
gh aw version
```

`version` が表示されない場合: `~/.local/share/gh/extensions` を PATH に追加してリトライ。

### Step B. repo を gh aw 用に初期化

```bash
gh aw init
git status
```

期待: 以下が新規作成されている
- `.gitattributes`
- `.github/agents/agentic-workflows.agent.md`
- `.vscode/settings.json`
- `.github/mcp.json`
- `.github/workflows/copilot-setup-steps.yml`

### Step C. triage workflow をコミット

```bash
mkdir -p .github/workflows
cat > .github/workflows/triage-issue.md <<'EOF'
---
name: "Triage Issue (validation)"
description: "Validate gh aw safe-outputs add-labels and add-comment on a real issue"
on:
  issues:
    types: [opened]
permissions:
  contents: read
  issues: write
safe-outputs:
  add-labels:
    allowed: [bug, feature, question, docs]
  add-comment:
    max: 1
---

## Triage Issue

When a new issue is opened, classify it into exactly one of these categories
based on the issue body:

- bug — something is broken or behaves incorrectly
- feature — request for new functionality
- question — asking how to do something
- docs — documentation improvement

Then:

1. Add the chosen category as a label via safe-outputs.
2. Post one short greeting comment that:
   - confirms the chosen category
   - asks for any obvious missing reproduction info if it is a bug

Do not modify the issue title or body.
EOF

# gh aw が .lock.yml を生成
gh aw compile  # コマンド名は確認、Phase 01 中に確定

git add .github/
git commit -m "Add triage-issue gh aw workflow"
git push
```

### Step D. 動作トリガ

新しい seed Issue を作成して workflow を起動:

```bash
gh issue create --title "Login button doesn't work" \
  --body "Pressing login does nothing in Chrome 120."
```

### Step E. 結果確認

```bash
gh run list --limit 3
gh run watch
```

期待:
- workflow run が成功
- 新規 issue にラベル `bug` が付く
- Bot から greeting コメントが 1 件投稿される

GitHub Web UI で issue を開いて目視確認も推奨。

## 3. 記録 (RESULT.md に追記)

- `gh aw init` で生成された `agentic-workflows.agent.md` の内容を貼る
- `triage-issue.lock.yml` の内容 (sanitized) を貼る
- workflow run のリンク
- 実際に付与されたラベル / コメントのスクリーンショット

## 4. PASS 基準

- [ ] `gh aw init` 成功
- [ ] triage workflow が compile 成功 (lock.yml 生成)
- [ ] 新規 Issue で workflow が自動起動
- [ ] `add-labels` / `add-comment` 双方が反映

## 5. FAIL 時の対応

| 症状 | 対応 |
|---|---|
| `gh aw compile` のコマンド名が違う | `gh aw --help` で確認、PROCEDURE 修正 |
| workflow が起動しない | Actions tab で events を確認、permissions / branch protection を見直し |
| `add-labels.allowed` の挙動が違う | gh-aw `docs/` の現行 spec を読み直す、workflow を最小化 |
| 持続的に動かない | Master Plan §6 R3 を発動: Step 4 をスクリプト録画 + 完成形 fork に縮退 |
