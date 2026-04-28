# E7 Result — Copilot CLI と Skill 連携仕様の確定 + 実機完走 (Phase 05 mini-PoC)

**Status**: ✅ **PASS** (初期 spec 確証 + E7 実機完走 18 findings + E7' Cloud Agent boundary 確証)
**Date**: 2026-04-25 (Phase 05 W2 = rubber-duck refine 中に初版、W4 で実機完走、refine 中に E7' 追加)
**Authoritative source**: 実機 (`gh copilot v1.0.36`、Codespaces dev container)、公式 Web ドキュメント、実物 SKILL.md (`~/.copilot/pkg/universal/<ver>/builtin-skills/`、`~/.copilot/skills/<name>/`)、playground repo (`shinyay/ghcp-6-layer-agentic-platform-phase3-dry-run`)

---

## 1. 検証目的

Phase 05 (Step 2) は **U-C = chat_plus_cli** = Copilot Chat + Copilot CLI の **2 surface invoke** を必須としているが、計画策定時点 (D13) で Copilot CLI と SKILL.md の連携仕様 (slash commands / 認識 path / invoke 形式) が rubber-duck Critical 1 で「曖昧、確証必要」と指摘された。本 mini-PoC でこれを確証し、IDE Chat fallback を不要にする。

加えて **W4 で実機 8-step 完走 (F1-F18)** を行い、教材の前提仮説 ("commit gating") が誤りで実態は **"Local invariance + publication boundary"** であることを確証した。さらに refine 中に **E7' (Cloud Agent propagation 検証)** を実施し、F19-F21 を追加発見した。

## 2. 検証手順

1. `gh extension list` で `gh copilot` の存在 / バージョン確認
2. `~/.copilot/skills/` および `~/.copilot/pkg/universal/<ver>/builtin-skills/` 配下の実物 SKILL.md を `view` / `cat` で確認
3. 公式ドキュメント / GitHub blog で `/skills list` `/skills info` `/skills reload` `/skills add` の挙動確認
4. invoke 形式 (自動 invoke = 自然言語 prompt / 明示 invoke = `Use the /<name> skill ...`) を公式 docs と実物 SKILL.md frontmatter から導出
5. **(W4) 実機 8-step walkthrough** = playground repo (`...phase3-dry-run`) で `.github/skills/issue-triage/SKILL.md` 作成 → uncommitted Local Chat invoke → commit/push → `gh copilot` CLI invoke → step-2-complete branch
6. **(E7') Cloud Agent propagation 検証** = playground repo の Issue を作成 → Issue Assignees に Copilot を追加 → Cloud Agent が起動 / branch 作成 / PR 草案を作るまでを観察

---

## 3. 確定 spec

### 3.1 Copilot CLI extension

| 項目 | 値 |
|---|---|
| バージョン | **`v1.0.36` 観測動作** (Codespaces dev container 実機、auto pre-install されない場合あり、`gh extension install github/gh-copilot` で導入) |
| インストールパス | `~/.local/share/gh/copilot/` |
| エントリーポイント | `gh copilot` (no args = interactive mode) |
| `-p` フラグ | 単発 prompt 実行用だが、本検証では timeout 観測 (interactive 推奨) |
| 起動時認証 | VS Code セッションの GitHub OAuth を継承 (Step 0 Trust 階層 Layer 1 と同じ仕組み) |
| **TUI 起動条件** | TTY が必要 (`tee` 等のパイプを噛ませると TUI が出ない)。ログ取りには `script -q -c "gh copilot" /tmp/copilot.log` で PTY 確保 |

> **F14 (E7 walkthrough)**: `gh copilot 2>&1 \| tee -a /tmp/copilot.log` は **TUI が起動しない**。`script` 経由で PTY を確保すれば TUI + ログ両立可能。

### 3.2 Skill 認識 path (3 階層)

CLI は以下 3 階層から SKILL.md を自動発見する:

| 階層 | パス | 教材スコープ |
|---|---|---|
| **Project (repo)** | `.github/skills/<name>/SKILL.md` | ✅ **Step 2 で扱う** (E2 RESULT §3.4 と一致) |
| **User (global)** | `~/.copilot/skills/<name>/SKILL.md` | ❌ 教材スコープ外 |
| **Built-in** | `~/.copilot/pkg/universal/<version>/builtin-skills/<name>/SKILL.md` | ❌ 教材スコープ外 (CLI 同梱) |

> **教材で教えるのは project 階層のみ**。User / built-in は §5 troubleshooting で `/skills list` 一覧に紛れて出てきた場合の見分けに利用する程度。

### 3.3 Slash commands (公式仕様)

| コマンド | 用途 | Step 2 での出現 |
|---|---|---|
| **`/skills list`** | 認識中の全 skill を一覧 (project / user / built-in 混在表示) | §3.E 冒頭 |
| **`/skills info <name>`** | 個別 skill の詳細 (name / description / path) | §3.E |
| **`/skills reload`** | repo の最新 main を再スキャン | §5 Troubleshooting |
| `/skills add <dir>` | 任意 dir を skill source に追加 | 教材スコープ外 |

その他の Copilot CLI 共通 slash commands (参考): `/help` / `/clear` / `/cwd` / `/model` / `/new`。

### 3.4 invoke 形式 (2 種類)

| 形式 | 例 | 挙動 |
|---|---|---|
| **自動 invoke** | `このリポジトリの open issue を 1 件 triage して。` | Copilot が description を読んで該当 skill を自分で当てに行く (= Chat と同じ仕組み) |
| **明示 invoke** | `Use the /issue-triage skill to triage the latest open issue.` | skill 名を slash 付きで明示指定、自動 invoke が個体差で発火しない場合のフォールバック |

### 3.5 SKILL.md frontmatter 実物観測 + **YAML 構文要件**

#### 3.5.1 必須フィールド

| キー | E2 RESULT §3 記載 | 本 PoC で観測 | 教材スコープ |
|---|---|---|---|
| `name` | ✅ 必須 | ✅ 必須 | ✅ Step 2 で教える |
| `description` | ✅ 必須 (単行 string 例) | ✅ 必須 | ✅ Step 2 で教える (**folded scalar `>-` 推奨**) |
| `license` / `compatibility` / `metadata.version` | 任意 (推奨) | 一部観測 (awesome-copilot 由来) | Step 6 で再登場予定 |
| **`user-invocable`** ⭐新発見 | ❌ 未記載 | ✅ 観測 (built-in skill で `false`) | ❌ 教材スコープ外 |

#### 3.5.2 YAML 構文 4 要件 (E7 walkthrough で全部踏んだ後の決定版)

教材で配布する SKILL.md template は **以下 4 つを必ず満たすこと**:

1. **`---` は列 0 (行頭) 配置**: heredoc / paste 経由で行頭 space が入るとパースされない (F8/F9/F10/F11/F12 の主原因)
2. **`description: >-` (folded scalar with strip chomping) を使用**: `>-` は複数行を半角 space で連結して 1 文字列として渡す
3. **`description:` 直下から 2-space indent**: indent ずれ = パース失敗
4. **物理改行 (CR/LF) 禁止**: `cat -A SKILL.md` で末尾が `$` のみであることを確認 (`^M$` は NG)

> **canonical template**: [`templates/SKILL.md`](./templates/SKILL.md) (folded scalar 版、列 0、2-space indent、repo 既存 label `bug` / `enhancement` / `question` / `documentation` 採用)

#### 3.5.3 `user-invocable` 補足

実物 (built-in skill `customize-cloud-agent`) の frontmatter:

```yaml
---
name: customize-cloud-agent
description: >-
  Customize cloud agent ...
user-invocable: false
---
```

> [!IMPORTANT]
> **`user-invocable: false` は cloud agent の内部用 skill** に付くと推測。Step 2 で学習者が書く triage skill は **default = 自動 invoke 可** で問題なく機能する。VERSIONS.md §2.7 に「観測されたが教材スコープ外」と注記して将来の spec drift 監視のみ対応。

### 3.6 Surface 別トレース表記 (W4 walkthrough で確定)

| Surface | 観測されるトレース文字列 |
|---|---|
| **VS Code Chat** | `スキル [issue-triage](file:///<ws>/.github/skills/issue-triage/SKILL.md?vscodeLinkType=skill) の読み取り` (日本語 + ファイルリンク) |
| **`gh copilot` CLI** (interactive) | `skill(issue-triage)` 形式 (英語、関数記法) |
| **想定していた `Read skill [...]`** | ❌ **どちらの surface でも観測されず** — 旧 README 想定は誤りだった |

→ T-205 の trace-string regex は概念 keyword + 構造 gate に作り替え (C8 で実施)。

### 3.7 Local invariance vs Publication boundary (E7 W4 で確定)

| Action | VS Code Chat | `gh copilot` CLI | Cloud Agent (`@copilot` Assignee) |
|---|---|---|---|
| `SKILL.md` 作成 (uncommitted) | ✅ 即読む (`file:///`) | ✅ `/skills list` に出る + invoke 可 | ❌ 見えない |
| `git commit` | ✅ 同じ挙動 (file:// 経由のまま) | ✅ 同じ挙動 | ❌ 依然見えない |
| `git push origin main` | ✅ 同じ挙動 | ✅ 同じ挙動 | ✅ Issue Assignees → Copilot で起動可能、SKILL.md を読む |

→ **新コア**: Local Chat / CLI は **commit-invariant** (= workspace 直読み)。push の意味は **Cloud surface への propagation** であって Local の activation ではない。

### 3.8 Cloud Agent 起動条件 (E7' で確定)

| 操作 | Cloud Agent (coding agent) を起動するか |
|---|---|
| Issue body に `@copilot` mention を書く | ❌ **しない** (普通の通知のみ) — **F19** |
| **Issue Assignees に `Copilot` を追加** | ✅ **正規トリガ** (Web UI / API どちらも可) |
| PR 内コメントで `@copilot` mention | ✅ 既存 PR への follow-up として動く |

> **F19**: Cloud Agent の正規トリガは Assignees 追加。`gh issue create --body "@copilot ..."` だけでは起動しない。CLI assign は環境により失敗 (`Bot does not have access to the repository`) — Web UI 推奨。
> **F20**: Cloud Agent は **GitHub Actions minutes を消費**する (Free / quota 制限下では完走しない)。E7' でも Initial plan commit 後に Actions quota で finish_failure。
> **F21**: Cloud Agent はデフォルトで **code-fix mode** に解釈する。triage skill の起動を保証するには Issue body に「Use the issue-triage skill to triage this issue.」と明示する必要がある。

---

## 4. Phase 05 設計への反映 (refine 後の D マッピング)

| 設計判断 | 本 PoC で確定した内容 |
|---|---|
| **D7 (5 sub-step §3)** | 新フロー = A: 雛形 → B: frontmatter (folded scalar `>-` 必須) → C: 本文 + **Local 即効体感** (uncommitted で Chat invoke) → D: commit/push (= **publication step**、Local 体感は不変) → E: CLI invoke (= 第 2 surface) |
| **D10 (教える frontmatter)** | 必須 2 (`name` + `description`) のみ。description は **folded scalar `>-` + 2-space indent** で書かせる。`user-invocable` 等は教材スコープ外 (VERSIONS §2.7 注記のみ) |
| **D12 (before/after)** | 廃止。代わりに **Local invariant (commit 前後で Local 挙動が同じ) + Publication boundary (Cloud は push 必須) の 2 概念** に置き換え。Step 2 で Local invariant を体感、Step 3 で Publication boundary を体感 |
| **D13 (CLI invoke 具体コマンド)** | `gh copilot` interactive → `/skills list` → `/skills info issue-triage` → 自然言語 prompt または `Use the /issue-triage skill ...`。**TUI ログ取りは `script` 経由必須** (F14)。**IDE Chat fallback 不採用** |
| **D16 / T-205 (regex gate)** | trace-string regex (`Read skill [...]`) は **想定実物と乖離** していたため廃止 (C8 で reframe)。新 gate は概念 keyword (`Local`/`publication`/`uncommitted`/`folded scalar`) + 構造 (2 段階 done) |
| **D19 (P8)** | prerequisites.md P8 を folded scalar / Local invariance に整合 |
| **D20 (§6)** | Step 3 motivation を「Cloud Agent propagation の publication boundary」を中心に書き直し |
| **R05-2 / R05-8 / R05-10 (Troubleshooting)** | §5 に `/skills list` `/skills reload` `/skills info` 切り分け、`gh copilot --version` チェック、`script` で TUI ログ、`gh api` で template 取得、Cloud Agent assign 失敗のフォールバック |
| **R05-7 (playground push 必須)** | CLI も project skill = `.github/skills/<name>/SKILL.md` を repo の現在 branch から拾うため、playground repo 側にも default branch push が必要。**Cloud Agent は push 必須** (Local Chat / CLI は uncommitted でも動く点が異なる) |

---

## 5. ハードゲート判定

| 判定項目 | 結果 |
|---|---|
| `gh copilot` extension の存在 / バージョン確認 | ✅ v1.0.36 動作確認 |
| `/skills list` `/skills info` `/skills reload` の公式仕様確認 | ✅ 公式 docs + Web search で確証 |
| `.github/skills/<name>/SKILL.md` が CLI で project skill として認識される path であること | ✅ E2 RESULT §3.4 と一致 |
| 自動 invoke + 明示 invoke 形式の確認 | ✅ Copilot CLI docs で確認 |
| **W4 walkthrough 8-step 完走** | ✅ F1-F18 取得、step-2-complete branch 押し上げ |
| **E7' Cloud Agent propagation 確認** | ✅ Assignees → Copilot で起動 + branch + PR 草案 (Actions quota で finish_failure だが boundary 実証は完了) |
| Phase 05 D13 / D7 / D12 / D16 確定に十分な情報量 | ✅ |

**Phase 05 W3 (C1) + W4 (C5) + Refine (C6) 全条件達成。**

---

## 6. 学び / 注意 (E7 + W4 + E7' から集約 = F1-F21)

### Critical findings (educational impact あり)

- **F4**: VS Code Chat は **uncommitted SKILL.md** を `file:///` 経由で完璧に読む — 「commit してから初めて効く」は誤り
- **F8/F9/F10/F11/F12**: SKILL.md の YAML frontmatter は **列 0 / 2-space indent / folded scalar / 物理改行禁止** をすべて満たさないとパースされない (heredoc / paste で簡単に踏む)
- **F13**: private repo の `raw.githubusercontent.com` は **anonymous 404** — `gh api repos/.../contents/<path> -H "Accept: application/vnd.github.raw"` で認証込み取得
- **F14**: `gh copilot` を `tee` パイプで起動すると TUI が出ない — `script -q -c "gh copilot" /tmp/copilot.log` で PTY 確保
- **F15**: `gh copilot` CLI も **uncommitted SKILL.md** を Project skill として認識 + invoke する (Local invariance は Chat だけでなく CLI でも成立)
- **F17**: commit 後も Chat は依然 `file:///` を読む (= Local は commit invariant、git history は activation boundary ではない)
- **F18**: SKILL.md の hardcoded label が repo に存在しない場合、agent は graceful adapt (近い既存 label を選び、コメントで substitution を説明) — 教材は **deterministic 化のため repo 既存 label = `bug` / `enhancement` / `question` / `documentation` を採用**、adapt は §3.C sidebar で言及
- **F19**: Cloud Agent は Issue body の `@copilot` mention だけでは起動しない、**Issue Assignees に Copilot 追加が正規トリガ**
- **F20**: Cloud Agent は GitHub Actions minutes を消費する — quota 制限下では完走しない
- **F21**: Cloud Agent はデフォルト code-fix mode、triage skill 起動を保証するには Issue body に「Use the issue-triage skill」と明示

### その他の観測 / 注意

- **`gh copilot -p "<prompt>"` は本検証で timeout 観測**。理由不明 (auth 経路 / interactive 必須仕様 / 既知バグ いずれも候補)。教材本文では **interactive モード推奨** とし、`-p` は将来安定したら §3.E 末尾に「上級者向け 1-shot」として追加候補。
- 実物 SKILL.md の `description` は **YAML `>-` (folded scalar、改行を半角 space に折る) や `\|` (literal scalar、改行保持)** で複数行になっているケースあり。教材は **folded scalar `>-`** を canonical として採用 (改行を space 化することで応答品質に影響しないため)。
- `user-invocable: false` の skill は `/skills list` には出るが、自然言語 prompt では invoke されない (`Use the /<name> skill ...` 明示 invoke のみ可) と推測。教材スコープ外。

## 7. References

- 公式 docs (Web search 確証): GitHub Copilot CLI documentation `/skills` command reference
- E2 RESULT.md §3 (SKILL.md frontmatter 確定 spec、awesome-copilot 由来)
- 実物 SKILL.md: `~/.copilot/pkg/universal/<ver>/builtin-skills/customize-cloud-agent/SKILL.md` (`user-invocable: false` 観測源)
- 実物 SKILL.md: `~/.copilot/skills/agent-governance/SKILL.md` (`description` の `\|` block scalar 観測源)
- VERSIONS.md §2.7 (本 PoC を引用元として記録)
- canonical SKILL.md template: [`templates/SKILL.md`](./templates/SKILL.md)
- E7 W4 walkthrough log + E7' Cloud Agent verification: 本 RESULT §3.6-3.8、§6
- playground repo (E7 + E7' verification target): `shinyay/ghcp-6-layer-agentic-platform-phase3-dry-run` (PR #8 が E7' Cloud Agent 起動の証跡)
