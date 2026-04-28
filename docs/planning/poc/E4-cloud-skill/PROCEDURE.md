# E4 Procedure — Cloud Agent + SKILL.md 連携検証 (手動)

> **対象**: ユーザー手動実行
> **目的**: Step 3 で「同じ SKILL.md を Cloud Agent が選んで使う」体験が成立することを実機で確認

---

## 1. 前提

- E1 + E3 完了
- throwaway repo に triage SKILL.md が存在 (E3 Step C で生成済 / なければ下記 §2 で配置)
- Cloud Agent が Issue assign で起動できる契約状態であることを確認済

## 2. 準備: triage SKILL.md を repo に置く

```bash
mkdir -p .github/skills/triage-issue
cat > .github/skills/triage-issue/SKILL.md <<'EOF'
---
name: triage-issue
description: 'Use this skill when a new GitHub issue needs triage. Reads the issue body, picks one category label (bug, feature, question, docs), and writes a short greeting comment that confirms the category and lists any missing reproduction info. Do not trigger for issues that already have a category label.'
---

# Triage Issue

## When to use
- 新規 issue で category label が未付与のとき
- 既に category label がついている issue は対象外

## Workflow
1. Issue body を読む
2. 内容から最適な 1 つの category label を選ぶ (bug / feature / question / docs)
3. ラベルを付ける
4. 確認のための短いコメントを残す
EOF

git add .github/skills/
git commit -m "Add triage-issue SKILL.md"
git push
```

## 3. 検証手順

### Step A. Issue 作成

```bash
gh issue create --title "Help: how to enable verbose logs?" \
  --body "I want more debug output during startup."
ISSUE=$(gh issue list --limit 1 --json number -q '.[0].number')
echo "Issue #$ISSUE"
```

### Step B. Cloud Agent (Copilot Coding Agent) に assign

Web UI から:
1. 上記 Issue を開く
2. Assignees → `Copilot` (または `@copilot`) を選択
3. Cloud Agent が起動 (Issue にコメントが付き、PR が作成される動き)

CLI で可能なら:
```bash
gh issue edit $ISSUE --add-assignee copilot
```

### Step C. Cloud Agent の挙動を観測

期待される動作 (実機で確認したい仮説):
- Cloud Agent が `.github/skills/triage-issue/SKILL.md` を発見し description で trigger 判定する
- ラベルとコメントを付ける (もしくは Draft PR で Skill 利用を提案する)
- commit が **Verified** バッジ付き (Signed Commits)

### Step D. 観測ポイント

| 観測項目 | 場所 |
|---|---|
| Skill が選ばれたか | Cloud Agent の plan / コメント本文 |
| ラベル付与 | Issue page |
| greeting コメント | Issue page |
| Signed Verified Commit | (PR が出た場合) commit list の Verified バッジ |

## 4. 記録 (RESULT.md)

- Cloud Agent のセッションログ URL
- Skill が trigger された証拠 (Agent が `triage-issue` を言及した発言など)
- Issue の最終状態スクリーンショット
- Verified commit のスクリーンショット (出た場合)

## 5. PASS 基準 (Phase 01 §3 E4)

- [ ] Cloud Agent が triage-issue Skill を選んだ証拠が取れる
- [ ] ラベル付与またはコメント投稿のいずれかが成立
- [ ] (任意) Signed Verified Commit を確認

## 6. FAIL / 縮退ストラテジ

Cloud Agent が SKILL.md を **直接実行する** モデルではないことが判明している (Master Plan §technical_details)。
そのため "Cloud Agent が skill を選んで使う" という体験が観測できない場合の縮退案:

| 観測結果 | 教材方針 |
|---|---|
| ✅ Cloud Agent が skill を発見・利用した | Step 3 で「Cloud Agent も同じ Skill を使う」と教える (理想形) |
| △ Cloud Agent は Skill を直接利用しないが、`triage-issue` の意図に沿った行動を取った | Step 3 で「Cloud Agent は Issue assign で起動し、Skill を参照しながら作業する」と教える |
| ❌ Skill が無視された | Step 3 を「Cloud Agent と CLI Agent の体験を分けて教える」に再設計 (Master Plan §6 R5 発動) |
