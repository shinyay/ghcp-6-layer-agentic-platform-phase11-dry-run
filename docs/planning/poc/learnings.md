# Phase 01 Learnings — 検証中に得た副次的な学び (内部 KB)

> **Scope**: これは**学習者向け教材ではなく、教材執筆チーム (= 私たち) のための内部 KB** です。Phase 02 以降で Step 教材を書くときに繰り返し参照することを想定し、E1〜E6 の検証中に発見した「明文化しないと忘れる」「教材で必ず触れるべき」小ネタを集約します。
>
> **Audience**: Phase 02 以降の教材執筆者 (= 主に shinyay と Copilot)
> **Updated**: 2026-04-25 (Phase 01 クロージング作業)

---

## 0. 凡例

各項目は次の 4 段で記述します:

- **症状** — 何が起きたか (現物 / エラーメッセージ)
- **原因** — なぜそうなるか (技術的根拠)
- **回避策** — 検証時に取った対応
- **教材化方針** — どの Step / Phase に、どう反映するか

ソース: 各項目末尾に `→ Source: poc/EX-*/RESULT.md §N` 形式で原典を明示。

---

## 1. インフラ系 (Codespaces / Self-hosted runner / az cli)

### 1.1 Self-hosted runner 追加登録時の symlink 罠

- **症状**: 既存 ACI コンテナに 2 つ目の runner instance を起動しようと `cp -r bin .` で actions-runner を複製したところ、`Runner.Listener` が起動直後に "already configured" で終了。
- **原因**: actions-runner の `bin/` `externals/` はバージョンディレクトリへの **symlink** (`bin -> bin.2.333.1`)。`cp -r` は symlink そのものをコピーするため、新しい場所からも結局同じ実体ディレクトリを参照し、**親ディレクトリの `.runner` を検出してしまう**。
- **回避策**: `cp -rL bin .` `cp -rL externals .` で **dereference してコピー** (実体を新しい場所に複製)。
- **教材化方針**: 教材本文には不要 (学習者は自分で runner を立てない)。**ただし** 講師ガイドの「Codespaces 不可で物理 runner を立てる場合の注意」付録に 1 行残す。

→ Source: 本セッション中の作業ログ (checkpoint 003 周辺)

### 1.2 `az container exec --exec-command` のトークナイズ事故

- **症状**: `az container exec -g <rg> -n <name> --exec-command "chmod +x foo.sh"` を実行しても `+x` が空文字に消える。pipe (`|`) は分割される。quote の入れ子は全て壊れる。
- **原因**: az cli が exec-command 文字列を独自のトークナイザにかけて再構成するため、shell metacharacter が部分的に欠落・分割される。**Azure CLI 既知制限**。
- **回避策**: スクリプトを **gist に upload → コンテナ内で curl 取得 → `chmod 755 file` (NOT `+x`) → `env VAR=val ./file` 形式で実行**。実行後 gist は削除して clean up。
- **教材化方針**: 教材スコープ外。**講師ガイド付録**にのみ残す。

→ Source: 本セッション中の作業ログ (checkpoint 003 周辺)

### 1.3 GitHub Pages を self-hosted runner でデプロイできる

- **症状**: GitHub-hosted runner 不使用環境でも、`actions/configure-pages@v5` `actions/upload-pages-artifact@v3` `actions/deploy-pages@v4` の 3 点セットは self-hosted runner で完走する。
- **原因**: これらの action は OIDC token / Pages API を叩くだけで、ランタイムに依存しない。
- **回避策**: `runs-on: [self-hosted, Linux, X64]` で OK。build/deploy を 2 job に分け、deploy job に `permissions: pages: write, id-token: write` と `environment: github-pages` を設定。
- **教材化方針**: 教材本文では Codespaces 前提なので不要。**Phase 11 (公開準備) で keynote サイトの運用ノートとして残す**。

→ Source: `.github/workflows/pages.yml` (commit `f151e9d`)

---

## 2. PAT / 認証

### 2.1 ★ gh aw Copilot engine の PAT は「秘伝の手順」

- **症状**: `gh aw` workflow が `Error: None of the following secrets are set: COPILOT_GITHUB_TOKEN` で失敗。
- **原因**: gh aw の `engine: copilot` は LLM 呼び出しに **GitHub Copilot Requests** API を叩くため、**`Copilot Requests: Read-only` permission を持つ fine-grained PAT が必須**。
- **回避策 (秘伝の手順)**:
  1. https://github.com/settings/personal-access-tokens/new
  2. **Resource owner**: 個人アカウント
  3. **Repository access**: **Public repositories** ← この設定でないと `Copilot Requests` permission が選択肢に出てこない
  4. **Permissions** → Account permissions → **Copilot Requests: Read-only**
  5. 生成 → `gh secret set COPILOT_GITHUB_TOKEN -R <owner>/<repo>` で登録
- **教材化方針 (★必須)**: **Phase 07 (Step 4 教材化) の冒頭に prerequisite として組み込む**。スクリーンショット付き。`Resource owner` 選択を間違えると沼にハマる旨を強調。

→ Source: `poc/E3-gh-aw/RESULT.md §5`

### 2.2 ★ PAT の copy ミスで `Bad credentials` 偽陽性

- **症状**: 上記の PAT を正しく作っても 1 度目は `Bad credentials` で失敗。`curl /user` で `null` が返り invalid と判明。再発行すると同じ手順で成功。
- **原因**: token 文字列の copy 時に末尾欠落 / 先頭末尾の whitespace 混入が頻発する。GitHub UI の "Copy" ボタンを使っていても発生する。
- **回避策**: 登録前に **必ず sanity check**:
  ```bash
  curl -H "Authorization: Bearer <token>" https://api.github.com/user
  # → "login" フィールドが返れば OK、null や 401 なら NG
  ```
- **教材化方針 (★必須)**: **Phase 07 の prerequisite チェックスニペット**に上記 curl を必ず含める。「PAT 作ったらまず叩く」の 1 行で全員救える。

→ Source: `poc/E3-gh-aw/RESULT.md §8.3`

### 2.3 throwaway repo は public で作る

- **症状**: 1 度目の workflow run が `recent account payments have failed or your spending limit needs to be increased` で起動拒否。
- **原因**: private repo は GitHub-hosted runner の Actions 分数を消費し、個人 spending limit でブロックされる。
- **回避策**: `gh repo edit --visibility public --accept-visibility-change-consequences`。public repo は Actions 無料無制限。
- **教材化方針 (★必須)**: **Phase 03 (Step 0 教材化) の environment setup** で「throwaway repo は public で作成」と明示。1 行で全員救える。

→ Source: `poc/E3-gh-aw/RESULT.md §4`

---

## 3. gh aw 仕様の落とし穴

### 3.1 ★ strict mode が `issues: write` を直接付与することを禁止

- **症状**: workflow `permissions:` に `issues: write` を入れて `gh aw compile` すると:
  ```
  strict mode: write permission 'issues: write' is not allowed for security reasons.
  Use 'safe-outputs.create-issue', 'safe-outputs.create-pull-request',
  'safe-outputs.add-comment', or 'safe-outputs.update-issue' to perform write operations safely.
  ```
- **原因**: gh aw は **default で strict mode**。Agent の生出力をそのまま GitHub に書くことを禁止し、**必ず `safe-outputs` 経由で書く** ことを強制 (= Trust thread Layer 4 の核心)。
- **回避策**: `permissions:` は `contents: read` のみ。書き込みは `safe-outputs.add-labels` `safe-outputs.add-comment` 等で。
- **教材化方針 (★最強の現物教材)**: **Phase 07 で「あえて失敗させる」教材ステップ**を入れる。
  - Step 4-a: `issues: write` を入れて compile → 失敗を体感
  - Step 4-b: `safe-outputs` に直してから compile → 通る
  - → **keynote の「ガードレール」セクションの最強の現物デモ**になる

→ Source: `poc/E3-gh-aw/RESULT.md §3`

### 3.2 `gh aw init` の生成物は予想と違う

| 想定 | 実機 (v0.68.3) |
|---|---|
| `.github/mcp.json` | **`.vscode/mcp.json`** ← 場所違う |
| (記述なし) | **`.github/aw/actions-lock.json`** ← 追加で生成 |
| `.github/agents/agentic-workflows.agent.md` | 同じ ✅ |
| `.github/workflows/copilot-setup-steps.yml` | 同じ ✅ |

- **教材化方針**: VERSIONS.md に記録済 (§5)。Phase 07 で配布する初期 file tree 図に反映。

→ Source: `poc/E3-gh-aw/RESULT.md §2`

### 3.3 `.agent.md` の `name` は実は任意

- **症状**: gh aw が生成する `agentic-workflows.agent.md` には `name` フィールドがない。`description` のみ。
- **原因**: spec 上 `name` は任意。`awesome-copilot` の `CSharpExpert.agent.md` は `name` ありだが必須ではない。
- **教材化方針**: VERSIONS.md §3 に「`description` のみ必須」と確定済。Phase 09 (Step 6) の `.agent.md` テンプレでは name を**任意フィールド扱い**にする。

→ Source: `poc/E3-gh-aw/RESULT.md §2.1`

### 3.4 gh aw triage workflow の所要時間 (約 3 分)

| Job | 時間 |
|---|---|
| pre_activation | 10s |
| activation | 18s |
| **agent (Copilot CLI 推論)** | **1m20s** |
| detection | 51s |
| safe_outputs | 9s |
| conclusion | 12s |
| **合計** | **約 3 分** |

- **教材化方針**: Phase 07 のデモ尺で「Issue を立ててから triage 完了まで 3 分」を時間目安として示す。

→ Source: `poc/E3-gh-aw/RESULT.md §8.4`

---

## 4. Cloud Agent (`@copilot`) の振る舞い

### 4.1 ★ Cloud Agent は default で firewall に守られている

- **症状**: PR #6 body に Cloud Agent 自身のログが開示され、`api.github.com/graphql` `api.github.com/repos/.../labels` `api.github.com/user` 等への直接アクセスが **firewall でブロック**されている。
- **原因**: Cloud Agent (copilot-swe-agent) のサンドボックスは egress が **default deny**。許可ホストは Settings → Copilot → Coding agent → Custom firewall で allowlist 編集。
- **回避策**: 検証では allowlist 変更せず、Agent が自発的に「では Actions 経由で叩く workflow を書こう」と方針転換した結果を観測。
- **教材化方針 (★Trust thread の核)**:
  - **Phase 06 (Step 3 教材化)** で「Cloud Agent は repo の中で動くが外部ネットワークは制約される」を**スクショで提示**
  - keynote の Trust thread Layer 3 (Agent サンドボックス) の最強の現物デモ
  - 教材で allowlist 変更手順は**示さない** (デフォルト挙動のまま体感させる方が学びが深い)

→ Source: `poc/E4-cloud-skill/RESULT.md §4`

### 4.2 Cloud Agent は「直接実行」ではなく「PR を提案する」

- **症状**: Issue #5 を `@copilot` に assign したら、ラベルを直接付けるのではなく **「ラベル付与する workflow 」を含む Draft PR** が出来た。
- **原因**: §4.1 の firewall + Cloud Agent の設計思想 (review-able な変更を提案)。
- **教材化方針**: Phase 06 で Step 3 narrative を **「CLI Agent はその場で動かす、Cloud Agent は repo に変更を提案する」** で確定。直感と違うため**冒頭で先に種明かし**。

→ Source: `poc/E4-cloud-skill/RESULT.md §5`

### 4.3 Cloud Agent assign は CLI で完結する

- **症状**: UI で「Copilot」を assignee に選ぶ操作は不要。`gh issue edit <N> --add-assignee copilot-swe-agent` で完結。
- **教材化方針**: Phase 06 で **CLI 1 行で実演** (UI スクショなしでも進められる)。

→ Source: `poc/E4-cloud-skill/RESULT.md §2`

### 4.4 Cloud Agent は Signed Verified Commits を打てる

- **症状**: `copilot-swe-agent[bot]` の commit が `verified: true, reason: valid` で記録される。
- **教材化方針**: Phase 06 で「branch protection で `Require signed commits` を有効化しても Cloud Agent はマージ可能」と 1 スライドで示す。keynote 主張「Signed Verified Commits 対応 (2026-04)」の現物。

→ Source: `poc/E4-cloud-skill/RESULT.md §7`

### 4.5 Cloud Agent は repo 横断的に文脈を把握する

- **症状**: PR #6 body で「既存 `triage-issue.lock.yml` が COPILOT_GITHUB_TOKEN 不在で失敗している」ことに自発的に言及。
- **教材化方針**: Phase 06 で「Cloud Agent は repo を全体で読む」を 1 行で触れる。

→ Source: `poc/E4-cloud-skill/RESULT.md §6`

---

## 5. Memory (★ Phase 01 で最も大きな発見)

### 5.1 ★ Memory は **物理的な Markdown ファイル**としてディスクに保存される

- **症状**: コマンドパレット `Chat: Show Memory Files` でファイル一覧が開ける。中身は普通の Markdown。
- **保存先**:
  | スコープ | パス |
  |---|---|
  | **Global (User)** | `~/.vscode-server-insiders/data/User/globalStorage/github.copilot-chat/memory-tool/memories/preferences.md` |
  | **Repo (Workspace)** | `~/.vscode-server-insiders/data/User/workspaceStorage/<workspace-id>/GitHub.copilot-chat/memory-tool/memories/repo/<auto-named>.md` |
- **教材化方針 (★Trust thread の核)**: **Phase 04 (Step 1 教材化) の主柱**。
  - 「ブラックボックスではない」を**ファイル可視化で示す**
  - ファイルを開いて中身を見る・編集する・削除する = 「自分の Copilot を躾けている」のメンタルモデル

→ Source: `poc/E6-memory/RESULT.md §2`

### 5.2 ★ Copilot がスコープを自動判別する

- **症状**: 同じ "覚えて" 系の入力でも、内容で振り分けが自動で切り替わる:
  | 入力例 | 自動判定 | 保存先 |
  |---|---|---|
  | 「**このリポでは** [bug]/[feat]/[docs] prefix」 | Repo | `repo/issue-conventions.md` |
  | 「コミットメッセージは Conventional Commits」 | Global | `preferences.md` |
- **教材化方針**: Phase 04 で **2 種類の入力を順に試させる** デモ構成。スコープ自動判別の賢さを体感させる。

→ Source: `poc/E6-memory/RESULT.md §2.2`

### 5.3 ★ Chat 上に "Created memory file [link]" / "Read memory [link]" のトレースが出る

- **症状**: 記憶植え付け時 → `Created memory file [path]` がリンク付きで応答冒頭に表示。記憶参照時 → `Read memory [path]` 同様。
- **教材化方針**: Phase 04 の Step 1 演習で **「植え付け時 / 参照時の Chat ログのスクショ」を成果物として要求**。学習者が「効いた!」を二重 (UI 表示 + ファイル中身) で実感できる。

→ Source: `poc/E6-memory/RESULT.md §3, §4`

### 5.4 Memory off / 削除 UI は未確認 (ファイル直接削除でリセット可)

- **症状**: 公式の「Memory パネル UI で off/on 切替」は今回未確認。
- **回避策**: ファイル直接 `rm` で記憶リセット (検証では未実施だがファイル可視性から成立は明らか)。
- **教材化方針 (★プライバシー)**: **Phase 04 で「削除 = ファイルを消す」を必ず教える**。プライバシー懸念への配慮として欠かせない。Phase 11 の公開準備で「Memory が物理ファイルである」をプライバシー注意事項としても明文化。

→ Source: `poc/E6-memory/RESULT.md §6`

### 5.5 検証時の環境メモ

- VS Code: **Insider** で確認 (安定版でも動作見込みだが未検証)
- workspace ID 例: `2413842ddc815e4ce37260503d8aeba0` (test-ghcp-workshop-validation)
- クラウド同期挙動: 未確認 (Phase 04 着手時に再検証 candidate)

→ Source: `poc/E6-memory/RESULT.md §7`

---

## 6. Required Check (Step 6) — Path 比較

### 6.1 ★ `.agent.md` 直接 Required Check (Path A) は preview/未公開

- **症状**: `.github/agents/review-pr.agent.md` を main に commit して PR を作っても check が一切 auto-trigger しない。Branch Protection の Required Check 候補にも出てこない。
- **原因**: macroscope 等が言う「Check Run Agents」機能は GA 前。repo / org 設定にも該当項目なし (2026-04 時点)。
- **教材化方針**: **Phase 09 (Step 6) では Path A は採用しない**。教材本文では「将来的にこの機能で `.agent.md` を直接 Required Check 化できる予定」と Trust thread の伏線にとどめる。

→ Source: `poc/E5-required-check/RESULT.md §2`

### 6.2 `.agent.md` を Actions から呼ぶ公開 API がない (Path B)

- **症状**: `gh copilot custom-agent run` のような CLI が存在しない。`gh aw` は workflow `.md` 専用 (`.agent.md` は dispatcher として読まれるのみ)。GitHub REST/GraphQL の Custom Agent invoke endpoint も未公開。
- **回避策 (現状)**: `.agent.md` の起動経路は **(a) Copilot CLI/IDE/Cloud Agent からの delegation 経由** と **(b) Chat で `@<agent-name>` 明示** の 2 つのみ。
- **教材化方針**: Phase 09 で `.agent.md` は **「再利用可能なレビュアー人格」** として並列紹介。Required Check 化は Path C に任せる。

→ Source: `poc/E5-required-check/RESULT.md §3`

### 6.3 ★ Copilot Code Review (Path C) を Required Check 主軸に採用

- **設定**: Settings → Copilot → "Enable Copilot code review on PRs" → ON。Branch protection で "Require Copilot review" を Required に。
- **API 経由の reviewer 要請は不可**: `gh pr edit --add-reviewer copilot` 系は全て NOT_FOUND。**UI / repo 設定のみ**。
- **教材化方針**: **Phase 09 の主軸**。UI スクショ中心の 5 分構成 (RESULT.md §4 に手順案あり)。Custom Agent (`.agent.md`) は同 Phase の発展題材として並列に教える。

→ Source: `poc/E5-required-check/RESULT.md §4`

---

## 7. UI / コマンドパレット 定型

教材で繰り返し使う UI 操作はここに集約 (Phase 03 以降で参照):

| 操作 | コマンド / パス |
|---|---|
| Memory ファイル一覧 | `Ctrl+Shift+P` → `Chat: Show Memory Files` |
| MCP 設定 | `.vscode/mcp.json` (Cloud `gh aw init` 生成、または手書き) |
| Copilot Code Review 有効化 | Settings → Copilot → "Enable Copilot code review on PRs" |
| Copilot allowlist (Cloud Agent firewall) | Settings → Copilot → Coding agent → Custom firewall |
| PAT 作成 (Copilot Requests) | https://github.com/settings/personal-access-tokens/new (Owner: 個人 / Repo access: **Public**) |
| Cloud Agent assign (CLI) | `gh issue edit <N> --add-assignee copilot-swe-agent` |
| gh aw secret 登録 | `gh secret set COPILOT_GITHUB_TOKEN -R <owner>/<repo>` |
| gh aw 初期化 | `gh aw init` (5+1 ファイル生成) |
| gh aw compile | `gh aw compile` (`.lock.yml` 生成) |

---

## 8. SKILL.md / `.agent.md` spec 関連の "教材化注意"

### 8.1 SKILL.md frontmatter は「`name` + `description`」だけ教える

- **理由**: spec が小さく、変動しても教材が陳腐化しにくい。`description` がモデル trigger になる仕組みは安定 (E2 で確認済)。
- **教材化方針**: Phase 05 (Step 2) のテンプレは 2 フィールドのみ。`license` `metadata.version` は推奨として補足。

→ Source: `VERSIONS.md §2`

### 8.2 `safe-outputs` は教材で "ガードレール" の象徴として位置づける

- **使うキー**: `add-labels` (Step 4 メイン) / `add-comment` (Step 4 メイン) / `create-issue` (サンプル例)
- **使わない**: `create-pull-request` (Step 6 で間接的)
- **教材化方針**: Phase 07 で `safe-outputs` を **「Agent の生出力を GitHub に直接書かせない gh aw のガードレール機構」** と明示説明。Trust thread Layer 4 の主舞台。

→ Source: `VERSIONS.md §4`, `poc/E3-gh-aw/RESULT.md §3`

---

## 9. MCP / Copilot Chat UX (Phase 03 dry-run で発覚)

> **発見契機**: Phase 03 (Step 0 教材化) のユーザー実機 dry-run (`shinyay/ghcp-6-layer-agentic-platform-phase3-dry-run`, 2026-04-25)。E1 検証 (2026-04-24) と僅か 1 日差で挙動が変わったため、Phase 04+ 全 Step に共通する教訓として独立章にした。
> **権威ソース**: `phase-03-step0.md` §10 改訂履歴 / `00-master-plan.md §4.5.2` (MCP verification block 標準化条文)

### 9.1 ★ MCP server は `.vscode/mcp.json` で明示宣言する (auto-detect は version-dependent)

- **観測 1 (2026-04-24, E1)**: `.vscode/mcp.json` 不在の throwaway repo でも、Codespaces の Copilot Chat が GitHub MCP server を **自動検出** し `mcp_github_*` ツールを露出していた。
- **観測 2 (2026-04-25, Phase 03 dry-run)**: 同じ手順で起動した playground repo では **自動検出されず**、Agent が `gh` CLI に勝手にフォールバックした (Trust thread 完全スキップ)。
- **解消手段**: workshop repo (= template) に以下を同梱し、template-create 経由で playground にも伝播させる:
  ```json
  { "servers": { "github": { "type": "http", "url": "https://api.githubcopilot.com/mcp/" } } }
  ```
- **教材化方針**: Phase 04+ で MCP を使うすべての Step (Step 0/4/6 等) は **template から作った playground を前提**にし、教材冒頭の verification block で「`.vscode/mcp.json` が repo にあるか」を必ず確認させる。

→ Source: `phase-03-step0.md §10` (C6 hotfix 行) / `00-master-plan.md §6.2 R13`

### 9.2 ★ MCP tools は palette **checkbox default OFF** — Trust thread スキップの最大原因

- **観測**: `.vscode/mcp.json` を投入し Reload 後、Tools palette に `github` server は表示されたが、配下のツール (`list_issues` 等) の **チェックボックスはすべて OFF** だった。
- **症状**: OFF のまま triage プロンプトを送ると Agent は MCP を呼ばず、`gh` CLI フォールバックしてしまう (= F4 と同じ症状を別経路で再現)。
- **対処**: 受講者に **明示的に「ON にする」操作を指示**する。最低 3 ツール (`list_issues` / `update_issue` / `add_issue_comment`) を ON、または `github` server まとめて ON。
- **教材化方針**: Phase 04+ の MCP verification block §3 に「checkbox を ON にする」を独立ステップとして明示。スクリーンショット推奨 (Phase 11 で本物画像差し替え)。

→ Source: dry-run ターミナルログ (2026-04-25 10:54 JST 報告)

### 9.3 ★ 認証は **3 層モデル** (PAT 不要は不変だが、ダイアログは 3 種類出る)

| Layer | いつ出るか | 何を承認するか | 頻度 | 教材での扱い |
|---|---|---|---|---|
| **Layer 1: Copilot サインイン** | Codespaces 起動直後 | VS Code → GitHub アカウント連携 (Copilot 利用) | 初回のみ | Step 0 §3.B |
| **Layer 2: MCP server OAuth** | `github` server の checkbox を初めて ON にしたとき | MCP server → GitHub API への OAuth スコープ付与 | 初回のみ (セッション継承) | Step 0 §3.C-2 (新規明示) |
| **Layer 3: Tool 実行ごとの Allow** | Agent が各 MCP ツールを初めて呼ぶたびに | そのツール (label / comment / etc.) に対する承認 | 各ツール初回 (= Trust thread の本命) | Step 0 §3.E (mini-triage で 2-3 回) |

- **これまでの誤解**: 「PAT 不要 = 認証ダイアログ 0 回」と表現していた (E1 RESULT §3 / VERSIONS §2.5 旧版)。実際は PAT 不要だが OAuth ダイアログは出る。
- **教材化方針**: Step 0 README 冒頭に **3 層 Mermaid 図** を入れて受講者に「ダイアログが複数レイヤーで出るのは正常」と前置きする。Layer 3 が Step 0 のクライマックスで、Layer 1/2 は通過儀礼として扱う。

→ Source: dry-run の OAuth ダイアログ目視 (2026-04-25 10:52 JST 報告)

### 9.4 gh CLI フォールバック検出パターン (Trust thread スキップのサイン)

- **検出文言** (Agent 応答に出たら MCP 未経由):
  - 「`gh issue edit ...` を実行しました」
  - 「`gh issue comment ...` で投稿しました」
  - 末尾の言い訳「GitHub MCP server tools が直接公開されていなかったため、`gh` CLI で実行しました」
- **正しい挙動の文言** (Trust thread 成立サイン):
  - 「Add comment to issue を実行しました」「Create or update issue. を実行しました」のような **MCP ツール表示名**
  - Chat UI に承認ダイアログのフォロー表示 (`Allow add_issue_comment to run?` 等)
- **教材化方針**: Step 0 §3.E の「期待挙動」と「失敗パターン」を CAUTION で対比表示 (現状 README §3.E 既存)。Phase 04+ も同じ検出ガイドを継承。

→ Source: dry-run 失敗ログ (2026-04-25 §3.E 1 回目試行)

### 9.5 Copilot 前提欠落 UX (positive)

- **観測**: Issue 0 件の状態で「triage して」と頼むと、Copilot は強行せずに **「seed しますか? 別 repo を指定しますか? 新規 Issue を作りますか?」** と選択肢を提示してくれた。
- **学び**: Agent モードでも Copilot は **前提欠落を察知すると安全側に倒す** 良い設計が入っている。
- **教材化方針**:
  - Step 0 §5 Troubleshooting に「Issue が空のまま triage を頼んだ → Copilot が選択肢を出す」行を確保 (既存)。
  - Phase 04+ (Step 1 Memory / Step 4 gh aw) でも、前提欠落シナリオを **意図的に踏ませて** Copilot の安全動作を体験させる演習を検討。

→ Source: dry-run §3.E 1 回目 (2026-04-25 報告)

### 9.6 template repo 化は **private** でも動作 (D11 解消)

- **検証**: `gh repo edit shinyay/ghcp-6-layer-agentic-platform --template` を private repo に対して実行 → `isTemplate: true` が反映、「Use this template」UI が出現、private のまま template として利用可能。
- **以前の懸念**: D11 で「template 化は public 必須」と仮定していたが、実機では private で問題なし (GitHub 仕様変更 or 元から OK だった)。
- **教材化方針**:
  - Phase 11 まで repo は private 維持で OK (公開タイミングを workshop 開催直前まで遅らせられる)。
  - Step 0 README §3.A の「Use this template」誘導は public 化前でも有効。

→ Source: Phase 03 C2 commit `d0a6667`、`gh repo view --json isTemplate -q .isTemplate` = `true` 確認

---

## 10. Memory / Step 1 教材化 (Phase 04 で確立)

> Phase 04 (Step 1 Memory 教材化) で得た UX 知見と設計パターン。Phase 03 §9 (MCP) と並ぶ Step 教材化固有の章。Phase 05+ 計画書執筆時に必ず参照。

### 10.1 ★ Memory のスコープ自動判別が「賢さ」を実感させる

E6 §2.2 の発見を Phase 04 教材化で確証: 同じ Chat セッション内で 2 種類の植え付け prompt を順に投げると、Copilot は **発話の文脈** から保存先スコープを自動判別する:

| 入力例 | 判定 | 保存先 |
|---|---|---|
| 「**このリポジトリでは** Issue タイトルに [bug]/[feat]/[docs] prefix」 | **Repo** スコープ | `repo/issue-conventions.md` (auto-named) |
| 「コミットメッセージは Conventional Commits を使います」 | **Global (User)** スコープ | `preferences.md` |

> **教材化の含意**: 学習者は「Memory がブラックボックスじゃない」(§5 で既に体感) の次に「**振り分けも賢い**」を §3.D で連続体験する。これが Step 1 の中ピーク → 大ピークへの感情線を支える。Step 2 ⭐ への動機 (= 「個人 Memory を repo Skill に格上げしたい」) はこの "賢さ" 体感の延長で初めて自然に立ち上がる。

### 10.2 ★ F5 演習は **reset → 演習 → restore** の 3 段で前提を固定する

§9.5 の F5 (前提欠落 UX) は positive な発見だが、教材で線形に流すと **演習後に Memory が空のまま終わって次 Step が動機を失う** 罠がある (R04-4)。Phase 04 D9 で確立した解法:

```
(1) Memory リセット (rm)        ← F5 の前提を作る
(2) 空 Memory で triage 依頼    ← F5 演習本体
(3) Restore: §3.A の植え付け prompt をコピペ  ← 終端を安定状態に固定
```

> **教材化の含意**: 「演習で見せたい挙動」と「次 Step に必要な前提」が衝突する場合、**演習を 3 段でサンドイッチする** のが汎用解。Step 4 (gh aw) で「workflow を一旦壊して挙動を見る」演習や、Step 6 (Gate) で「Required Check を一旦解除して見せる」演習にも転用可能。

### 10.3 ★ escape hatch branch の限界 = repo state only、ローカル状態は乗らない

Phase 03 で「`step-N-complete` で repo を等価状態に戻せる」を P3 として確立したが、Phase 04 で **Memory のような クライアントローカル状態は branch には乗らない** ことが現物で問題化 (R04-11)。rubber-duck Critical 1 を受けて確立した P04-2 パターン:

- README §4 Done checklist の **末尾に branch 切替コマンドを書く際、`⚠ Memory はローカル状態` 警告を必ず付記**
- README §6 (次の Step) に **「escape hatch で飛んできた場合の bootstrap」セクション** を独立で配置
- 計画書 §7 リスク表に R04-11 として明示、Phase 05+ も同型

> **教材化の含意**: この問題は Memory 固有ではなく、**「ローカルクライアント状態 (拡張設定 / ワークスペース cache / Codespace 内ファイル変更)」を持つ Step すべて** で発生する。Step 3 (Where to Run) で CLI ログイン状態、Step 5 (Multi-engine) で API key 設定など、各 Step で同じ警告 + bootstrap パターンを踏襲する。

### 10.4 §3.5 のような **独立節** は「個別関心で読み返す」用途

D2 (ユーザー判断) で確立: プライバシー / 削除 / リセット手順は **手順節 (§3) の中だが ## 3.x ではなく ### 3.X で配置**。これにより:

- 線形読者は §3.A → §3.B → ... → §3.E の順で自然に通過 (= プライバシーは §3.5 で軽く流す程度)
- 「うっかり覚えさせちゃった、どう消す?」と後日戻ってくる読者は ToC で `### 3.5` を見つけて直接ジャンプできる
- §6 (次の Step) や §5 (詰まったら) に紛れ込ませると "教材本筋" として読まれてしまい、独立性が失われる

> **教材化の含意**: Step 4 でのワークフロー停止コマンド、Step 5 での API key ローテーション、Step 6a での Required Check 解除手順 など、**「フロー外で参照される操作」は独立節で配置** する。

### 10.5 all-step gate (paths `content/**`) の運用明文化

D13 で確立、phase-04-step1-memory.md §11.1 P04-5 として固定化。`step-gate.yml` の paths trigger を細粒化せず `content/**` のままにすることで:

- Step 1 を変更したら Step 2-6 の gate も走る = early signal
- 各 Step gate は **そのまま実行されてもファイル不在で fail しない設計** (T-101 等は対象 README が無ければ最初の `test -f` で即 exit 0 ではなく fail だが、各 step-N-gate は対象 step が公開済かを `test -f` の前提に組み込む実装になっており、Step N+1 が未公開の状態で誤発火しない)

> **教材化の含意**: Phase 11 で paths 細粒化を再検討する際、CI 時間がボトルネックになっていなければ all-step gate を維持する方針。Step 6b (Custom Agent 発展題材) のような「公開判断保留」Step がある場合に paths 細粒化が必要になる可能性。

### 10.6 §4.5.3 V1-V4 の exempt 適用パターン (MCP 非依存 Step)

P04-1 として固定化。MCP verification block (V1=mcp.json / V2=Tools palette / V3=tool name / V4=auth) は「MCP 経由で Trust thread を体験させる Step」のために設計されたが、Memory のように **Copilot Chat 拡張のクライアントローカル機能のみで完結する Step** では適用しても意味がない (Trust UI が出現しないため)。

Phase 04 §10 で確立した **exempt 明示マッピングテンプレ**:

| # | チェック項目 | 当該 Step での応答 |
|---|---|---|
| 1 | MCP 利用 Step か? | **No** (or Yes) |
| 2 | Yes の場合: §「前提条件」に V1-V4 準拠明記 | **N/A** (No なら) |
| 3 | Yes の場合: 利用 MCP ツール最小セット明示 | **N/A** (No なら) |
| 4 | §5 Troubleshooting に「Trust thread が出ない」行 | **読み替え適用**: 機能未利用時のトラブル行 (Pro 未満 / コマンド未表示 / 反映遅延 / セッション持続性) を必ず含める |

> **教材化の含意**: 項目 4 の **「読み替え適用」** が重要。MCP 非経由 Step でも「機能が動かない時の症状リスト」は必ず §5 に置く。空欄にすると学習者が困った時に詰まる。

---

## 11. 残タスク / 未確認事項 (Phase 02 以降で再確認)

| 項目 | 再確認 Phase | メモ |
|---|---|---|
| Memory ファイルのクラウド同期挙動 | Phase 04 | VS Code Settings Sync で同期されるか? プライバシー説明に必須 |
| Memory off/on の公式 UI | Phase 04 | コマンドパレット / Settings に切替が出るか再調査 |
| `.agent.md` Required Check 直接化 (Check Run Agents) | Phase 09 / Phase 11 | GA 状況を Phase 11 (公開準備) でも追跡 |
| VS Code 安定版での Memory 動作 | Phase 04 | Insider のみで動く場合、教材で「Insider 推奨」と明記 |
| gh aw のバージョン更新による spec 変動 | Phase 11 | 公開直前に再 compile / re-run check |

---

## 12. 改訂履歴

| 日付 | 変更 |
|---|---|
| 2026-04-25 | 初版作成 (Phase 01 クロージング作業 D-learnings) |
| 2026-04-25 | **§9 新章追加** (MCP / Copilot Chat UX, 9.1-9.6): Phase 03 dry-run で発覚した F1-F6 (`.vscode/mcp.json` 必須化、tools default OFF、認証 3 層モデル、gh CLI フォールバック検出、Copilot 前提欠落 UX、template private OK)。既存 §9 残タスク → §10、§10 改訂履歴 → §11 に繰り下げ |
| 2026-04-25 | **§10 新章追加** (Memory / Step 1 教材化, 10.1-10.6): Phase 04 で確立した UX 知見 (Memory スコープ自動判別の "賢さ"、F5 演習 reset→演習→restore 3 段、escape hatch repo state only 限界とローカル状態 bootstrap、§3.5 独立節パターン、all-step gate 運用、§4.5.3 V1-V4 exempt 適用)。既存 §10 残タスク → §11、§11 改訂履歴 → §12 に繰り下げ |
