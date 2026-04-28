# Pinned Versions / 検証時点の権威ソース

> **Purpose**: Phase 01 で実機検証した時点の各技術スタックの版を pin し、教材コンテンツ (後続 Phase) で参照する authoritative source とする。
> **Updated**: Phase 01 進行中 (進捗ごとに加筆)

---

## 1. リポジトリと commit SHA

| 技術 | リポジトリ | 検証時 ref / commit | 備考 |
|---|---|---|---|
| GitHub MCP Server | `github/github-mcp-server` | (E1 で確定) | Codespaces 既定の Remote MCP `https://api.githubcopilot.com/mcp/` を使用 |
| Skills (samples) | `github/awesome-copilot` | `63d08d51` | `skills/acquire-codebase-knowledge/SKILL.md` を spec の参考実装とする |
| Custom Agents (samples) | `github/awesome-copilot` | `63d08d51` | `agents/CSharpExpert.agent.md` を `.agent.md` の参考実装とする |
| gh aw workflows (samples) | `github/awesome-copilot` | `63d08d51` | `workflows/daily-issues-report.md` を triage シナリオの土台にする |
| gh aw CLI extension | `github/gh-aw` | **`v0.68.3` (実機 install で確定)** | Technical Preview。`install-gh-aw.sh` でインストール |
| gh CLI | host installation | `2.90.0` (2026-04-16) | `install-gh-aw.sh` で gh extension として導入される |

> [!IMPORTANT]
> **gh aw は Technical Preview**。教材執筆時は spec が変動する可能性があるため、Phase 11 で必ず再検証する (Master Plan §6 R6)。
>
> **Phase 07 publish 時点 (2026-04-26) で v0.68.3 spec PASS を再確認済** (E9 ユーザー手動完走 marker、E3 RESULT §8.2 / §8.4 ベース)。Phase 11 で v0.69+ への drift (生成ファイル数 / safe-outputs キー / Copilot Requests permission UI 表記 / `workflow_dispatch.inputs` パターン挙動) を再検証必須。
>
> **Phase 08 完了 (2026-04-26)**: `engine` stanza spec drift checklist (R6 sub-risk) を本 §1 に集約。`engine: claude` / `engine: codex` の **canonical syntax (scalar `engine: claude` vs object `engine:\n  id: claude`)**、期待 secret 名 (`ANTHROPIC_API_KEY` canonical / `OPENAI_API_KEY` canonical + `CODEX_API_KEY` accepted alternative)、`.lock.yml` 出力差分 — いずれも Phase 08 C2b dogfooding discovery で確定済の built-in 設計、`.lock.yml` 内 secret 参照名のみ Phase 11 dogfooding で実機確定。
>
> **Phase 08 C2c (truth migration 後段、2026-04-26) で確定**: Phase 08 内 dogfooding は **教材 repo の構造検証範囲に限定** (= API key を本 repo に登録しない D14 / Trust thread 制約により、実機 `engine: claude` / `engine: codex` invocation は本 Phase スコープ外)。**本 Phase での確定値**: ① canonical syntax は **scalar (`engine: claude`) と object (`engine:\n  id: claude`) の両形 OR を canonical として publish**、step-5-gate Group A regex も両形 OR で実装 (D08-13)、`model` / `version` 併記必要時のみ object 形に切替を推奨 ② 期待 secret 名 = `ANTHROPIC_API_KEY` (Claude canonical) / `OPENAI_API_KEY` (Codex canonical) / `CODEX_API_KEY` (Codex accepted alternative、gh-aw 側で優先される実装の場合あり) ③ `.lock.yml` 内 secret 参照名 = **Phase 11 dogfooding で実機確定** (S11-* / 旧 S10-* 申し送り)。**Phase 11 で v0.69+ drift 再検証** (`gh aw version` / `gh aw compile` / `safe-outputs` キー一覧 / `.lock.yml` 構造 / **engine stanza canonical 単形収束有無**) 時に本項を必ず再評価。

---

## 2. SKILL.md frontmatter (確定 spec)

実物 (`github/awesome-copilot@63d08d51:skills/acquire-codebase-knowledge/SKILL.md`) より:

```yaml
---
name: acquire-codebase-knowledge        # 必須: kebab-case 識別子
description: 'Use this skill when ...'  # 必須: いつ使うかの自然言語ガイダンス (model trigger)
license: MIT                             # 任意
compatibility: 'Cross-platform. ...'     # 任意: ランタイム要件
metadata:                                # 任意
  version: "1.3"
  enhancements:
    - ...
argument-hint: 'Optional: ...'           # 任意: invocation 時のヒント
---
```

**教材で必須として教える 2 フィールド:** `name`, `description`
**教材で推奨として教える 2 フィールド:** `license`, `metadata.version`

理由: 最小教育コストで spec 変動への耐性を持つ (description が trigger になるという仕組みは安定)。

---

## 2.5 GitHub MCP Server tool 名 (Phase 01 / E1 検証時点スナップショット)

> **検証日**: 2026-04-24 (E1 RESULT) / **2026-04-25 Phase 03 dry-run 反映** (registration regression を §2.5.1 で記録)
> **endpoint**: `https://api.githubcopilot.com/mcp/` (Codespaces から remote 利用)
> **PAT**: 不要 (VS Code Copilot サインインの OAuth セッションを継承)
> **目的**: Step 0 教材 (mini-triage) で利用する 3 ツールを pin し、tool 名 rename / registration 仕様変動 (Phase 03 R13) に備える

### 2.5.1 registration (★ Phase 03 dry-run で挙動変化発覚)

workshop repo (= template) と playground repo の両方に **以下を必ず同梱** する (template から作った playground にも自動伝播):

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```

- ファイルパス: `.vscode/mcp.json`
- **必須化の経緯**: E1 検証 (2026-04-24) では `.vscode/mcp.json` 不在でも Copilot Chat が **auto-detect** していた。Phase 03 dry-run (2026-04-25) では auto-detect が消失、Agent が `gh` CLI フォールバックする regression を観測。Copilot Chat 拡張バージョン更新が原因と推定 (Phase 11 で確証予定)。
- **正規版**: `E1-mcp/RESULT.md §7` (regression note) / `learnings.md §9.1` / `00-master-plan.md §6.2 R13`

### 2.5.2 tool 名 (短形 / E1 観測形 両表記)

| ツール名 (短形) | E1 観測形 (Chat 上 prefix 付) | 用途 | Step 0 での出現 |
|---|---|---|---|
| `list_issues` | `mcp_github_list_issues` | open / closed Issue を一覧取得 | mini-triage 手順 E (1 回目の承認) |
| `update_issue` | `mcp_github_issue_write` (E1) / `mcp_github_update_issue` (Phase 03 dry-run) | label 付与 / state 変更 / assignee 変更 | mini-triage 手順 E (2 回目の承認) |
| `add_issue_comment` | `mcp_github_add_issue_comment` | Issue にコメント追加 | mini-triage 手順 E (3 回目の承認) |

> [!IMPORTANT]
> 上記ツール名は **VS Code Copilot Chat の承認ダイアログ** および **Chat が出力するツール呼び出しログ** で観測した実値。
> Phase 03 dry-run (2026-04-25) で `update_issue` の観測形が **`mcp_github_issue_write` → `mcp_github_update_issue`** に変化したことを確認 (= MCP server 側の rename ドリフト)。
> 教材本文では「**`list_issues` のような名前のツール**」のように **正規表現的記述** を併用して将来の rename にも形が残るようにする。Phase 11 dogfooding で再検証する。

### 2.5.3 認証 3 層モデル (★ Phase 03 dry-run で整理)

PAT 不要は不変だが、ダイアログは **3 種類** 出る (受講者が「PAT 不要 = ダイアログ 0 回」と誤解しないよう教材で明示):

| Layer | いつ出るか | 何を承認するか | 頻度 | Step 0 該当箇所 |
|---|---|---|---|---|
| **Layer 1: Copilot サインイン** | Codespaces 起動直後 | VS Code → GitHub アカウント連携 | 初回のみ | §3.B |
| **Layer 2: MCP server OAuth** | `github` server を初めて ON にしたとき | MCP server → GitHub API への OAuth スコープ付与 | 初回のみ (セッション継承) | §3.C-2 |
| **Layer 3: Tool 実行 Allow** | Agent が各 MCP ツールを初めて呼ぶたびに | そのツール (label / comment / etc.) | 各ツール初回 (= **Trust thread の本命**) | §3.E (mini-triage で 2-3 回) |

> [!IMPORTANT]
> Layer 2 の OAuth ダイアログを **Cancel** すると `github` server は **未認証状態** になり、Tools palette に出ても呼び出せない (= F4 のフォールバック症状を別経路で誘発)。教材 §5 Troubleshooting で「Cancel した場合の復旧手順」を提示する。
> 詳細根拠: `learnings.md §9.2 / §9.3`

---

## 2.6 Copilot Memory tool / パス (Phase 04 / Step 1 検証時点スナップショット)

> **検証日**: 2026-04-25 (Phase 04 着手時、E6 RESULT 経路を踏襲)
> **検証クライアント**: VS Code **Insider** + GitHub Copilot Chat (Pro+ プラン)
> **目的**: Step 1 教材で利用する Memory コマンド名と物理ファイルパスを pin し、Public Preview 段階の changelog drift (R04-1) に備える
> **Stable 動作**: 未検証 (E6 §5.5)。下記 fallback パス併記で対応、Phase 11 dogfooding で Stable 経路を再検証予定

### 2.6.1 主導線コマンド (★教材の入口)

| コマンド名 | 役割 | 教材本文での出現 |
|---|---|---|
| `Chat: Show Memory Files` | Copilot Chat が現在保持している全 Memory ファイルを一覧表示 | Step 1 §3.B (主導線) / §3.5 / §4 |

> [!IMPORTANT]
> 教材本文では **このコマンド名を主導線** にする (= 直接パスを記憶しなくても辿り着ける UX)。直接パスは fallback として §5 で提示。これにより Stable / Insider 差分や将来パス変更の影響を最小化する。

### 2.6.2 物理ファイルパス (fallback、Insider / Stable 別)

Memory は Copilot Chat 拡張のクライアントローカル状態として、以下のファイル構造で書かれる。`<workspace-id>` は環境ごとに異なる Hash 値:

| スコープ | Insider 経路 (検証済) | Stable 経路 (見込み) |
|---|---|---|
| **Global (User)** | `~/.vscode-server-insiders/data/User/globalStorage/github.copilot-chat/memory-tool/memories/preferences.md` | `~/.vscode-server/data/User/globalStorage/github.copilot-chat/memory-tool/memories/preferences.md` |
| **Repo (Workspace)** | `~/.vscode-server-insiders/data/User/workspaceStorage/<workspace-id>/GitHub.copilot-chat/memory-tool/memories/repo/<auto-named>.md` | `~/.vscode-server/data/User/workspaceStorage/<workspace-id>/GitHub.copilot-chat/memory-tool/memories/repo/<auto-named>.md` |

実値発見コマンド (環境共通):
```bash
find ~/.vscode-server*/data -path '*memory-tool*' -name '*.md' 2>/dev/null
```

### 2.6.3 Chat 上のトレース表記 (★Trust thread の核)

| 操作 | Chat 応答冒頭に出る表記 | 教材本文での出現 |
|---|---|---|
| Memory 植え付け | `Created memory file [<path>]` | Step 1 §3.A |
| Memory 参照 | `Read memory [<path>]` | Step 1 §3.C |

> [!NOTE]
> いずれもクリック可能なリンク付き。学習者が「効いた!」を **2 重 (Chat ログ + ファイル中身)** で実感する核。
> 詳細根拠: `learnings.md §5.1 / §5.3` / `poc/E6-memory/RESULT.md §3 / §4`

### 2.6.4 スコープ自動判別の振り分けルール (E6 §2.2 観測)

Copilot は植え付け prompt の文脈から **スコープを自動判別** する:

| 入力例 | 自動判定 | 保存先 |
|---|---|---|
| 「**このリポジトリでは** Issue タイトルに [bug]/[feat]/[docs] prefix」 | **Repo** スコープ | `repo/issue-conventions.md` (auto-named) |
| 「コミットメッセージは Conventional Commits を使います」 | **Global (User)** スコープ | `preferences.md` |

> [!IMPORTANT]
> Step 1 §3.D で 2 種類の入力を順に試させ、**「Copilot は repo 文脈の有無で振り分けを変える」** という発見を実機で体験させる構成にしている。

### 2.6.5 Memory 削除 / リセット (プライバシー)

UI 経由の削除コマンドは未確認 (E6 §6)。物理ファイル削除でリセット成立:

```bash
# 特定 Memory だけ削除
find ~/.vscode-server*/data -path '*memory-tool*/repo/issue-conventions.md' -delete

# 全 Memory リセット (大胆版)
find ~/.vscode-server*/data -type d -name 'memory-tool' -exec rm -rf {} +
```

教材本文では Step 1 §3.5 (プライバシー独立節) でこの手順を提示し、Trust thread (= 「Agent に何を覚えさせ / 覚えさせないか」を握る) の延長として位置付ける。

---

## 2.7 SKILL.md spec / path (Phase 05 / Step 2 検証時点スナップショット)

> **検証日**: 2026-04-25 (Phase 05 着手時、E2 RESULT §3 + E7-cli-skill RESULT を権威ソースとして継承)
> **目的**: Step 2 教材で扱う SKILL.md frontmatter の必須/任意キーと、Copilot Chat / CLI の両方が認識する project skill path を pin し、Public Preview / Active development 段階の changelog drift (R05-1) に備える

### 2.7.1 frontmatter — 教材で教えるフィールドセット

E2 RESULT §3.2 を継承 (再掲):

| 段階 | フィールド | Step 2 で扱うか |
|---|---|---|
| **必須 (Step 2 で教える)** | `name`, `description` | ✅ §3.B で必須提示 |
| **推奨 (Step 6 までに教える)** | `license`, `metadata.version`, `compatibility` | ❌ Step 2 では出さない、§6 で予告のみ (Step 6 = Required Check で資産化レビュー時) |
| **発展 (出さない)** | `argument-hint`, `metadata.enhancements` | ❌ |

> [!IMPORTANT]
> **`description` 自体が trigger を兼ねる** (= 別途 `when_to_use` のような専用キーは存在しない)。Web 検索結果に時々ハルシネーションで出る `when_to_use` / `trigger` キーは公式リポの実物に存在しないため教材で扱わない。

#### 2.7.1.1 YAML 構文 4 要件 (E7 walkthrough で確定)

教材で配布する SKILL.md template は **以下 4 つを必ず満たすこと** (どれを外しても `gh copilot` の `/skills list` から消える):

| # | 要件 | 違反した場合 |
|---|---|---|
| 1 | **`---` は列 0 (行頭) 配置** | heredoc / paste で行頭 space が混じるとパース失敗 (F8/F9/F10/F11/F12 主因) |
| 2 | **`description: >-` (folded scalar with strip chomping) を使用** | 1 行 quoted で長文 → エディタ折り返しコピー時に物理改行混入 |
| 3 | **`description:` 直下から 2-space indent** | indent ずれでパース失敗 |
| 4 | **物理改行 (CR/LF) 禁止** | `cat -A SKILL.md` で `^M$` が見えたら NG (`dos2unix` で除去) |

> canonical template: [`docs/planning/poc/E7-cli-skill/templates/SKILL.md`](poc/E7-cli-skill/templates/SKILL.md) (folded scalar 版、列 0、2-space indent、repo 既存 label `bug` / `enhancement` / `question` / `documentation` 採用)。`gh api repos/<owner>/<repo>/contents/<path> -H "Accept: application/vnd.github.raw"` で取得 (private repo で `raw.githubusercontent.com` が anonymous 404 になる対策、F13)。

### 2.7.2 path 階層 (Copilot CLI が認識する 3 階層、E7-cli-skill PoC で確定)

| 階層 | パス | Step 2 教材で扱うか |
|---|---|---|
| **Project (repo)** | `.github/skills/<name>/SKILL.md` | ✅ **Step 2 のメイン**。`git commit` & default branch push でチーム共有資産化 |
| **User (global)** | `~/.copilot/skills/<name>/SKILL.md` | ❌ 教材スコープ外 (個人ローカル、Step 2 = 共有資産メッセージと噛み合わない) |
| **Built-in** | `~/.copilot/pkg/universal/<version>/builtin-skills/<name>/SKILL.md` | ❌ 教材スコープ外 (CLI 同梱) |

### 2.7.3 Copilot CLI 連携 — slash commands (E7-cli-skill PoC で確定)

| コマンド | 用途 | Step 2 教材本文での出現 |
|---|---|---|
| `/skills list` | 認識中の全 skill 一覧 | §3.E 冒頭、§5 Troubleshooting |
| `/skills info <name>` | 個別 skill 詳細 (name / description / path) | §3.E、§5 Troubleshooting |
| `/skills reload` | repo の最新 main を再スキャン (commit 直後に出ない時) | §5 Troubleshooting |

invoke 形式: **自動 invoke** (自然言語 prompt) または **明示 invoke** (`Use the /<name> skill ...`)。Chat と CLI で同じ仕組み (= Skill = surface 非依存資産)。

> [!TIP]
> **TUI ログ取り**: `gh copilot` を `tee` パイプ経由で起動すると TUI が出ません (TTY 検出失敗、F14)。ログを取りたい場合は `script -q -c "gh copilot" /tmp/copilot.log` で PTY を確保してください。ANSI 除去は `sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g; s/\x1b][^\x07]*\x07//g; s/\r//g' /tmp/copilot.log`。
> **観測 version**: 本検証では `gh copilot v1.0.36` で動作確認済 (Codespaces dev container)。auto pre-install されない場合は `gh extension install github/gh-copilot` で導入。

### 2.7.4 観測されたが教材スコープ外のキー: `user-invocable` (E7-cli-skill PoC §3.5)

実物 built-in skill (`~/.copilot/pkg/universal/<ver>/builtin-skills/customize-cloud-agent/SKILL.md`) で **`user-invocable: false`** という E2 RESULT §3 に未記載のキーを観測した。

| 値 | 推定挙動 |
|---|---|
| `true` (デフォルト) | 自然言語 prompt で自動 invoke 可、Chat / CLI 共通 |
| `false` | 自動 invoke 不可、`Use the /<name> skill ...` 明示 invoke のみ可 (cloud agent orchestration から呼ぶ用と推測) |

> [!NOTE]
> **教材では教えない**: Step 2 で学習者が書く triage skill は **デフォルト = 自動 invoke 可** で問題なく機能する。`user-invocable` は Step 2 必須 2 フィールドの最小性を崩すため除外。Phase 11 dogfood で再検証し、必要なら §2.7.4 を更新。

### 2.7.5 注意 (changelog drift 監視)

> [!IMPORTANT]
> Skill 仕様は安定してきているが、`description` の trigger 仕様 / `user-invocable` のような新キー追加は将来発生し得る。Phase 11 (Dogfooding) で再検証する。Chat / CLI のトレース表記が変わった場合 や CLI `/skills list` の出力形式が変わった場合は [Copilot changelog](https://github.blog/changelog/?label=copilot) で `skill` 関連を確認。
> 詳細根拠: `docs/planning/poc/E2-skill/RESULT.md §3` / `docs/planning/poc/E7-cli-skill/RESULT.md §3`

### 2.7.6 Surface 別トレース表記 (E7 walkthrough W4 で確定)

旧版 README / T-205 で想定していた `Read skill [...]` という英語表記は **どちらの surface でも観測されず**、実物は以下のとおり:

| Surface | 観測されるトレース (実機) |
|---|---|
| **VS Code Chat** (本 dev container) | `スキル [issue-triage](file:///<workspace>/.github/skills/issue-triage/SKILL.md?vscodeLinkType=skill) の読み取り` (日本語 + 直接 `file:///` リンク) |
| **`gh copilot` CLI** (interactive) | `skill(issue-triage)` (英語、関数記法) |

> [!IMPORTANT]
> **教材記述ルール**: 観測トレースは surface ごとに違うため、教材では **両 surface の表記を併記** する (Chat 例 = `スキル [issue-triage] の読み取り` / CLI 例 = `skill(issue-triage)`)。「`Read skill [...]` を観察する」のような英語想定の文言は使わない。
> **publication boundary との関係**: VS Code Chat の `file:///` リンクから読んでいるという事実は **Local invariance** (= workspace 直読み = git history 非依存) を直接表す観測証跡。commit 後も Chat は依然 `file:///` を読む (= F17)。

### 2.7.7 Cloud Agent 起動条件 (E7' で確定)

| 操作 | Cloud Agent (coding agent / cloud agent) を起動するか |
|---|---|
| Issue body に `@copilot` mention を書く | ❌ 起動しない (普通の通知のみ) — **F19** |
| **Issue Assignees に `Copilot` を追加** | ✅ 正規トリガ (Web UI 推奨、CLI は環境により失敗) |
| PR 内コメントで `@copilot` mention | ✅ 既存 PR への follow-up として動く |

> [!IMPORTANT]
> Step 3 (Phase 06) で Cloud Agent demo を組むときは、**Issue Assignees → Copilot** が正規トリガであることを前提に手順を書くこと。`@copilot` mention で起動するという誤解は教材から排除する。Cloud Agent は **GitHub Actions minutes を消費** (F20)、**default で code-fix mode に解釈** (F21) する点も併記。Plan 要件 = Pro+ / Business / Enterprise (E7' verification 時点で確認)。

### 2.8 Cloud Agent surface pin (E7' で確定、2026-04-25)

| 項目 | 確定値 | 根拠 |
|---|---|---|
| **正規トリガ** | Issue 右サイドバー Assignees に `Copilot` を追加 (Web UI 推奨) | E7' / F19 |
| 代替トリガ | `gh issue edit <N> --add-assignee Copilot` は **env-dependent** (`Bot does not have access to the repository` で fail することあり) | E7' 実機 |
| 起動しない操作 | Issue body に `@copilot` mention だけ書く / Issue を作るだけ | E7' / F19 |
| **Plan 要件** | Copilot **Pro+ / Business / Enterprise** (Pro 単体は不可) | E7' 実機 (Settings UI 確認) |
| **有効化** | repo Settings → Copilot → **Coding agent → Enabled** が前提 | E7' 実機 |
| **Actions minutes** | GitHub Actions minutes を消費。quota 切れの場合 Initial plan commit 直後に `copilot_work_finished_failure` で停止 | E7' / F20 / PR #8 実機 |
| **Default mode** | **code-fix mode**。Issue body 冒頭に `Use the issue-triage skill to triage this issue.` (slash 無し、E7' 実証文言) を必須化することで triage mode に矯正 | E7' / F21 |
| **Firewall** | サンドボックスは default で外部接続を **default deny**、workflow file PR で迂回を提案 (Trust thread の核) | E4 §4 / R10 |
| **Multi-engine 観察** | `gh api graphql` の `suggestedActors(capabilities: [CAN_BE_ASSIGNED])` で利用可能 actor 一覧 (Copilot 必須 / Claude `anthropic-code-agent` / Codex `openai-code-agent` は plan/org/repo rollout 状況依存で bonus) | E4 §2 / 教材設計上の invariance 緩和 |
| **検証日** | 2026-04-25 | E4 RESULT + E7' walkthrough |

> [!IMPORTANT]
> §2.7.7 と §2.8 が **Cloud Agent 起動方法の権威ソース**。**§6.3 P4 の旧 truth (CLI で完結 / `copilot-swe-agent` bot login 名) は superseded** (下記参照)。教材 (learner-facing docs) では `copilot-swe-agent` / `@copilot mention だけで起動` / `CLI が確実` の文言を使わない。

---

## 3. `.agent.md` frontmatter (確定 spec)

実物 (`github/awesome-copilot@63d08d51:agents/CSharpExpert.agent.md`) より:

```yaml
---
name: "C# Expert"                       # 必須
description: An agent designed to ...   # 必須
# version: 2026-01-20a                  # 任意 (本物ではコメントアウトされている)
---
```

本文は `You are an expert ...` で始まる instruction prose。`When invoked:` セクションで起動時の動作を箇条書きする慣例。

> [!NOTE]
> **`name` は実は任意**。`gh aw init` (v0.68.3) が生成する `.github/agents/agentic-workflows.agent.md` は **`description` のみ**で `name` を持たない。
> その他の任意キー: `disable-model-invocation: true`(他 agent を invoke しないことを宣言、Trust thread 関連)。
> 教材では「**`description` のみ必須**」と教える方が安全(E3 RESULT §2.1 参照)。

---

## 4. gh aw workflow `.md` frontmatter (確定 spec)

実物 (`github/awesome-copilot@63d08d51:workflows/daily-issues-report.md`) より:

```yaml
---
name: "Daily Issues Report"
description: "..."
on:
  schedule: daily on weekdays           # 自然言語スケジュール記述が許される
permissions:
  contents: read
  issues: read
safe-outputs:                            # ★教材の重要ポイント
  create-issue:
    title-prefix: "[daily-report] "
    labels: [report]
---
```

**教材で扱う `safe-outputs` のキー** (Issue Triage シナリオで使用):

| キー | 用途 | 教材で扱うか |
|---|---|---|
| `add-labels` | Issue/PR にラベル追加 | ✅ Step 4 メイン |
| `add-comment` | Issue/PR にコメント追加 | ✅ Step 4 メイン |
| `create-issue` | Issue を新規作成 | ⭕ サンプル例として |
| `create-pull-request` | PR を新規作成 | ❌ Step 6 の発展で間接的 |

> `safe-outputs` は gh aw が **agent の生出力をそのまま GitHub に書かない** ガードレール機構。Trust thread の Layer 4 における主舞台。

### 4.1 Phase 07 (Step 4) で確定する追加パターン (`triage-issue.md` canonical sample、E9 / B1 反映)

```yaml
---
name: "Triage Issue"
description: "..."
on:
  issues:
    types: [opened]
  workflow_dispatch:                       # ★ specific issue re-run 用 entrypoint
    inputs:
      issue_number:
        required: true
        type: string
permissions:
  contents: read                           # ★ strict mode で issues: write は禁止
safe-outputs:
  add-labels:
    allowed: [bug, enhancement, question, documentation]   # ★ Step 2/3 vocabulary + GitHub default labels と整合
    target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"  # ★ 2 trigger 経路を統一解決
  add-comment:
    target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
---
```

**ポイント**:

- `on.issues.opened` (auto-trigger) と `on.workflow_dispatch.inputs.issue_number` (manual re-run) を **両方** 併記 = 自動起動を主、手動再実行を運用 entrypoint として併用
- safe-outputs target = `github.event.issue.number || github.event.inputs.issue_number` で **2 trigger 経路を 1 行で統一解決** (`workflow_dispatch` には `github.event.issue.number` がないため input 必須)
- label allowlist は **`[bug, enhancement, question, documentation]` で固定** (Step 2/3 vocabulary + GitHub default labels と整合、E3 PROCEDURE の `feature/docs` は PoC 仮 vocabulary)

---

### 4.2 Phase 08 (Step 5 = Multi-engine) で確定する追加パターン (engine stanza canonical samples)

> **状態**: **Phase 08 C2c (truth migration 後段、2026-04-26) で確定**。**両形 OR canonical** の publish 方針を採用、`.lock.yml` 内 secret 参照名の実機確定値は Phase 11 dogfooding に持ち越し (S10-* 申し送り)。
>
> **目的**: Step 4 で書いた `triage-issue.md` の **`engine` stanza のみを書き換える** 形で head-to-head 比較する Step 5 の canonical sample を集約。Step 4 の `on` / `permissions` / `safe-outputs` ガードレールは継承する (= Trust thread Layer 4 invariant の verification target = 全 engine で safe-outputs job 経由が維持されるかを Phase 08 C5 で **`partially confirmed` で publish** = 構造的検証 PASS、実機 evidence は Phase 11 dogfooding で `confirmed` 再昇格判断)。

#### 4.2.1 engine stanza 切替パターン (3 engine、unified diff patch 形式)

```diff
 ---
 name: "Triage Issue"
 description: "..."
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
+# === Step 5: engine 切替の差分のみ ===
+# (A) Copilot baseline (Step 4 既定、暗黙でも明示でも可、Phase 08 R08-9 backward compat)
+engine: copilot
+# (B) Claude engine (Anthropic、ANTHROPIC_API_KEY 必須)
+# engine: claude
+# (C) Codex engine (OpenAI、OPENAI_API_KEY canonical + CODEX_API_KEY accepted alternative)
+# engine: codex
 safe-outputs:
   add-labels:
     allowed: [bug, enhancement, question, documentation]
     target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
   add-comment:
     target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
 ---
```

**ポイント (Phase 08 C2c で確定)**:

- **canonical syntax**: gh aw v0.68.3 では scalar (`engine: claude`) と object (`engine:\n  id: claude`) の **両形 OR を canonical として publish**。`model` / `version` 併記時のみ object 形が canonical 候補 (Phase 08 R08-1 / D08-13)。Step 5 README §3.C / §3.D / templates `triage-issue-engine-swap.md` も両形 OR を提示、step-5-gate Group A regex も両形 OR で実装。**単形への収束は Phase 11 dogfooding で再評価** (S10-* 申し送り)
- **`.lock.yml` 出力差分**: engine 切替時の `.lock.yml` 期待差分 (job 構造 / safe_outputs job boundary / secret 参照名) は **Phase 11 dogfooding で実機確定値を本 §4.2 に追記予定** (本 Phase ではエージェント側 invariant `safe_outputs` job 維持を **verification target** として表現に留める)
- **`engine` 暗黙 → 明示の backward compat**: Step 4 の既存 `triage-issue.md` (engine 暗黙 = `copilot`) は Step 5 で `engine: copilot` を明示しても動作不変 (R08-9)。step-5-gate T-503 で Step 4 動作不変を確認

#### 4.2.2 engine x secret マトリクス (Phase 08 C2c で確定、`.lock.yml` 内参照名は Phase 11 持ち越し)

| engine | 必須 secret (canonical) | accepted alternative | `.lock.yml` 内 secret 参照名 (Phase 11 dogfooding で実機確定) | 備考 |
|---|---|---|---|---|
| `copilot` | `COPILOT_GITHUB_TOKEN` (fine-grained PAT、Copilot Requests = Read-only) | — | `COPILOT_GITHUB_TOKEN` (Step 4 P10 と同じ、E3 RESULT §8.4 で実機確認済) | Step 4 baseline、Pro 以上の Copilot license 前提 (Pro plan 縛り廃止 = Q5 = API key 条件のみ追加で baseline 不変) |
| `claude` | **`ANTHROPIC_API_KEY`** | (Phase 11 で実機検証、accepted alt 名なしの可能性) | (Phase 11 dogfooding で実機確定) | Anthropic Console で発行、利用量に応じて請求 |
| `codex` | **`OPENAI_API_KEY`** | **`CODEX_API_KEY`** (gh-aw 側で優先される実装の場合あり、Phase 11 で gh-aw secrets schema 調査) | (Phase 11 dogfooding で実機確定) | OpenAI Platform で発行、利用量に応じて請求 |

**Trust thread invariant (verification target)**: 全 engine で `safe_outputs` job boundary が維持されること = agent の生出力が直接 GitHub に書かれないこと。**Phase 08 C5 で `partially confirmed` で publish 確定** (構造的検証 PASS = 両形 OR canonical syntax / `safe_outputs` job boundary / `permissions: contents: read` / `add-labels.allowed`、実機 invocation evidence は Phase 11 dogfooding で `confirmed` 再昇格判断)。


---

## 5. インストール手順 (確定)

### gh aw

```bash
curl -sL https://raw.githubusercontent.com/github/gh-aw/main/install-gh-aw.sh | bash
gh aw version  # 動作確認 (v0.68.3 が確認できる)
gh aw init     # repo 初期化
```

`gh aw init` が作るもの (**実機 v0.68.3 で確認済**):
- `.gitattributes` (`.lock.yml` を generated としてマーク)
- `.github/agents/agentic-workflows.agent.md` (dispatcher、`description` + `disable-model-invocation`)
- `.github/aw/actions-lock.json` (← 当初想定外。Actions の SHA pin)
- `.github/workflows/copilot-setup-steps.yml`
- **`.vscode/mcp.json`** (← `.github/` ではなく `.vscode/` 配下、要注意)
- `.vscode/settings.json`

### Copilot engine 用 PAT (★必須)

gh aw の Copilot engine は `COPILOT_GITHUB_TOKEN` secret 必須。fine-grained PAT を作成して `gh aw secrets bootstrap` で登録する:

- 作成 URL: https://github.com/settings/personal-access-tokens/new
- Resource owner: 個人
- Repository access: **Public repositories** (← この設定でないと Copilot Requests 権限が表示されない)
- Permissions: **Copilot Requests = Read-only**

```bash
gh aw secrets bootstrap   # 対話プロンプトで PAT を貼る
```

### 注意: Actions 分数

private repo は GitHub-hosted runner の分数を消費し、spending limit でブロックされ得る。**throwaway / 教材 repo は public 推奨**。

### GitHub MCP Server (Codespaces から remote 利用)

VS Code Copilot Chat の MCP 設定で endpoint:
```
https://api.githubcopilot.com/mcp/
```

GitHub 認証は VS Code セッションを継承 (PAT 不要)。

---

## 6. 学習者前提環境 (Phase 01 確定)

> **目的**: ワークショップを完走するために学習者が事前に持っている / 用意する必要があるものを 1 ページに集約。Phase 03 (Step 0 教材化) の `README.md` / `prerequisites.md` の一次ソースになる。
> **根拠**: E1〜E6 の検証結果と `docs/planning/poc/learnings.md` の発見をもとに確定。

### 6.1 必須環境

| 項目 | 要件 | 理由 / 根拠 |
|---|---|---|
| **GitHub アカウント** | 個人アカウント (PAT 作成権限あり) | E3: gh aw Copilot engine PAT 作成のため (learnings §2.1) |
| **GitHub Copilot プラン** | **Pro / Pro+ / Business / Enterprise のいずれか** | E6 Memory 機能、E4 Cloud Agent (`@copilot`)、E3 gh aw Copilot engine の利用条件 |
| **GitHub Codespaces アクセス権** | 個人 60 時間 / 月 (Free) で完走可能を目標 | Phase 01 設計原則 P4 (Codespaces 1 クリック)、Master Plan §6 R7 |
| **Web ブラウザ (モダン版)** | OAuth フロー、PR/Issue UI、Settings UI 操作 | E5 Path C (Copilot Code Review 設定は UI のみ) |
| **VS Code (Web 版 / Desktop 版どちらか)** | Copilot Chat 拡張同梱版 (Codespaces なら自動) | E1, E2, E3, E6 の全実験前提 |

### 6.2 推奨環境 (なくても可だが体験向上)

| 項目 | 要件 | 用途 |
|---|---|---|
| **VS Code Insider** | (任意) | E6 Memory 機能の検証は Insider で実施 (安定版でも動作見込みだが Phase 04 で再確認予定) |
| **個人 GitHub Spending limit > $0** | 任意 (private repo を使う場合) | private repo の Actions 分数消費を許容できる場合のみ。**throwaway repo は public 推奨**で回避可能 (learnings §2.3) |
| **Anthropic / OpenAI API key** | 任意 (Step 5 Multi-engine をフル体験する場合) | Step 5 は任意化済 (§4.5)。録画視聴で代替可能 |

### 6.3 Phase 01 で確定した「秘伝の前提」(教材で必ず明示)

| # | 前提 | 詳細 | 根拠 |
|---|---|---|---|
| P1 | **throwaway repo は public で作成** | private は Actions 分数を消費し spending limit でブロックされ得る | learnings §2.3, E3 RESULT §4 |
| P2 | **gh aw 用 PAT は Resource owner = 個人 / Repository access = Public** | これでないと `Copilot Requests` permission が UI に表示されない | learnings §2.1, E3 RESULT §5 |
| P3 | **PAT 作成後すぐに sanity check** | `curl -H "Authorization: Bearer <token>" https://api.github.com/user` で `login` フィールド確認。copy ミスによる `Bad credentials` 偽陽性を防ぐ | learnings §2.2, E3 RESULT §8.3 |
| P4 | **Cloud Agent assign は Web UI が正規 (Issue Assignees → Copilot)** | ⚠ **Superseded by E7' (2026-04-25)**: 旧版「`gh issue edit <N> --add-assignee copilot-swe-agent` の CLI で完結」は env-dependent (`Bot does not have access` で fail することあり) のため main path から外し、**Issue 右サイドバー Assignees → `Copilot` (Web UI)** を正規トリガに変更。詳細は §2.7.7 / §2.8 参照 | learnings §4.3 (旧), E4 RESULT §2 (旧), **§2.7.7 / §2.8 (現行)** |
| P5 | **Cloud Agent サンドボックスは default で外部接続を blocking** | `api.github.com` 含む。allowlist 編集は教材では**変更させない** (デフォルト挙動の方が学びが深い) | learnings §4.1, E4 RESULT §4 |
| P6 | **Copilot Code Review reviewer 要請は UI / repo 設定のみ** | `gh pr edit --add-reviewer copilot` 等の CLI は NOT_FOUND | learnings §6.3, E5 RESULT §4 |
| P7 | **Memory はユーザーローカルディスクに物理 Markdown ファイルとして保存** | プライバシー考慮、削除はファイル直接 `rm` で OK | learnings §5.1, §5.4, E6 RESULT §2 |

### 6.4 環境チェックリスト (Step 0 教材冒頭で配布候補)

```bash
# 1. GitHub CLI
gh --version  # 2.x 以降

# 2. Copilot プラン確認
gh api /user/copilot --jq '.copilot_plan'  # "individual" / "business" / "enterprise" のいずれか

# 3. Codespaces 残り分数 (任意)
gh api /user/codespaces --jq '.codespaces[].machine.display_name'

# 4. (Step 4 で必要) PAT 作成後の sanity check
curl -H "Authorization: Bearer <token>" https://api.github.com/user | jq '.login'
```

---

## 7. Trust thread ガードレール — gh aw strict mode + safe-outputs (Phase 07 / Step 4)

> **位置付け**: Step 3 の Cloud Agent firewall default deny と並ぶ Trust thread Layer 4 ガードレール。Step 4 では **strict mode + safe-outputs** が "agent の生出力を直接 GitHub に書かせない" 強制機構として核となる。

`gh aw` workflow は **default で strict mode**:

- agentic job (= Copilot CLI engine が走る job) には `permissions: contents: read` のみが推奨され、`permissions: issues: write` 等の write 権限を直接付与すると `gh aw compile` が **strict mode error** で fail する (E3 RESULT §3 で現物確認)
- 書き込みは全て **`safe-outputs` 経由**: 別途分離された `safe_outputs` job だけが `add-labels` / `add-comment` / `create-issue` / `create-pull-request` を実行し、agent の生出力を直接 GitHub に書かせない
- これは **Trust thread Layer 4 における核心メッセージ**: "**エージェントに直接書き込み権限を渡さない**" を spec レベルで強制 = Step 6a (Required Check / 人間が最後に判断) への伏線

教材化 (Step 4 §3.C) では学習者にあえて `permissions: issues: write` を入れて `gh aw compile` を失敗させ、`safe-outputs` 必須化を体感させる "fail-then-fix" stage を 1 ステップとして埋め込む。**compile-before-commit 順序を厳守**:

1. `permissions: issues: write` を入れた状態で yaml を編集
2. `gh aw compile` を実行 → strict mode error
3. `safe-outputs` 追加 + `permissions: contents: read` のみに修正
4. `gh aw compile` 再実行 → PASS
5. ここで初めて `git add / commit / push`

**根拠**: E3 RESULT §3 (strict mode error 現物)、本文 §4 (`safe-outputs` キー一覧)、Master Plan §4.5.3 訂正 (Step 4 = gh-aw runtime Step、VS Code MCP 非利用)、`docs/planning/phase-07-step4-automate.md §10` (gh-aw runtime verification block)。

---


## 9. Step 5 (Multi-engine、任意) Secrets 登録経路 (Phase 08)

> **状態**: **Phase 08 C2c (truth migration 後段、2026-04-26) で確定**。`gh aw secrets list` / `bootstrap` の engine 別挙動の実機確定値は Phase 11 dogfooding に持ち越し (S11-* / 旧 S10-* 申し送り)。
>
> **目的**: Step 4 P10 (`COPILOT_GITHUB_TOKEN`) と並列構造で、Step 5 で追加登録する `ANTHROPIC_API_KEY` (Claude engine 用) / `OPENAI_API_KEY` (Codex engine 用) の登録経路を集約。**Q5 = Pro plan 縛り廃止 = API key 条件のみ追加** (Copilot baseline は Step 4 継承)。

### 9.1 必須前提

- **設定先 repo は playground repo** (workshop repo ではない、Step 4 P10 と同じ Trust thread)
  - `gh repo view --json nameWithOwner --jq .nameWithOwner` で playground であることを確認してから登録
- **Copilot baseline は継承**: Step 4 で登録済の `COPILOT_GITHUB_TOKEN` + Copilot license (Pro 以上) は Step 5 でも必要 (`engine: copilot` 再走に必須)
- **Step 5 は任意**: API key 不所持なら本セクションは skip 可、録画視聴で代替 (Phase 11 以降で提供予定)

### 9.2 engine 別 canonical secret 名 (Phase 08 C2c 確定 / `.lock.yml` 参照名 Phase 11 持ち越し)

| engine | canonical secret | accepted alternative | 取得元 |
|---|---|---|---|
| `claude` | **`ANTHROPIC_API_KEY`** | (Phase 11 で実機検証、accepted alt 名なしの可能性) | Anthropic Console (https://console.anthropic.com/) |
| `codex` | **`OPENAI_API_KEY`** | **`CODEX_API_KEY`** (gh-aw 側 secrets schema で優先される実装の場合あり、Phase 11 で実機確定) | OpenAI Platform (https://platform.openai.com/) |

### 9.3 登録経路 (4 経路、Step 4 P10 と並列構造)

```bash
# ① UI method (Settings → Secrets and variables → Actions → New repository secret、Codespaces で確実)
#    Repository → Settings → Secrets and variables → Actions → New repository secret
#    Name: ANTHROPIC_API_KEY  /  OPENAI_API_KEY
#    Value: 各 console で発行した key (sk-ant-... / sk-...)

# ② gh aw secrets set (gh-aw docs 主導線)
gh aw secrets set ANTHROPIC_API_KEY --value "$ANTHROPIC_KEY"
gh aw secrets set OPENAI_API_KEY    --value "$OPENAI_KEY"

# ③ gh aw secrets bootstrap (対話式 + existing secrets check)
gh aw secrets bootstrap   # ← engine 別の必要 secret を対話的に登録 (Phase 11 で実機挙動確定)

# ④ fallback: gh secret set
gh secret set ANTHROPIC_API_KEY -R <owner>/<playground>
gh secret set OPENAI_API_KEY    -R <owner>/<playground>

# 登録確認 (P11 環境チェック ⑨ ⑩ と整合)
gh secret list -R <owner>/<playground> | grep -E "ANTHROPIC_API_KEY|OPENAI_API_KEY|CODEX_API_KEY"
gh aw secrets list  # ← engine 別の登録済 secret を表示
```

### 9.4 cost / billing 注意 (R08-2)

- Anthropic / OpenAI API key は利用量に応じて Anthropic Console / OpenAI Platform で請求が発生
- Step 5 README は **1 engine 1 invocation で十分な構成** (R08-7 = rate limit 回避設計)
- 各 console の **billing/usage visibility** (Phase 08 D08-14 = 5 軸比較表 Group 2 = Post-run optional) で実測コストを確認

### 9.5 Trust thread invariant

- **Workshop repo に API key secret を登録しない** = 学習者の playground repo に各自登録 (D14 制約継承 = active gh-aw workflow を workshop repo に置かない)
- `step-5-complete` escape hatch branch は **documentation + canonical template state** のみ、secret は branch に乗らない (Phase 08 D08-15 / Phase 07 P07-6 継承)

---

## 10. Branch protection / Required Review UI canonical labels (Phase 09 / Step 6)

> **目的**: GitHub UI の文言は時期によって drift しがち (Branches → Rules → Rulesets 移行など)。Step 6 README で **semantic anchor** として再利用するための canonical labels を pin する (Phase 09 Suggestion 13 / R09-1)。
> **検証時点**: 2026-04 (Phase 09 着手 commit `9030979` 時点)。

### 10.1 Repository settings 経路 (canonical labels)

| Step 6 README で参照する label | 2026-04 時点の UI 表記 (canonical) | 旧表記 / 同義表現 (= semantic anchor 範囲) | Drift 検出時の対応 |
|---|---|---|---|
| **Settings → Branches** | `Settings → Code and automation → Branches` (or `Settings → Rules → Rulesets`) | `Settings → Branches and tags` (旧表記) / `Settings → Rules` | 両表記を README §3.B で OR 条件で記述 (semantic anchor)、Phase 11 で再 pin |
| **Add branch protection rule** | `Add branch protection rule` (Branches 経路) / `New ruleset` (Rulesets 経路) | `Add rule` (旧 Branches UI) | 両形を README §3.B で 1 段落で説明 |
| **Branch name pattern** | `Branch name pattern` (Branches) / `Target branches` (Rulesets) | `Branch pattern` | `main` を入力する canonical 値で固定 |
| **Require pull request reviews before merging** | `Require a pull request before merging` (現行) | `Require pull request reviews before merging` (旧表記) / `Require pull request` | 文言検索ではなく **checkbox の機能** (= PR review 必須化) で説明 |
| **Required reviewers** | `Required reviewers` / `Require review from Code Owners` | `Required approving reviewers` | 数値 = 1 以上、`Restrict who can dismiss pull request reviews` は本 Step では触れない |
| **GitHub Copilot - Code Review** (Required Reviewer に追加する identity) | `Copilot` / `GitHub Copilot Code Review` (UI で picker に表示される identity) | `Copilot Code Review` (短縮形) | picker で `Copilot` を選択 = canonical (Phase 11 で再確認、R09-1) |

### 10.2 Copilot Code Review setting 経路 (P12 (c)(d))

| 経路 | 2026-04 時点の UI 表記 | 同義表現 / Drift 範囲 |
|---|---|---|
| **Repository scope** | `Settings → Code & automation → Copilot → Code Review` | `Settings → Copilot → Code Review` (旧短縮) |
| **Organization scope (org policy)** | `Organization Settings → Copilot → Policies → Code Review` | `Org Settings → Copilot → Policies` (短縮) |
| **Setting 状態 (visible / disabled)** | `Enabled` / `Disabled by policy` (org policy 制限時) | `Not available on your plan` (Free plan の場合 = degraded path 誘導) |

### 10.3 UI verification block 4 項目 (D09-12 / Step 6 §3.A の semantic anchor 接続先)

`phase-09-step6-gate.md §10.4` で定義する UI verification block (U1-U4) は本 §10 の canonical labels と 1:1 で接続:

- **U1** = Repo Admin (`Settings → Branches` メニューが開ける = §10.1 row 1)
- **U2** = Copilot Code Review setting visible (= §10.2 `Enabled` 状態)
- **U3** = Branch protection rule editable (= §10.1 row 2 `Add branch protection rule` ボタン押下可)
- **U4** = Required reviewer setting visible (= §10.1 row 5 `Required reviewers` field 編集可)

### 10.4 Drift watch (Phase 11 dogfooding)

- **Watch list**: §10.1 row 1-6 すべて、§10.2 全行
- **Trigger**: GitHub UI release notes / Copilot release notes で `Branches` / `Rulesets` / `Code Review` 関連の変更が出たら本 §10 を更新
- **Phase 11 dogfooding 持ち越し**: 実機 PR で Copilot Code Review が Required Reviewer として satisfied / not satisfied 状態を 4 行表で確定 (R09-1 = Branch protection UI drift watch、S10-5)
