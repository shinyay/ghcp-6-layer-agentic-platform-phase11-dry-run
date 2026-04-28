# E4 Result — Cloud Agent + SKILL.md 連携検証

> [!WARNING]
> **⚠ Superseded by E7' (2026-04-25) for trigger truth**: 本 PoC の **動作根拠 (Skill discovery + utilization + firewall thread + Verified Signed Commits)** は引き続き有効ですが、**Cloud Agent の正規起動方法は Issue Assignees → Copilot (Web UI 推奨) が main path** に変わりました。本ドキュメントの `gh issue edit --add-assignee copilot-swe-agent` (CLI 1 行) は env-dependent (`Bot does not have access to the repository` で fail することあり) のため教材では TIP 扱い。最新の起動条件は [`docs/planning/VERSIONS.md` §2.7.7 / §2.8](../../VERSIONS.md#277-cloud-agent-起動条件-e7-で確定) を参照してください。

**Status**: ✅ **PASS** (Skill discovery + utilization confirmed) + 🎁 **BONUS findings** (firewall thread)
**Date**: 2026-04-24
**Throwaway repo**: https://github.com/shinyay/test-ghcp-workshop-validation
**Issue used**: [#5 "Help: how to enable verbose logs?"](https://github.com/shinyay/test-ghcp-workshop-validation/issues/5)
**PR produced**: [#6 "Triage issue #5 as `question`"](https://github.com/shinyay/test-ghcp-workshop-validation/pull/6)

---

## 1. 結果サマリ

| PASS 基準 | 結果 | 証拠 |
|---|---|---|
| Cloud Agent が SKILL.md を選んだ証拠 | ✅ | PR title が SKILL の workflow に完全一致 / category enum (`question`) を SKILL から正しく選択 |
| ラベル付与またはコメント投稿が成立 | ✅(コードとして) | PR が label + comment を行う workflow を生成。merge で実行される |
| Signed Verified Commits | ✅ | 両コミット `verified: true, reason: valid` (`copilot-swe-agent[bot]`) |

---

## 2. Cloud Agent 起動方法 (CLI で完結)

```bash
# Issue 作成
gh issue create --title "Help: how to enable verbose logs?" --body "..."

# Cloud Agent (copilot-swe-agent) を assign — bot login 名で OK
gh issue edit 5 --add-assignee copilot-swe-agent
# (`@copilot` でも assign される)
```

検証: `gh api graphql` で `suggestedActors(capabilities: [CAN_BE_ASSIGNED])` を叩くと、3 つの coding agent bot が並ぶ:

```
copilot-swe-agent       (Copilot Coding Agent)
anthropic-code-agent    (Claude)
openai-code-agent       (Codex)
```

→ **これは Layer 5 (Agent HQ) の最強の現物デモ**。教材で「同じ Issue に Claude や Codex を assign してみよう」とすると、聴講者は Multi-Engine を体感できる。

---

## 3. 発見 #1 ★★★ — Cloud Agent は SKILL.md を発見し正しく解釈する

PR #6 の最終 title:

> **Triage issue #5 as `question` — add label and greeting comment via workflow**

PR body の作業ログ:

> - [x] Read and analyzed issue #5 "Help: how to enable verbose logs?"
> - [x] Classified issue as **question** category (user asking how to configure verbose logging)
> - [x] Created `.github/workflows/apply-triage-issue-5.yml` workflow that:
>   - Adds the `question` label to issue #5
>   - Posts a greeting comment confirming the **question** category

**証拠の質**:
- SKILL.md `description`: *"picks one category label (bug, feature, question, docs), and writes a short greeting comment that confirms the category"*
- Cloud Agent の出力: ↑ をほぼ rephrase で再現 — **enum も "greeting" も SKILL から literal に拾われている**

**生成されたコメント本文**(SKILL の `description` 文と意味的に対応):

```
👋 Thanks for opening this issue!

I've categorized this as a **question** — you're asking how to configure verbose logging.

If you can share more context (e.g., which application or runtime, any existing config files),
we can point you to the right configuration option.
```

→ **Step 3 の最終 narrative は確定**: 「同じ SKILL.md を CLI も Cloud Agent も使う」が**現実に動く**。

---

## 4. 発見 #2 ★★★ — Cloud Agent の **環境は firewall に守られている**(Trust thread)

PR #6 body の警告ブロックに、Cloud Agent 自身の作業ログが完全に開示されていた:

> Firewall rules blocked me from connecting to one or more addresses
> - `https://api.github.com/graphql` (gh issue view 5)
> - `https://api.github.com/repos/.../issues/5/labels` (POST で label 追加を試行)
> - `https://api.github.com/user`
> ...

つまり: **Cloud Agent は直接 GitHub API を叩こうとした → firewall でブロックされた → "じゃあ Actions の中で叩く workflow を書こう" と方針転換**。

これが **Trust thread の最強の現物**:
- Cloud Agent は repo の中で動くが、**外部ネットワークアクセスは firewall で制御される**
- 必要なら admin が allowlist を編集 (`/settings/copilot/coding_agent`)
- → "勝手に動く" は実は **"行動範囲が制約された中で動く"**

これを keynote の「ガードレール」セクションに **そのまま** スクショで使える。

---

## 5. 発見 #3 ★★ — Cloud Agent は "コードを納品する" 振舞

直感: 「Skill を読んだら、Agent が直接 label を付けてコメントを書く」  
実際: **Agent は workflow ファイルを書いて PR を出した**

理由は #4 の firewall。だが教材的には**むしろ良い**:

| 教える内容 | 効果 |
|---|---|
| Cloud Agent は **review ageable な PR を作る** が本質 | "Plan / Diff / Approve" の文化を強調できる |
| 直接実行ではなく **infrastructure を整える** | DevOps 文脈にもハマる |
| **Self-review チェックリスト**(PR body の `[x]` 形式)も自動生成 | Layer 6 (Code Review Agent) への伏線 |

→ Step 3 narrative: 「CLI Agent は今その場で動かす、Cloud Agent は repo に変更を提案する」と区別して教える。

---

## 6. 発見 #4 ★★ — Cloud Agent は **既存の gh aw workflow も読んで理解した**

PR #6 body 抜粋:

> The existing `triage-issue.lock.yml` agentic workflow was supposed to handle this automatically
> but fails because `COPILOT_GITHUB_TOKEN` is not set in the repository.

**Cloud Agent は repo を全体で把握し、E3 で配置した gh aw workflow の存在と失敗理由まで認識**して PR description に書いている。これは:
- repo 横断的な context 把握能力の現物
- 教材で「Layer 4 と Layer 3 が同じ repo 上で交差する」シーンに使える

---

## 7. 発見 #5 ★★ — Signed Verified Commits 動作確認

```bash
$ gh api repos/.../commits/b4b4e68 --jq '.commit.verification'
{ "author": "copilot-swe-agent[bot]", "verified": true, "reason": "valid" }

$ gh api repos/.../commits/5501ef3 --jq '.commit.verification'
{ "author": "copilot-swe-agent[bot]", "verified": true, "reason": "valid" }
```

→ keynote 主張「Signed Verified Commits 対応 (2026-04)」は **現物で確認済**。
branch protection で `Require signed commits` を有効化しても Cloud Agent はマージ可能。

---

## 8. PROCEDURE 訂正

| 項目 | 修正前 | 修正後 |
|---|---|---|
| assign 手順 | UI から `Copilot` 選択 | **CLI で `gh issue edit N --add-assignee copilot-swe-agent` で完結** |
| 期待される動作 | 「ラベル付与 / コメント / Verified Commit」 | **「ラベル / コメントを行う workflow を含む Verified Draft PR」** が正解 |
| firewall 言及 | なし | **追加必須** — 教材で Trust thread の柱になる |
| Multi-Engine 言及 | なし | **追加** — `suggestedActors` クエリで Claude / Codex も可視化できる |

---

## 9. 教材設計への反映 (Master Plan §4 Phase 06 / 07 で確定)

| 反映先 | 内容 |
|---|---|
| Step 3 narrative | 「Cloud Agent は SKILL.md を解釈して PR を提案する」と確定 |
| Step 3 アクティビティ | `gh issue edit --add-assignee copilot-swe-agent` を 1 行で実演 |
| Trust thread Layer 3 | firewall の存在を 1 スライドで強調 |
| Trust thread Layer 3 | Signed Verified Commit を スクショで提示 |
| Layer 5 (Agent HQ) 補足 | `suggestedActors` GraphQL を発展教材として提示 |

---

## 10. References

- Issue #5: https://github.com/shinyay/test-ghcp-workshop-validation/issues/5
- PR #6: https://github.com/shinyay/test-ghcp-workshop-validation/pull/6
- Cloud Agent run (success): https://github.com/shinyay/test-ghcp-workshop-validation/actions/runs/24872727285
- Branch: `copilot/configure-verbose-logging`
- Commits: `13273d9` (Initial plan) → `b4b4e68` (workflow追加) → `5501ef3` (idempotency 改善)
