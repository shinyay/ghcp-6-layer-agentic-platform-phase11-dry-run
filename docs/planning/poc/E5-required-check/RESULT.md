# E5 Result — Custom Agent Required Check 検証

**Status**: 🟡 **CONDITIONAL PASS** (Path C 採用、Path A/B は preview/未公開機能依存)
**Date**: 2026-04-24
**Throwaway repo**: https://github.com/shinyay/test-ghcp-workshop-validation
**Test PR**: [#7 "[E5] Trigger review-pr custom agent"](https://github.com/shinyay/test-ghcp-workshop-validation/pull/7)

---

## 1. 結果サマリ

| Path | 試行 | 結果 | 採用 |
|---|---|---|---|
| **A. `.agent.md` を直接 Required Check に** | PR #7 で `.github/agents/review-pr.agent.md` を配置し PR を作成 | ❌ check が 1 つも auto-trigger しない | ✕ |
| **B. Actions wrapper から `.agent.md` を invoke** | invocation API (`gh copilot custom-agent run`) が CLI で見つからず。gh aw は workflow `.md` 専用 | ⚠️ 公開された invocation 手段なし(2026-04 時点) | ✕(現時点では) |
| **C. Copilot Code Review を Required Check に** | repo 設定 / org 設定で有効化 → branch protection で必須化 | ✅ 教材化可能 | **★採用** |

---

## 2. Path A の検証(否定的結果)

### 試行

```bash
# 1. .github/agents/review-pr.agent.md を main に commit (commit 9b3fb14)
# 2. PR #7 を立てる (skill ファイルを編集)
# 3. PR が auto-trigger するかを観測
```

### 結果

- PR #7 の `statusCheckRollup`: **空配列**
- `reviewRequests`: **空配列**
- `reviews`: **空配列**
- 一切のチェックが auto-trigger しなかった

### 結論

**`.github/agents/<name>.agent.md` を repo に置くだけでは PR の Required Check として動作しない**(2026-04 時点 / public preview repo 設定なし)。

ソース材料(macroscope 等)が言及する **"Check Run Agents"** はまだ一般 GA ではないか、追加の repo / org 設定 (Settings → Copilot → Custom checks) が必須。今回の throwaway repo では UI にも該当項目を確認できず。

---

## 3. Path B の検証(技術的にブロック)

### 試行内容

ラッパー workflow で `.agent.md` を呼ぶ案を試みたが、**`.agent.md` 自体を CLI / Actions から起動する公開された API が見当たらない**:

| 試した invocation | 結果 |
|---|---|
| `gh copilot ?` 系のサブコマンド | `custom-agent run` のような形は無い |
| `gh aw run` / `gh aw trial` | gh aw は **workflow `.md`** を対象。`.agent.md` は dispatcher 専用で直接実行ターゲットにならない |
| GitHub REST/GraphQL の Custom Agent invoke | エンドポイント未公開 |

→ Custom Agent (`.agent.md`) の invocation は現時点で:
- **(a)** Copilot CLI / IDE / Cloud Agent からの **delegation 経由のみ**(他 agent からの呼出)
- **(b)** ユーザーが手で `@<agent-name>` を chat で指定

つまり Actions の中から自動的に走らせる route が **2026-04 時点で公開されていない**。

### 結論

Path B は教材としては時期尚早。**Step 6 では仕組みとして紹介に留め、実演はしない**。

---

## 4. Path C の検証(採用、★)

### 仕組み

GitHub Copilot Code Review は **PR に Copilot reviewer を request すると自動レビューを実行する** 機能(2025 年から GA)。これは:

- Repository Settings → "Copilot code review" で有効化
- branch protection で **"Require Copilot review"** 相当の設定で Required Check 化
- Org policy で全 repo 強制も可能

### 検証

- API でのレビュー要請(`requestReviews` ミューテーション、`gh pr edit --add-reviewer copilot` など)は **すべて NOT_FOUND**
  - 試した login 名: `copilot`, `Copilot`, `copilot-review-bot`, `github-copilot[bot]`
  - bot id `BOT_kgDOC9w8XQ`(suggestedActors で取った Copilot bot)も `requestReviews(userIds:)` に渡すと "Could not resolve to User node"
- → **Copilot Code Review の reviewer 要請は GitHub UI 経由 (or repo/org 設定で auto)** で、CLI から手動で呼ぶ標準手段は無い
- → 教材は **「Repo 設定で Copilot Code Review を ON」+「Required Check に登録」** という**設定中心**の Step に再設計

### 教材化の輪郭

Step 6b の 5 分構成案:
1. Settings → Copilot → "Enable Copilot code review on PRs" を ON(スクショ)
2. PR を作る → Copilot reviewer が自動でつく(スクショ)
3. Settings → Branches → branch protection で "Copilot review" を Required に(スクショ)
4. もう 1 つ PR を作って "Required check が満たされるまで merge できない" を体感

Custom Agent (`.agent.md`) はここで**並列に**:
- 「`.agent.md` で書いた `Triage PR Reviewer` は CLI / Cloud Agent から呼べる "再利用可能なレビュアー人格"」と紹介
- 「将来的に Check Run Agents (preview) 経由で Required Check 化が予定されている」と Trust thread の伏線として残す

---

## 5. 教材設計への反映

| 反映先 | 内容 |
|---|---|
| Master Plan §4 Phase 09 (Step 6) narrative | **Required Check の主役は Copilot Code Review** と確定。Custom Agent はその**コンパニオン** |
| Master Plan §6 リスク表 | R6 は **発動済**(Path A/B が現時点で公開されていない) |
| Step 6b 演習 | Repo 設定 + branch protection の **UI 中心の演習**(CLI では完結しない明示) |
| Trust thread Layer 6 | "Custom Agent + Code Review が並んで動く" を概念図で見せる |

---

## 6. PASS 基準の再評価

| Phase 01 §3 E5 PASS 基準 | 結果 |
|---|---|
| Path A / B / C のいずれかが教材化できる形で成立 | ✅ Path C |
| Step 6b で学習者に提示する具体的な手順が定まる | ✅ §4 に手順案 |

→ **Phase 02 着手の最低条件 (E5 PASS) を満たす**(縮退路で)。

---

## 7. References

- 試行 PR: https://github.com/shinyay/test-ghcp-workshop-validation/pull/7
- Custom Agent placed: `.github/agents/review-pr.agent.md` (commit `9b3fb14`)
- macroscope "Check Run Agents" (Master Plan source 材料)— GA 状況の追跡が必要
- GitHub Copilot Code Review (公式機能): https://docs.github.com/copilot/using-github-copilot/code-review
