# E1 Result — GitHub MCP Server 接続検証

**Status**: ✅ **PASS**
**実施日**: 2026-04-24
**実施者**: ユーザー (shinyay) 手動実行
**throwaway repo**: https://github.com/shinyay/test-ghcp-workshop-validation
**環境**: Codespaces + VS Code + Copilot Chat (GitHub MCP Server: Remote MCP `https://api.githubcopilot.com/mcp/`)

---

## 1. 検証結果サマリ

| PASS 基準 (PROCEDURE §3 / Phase 01 §3 E1) | 結果 | 証拠 |
|---|---|---|
| Codespaces から MCP 経由で Issue 取得成功 | ✅ | `mcp_github_list_issues` が 8 件返却(repo `shinyay/test-ghcp-workshop-validation`, state OPEN) |
| ラベル追加成功 | ✅ | `mcp_github_issue_write` で issue #8 に `bug` ラベル付与 |
| コメント追加成功 | ✅ | `mcp_github_add_issue_comment` で issue #8 にコメント追加 |
| ツール承認 UI が出る (Trust thread の伏線) | ✅ | Chat 上に "Ran <tool name>" 表示 |

→ **全 PASS 基準を満たした。Phase 02 着手の必須条件 (Phase 01 §6.3) クリア。**

---

## 2. 確認できた MCP tool 名(教材で言及するもの)

| Chat 上の tool 表示 | 用途 | 教材での扱い |
|---|---|---|
| `mcp_github_list_issues` | open/closed Issue 一覧取得 | Step 0 で最初に呼ばせる代表ツール |
| `mcp_github_issue_write` | Issue 編集 (label 追加/state 変更/etc.) | Step 0 で triage アクション(label 付与)に利用 |
| `mcp_github_add_issue_comment` | Issue にコメント投稿 | Step 0 で triage 結果の通知に利用 |

> 命名は GitHub Copilot Chat 側の MCP tool 名 (`mcp_github_*` プレフィックス)。
> `add_label` 単独ではなく **`issue_write`** で更新系がまとめられている設計を確認 — 教材でも「label 追加 = issue_write の 1 オプション」として説明する。

## 3. 観測事実

- Remote MCP (`https://api.githubcopilot.com/mcp/`) は **PAT なし** で動作 (Codespaces の OAuth が透過的に効いている)
- ツール承認ダイアログは各 tool の初回呼び出しで表示 → 承認後はセッション内で再利用された(Trust thread の教材化に十分)
- レスポンスは体感数秒以内、教材の流れを止めない

## 4. 教材設計への反映

1. **Step 0 (Cloud / IDE 初接続)** で必ず `mcp_github_list_issues` を最初に投げる構成にする(承認 UI を必ず受講者に体験させる)
2. **Trust thread**: 「ツール承認 = Agent に許可する範囲を決める瞬間」を Step 0 のキーメッセージにする
3. **Layer 0 訴求**: PAT 不要で接続できる事実は受講者の心理的障壁を大きく下げる → keynote の "5 分で動く" デモに使える

## 5. 残タスク

- [ ] 重複 seed Issue (#1/#8, #2/#9, #3/#10) は将来の E4 再 trigger 前に `gh issue close 1 2 3` で掃除推奨(任意)
- [ ] Docker 方式 (`docker run -i --rm ghcr.io/github/github-mcp-server:latest`) の代替検証は **Phase 02 以降の Codespaces 環境組み立て時** に実施(現時点では Remote MCP のみで Step 0 が成立するため pending)

## 6. Phase 02 着手判定への影響

| 実験 | 状態 | Phase 02 着手最低条件 |
|---|---|---|
| **E1** | ✅ PASS | ✅ 必須 → クリア |
| E2 | ✅ PASS | — |
| E3 | 🟡 PARTIAL | 推奨 (PAT 後完走) |
| E4 | ✅ PASS | 任意 → クリア |
| E5 | 🟡 CONDITIONAL PASS (Path C) | 任意 |
| E6 | ⏳ PENDING | 任意 |

→ **Phase 02 (Step 0 教材化) の着手 GO**。E3 完走と E6 確認は並行進行で可。

---

## 7. 2026-04-25 Phase 03 dry-run regression note

> **本節は §1 PASS 結論を変更しない**。Remote MCP `https://api.githubcopilot.com/mcp/` が動作する事実は不変。本節は **registration 経路** が観測日 1 日差で変化したことを補足する追記である。

### 7.1 観測差分 (1 日で変化)

| 観測日 | 環境 | `.vscode/mcp.json` | Copilot Chat の挙動 |
|---|---|---|---|
| 2026-04-24 (E1 検証) | `shinyay/test-ghcp-workshop-validation` (throwaway) | **不在** | `mcp_github_*` を **自動検出**、Tools palette に露出 (本節 §1 の PASS 根拠) |
| 2026-04-25 (Phase 03 dry-run) | `shinyay/ghcp-6-layer-agentic-platform-phase3-dry-run` (template から作成) | **不在 (template から伝播せず)** | 自動検出されず、Agent が **`gh` CLI フォールバック** で triage を実行 (Trust thread 完全スキップ) |

### 7.2 仮説

- VS Code Copilot Chat 拡張のバージョン更新で **MCP server の registration ポリシー** が「auto-detect 許容」から「manifest 必須 (= `.vscode/mcp.json`)」に変化した可能性が高い。
- Copilot Chat 拡張の release notes は未確認 (Phase 11 の再検証時にバージョン履歴と突き合わせて確証する)。

### 7.3 解消手段 (Phase 03 で実施済み)

- workshop repo (= template source) に `.vscode/mcp.json` を新設し、`github` server を pin (commit `b9977c0`):
  ```json
  { "servers": { "github": { "type": "http", "url": "https://api.githubcopilot.com/mcp/" } } }
  ```
- template-create 経由で playground にも `.vscode/mcp.json` が伝播 → Phase 03 dry-run 再検証で MCP 経由完走確認 (commit `2012cc2`)。

### 7.4 Phase 04+ への影響

- 本 regression は MCP を利用するすべての Step (Step 0 / Step 4 / Step 6 等) に波及する。
- 対処は `00-master-plan.md §4.5.2` で **MCP verification block 必須条文** として標準化済 (Phase 03 真クローズ後に追加)。
- 本節の挙動差は `learnings.md §9.1` に教材化方針付きで記録。

### 7.5 結論

- §1 の **PASS 判定は維持**。Phase 02 着手 GO 判断にも影響なし。
- registration 経路の変化のみが本節の追加情報。Phase 11 で再検証時に Copilot Chat 拡張バージョンと突き合わせ、本節の仮説 (7.2) を確証または修正する。

→ Source: `phase-03-step0.md §10` (C6 hotfix), `learnings.md §9.1`, `00-master-plan.md §6.2 R13`
