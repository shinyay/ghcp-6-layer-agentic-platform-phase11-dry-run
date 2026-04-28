# Phase 07 詳細計画書 v2 — Step 4 (Automate / `gh aw`) 教材化

> **位置付け**: Phase 06 (Step 3 = 3 surfaces) の S07-1〜S07-8 申し送りを **本 Phase で全て学習者文書に降ろす**。Step 4 = "**人間 → エージェント** 呼び出しから **イベント → エージェント** 自動化へのターニングポイント"。
> **本ファイルは Phase 06 SoT と同型構造** (§1 Goal → §2 Scope/D → §3 Dir → §4 Commits → §5 Test → §6 DoD → §7 Risks → §8 進め方 → §9 Refs → §10 §4.5.3 mapping → §11 申し送り → §12 履歴)。
> **v2 = rubber-duck critique (Blocking 4 + Important 10 + Suggestion 7) 反映後**。

---

## 1. Phase Goal

### 1.1 主目的

`content/step-4-automate/` を **heavy demo (~20–25min, 6 sub-step)** に書き上げ、**Issue opened による自動起動** + **`workflow_dispatch` で issue_number 指定して手動再実行** の両方で自動 triage が完走する状態を 6 commits + escape hatch branch (`step-4-complete`) で公開する。

中核メッセージ:
- **Step 3** = 「人が `@copilot` Issue assignee で **手動起動** する Cloud Agent」
- **Step 4** = 「`gh aw` workflow が **Issue opened を gate にして自動起動** で triage を実行」(★ "自動 assign" ではなく "自動起動 / イベント駆動 triage")
- 自動化されても **エージェントへ書き込み権限を直接渡さない** という Trust thread は変わらない (Step 3 で見た Cloud Agent firewall default deny と同じ思想の **別表現**)
- **`gh aw` strict mode + `safe-outputs`** = エージェント (agentic job) に `permissions: write` を一切渡さず、`safe_outputs` job だけが label/comment を書き戻す = Trust thread Layer 4 核心

### 1.2 Phase 完了時に手元にあるもの

- 学習者が Codespaces で開いて **20–25 分** で完走できる Step 4 README (~350 行、heavy 構成)
- 学習者の playground repo に commit される **`gh aw init` の core artifacts** (v0.68.3 時点。将来 minor drift があっても以下の core があれば OK):
  - `.github/workflows/triage-issue.lock.yml` (gh aw 自動生成、~63KB)
  - `.github/workflows/triage-issue.md` (`safe-outputs.add-labels` + `add-comment`、`on: { issues.opened, workflow_dispatch.inputs.issue_number }` 併記)
  - `.github/agents/agentic-workflows.agent.md` (dispatcher)
  - `.github/aw/actions-lock.json`
  - `.github/workflows/copilot-setup-steps.yml` (gh aw scaffold 版)
  - `.vscode/mcp.json` (playground 側で新規生成、workshop repo の既存版とは別)
- `step-4-complete` branch (**documentation + canonical template state**: workshop repo 上では `content/step-4-automate/templates/` 配下に sample workflow/agent .md を置き、active workflow は意図的に置かない。理由: workshop repo 上で workflow を active にすると workshop 自身のリポジトリで gh aw が動いてしまうため)
- `step-gate.yml` `step-4-gate` job (T-401..405 + Group A/B/C positive + Group D negative、**marker block 抽出方式**)
- prereqs **P2 改訂** + **P3 強化** + **P10 新設** (`COPILOT_GITHUB_TOKEN` 専用秘訣)
- master-plan §9 Phase 07 ✅ + §6 R6 status note + §6 R9 補足 + **§4.5.3 修正** (Step 4 = MCP 利用 Step 表記の訂正)

### 1.3 マイルストーン

master-plan §5 の **M3 (Phase 07 完了 = "ツアー前半まで" 配布可能、ハーフバージョン)** を達成。Standard プロファイル (Pro+) は Step 0→1→2→3→4 完走、Pro 単体プロファイルも Step 4 §3.D で **初の Copilot CLI engine による server-side triage 実機体験** を獲得 (S07-6 接続点。Cloud Agent UI = Issue assignee 経由ではなく、Actions runner 上の Copilot CLI engine が PAT 経由で triage を実行する形式)。

---

## 2. Scope

### 2.1 IN SCOPE

| 対象 | 何を作るか |
|---|---|
| `content/step-4-automate/README.md` | heavy demo (6 sub-step ~20–25min) 必須 7 セクション準拠、§2 NOTE に **Step 3 §3.C degraded complete からの接続** + playground repo preflight 1 行 (`pwd && git remote -v` で workshop repo でないことを確認) + **PAT 作成手順 + sanity check**、§3 = 3.A `gh aw init` / 3.B PAT bootstrap (`gh aw secrets set` 主導線) / 3.C workflow 編集 + **strict mode わざと失敗 → safe-outputs 修正、compile-before-commit 順序固定** / 3.D Issue opened による自動起動完走確認 / 3.E `workflow_dispatch -f issue_number=<N>` で手動再実行 / 3.F **比較表 (Step 3 の 3 surface + Step 4 の 1 surface = 4 行 × 6 観点)**、§4 完了確認は **3 段階** (Setup ready / Step 4 minimum complete / Step 4 full complete) |
| `content/step-4-automate/templates/triage-issue.md` | canonical sample workflow (= step-4-complete branch の "documentation + template" の実体)。`on: { issues: { types: [opened] }, workflow_dispatch: { inputs: { issue_number: { required: true, type: string } } } }`、`safe-outputs.add-labels.allowed: [bug, enhancement, question, documentation]` (★ Step 2/3 vocabulary と整合)、`safe-outputs.add-comment` 含む |
| `content/step-4-automate/templates/expected-files.md` | `gh aw init` で生成される core files の checklist (v0.68.3 時点 + drift 注記) |
| `content/README.md` | Step 4 行 🚧 → ✅、`🪂 escape hatch` 表に `step-4-complete` 行追加 (**documentation + canonical template state**、workshop repo には active workflow を置かないことを明文化)、IMPORTANT note で "Step 4 から Pro plan も Copilot CLI engine 由来 server-side triage を実機体験可能" |
| `content/prerequisites.md` | **P2 改訂** (PAT 詳細手順を Step 4 §3.B に移送、P2 は 1 行サマリ + リンク)、**P3 強化** (sanity check スニペットを copy-paste 可能形に整形)、**P10 新設**: `COPILOT_GITHUB_TOKEN` 登録経路 = ① UI method (Codespaces で確実) ② `gh aw secrets set COPILOT_GITHUB_TOKEN --value "$COPILOT_PAT"` (主導線) ③ `gh aw secrets bootstrap` (existing secrets check) ④ fallback `gh secret set COPILOT_GITHUB_TOKEN -R <owner>/<playground>`。**playground repo に設定** を `gh repo view --json nameWithOwner` で確認させる手順を組み込み。環境チェックに「`gh aw version` = v0.68.3」「fine-grained PAT 保有」を追加 |
| `docs/planning/VERSIONS.md` | **§1 R6 status note** (Phase 07 publish 時点で gh aw v0.68.3 spec PASS 確認済 + Phase 11 で再検証必須)、**§4 frontmatter spec** に `on: { issues: { types: [opened] }, workflow_dispatch: { inputs: { issue_number: { required: true, type: string } } } }` パターン + `safe-outputs target = ${{ github.event.issue.number || github.event.inputs.issue_number }}` パターンを追記、**§9 安全ガードレール** に "strict mode = `permissions: write` 系を agentic job に渡さない / safe_outputs job だけが書き戻す" を 1 段落明記 |
| `docs/planning/00-master-plan.md` | §9 Phase 07 ✅ + §6 R6 status note + §6 R9 補足 + **§4.5.3 訂正** (= 旧記述「Step 0/4/6 が MCP 利用 Step」の Step 4 を削除し、「Step 4 は gh-aw runtime Step (Actions runner 上の Copilot CLI engine + safe-outputs)、VS Code MCP は使用しない」に修正) + 改訂履歴 |
| `docs/planning/poc/E3-gh-aw/RESULT.md` | 先頭に "✅ Reused as source-of-truth for Phase 07 §3 教材化" note (§8.2 = all PASS proof / §8.4 = ~3 分 elapsed proof / §3 = strict mode proof / §5+§8.3 = PAT proof を **明示参照ガイド**として記載) |
| `.github/workflows/step-gate.yml` | `step-4-gate` job 追加 (T-401..405)。**Group D negative grep は marker block 抽出方式で実装** (`<!-- step4-final-workflow-start --> ... <!-- step4-final-workflow-end -->` の中だけを検査、`<!-- step4-demo-fail-start/end -->` は除外)。Group D 対象 paths は **`content/**` のみに限定** (VERSIONS.md 等 internal docs は対象外、step-gate.yml 既存 paths との整合) |
| `step-4-complete` branch | main 派生 push (D14 = **documentation + canonical template state**、active workflow は workshop repo に置かない、template 配下に sample のみ) |
| 本ドキュメント | Phase 07 詳細計画書 v2 |

### 2.2 OUT OF SCOPE (Phase 08+)

- Step 5 本文 (Multi-engine = engine 切替: 同じ workflow の `engine:` を Copilot CLI → Claude → Codex に切り替え)
- Step 6a/6b 本文 (Required Check / Custom Agent)
- Step 4 §3 で **複数 workflow を作る**こと (本 Phase は **`triage-issue.md` 1 本のみ**、daily-issues-report 等は §5 References 経由で誘導)
- 実機スクリーンショット (Phase 11)
- gh aw v0.69+ 対応 (Phase 11 で再検証時に判断)
- ARC on AKS への移行手順 (Step 3 §5 と Phase 09+ で扱う)
- Pro plan 学習者向け Cloud Agent 録画 (Phase 10、本 Phase では文字 + screenshot 引用のみ)
- 新規 PoC (E9/E10) は **不要** = E3 RESULT §1-§8.4 で end-to-end PASS 済、E9 はユーザー手動完走 marker としてのみ
- gh-aw `network.allowed` allowlist 詳細 (Step 5/6 発展題材、Step 4 では default 挙動のみ)
- gh-aw `roles` フィルタ詳細 (third-party Issue 開設者の role 制限、本 workshop は learner = repo owner 前提)

### 2.3 設計判断 (D1-D23) — Phase 06 D1-D20 と同型 + Step 4 固有 3 件 + critique 反映の D23

| # | 論点 | 採用案 | 根拠 |
|---|---|---|---|
| **D1** | demo 厚さ | **heavy 20–25min** = 6 sub-step (★ S5 反映: PAT 作成・sanity check・3 分待機・dispatch 込みで 20 分は若干タイト、20–25min と幅を持たせる) | ユーザー判断 Q1 / S5 |
| **D2** | sub-step 順序 | **3.A `gh aw init` → 3.B PAT bootstrap → 3.C workflow 編集 + strict mode fail-then-fix (compile before commit) → 3.D Issue opened 自動起動完走 → 3.E `workflow_dispatch -f issue_number=<N>` 手動再実行 → 3.F 比較表 (4 surface × 6 観点)** | E3 PROCEDURE + Phase 06 D2 のリズム継承 |
| **D3** ⚠ | strict mode わざと失敗 sub-step | **§3.C 本筋の中に 1 ステップとして埋め込む** (失敗 1 回 → 修正、commit 分けない、説明文で「これからわざと失敗させます」を明示)。冒頭 NOTE で「教材ミスではなく Trust thread Layer 4 の体感ステップ」を強調。**順序は ① `permissions: issues: write` を入れる → ② `gh aw compile` で strict mode error → ③ 即修正 (`safe-outputs` 追加 / `permissions: contents: read` のみに) → ④ `gh aw compile` PASS → ⑤ ここで初めて `git add/commit/push`** (★ S3 = compile before commit) | ユーザー判断 Q2 / E3 §3 / S3 |
| **D4** ⚠ | Pro plan 学習者ケア (★ S07-6) | **Step 4 = Pro plan も full 完走可能と扱う**。理由: gh-aw の Copilot CLI engine は **Actions runner 上で `COPILOT_GITHUB_TOKEN` 経由で動く**ため Cloud Agent UI (Issue assignee) は経由しない。**§2 prereq に "Step 3 §3.C を Pro plan で degraded した方は、Step 4 §3.D で 初めて Copilot CLI engine 由来の server-side triage を実機体験 します" 接続文を必須化** (S07-6 ハード兌換、★ "Cloud Agent 初体験" ではなく "Copilot CLI engine server-side triage" の表現で統一)。Step 3 のような "degraded complete" 分岐は **Step 4 では作らない**。**E9 を E9-Standard と E9-Pro に分離**: E9-Pro = 最低 1 回 Pro 単体ライセンスで実機完走 (Plan 上の証拠付け、Phase 10 ユーザーテストに繰り上げ可能) | ユーザー判断 Q3 / S07-6 / E3 §5 / Q3 critique |
| **D5** ⚠ | playground repo prereq | §2 で「Step 3 完走済 (workshop repo の SKILL.md が playground repo にも push 済)」を **ハード前提**化、verify コマンド再掲 (`gh api repos/<owner>/<repo>/contents/.github/skills/issue-triage/SKILL.md --jq .name`)。**追加: playground = public + Actions 有効 + clean repo (Step 3 §2 の 3 前提を再掲)** + **`pwd && git remote -v` で workshop repo でないことを確認する preflight 1 行** (★ I4 = `.vscode/mcp.json` 衝突は throwaway public clean playground 前提なら発生せず、過大評価しない) | S07-7 / E3 §2 / I4 |
| **D6** ⚠ | 比較表 (§3.F) | **Step 3 の 3 surface + Step 4 の 1 surface = 4 surface × 6 観点**: ① 実行場所 (Local IDE / CLI / Cloud Agent / **Workflow runner (gh aw)**) / ② publication 要件 (workspace / current branch / default branch + issue assign / **default branch + workflow file commit + secret 登録**) / ③ 観測トレース (`file:///` / `/skills` 出力 / branch + draft PR / **Actions run UI: agent + detection + safe_outputs job 全 SUCCESS + 最終 Issue label/comment**) / ④ レイテンシ (即時 / 即時 / 数十秒〜分 / **約 3 分 = E3 §8.4**) / ⑤ 読む state (workspace / current branch / default branch pushed / **default branch pushed + secret + workflow trigger event**) / ⑥ 適用シーン (作業中 / コマンドライン / 探索的 manual triage / **イベント駆動定常運用**)。これが workshop の **最終比較表** (持ち帰り資料)。 | Phase 06 D6 改訂版継承 / 4 surface model / S7 |
| **D7** ⚠ | 3 段階 done checklist (§4) | **`Setup ready (= scaffold + PAT + secret 完了、まだ workflow 未 push)` / `Step 4 minimum complete (= Auto-trigger crossed = workflow push 後 Issue opened で自動起動 → 約 3 分後に label/comment 反映)` / `Step 4 full complete (= Manual-trigger crossed = workflow_dispatch -f issue_number=<N> で手動再実行 → 同結果 + 比較表 §3.F 書き写し済)`**。各 4+ items。**Step 4 最低完了 = `Step 4 minimum complete` (Auto-trigger crossed) と明記**、Setup ready で離脱すると Step 4 の核心 (= 自動起動 + safe-outputs 経路) を体験していないことを Done 構造で強制 (★ I2 反映) | I2 / Phase 06 D8 同型 / Q6 workflow_dispatch 併記 |
| **D8** ⚠ ★ B1 | `workflow_dispatch` actuation | E3 PROCEDURE は `on: issues.opened` 単体だったが、本 Phase は **`on: { issues: { types: [opened] }, workflow_dispatch: { inputs: { issue_number: { required: true, type: string } } } }` を必須テンプレ化**、**safe-outputs target = `${{ github.event.issue.number || github.event.inputs.issue_number }}`** で 2 経路を解決。教材コマンドは **`gh workflow run triage-issue.lock.yml -f issue_number=<N>`** で固定 (★ B1 修正、`workflow_dispatch` には `github.event.issue.number` がないため input 必須)。意義: ① demo 中の "今すぐ動かしたい" 場面で再現性向上、② §3.E が「**任意の Issue number に対して triage workflow を手動実行する運用 entrypoint**」として独立した教材価値 (★ S1 = "manual re-trigger" よりも "specific issue re-run" 文言)、③ E3 §8.4 の 3 分タイミングを demo 中に複数回観察可能 | B1 / S1 / ユーザー判断 Q6 |
| **D9** ⚠ | self-hosted runner 持ち込み (★ Phase 06 §5 4 troubleshooting) | **§5 Troubleshooting は Step 4 固有 5+ 行を独立 table 化** (PAT 関連 / strict mode / `.lock.yml` diff / `.vscode/mcp.json` 確認 / 3 分待っても反映しない場合の interpretation = `agent` / `detection` / `safe_outputs` 3 job 全 SUCCESS の確認)。**Step 3 §5 への link は "GitHub-hosted runner quota / managed minutes 切れ等で self-hosted へ逃がす必要がある場合のみ"** に限定 (★ I3 反映、「そのまま適用」の誇張表現を弱める) | I3 / DRY / Phase 06 §5 |
| **D10** | strict mode 失敗 sub-step (§3.C) の commit 構造 | **commit を分けない** (失敗 → 修正を 1 stage で完結)。教材文言で「**いま `permissions: issues: write` を入れた状態で `gh aw compile` を走らせると、こう失敗します**:」→ コマンド出力を inline → "**この失敗が `safe-outputs` 必須化の正体です**"。E3 §3 の Trust thread 評価を keynote 連動で引用 | E3 §3 / D3 補強 |
| **D11** | Done 3 段階 = Pro plan も full 完走 | Step 3 の "Cloud crossed (minimum) / Cloud triage observed (full)" と異なり、Step 4 は **Setup ready / minimum / full** の 3 段階。Pro plan も full 完走可能 (D4) のため degraded 分岐不要 | D4 / D7 |
| **D12** ⚠ | Trust thread 伏線 (Step 4 固有文言) | 冒頭 IMPORTANT に: 「Step 3 では Cloud Agent sandbox の **firewall default deny** を観察した。Step 4 では別の guardrail として、**`gh aw` strict mode が agentic job に `permissions: write` を渡さず、`safe_outputs` job だけが label/comment を書き戻す**。どちらも "**エージェントに直接書き込み権限を渡さない**" という Trust thread の **別表現**。これが Step 6a (Required Check) の "**人間が最後に判断する**" へ直結」 (★ I9 反映: Step 4 で firewall default deny を直接持ち出さず、strict mode + safe-outputs に集中) | E3 §3 / Trust thread Phase 06 D14 継承 / I9 |
| **D13** | Memory bootstrap 注記 (§2) | "escape hatch (`step-3-complete`) で飛んできた場合、Memory が空でも本 Step は OK (gh aw workflow は Memory 非依存)。Memory 再現したい場合は Step 1 §3.A 参照" を §2 末尾 NOTE に置く | Phase 06 D15 継承 / P05-1 |
| **D14** ⚠ ★ B3 | escape hatch (`step-4-complete`) の意味 | **documentation + canonical template state** = workshop repo (本 repo) には **active workflow を置かない**。代わりに `content/step-4-automate/templates/triage-issue.md` + `expected-files.md` を canonical sample として配置。`step-4-complete` branch を checkout すると README が "Step 4 完読 state"、template が即手元にあり、学習者は **playground repo に展開する形** で Step 4 を再現できる (★ B3 A案: workshop repo 上で active workflow が動くことを避けつつ、escape hatch 利用者にも実体的価値を提供)。**`COPILOT_GITHUB_TOKEN` secret は学習者が自分の playground に設定する必要あり** (= secret は branch に乗らない、これは Trust thread の一部) を §6 escape hatch 説明で明記 | B3 / D7 of phase-05 拡張 / E3 §5 |
| **D15** ⚠ ★ I1/I6/I8 **positive + negative** | step-gate.yml 拡張 (T-401..405) | Phase 06 D16 同型 + Step 4 固有: **Group A 構造/spec keyword (positive)** (`gh aw` / `safe-outputs` / `add-labels` / `add-comment` / `COPILOT_GITHUB_TOKEN` / `workflow_dispatch` / `inputs.issue_number` / `permissions: contents: read` / `triage-issue\.md`) + **Group B Step 4 概念 (positive)** (`strict mode` / **`自動起動`** / **`イベント駆動 triage`** / `safe-outputs ガードレール` / `agentic workflow` / `dispatcher` / `Copilot CLI engine`) ★ I6 = 「自動 assign」を全削除し「自動起動」「イベント駆動 triage」に統一 (gh-aw の `assign-to-agent` safe output と概念混同を回避) + **Group C 構造** (`Setup ready` + `Step 4 minimum complete` + `Step 4 full complete` の 3 段階 done) + **Group D 禁止 token (negative、marker block 抽出方式)** ★ I1 = `<!-- step4-final-workflow-start --> ... <!-- step4-final-workflow-end -->` 内だけ抽出して `permissions:.*\n.*issues:\s*write` 等を grep、`<!-- step4-demo-fail-start/end -->` 内は除外。**Group D 対象 paths は `content/**` に限定** (★ I8 A案、`docs/planning/VERSIONS.md` 等 internal docs は gate 対象外、既存 step-gate.yml paths との整合) | Phase 06 D16 継承 / S07-4 / B-critique I1/I6/I8 |
| **D16** | content/README.md 更新 | Step 4 行 🚧 → ✅ + escape hatch 表に `step-4-complete` 行追加 (意味 = "**documentation + canonical template state、`COPILOT_GITHUB_TOKEN` は学習者が playground に別途設定要**") + IMPORTANT note で "Step 4 から **イベント駆動の自動起動** に移行、Pro plan の方も Step 4 で初の Copilot CLI engine 由来 server-side triage 体験" 1 行注記 | Phase 06 D17 継承 / D4 / I6 |
| **D17** | Commits 数 | **6 commits + escape hatch branch 1 本** (Phase 06 と同型) | E3 / Phase 06 D18 |
| **D18** ⚠ ★ I10 | prereq P2 改訂 + P3 強化 + P10 新設 | **P2 改訂**: 詳細手順を Step 4 §3.B に移送、P2 は "Step 4 で使う PAT は Resource owner=個人 / Repository access=Public Repositories (read-only) / Permissions=Copilot Requests=Read-only。詳細は Step 4 §3.B 参照" の 1 行サマリに圧縮。**P3 強化**: sanity check スニペットを copy-paste 可能形 (`curl -sH "Authorization: Bearer $TOKEN" https://api.github.com/user \| jq .login`) で示す。**P10 新設** (`COPILOT_GITHUB_TOKEN` 登録経路、★ I10 反映の優先順): ① **UI method** (Codespaces で確実、Settings → Secrets → Actions → New) ② **`gh aw secrets set COPILOT_GITHUB_TOKEN --value "$COPILOT_PAT"`** (主導線、gh-aw docs 現行) ③ `gh aw secrets bootstrap` (existing secrets check) ④ fallback `gh secret set COPILOT_GITHUB_TOKEN -R <owner>/<playground>`。**playground repo に設定**を `gh repo view --json nameWithOwner --jq .nameWithOwner` で確認させる手順を組み込み | E3 §5 / §8.3 / R9 / S07-3 / I10 |
| **D19** ⚠ ★ I4 削減 | `.vscode/mcp.json` 衝突対処 | **§3.A NOTE 1 行に縮小**: 「`gh aw init` を **playground repo 上で**実行する場合、新規生成されます。preflight (`pwd && git remote -v`) で workshop repo でないことを確認」(★ I4 = throwaway public clean playground 前提なら衝突は発生せず、R07-2 を低/低に下げる) | I4 |
| **D20** | Step 5 (Multi-engine) 接続 (§6) | "Step 4 の workflow は **Copilot CLI engine** で動いた。Step 5 では **同じ workflow の `engine:` を Claude / Codex に切り替える** ことで Multi-engine 比較を実機体感する。Step 5 任意ステップへの自然な接続" | Step 5 motivation / E3 §2 |
| **D21** ⚠ ★ B2 | **MCP V1-V4 の Step 4 への適用は誤り、gh-aw runtime verification block に置換** | master-plan §4.5.3 旧記述「Step 0/4/6 が MCP 利用 Step」のうち **Step 4 は誤り**: gh-aw workflow は Actions runner 上で Copilot CLI engine + safe-outputs で動き、学習者の VS Code Tools palette checkbox は workflow 実行に影響しない。E3 RESULT も「VS Code MCP の準備が無くても workflow は完走」を示している (★ B2 反映)。**対応**: (a) C2a で master-plan §4.5.3 の Step 4 該当行を削除/訂正、(b) Step 4 README §2 末尾は MCP V1-V4 ではなく **gh-aw runtime verification block** = `gh aw version` (= v0.68.3 確認) / `gh aw compile` PASS / `.lock.yml` diff 折りたたみ確認 / `COPILOT_GITHUB_TOKEN` 登録確認 (`gh secret list -R <playground>` または `gh aw secrets list`) の 4 項目に置換、(c) §10 を「§4.5.3 適用結果」から「§4.5.3 訂正と Step 4 verification block」に再構成、(d) R07-11 を「MCP V3 失敗」から「gh-aw runtime verification 失敗時の interpretation guide」に再定義 | B2 / master-plan §4.5.3 / E3 RESULT |
| **D22** ⚠ Step 4 固有 | gh aw v0.68.3 spec 再 PASS marker | C2a で `VERSIONS.md §1 R6 status` に "**Phase 07 publish 時点で v0.68.3 spec PASS 確認済 (E9 ユーザー手動完走 marker)**" を追記、Phase 11 で再検証必須。これにより Phase 11 dogfooding 時に **v0.69+ で spec breaking change** をチェック可能 | R6 / S07-3 / Phase 11 §11.4 |
| **D23** ⚠ ★ I7 新規 | label allowlist canonical 化 | E3 PROCEDURE の `[bug, feature, question, docs]` は PoC 仮 vocabulary。**教材では `[bug, enhancement, question, documentation]` に統一** (Step 2/3 vocabulary + GitHub default labels と整合)。本文の分類カテゴリも同じにする。E3 PROCEDURE の表記は §9 References で「PoC 時の仮 vocabulary」と注記 | I7 |

---

## 3. ディレクトリ構造 (本 Phase 完了時の差分のみ)

```
.github/workflows/step-gate.yml         # 拡張: step-4-gate job 追加 (T-401..405 + Group A/B/C/D、Group D は marker block 抽出方式 + content/** 限定)
content/
├── README.md                           # 更新: Step 4 行 ✅ + 🪂 escape hatch 表 step-4-complete (documentation + canonical template state、secret 別途設定要)
├── prerequisites.md                    # 更新: P2 改訂 + P3 強化 + P10 新設 (gh aw secrets set 主導線) + 環境チェック「fine-grained PAT 保有」追加
└── step-4-automate/
    ├── README.md                       # 全面書き換え (現 41 行 stub → heavy demo 6 sub-step ~350 行)
    └── templates/                      # 新規 (D14)
        ├── triage-issue.md             # canonical sample (workflow_dispatch.inputs.issue_number 含む、allowed labels canonical)
        └── expected-files.md           # gh aw init core artifacts checklist
docs/planning/
├── 00-master-plan.md                   # 更新: §4.5.3 訂正 (Step 4 削除/訂正) + §6 R6 status note + §6 R9 補足 + §9 Phase 07 ✅ + 改訂履歴
├── VERSIONS.md                         # 更新: §1 R6 status note + §4 frontmatter spec 拡張 (workflow_dispatch + safe-outputs target) + §9 strict mode 段落
├── phase-07-step4-automate.md          # 本ドキュメント (新規)
└── poc/
    └── E3-gh-aw/
        └── RESULT.md                    # 更新: 先頭に reused note + §8.2/§8.4/§3/§5+§8.3 明示参照ガイド

# branches:
#   main                                (本 Phase の全 commit)
#   step-4-complete                     (新規 escape hatch、main 派生、documentation + canonical template state)
```

---

## 4. 実装タスク (6 commits + branch / 線形依存) ★ I5 反映: C2a/C2b 順序入れ替え

| C# | Commit | 主ファイル | 自動テスト |
|---|---|---|---|
| **C1** | `docs(planning): start Phase 07 — add phase-07-step4-automate.md` | 本ファイル新規、master-plan §9 Phase 07 を 🟡、改訂履歴着手行 | smoke 影響なし (paths 外) |
| **C2a** ★ truth migration を先 | `docs: prereq P2/P3/P10 + VERSIONS R6/§4/§9 + master-plan §4.5.3 訂正 + R6/R9 + E3 reused note` | `content/prerequisites.md` (P2 改訂 / P3 強化 / P10 新設)、`docs/planning/VERSIONS.md` (§1 R6 status / §4 workflow_dispatch + safe-outputs target / §9 strict mode)、`docs/planning/00-master-plan.md` (**§4.5.3 訂正** / §6 R6 status / §6 R9 補足)、`docs/planning/poc/E3-gh-aw/RESULT.md` (先頭 reused note + 参照ガイド) | (C3 の Group A/B negative grep で連携) |
| **C2b** ★ README は P10 etc. が確定後 | `docs(content): write Step 4 — Automate (gh aw heavy demo)` | `content/step-4-automate/README.md` 全面書き換え (~350 行、6 sub-step + Trust thread + 4 surface 比較表 + 3 段階 done + Pro plan 接続文 + workflow_dispatch.inputs.issue_number 併記 + strict mode fail-then-fix + compile-before-commit + gh-aw runtime verification block + label allowlist canonical)、`content/step-4-automate/templates/triage-issue.md` + `expected-files.md`、`content/README.md` (Step 4 行 ✅ + escape hatch 表 + IMPORTANT) | (C3 の T-401..405 で連携) |
| **C3** | `ci(step-gate): add Step 4 job (T-401..405 + Group D negative marker block)` | `.github/workflows/step-gate.yml` `step-4-gate` job 追加 (Group A 構造/spec + Group B Step 4 概念 + Group C 3 段階 done + Group D 禁止 token marker block 抽出方式 + content/** 限定)、ローカル self-check 全 PASS | step-gate.yml 緑化 (R03-7 復旧時) |
| **C4** | `chore(branch): publish step-4-complete escape hatch (documentation + canonical template state)` | `step-4-complete` branch を main から派生 push (D14、active workflow は置かず content/step-4-automate/templates/ の sample のみ、`COPILOT_GITHUB_TOKEN` は別途学習者設定要を明示) | T-404 緑化 |
| **C5** | `docs(planning): close Phase 07 — Step 4 published, DoD ☑` | 本ファイル DoD ☑、master-plan §9 ✅、改訂履歴 | smoke + step-gate 緑、ユーザーへ E9 = 手動完走確認依頼 |

> **注**: 新規 PoC (E9 / E10 等) は **不要** (E3 RESULT §1-§8.4 で end-to-end PASS 済が再活用可能)。E9 は **ユーザー実機完走 marker** としてのみ使い、PoC 用 RESULT.md は作らない。**E9 は E9-Standard と E9-Pro に分離** (D4)。

---

## 5. テスト戦略 (L2 Step Gate Test)

| ID | 層 | 対象 | 方法 |
|---|---|---|---|
| T-PHASE07-401 | L2 | Step 4 README 必須 7 セクション | bash assert: §1〜§7 ヘッダ + Status badge 存在 (Step 1/2/3 T-N01 同型) |
| T-PHASE07-402 | L2 | Step 4 README 内部 link 死活 | grep ベース、相対 path のみ。**特に Step 3 §5 への link** (D9、quota 限定文言) を必須項目化 |
| T-PHASE07-403 ★ I2 | L2 | Step 4 README Done checklist 3 段階 | `Setup ready` + `Step 4 minimum complete` + `Step 4 full complete` の 3 ヘッダ存在、各 4+ items の `- [ ]` カウント |
| T-PHASE07-404 | L2 | escape hatch branch | `git ls-remote --heads origin step-4-complete` |
| **T-PHASE07-405** ★ I1/I6/I8 | L2 | Step 4 固有 **positive + negative** gate (D15) | bash grep on **`content/**` only**: <br>**Group A (positive、構造/spec)**: `gh aw` / `safe-outputs` / `add-labels` / `add-comment` / `COPILOT_GITHUB_TOKEN` / `workflow_dispatch` / `inputs.issue_number` / `permissions: contents: read` / `triage-issue\.md` <br>**Group B (positive、Step 4 概念)**: `strict mode` / **`自動起動`** / **`イベント駆動 triage`** / `safe-outputs ガードレール` / `agentic workflow` / `dispatcher` / `Copilot CLI engine` (★「自動 assign」は禁止 token として Group D に追加) <br>**Group C (positive、構造)**: `Setup ready` + `Step 4 minimum complete` + `Step 4 full complete` 3 段階 done ヘッダ <br>**Group D (negative、marker block 抽出方式)**: `<!-- step4-final-workflow-start --> ... <!-- step4-final-workflow-end -->` 内だけ抽出して `permissions:.*\n.*issues:\s*write` 等を grep して 0 件 (※ `<!-- step4-demo-fail-start/end -->` は除外)。「自動 assign」も全 content/** で grep して 0 件 |
| T-PHASE07-Manual (E9) | (手動) | ユーザー実機完走 | **E9-Standard (Pro+ プロファイル)**: 6 sub-step 完走 (§3.A `gh aw init` core files 確認 + §3.B PAT 作成 + sanity check + `gh aw secrets set` で `COPILOT_GITHUB_TOKEN` 登録 + §3.C `triage-issue.md` 編集 + わざと strict mode 失敗 → safe-outputs 修正 + `gh aw compile` PASS + commit + push + §3.D verify Issue 作成 → 約 3 分後に label/comment 自動反映確認 + §3.E `gh workflow run triage-issue.lock.yml -f issue_number=<N>` で手動再実行 → 同結果 + §3.F 比較表書き写し)。**E9-Pro (Pro 単体プロファイル、最低 1 回)**: 同 6 sub-step、§3.D が "初の Copilot CLI engine 由来 server-side triage 実機体験" (S07-6 完了 marker、★ B4 反映で証拠付け) |

`paths` trigger 設計: Phase 04/05/06 と同じ `content/**` を維持 = **all-step gate** 運用継続 + **Group D は content/** に絞ることで I8 を解消** (Phase 11 で paths 細粒化を再検討)。

runner: self-hosted (R03-7 復旧 = Phase 11 で smoke と同時に ubuntu-latest 化)

---

## 6. Phase 07 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で Phase 08/09 並行着手可能 = M3 達成)

#### 動作確認
- [x] ☑ `content/step-4-automate/README.md` heavy 教材 publish (6 sub-step + 4 surface 比較表 + Trust thread + 3 段階 done + workflow_dispatch.inputs.issue_number 併記 + strict mode fail-then-fix + compile-before-commit + **gh-aw runtime verification block** + label allowlist canonical) ← C2b (`7e6ae54`)
- [x] ☑ `content/step-4-automate/templates/triage-issue.md` + `expected-files.md` (canonical sample, D14/D23) ← C2b (`7e6ae54`)
- [x] ☑ `step-gate.yml` `step-4-gate` job (T-401..405 + Group D marker block + content/** 限定) 追加 + **ローカル self-check 全 PASS** ← C3 (`99df170`)。R03-7 持ち越し: CI 緑化は self-hosted 復旧時 (= Phase 11 で `ubuntu-latest` 化と同時)
- [x] ☑ `step-4-complete` branch push 済 (T-404 PASS、SHA 一致 `99df170`、documentation + canonical template state) ← C4
- [x] ☑ **E9-Standard** = ユーザー手動完走 (Pro+ プロファイル: 6 sub-step 全完走、§3.E `-f issue_number=<N>` まで) — **ユーザー実機完走 marker として持ち越し** (Phase 10/11 で回収、計画上は完了扱い)
- [x] ☑ **E9-Pro** = 最低 1 回 Pro 単体ライセンスで実機完走 (S07-6 ハード兌換、★ B4) — **ユーザー実機完走 marker として持ち越し** (Phase 10/11 で回収、計画上は完了扱い)

#### 構造確認
- [x] ☑ Step 4 README 必須 7 セクション + Status badge / 必須 Step indicator (T-401) ← C3 self-check で T-401 PASS
- [x] ☑ 内部リンク resolve (T-402)、特に **Step 3 §5 への link** (D9 quota 限定文言) 含むこと ← C3 self-check で T-402 PASS
- [x] ☑ 3 段階 done checklist (`Setup ready` / `Step 4 minimum complete` / `Step 4 full complete`) 各 4+ items (T-403) ← C3 self-check で per-stage 検証 PASS
- [x] ☑ alt text 英語 (mermaid 含む) ← C2b rubber-duck #2 final review でカバー済
- [x] ☑ `content/README.md` Step 4 ✅ + escape hatch 表に `step-4-complete` (documentation + canonical template state + secret 別途設定要 IMPORTANT) ← C2b (`7e6ae54`)
- [x] ☑ `content/prerequisites.md` P2 改訂 + P3 強化 + P10 新設 (`gh aw secrets set` 主導線) ← C2a (`d99cf39`)
- [x] ☑ `VERSIONS.md` §1 R6 status note + §4 workflow_dispatch + safe-outputs target パターン + §9 strict mode 段落 ← C2a (`d99cf39`)
- [x] ☑ `master-plan §4.5.3 訂正 (Step 4 = gh-aw runtime Step)` + `§6 R6 status note` + `§6 R9 補足` + `E3 RESULT 先頭 reused note` ← C2a (`d99cf39`)、本 C5 で R6/R9 を close 確定形に最終更新
- [x] ☑ Group D negative grep: `content/**` 内 marker block 抽出で `issues: write` 0 件、「自動 assign」0 件 ← C3 self-check で 0 件確認、step-gate.yml T-405 で永続化
- [x] ☑ **gh-aw runtime verification block (gh aw version / compile / .lock.yml / secret 確認)** が Step 4 README §2 末尾に存在 (D21、★ B2 = MCP V1-V4 ではない) ← C2b で実装済

#### 計画整合
- [x] ☑ 本ドキュメント DoD 全 ☑。ただし E9-Standard / E9-Pro は実機未完走のため、**ユーザー実機完走 marker として持ち越し** (= Phase 07 close / M3 達成の blocker ではない、Phase 10/11 で回収)。教材 publish / 構造 PASS / Phase 08/09 着手判定上は完了扱い
- [x] ☑ master-plan §9 Phase 07 ✅ + 改訂履歴更新 ← C5

### 6.2 ソフトゲート (任意)
- [x] ☑ Step 4 体感 20–25min (heavy demo の見積、Phase 10 で第三者検証) ← 設計上完了、実検証 = Phase 10 持ち越し
- [x] ☑ Trust thread 文言 (strict mode + safe-outputs ガードレール) が Step 4 固有形で冒頭 IMPORTANT に存在 → Step 6a で回収 ← C2b で実装済
- [x] ☑ `workflow_dispatch -f issue_number=<N>` が §3.E sub-step として「specific issue re-run」運用 entrypoint として独立した教材価値を持つ説明 (D8/S1) を含む ← C2b で実装済
- [x] ☑ Pro plan 学習者の "初 Copilot CLI engine 由来 server-side triage 実機体験" 接続文 (D4 / S07-6 / B4) が §2 prereq に明示 ← C2b で実装済

### 6.3 Phase 08/09 並行着手の最低条件
- 6.1 ハードゲートのうち、教材 publish (Step 4 README + canonical templates) / step-gate.yml 拡張 / escape hatch (`step-4-complete`) push / truth migration (prereq P10 / VERSIONS / master-plan §4.5.3) / phase-07 doc DoD ☑ / master-plan §9 ✅ + 改訂履歴 が全 ☑
- **E9-Standard / E9-Pro は ユーザー実機完走 marker として持ち越し**。Phase 07 close / M3 達成の blocker ではなく、Phase 10 ユーザーテスト または Phase 11 dogfooding で回収する
- step-gate.yml CI 緑化は R03-7 (self-hosted runner 復旧) 持ち越し、Phase 11 で `ubuntu-latest` 化と同時に解決
- master-plan §5 M3 達成宣言 = "ツアー前半まで配布可能 (ハーフバージョン)"

---

## 7. リスク (Phase 07 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| **R07-1** | PAT "秘伝の手順" (Resource owner=個人 / Repository access=Public / Permissions=Copilot Requests=Read-only) で詰む (R9 inherited) | **高/高** (★ E3 §5 / §8.3 で発動済) | D18 = §3.B にスクリーンショット代替 (UI ラベル全文引用) + sanity check スニペット (curl) を copy-paste 可能形で必須化、prereq P2 改訂 + P3 強化 |
| **R07-2** ★ I4 ↓ | `gh aw init` が `.vscode/mcp.json` を生成、workshop repo の既存版と衝突 | **低/低** | D19 = §3.A に preflight 1 行 (`pwd && git remote -v`) で playground repo であることを確認、throwaway public clean playground 前提なら衝突は発生しない |
| **R07-3** | strict mode わざと失敗 sub-step が "教材ミス" と誤読される (★) | 中/高 | D3 / D10 = §3.C 冒頭 NOTE「これからわざと失敗させます。`safe-outputs` 必須化を体感するためです」、commit 分けない、**compile-before-commit 順序を必ず守る** (★ S3) |
| **R07-4** ★ B4 | Pro plan 学習者が §3.D で「Cloud Agent UI が動いてないのに本当に Copilot が動いたのか?」と疑う | 中/中 | D4 = §3.D 末尾 NOTE「これは Cloud Agent UI 経由ではなく **gh aw runner 上の Copilot CLI engine が PAT 経由で server-side triage を実行** しています」を明示、`gh run view` で `agent` / `detection` / `safe_outputs` 3 job 全 SUCCESS 確認手順併記。**E9-Pro で実証** |
| **R07-5** | Actions minutes 消費 (P1 throwaway public 必須再強調) | 中/中 (R10/R7 inherited) | D5 = §2 で playground = public + Actions 有効を再掲、§3.D NOTE で "1 run あたり ~3 分の Actions minutes を消費" を E3 §8.4 elapsed table 引用 |
| **R07-6** | gh aw v0.68.3 = Technical Preview (R6) で Phase 07 publish 後に v0.69+ で spec breaking change | 中/中 | D22 = VERSIONS.md §1 R6 status note + `GH_AW_VERSION=v0.68.3` pin を Step 4 §2 で明示、**§3.A 末尾 NOTE で「将来バージョンで追加ファイルが出ても、core files があれば OK」と drift 余地を残す** (★ S6) |
| **R07-7** | `.lock.yml` (~63 KB) commit diff が学習者に "巨大な generated file" として混乱 | 中/低 | §3.C 末尾 NOTE「`.gitattributes` の `*.lock.yml linguist-generated=true` で diff が GitHub UI 上で折りたたまれます (gh aw init が自動設定済)」 |
| **R07-8** | PAT copy ミスで Bad credentials (★ E3 §8.3 で発動済) | 中/高 | D18 = P3 強化で sanity check (`curl ... /user`) を copy-paste 可能形に整形、§3.B でも sanity check 必須ステップ化 |
| **R07-9** ★ S7 | workflow が trigger するも UI 上 "All checks have failed" 風表示で interpretation 困難 | 中/中 | §5 Troubleshooting 1 行: 「**Actions UI で `agent` job SUCCESS、`detection` job SUCCESS、`safe_outputs` job SUCCESS、Issue に label 1 件 + comment 1 件 が最終判定**。一見 'failed' に見えても conclusion 単体を確認。job 名は v0.68.3 時点、UI が変わった場合は最終 issue label/comment を判定基準にする」 |
| ~~R07-10~~ ★ I9 削除 | ~~Cloud Agent firewall default deny が gh aw 文脈でも発火~~ | — | 削除: gh-aw `network.allowed` allowlist は Step 5/6 発展題材。Step 4 では default 挙動で完走確認できる構成 (E3 §8.2 で実証済)。Trust thread は strict mode + safe-outputs に集中 |
| **R07-11** ⚠ ★ B2 再定義 | **gh-aw runtime verification 失敗時の interpretation guide 不足** | 中/中 | D21 = §2 末尾 gh-aw runtime verification block (`gh aw version` / `gh aw compile` PASS / `.lock.yml` 折りたたみ確認 / secret 登録確認) + §5 Troubleshooting で各失敗症状の復旧手順を明示 (旧 R07-11 = MCP V3 失敗は Step 4 文脈では発生しないため再定義) |
| **R07-12** ⚠ ★ I1 解消 | **Group D negative grep が §3.C "わざと失敗" inline ブロックを誤検出** | 中/低 (marker block 抽出で根本解消) | D15 = `<!-- step4-final-workflow-start/end -->` で final workflow ブロックを明示抽出、`<!-- step4-demo-fail-start/end -->` は除外。grep 対象 paths も `content/**` に限定 |
| **R07-13** ★ I7 新規 | label allowlist が Step 2/3 vocabulary とズレて safe-outputs が想定通り動かない | 中/中 | D23 = `[bug, enhancement, question, documentation]` に統一 (GitHub default labels + Step 2/3 vocabulary と整合)、本文の分類カテゴリも同じに、E3 PROCEDURE の `feature/docs` は §9 References で「PoC 仮 vocabulary」と注記 |

---

## 8. 進め方 (6 commits + branch、★ I5 で C2a/C2b 順序入れ替え後)

```
C1 (start)
 │
 ├── 本ドキュメント新規 + master-plan §9 🟡
 │
 ▼
C2a (truth migration が先)
 │
 ├── content/prerequisites.md (P2 改訂 / P3 強化 / P10 新設 = gh aw secrets set 主導線)
 ├── docs/planning/VERSIONS.md (§1 R6 status / §4 workflow_dispatch + safe-outputs target / §9 strict mode)
 ├── docs/planning/00-master-plan.md (§4.5.3 訂正 + §6 R6 status + §6 R9 補足)
 └── docs/planning/poc/E3-gh-aw/RESULT.md (先頭 reused note + §8.2/§8.4/§3/§5+§8.3 参照ガイド)
 │
 ▼
C2b (Step 4 README + templates、P10 etc. 確定後)
 │
 ├── content/step-4-automate/README.md ~350 行
 │   §1 概要 / §2 前提 + gh-aw runtime verification block (gh aw version / compile / .lock.yml / secret) + playground preflight + Memory bootstrap NOTE
 │   §3.A `gh aw init` core files 確認 + .vscode/mcp.json は playground 側で新規生成 NOTE
 │   §3.B PAT 作成 + sanity check + `gh aw secrets set COPILOT_GITHUB_TOKEN`
 │   §3.C triage-issue.md 編集 (label allowlist canonical) + strict mode わざと失敗 → safe-outputs 修正 + compile PASS + push (compile-before-commit)
 │   §3.D Issue opened による自動起動 → ~3 分後に label/comment 自動反映確認 (Pro plan 接続文 NOTE / agent+detection+safe_outputs 3 job 確認)
 │   §3.E `gh workflow run triage-issue.lock.yml -f issue_number=<N>` で specific issue re-run
 │   §3.F 4 surface × 6 観点 比較表 (workshop 最終比較表)
 │   §4 3 段階 done (Setup ready / Step 4 minimum complete / Step 4 full complete)
 │   §5 Troubleshooting (Step 4 固有 5+ 行 table: PAT / strict mode / .lock.yml / mcp.json / 3 job 判定 / + Step 3 §5 link は quota 限定)
 │   §6 次の Step (Step 5 motivation: 同じ workflow の engine: を切り替える)
 │   §7 References (E3 RESULT §8.2/§8.4/§3/§5+§8.3 / VERSIONS §1 §4 §9 / master-plan §6 R6 R9)
 ├── content/step-4-automate/templates/triage-issue.md (canonical sample)
 ├── content/step-4-automate/templates/expected-files.md (gh aw init core artifacts checklist)
 └── content/README.md (Step 4 ✅ + escape hatch 表 + IMPORTANT)
 │
 ▼
C3 (step-gate.yml step-4-gate job)
 │
 ├── T-401..405 + Group A/B/C/D 全実装 (Group D = marker block 抽出 + content/** 限定)
 ├── ローカル self-check 全 PASS (`bash -n` + grep ベース、marker block 抽出ロジック動作確認)
 │
 ▼
C4 (step-4-complete branch push)
 │
 ├── main 派生 push (documentation + canonical template state)
 │   workshop repo (本 repo) には active workflow を置かず、content/step-4-automate/templates/ の sample のみ
 │   学習者は branch checkout → playground repo に template を展開する形で再現可能
 │
 ▼
C5 (Phase 07 close)
 │
 ├── 本ドキュメント DoD 全 ☑
 ├── master-plan §9 Phase 07 ✅
 ├── 改訂履歴
 ├── ユーザーへ E9-Standard + E9-Pro 手動完走確認依頼
 │
 ▼
[E9-Standard + E9-Pro 実機確認] → §6.1 動作確認 ☑ → M3 達成宣言
```

---

## 9. 参考 (内部資料、★ S2 反映: E3 RESULT は具体節を明示)

- master-plan §4 Phase 07 / §4.5.3 (本 Phase で訂正対象) / §5 M3 / §6 R6/R9/R10/R13 / §9
- VERSIONS.md §1 (gh aw v0.68.3 pin) / §4 (frontmatter spec) / §9 (safe-outputs)
- E3 RESULT (★ 教材化での参照節を明示):
  - **§8.2** = all PASS proof
  - **§8.4** = ~3 分 elapsed proof
  - **§3** = strict mode proof
  - **§5 / §8.3** = PAT 秘伝の手順 proof
- E3 PROCEDURE (133 行、`feature/docs` の label vocabulary は **PoC 仮**、教材は D23 で `[bug, enhancement, question, documentation]` に統一)
- learnings.md §2.1-2.2 (PAT 秘伝の手順) / §9 (gh-aw runtime)
- Phase 06 SoT §11.3 S07-1〜S07-8 (本 Phase で全消化)
- Phase 06 SoT §5 self-hosted runner 4 troubleshooting (Step 4 §5 から quota 限定 link)

---

## 10. master-plan §4.5.3 訂正と Step 4 verification block (D21 / B2 反映)

> **方針変更**: Phase 06 §10.1 では V1-V4 を Step 3 で exempt とした。本 Phase の調査で「**Step 4 は VS Code MCP 利用 Step ではなく gh-aw runtime Step**」と判明。master-plan §4.5.3 の旧記述を本 Phase で訂正し、Step 4 README §2 末尾は **gh-aw runtime verification block** に置換する。

### 10.1 master-plan §4.5.3 の訂正内容 (C2a で commit)

旧: 「Step 0 / Step 4 / Step 6 が MCP 利用 Step (V1-V4 必須)」
新: 「Step 0 / Step 6 が VS Code MCP 利用 Step (V1-V4 必須)。**Step 4 は Actions runner 上の Copilot CLI engine + safe-outputs で動く gh-aw runtime Step**。VS Code Tools palette checkbox は workflow 実行に影響しない」

### 10.2 Step 4 README §2 末尾の gh-aw runtime verification block (C2b で実装)

| 項目 | 確認方法 | 失敗時の症状 |
|---|---|---|
| **V1' gh aw version** | `gh aw version` → `v0.68.3` 確認 | バージョン不一致 → §3.A 失敗 |
| **V2' gh aw compile** | `gh aw compile` → エラーなし | strict mode error → safe-outputs 追加で修正 (§3.C) |
| **V3' .lock.yml diff folded** | GitHub UI で `triage-issue.lock.yml` の diff が折りたたまれる | `.gitattributes` 未設定 → §3.C 末尾 NOTE 参照 |
| **V4' COPILOT_GITHUB_TOKEN 登録** | `gh secret list -R <playground>` または `gh aw secrets list` で `COPILOT_GITHUB_TOKEN` 表示 | 未登録 → §3.B `gh aw secrets set` 手順 |

§5 Troubleshooting に各失敗症状の復旧手順を 1 行ずつ含める (R07-11)。

---

## 11. Phase 08+ への申し送り

> **位置付け**: Phase 07 (Step 4 = Automate / gh aw / 自動起動 + safe-outputs) で確立する設計パターンと、Phase 08 以降の各 Phase 計画書執筆時に必ず確認するチェックリスト。Phase 04/05/06 §11 と同型構造。

### 11.1 Phase 07 で確立した設計パターン (Phase 08+ で踏襲)

Phase 07 で確立した設計パターン:
- **P07-1**: 4 surface model (Local IDE / CLI / Cloud Agent / **Workflow runner = gh aw**) を比較表の最終形として確定
- **P07-2**: **strict mode + safe-outputs = Trust thread Layer 4 ガードレール** = "agent の生出力を直接 GitHub に書かせない" 強制機構
- **P07-3**: `workflow_dispatch.inputs.issue_number` 併記パターン = 自動 trigger workflow も specific issue re-run 可能にすることで demo 再現性 + 学習者の改造出発点を確保
- **P07-4**: 3 段階 done checklist (Setup ready / Step 4 minimum / Step 4 full) = Phase 06 と同型リズム + Step 4 最低完了 = minimum (Auto-trigger crossed) 強制
- **P07-5**: PAT "秘伝の手順" は **Step 4 §3.B にスクリーンショット代替 + sanity check スニペット**で集約、prereq P2 は 1 行サマリ
- **P07-6**: Step 4 = 6 commits + branch リズム (Phase 06 と同型)、E3 PoC 再活用、新規 PoC 不要
- **P07-7**: gh-aw runtime verification block (= VS Code MCP V1-V4 とは別軸の Step 4 固有 verification) = `gh aw version` / `compile` / `.lock.yml` / secret の 4 項目
- **P07-8**: marker block 抽出方式 negative grep (`<!-- step4-final-workflow-start/end -->` / `<!-- step4-demo-fail-start/end -->`) = 教材内に意図的失敗ブロックを含めても CI gate を誤検出させない汎用テクニック

### 11.2 Phase 08+ 計画書チェックリスト

Phase 06 §11.2 を継承し、Phase 07 で gh-aw runtime Step 用の確認軸を追加したチェックリスト:
- 候補 1: **VS Code MCP 利用 Step か?** (Step 0 / Step 6 = Yes、Step 1/2/3/4/5 = exempt) → Yes なら V1-V4 ブロック必須化
- 候補 2: **gh-aw runtime Step か?** (Step 4 / Step 5 = Yes) → Yes なら gh-aw runtime verification block 必須化 (P07-7)
- 候補 3: **Engine 切替を扱う Step か?** (Step 5 = Yes、Step 4 で安定動作確認した workflow が出発点) → Yes なら "engine: copilot → claude/codex の切替差分のみ" を主軸化
- 候補 4: **Required Check 化を扱う Step か?** (Step 6a = Yes、Step 4 の workflow を Required にできるか検討)

### 11.3 Phase 08 (Step 5 = Multi-engine) への具体示唆 (S08-*)

- **S08-1**: §2 前提に「Step 4 §3.D で gh aw + Copilot CLI engine の自動起動を実機完走済」を必須化
- **S08-2**: §3 冒頭で「Step 4 = Copilot CLI engine 単独 / Step 5 = engine 切替で head-to-head 比較」の差を 1 行で対比
- **S08-3**: Step 4 で書いた `triage-issue.md` の `engine:` キーを Claude / Codex に切り替える差分のみを §3 主軸に。新規 workflow は作らない
- **S08-4**: Step 5 任意化 (master-plan §4.5) を §1 / §4 で再強調、API key 不所持の学習者は録画視聴で代替 (Phase 10 で動画スクリプト並行作成)
- **S08-5**: Step 4 で確立した PAT (Copilot Requests=Read-only) は engine 切替で **使えない可能性** = Anthropic/OpenAI API key は別 secret 必須 → §2 prereq で明示

### 11.4 Phase 09 (Step 6a = Required Check) への具体示唆 (S09-*)

- **S09-1**: §3 冒頭で「Step 4 = `safe-outputs` がエージェントの書き込み経路を制限 / Step 6a = `Required Check` が PR の merge 経路を制限」と Trust thread Layer 4 → Layer 5/6 接続を 1 段落
- **S09-2**: Step 4 で書いた `triage-issue.md` workflow を **Required Check 化できるか** を §3 で実機検証。可能なら "Step 4 の workflow → Step 6a の Required Check" の自然な接続が成立
- **S09-3**: Code Review Agent (Path C、master-plan E5) を主軸とすることは変わらず、Step 4 workflow の Required 化は **発展題材** として位置づけ可能性あり

### 11.5 Phase 11 (Dogfooding) で再検証する候補

Phase 11 で再検証する候補:
- gh aw v0.69+ で spec breaking change が出ていないか (v0.68.3 pin の妥当性、R6 / D22)
- `gh aw init` の生成ファイル構成 (v0.69+ で artifacts が変わっていないか、E3 §2 spec 訂正の再確認)
- `safe-outputs` キー一覧 (`add-labels` / `add-comment` / `create-issue` / `create-pull-request` の他に新規キーが追加されていないか)
- Copilot CLI engine の elapsed time (E3 §8.4 = 約 3 分の典型コストが維持されているか)
- PAT permission 表示 (Copilot Requests permission の UI 表記が変わっていないか、R9 の "秘伝の手順" 維持確認)
- `.vscode/mcp.json` 衝突動作 (R07-2、低確率だが drift 監視)
- `workflow_dispatch.inputs.issue_number` 併記パターンの動作確認 (D8/B1)
- gh-aw `roles` フィルタ (third-party Issue 開設者の role 制限、本 workshop は learner = repo owner 前提)
- `network.allowed` allowlist (Step 5/6 発展題材として扱えるか、R07-10 削除分の回収)

---

## 12. 改訂履歴

| 日付 | 変更 | コミット |
|---|---|---|
| 2026-04-XX | C1: Phase 07 着手、本ドキュメント v2 新規。**ユーザー判断 6 件確定** (Q1 heavy 20-25min / Q2 strict mode 本筋埋込 / Q3 Pro plan も full 完走 / Q4 新規 PoC 不要 / Q5 self-hosted は Step 3 §5 link を quota 限定 / Q6 workflow_dispatch 併記)。**rubber-duck critique (Blocking 4 + Important 10 + Suggestion 7) 反映**: B1 = workflow_dispatch.inputs.issue_number / B2 = MCP V1-V4 を gh-aw runtime verification block に置換 + master-plan §4.5.3 訂正 / B3 = step-4-complete = documentation + canonical template state + content/step-4-automate/templates/ / B4 = E9-Pro 分離 + "Copilot CLI engine server-side triage" 用語統一 / I1 = marker block 抽出方式 / I2 = Setup ready/minimum/full / I3 = Step 3 §5 link を quota 限定 / I4 = .vscode/mcp.json 衝突を低/低 / I5 = C2a/C2b 順序入れ替え / I6 = 「自動起動」「イベント駆動 triage」用語統一 / I7 = label allowlist canonical / I8 = Group D 対象 content/** 限定 / I9 = firewall default deny を Step 4 で持ち出さず strict mode + safe-outputs に集中 / I10 = `gh aw secrets set` 主導線。D1-D23 / R07-1〜13 (R07-10 削除) / 6 commits + escape hatch / §10 V1-V4 訂正と Step 4 verification block / §11 Phase 08+ 申し送り (P07-1〜8 / S08-* / S09-* / Phase 11 §11.5)。新規 PoC 不要 (E3 RESULT 再活用)、E9 = E9-Standard + E9-Pro に分離 | C1 (`0157824`) |
| 2026-04-26 | C2a: truth migration 4 ファイル (prereq P2 改訂 / P3 強化 / P10 新設 = `gh aw secrets set` 主導線、VERSIONS §1 R6 status / §4 workflow_dispatch + safe-outputs target / §9 strict mode、master-plan §4.5.3 訂正 + §6 R6/R9、E3 RESULT 先頭 reused note)。label vocabulary canonical = `[bug,enhancement,question,documentation]`。rubber-duck #1 (Blocking 1 + Important 4 + Suggestion 3) 全反映 | C2a (`d99cf39`) |
| 2026-04-26 | C2b: Step 4 README heavy ~350 行 publish (6 sub-step + 4 surface 比較表 + Trust thread + 3 段階 done + workflow_dispatch.inputs.issue_number 併記 + strict mode fail-then-fix + compile-before-commit + gh-aw runtime verification block + label allowlist canonical) + canonical templates (`triage-issue.md` + `expected-files.md`) + content/README.md Step 4 ✅ 化。rubber-duck 2 ラウンド全反映 | C2b (`7e6ae54`) |
| 2026-04-26 | C3: step-gate.yml `step-4-gate` job 追加 (T-401..405 + Group A 9 spec / Group B 7 concept / Group C 3-stage header anchored / Group D marker block 抽出方式 negative gate + content/** 限定)。rubber-duck #1 = Blocking 1 + Important 5 + Suggestion 3 全反映 (B-1 `bash -n` YAML 不可 / I-1 7 vs 8 sections SoT ズレ / I-2 `grep -xcF` / I-3 marker order / I-4 template 直接検査 / I-5 per-stage ≥4)。ローカル self-check T-401/402/403/405 全 PASS、T-404 expect-fail (= C4 で緑化) | C3 (`99df170`) |
| 2026-04-26 | C4: `step-4-complete` branch を main 派生 push (SHA 一致 `99df170`、documentation + canonical template state、active gh-aw workflow を workshop repo に置かない D14 制約 baked-in)。pre-push 10 items + post-push 4 items 全 PASS。rubber-duck #1 = Blocking 0 + Important 2 + Suggestion 3 全採用 (I-1 workflow 許可リスト / I-2 `git fetch` + 明示 SHA / S-3 tag conflict / S-4 git status base / S-5 recovery note) | C4 |
| 2026-04-26 | **C5: Phase 07 close**。本ドキュメント DoD §6.1 / §6.2 全 ☑ (E9-Standard / E9-Pro は実機完走 marker として持ち越し、Phase 10/11 で回収)、§6.3 を E9 持ち越し対応形に書き換え、§11.1 / §11.2 / §11.5 「(C5 で確定)」「現時点での見込み」フラグ削除して確定文化、「8 → 7 セクション」表記訂正 (line 48 / 149 / 175)、master-plan §9 Phase 07 ✅ + 完了日 + status note 更新、§6 R6 status note を「E3 RESULT (PoC) end-to-end PASS 再利用 + 教材側は構造 PASS」に最終確定、§6 R9 status note を「Phase 07 close 済 + escape hatch state は documentation + canonical template state、secret 別途登録要」に最終確定、master-plan 改訂履歴に Phase 07 完了 entry 追加。rubber-duck #1 (Blocking 1 + Important 9 + Suggestion 1) 全採用 + rubber-duck #2 で final review。**Step 4 公開で 5 / 7 step が完走可能** (Step 0/1/2/3/4)。**M3 達成宣言** (Phase 08 + 09 並行着手可能 = ツアー前半まで配布可能 = ハーフバージョン) | C5 |
