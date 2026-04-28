# Phase 09 詳細計画書 — Step 6 (Gate = 6a Required Review + 6b Custom Agent)

> **位置付け**: Phase 08 (Step 5 = Multi-engine) の §11.3 S09-1〜S09-4 申し送りを **本 Phase で全て学習者文書に降ろす**。Step 6 = "**Trust thread の最後のゲート = 人間が最後に判断する Required Review、と再利用可能なレビュアー人格 (`.agent.md`) を並列に紹介**" して **M4 (= 全 Step 揃った "content-complete フルバージョン")** を達成する Phase。
> **本ファイルは Phase 06 / 07 / 08 SoT と同型構造** (§1 Goal → §2 Scope/D → §3 Dir → §4 Commits → §5 Test → §6 DoD → §7 Risks → §8 進め方 → §9 Refs → §10 §4.5 強化 + Step 6 verification block + plan/permission completion matrix → §11 申し送り → §12 履歴)。
> **特殊性**: Step 6 は **UI-only verification block** Step (= Repo Admin / Copilot Code Review setting / Branch protection rule / Required reviewer setting の 4 項目 UI 確認、`gh aw` runtime / MCP server の動的 verification は不要) であり、master-plan §4.5.3 の MCP verification block (V1-V4) とは別経路。`.agent.md` (Step 6b) は Required Check 化機能 (Path A/B = preview/未公開、R11) の制約に縛られず、**再利用可能なレビュアー人格として並列紹介**する light appendix 構成。
> **rubber-duck #1 (planning critique) 反映**: Blocking 3 + Important 9 + Suggestion 6 の **全 18 件** を反映済 ⇒ ① canonical directory を `content/step-6-gate/` 単一 (Blocking 1)、② §3 Appendix で Step 4 workflow Required Check 化を **概念紹介 + 別 `pull_request` trigger workflow template の小さい sample** に弱化 (Blocking 2)、③ Plan/permission completion matrix (D09-11) + E11 を Setup/Minimum/Full/Degraded/Workflow-Advanced の 5 段階に分割 (Blocking 3)、④ タイトル/用語を **Required Review Gate** に統一 (Important 5)、⑤ Step 6 を **UI-only verification block** に再分類 (Important 6)、⑥ `.agent.md` 安全性 + 用語混同抑止を Group D に集約 (Important 7)、⑦ `.agent.md` sample に copy target + invocation path 明示 + read/search のみ (Important 8)、⑧ M4 = "content-complete" 宣言と "release readiness" の分離 (Important 9)、⑨ E11 marker 5 段階化 (Important 10)、⑩ 15min 過密対策 (Important 11)、⑪ GitHub plan vs Copilot plan 分離 prereq P12 (Important 12)、⑫ Trust thread Layer 4→5/6 接続表 (Suggestion 14)、⑬ 3.G "Not today" box (Suggestion 17)、ほか。
> **commit 構成**: **7 commits + escape hatch branch + C2c は conditional slot** (drift があれば 7 commits、なければ 6 commits で C5 統合、Phase 08 C2c pattern 継承)。

---

## 1. Phase Goal

### 1.1 主目的

`content/step-6-gate/` を **Step 6a heavy primary (~15min, 5 sub-step) + Step 6b light appendix (~3-5min, 2 sub-step) + §3 Appendix (workflow Required = 任意発展)** に書き上げ、**Copilot Code Review Agent を `main` branch の Required Reviewer として PR merge gate に組み込む** 体験を 7 commits + escape hatch branch (`step-6-complete`) で公開する。

中核メッセージ:
- **Step 4** = 「`gh aw` workflow + `safe-outputs` ガードレールで agent の **GitHub への書き込み経路** を制限」
- **Step 5** = 「engine を切り替えても safe-outputs invariant が維持される (Trust thread Layer 4 が engine 横断)」
- **Step 6a** = 「**Required Review** が PR merge 経路に最後のゲートを置く = 人間 (or AI レビュアー) が最後に判断する」(★ Required **Review** であって Required Status **Check** ではない、Important 5)
- **Step 6b** = 「`.agent.md` は再利用可能な **レビュアー人格** = 人間/Agent が同じ rubric で見る (今日 Required Check として直接登録できるわけではない、R11 = Path A/B preview/未公開、Suggestion 17 "Not today" box)」
- **§3 Appendix** = 「Step 4 で書いた `triage-issue.md` workflow (= `issues.opened` / `workflow_dispatch` trigger) を **そのまま PR Required Status Check 化することは設計上できない**。`pull_request` trigger workflow を別途用意する **任意発展題材** として位置づけ、Required Status Check と Required Review の用語/経路の違いを明示」(★ Blocking 2)

### 1.2 Phase 完了時に手元にあるもの

- 学習者が Codespaces を **起動せず** (= UI-only verification block) playground repo の Web UI で **15-20 分** で完走できる Step 6 README (~450 行、6a heavy + 6b light appendix + §3 Appendix)
- 学習者の playground repo に設定される **branch protection rule**:
  - `main` branch に "Require pull request reviews" + "GitHub Copilot - Code Review" を Required Reviewer として追加
  - 1 PR を立てて Copilot Code Review Agent が起動して review gate が表示されることを観察
- `step-6-complete` branch (**documentation + canonical template state**: workshop repo 上では `content/step-6-gate/` 配下に `agents/code-reviewer.agent.md` (read/search only sample) + `templates/pr-required-check.yml` (任意発展用 `pull_request` trigger workflow sample) + `recordings/README.md` placeholder。active branch protection rule は **意図的に置かない** = D14 制約継承、各学習者が自分の playground に設定)
- `step-gate.yml` `step-6-gate` job (T-601..605 + Group A/B/C positive + Group D negative `.agent.md` 安全性 + 用語混同抑止)
- prereqs **P12 新設** (GitHub plan = Free/Pro/Team/Enterprise vs Copilot plan = Pro/Pro+/Business/Enterprise の **5 項目分離**、Important 12)
- master-plan §4.5 強化 (Step 6a/6b refine) + §4.5.3 訂正 (Step 6 を **UI-only verification block** Step に再分類、MCP verification block 必須対象から外す、Important 6) + §6 R5/R11 status final + §9 Phase 09 ✅ + 改訂履歴
- VERSIONS.md **§10 新規** (Branch protection / Required Review UI canonical labels semantic anchor + Copilot Code Review Required Reviewer 表示名、Suggestion 13)
- **M4 = content-complete 宣言** (Important 9 = "全 Step 公開済 = content-complete フルバージョン" のみ宣言、E10/E11 user dogfooding pending / recordings pending Phase 10 / public release hardening pending Phase 11 を併記)

### 1.3 マイルストーン

master-plan §5 の **M4 = Phase 08 + Phase 09 完了 = "ツアー後半まで配布可能 (フルバージョン直前段階)"** を **本 Phase 完了で達成**。Phase 08 完了時点で Step 0→1→2→3→4→5 まで公開済、本 Phase で Step 6 (= 6a + 6b 並列 + workflow 発展 Appendix) を追加して全 Step 公開状態 (= content-complete) に到達する。

ただし **M4 達成 = "content-complete" のみ宣言** (Important 9):
- E10 (Phase 08 user dogfooding) / E11 (Phase 09 user dogfooding) はユーザー実機完走 marker として **Phase 10/11 で回収**
- 録画 (Phase 10 で配置) / 公開リリース hardening (Phase 11) は **M5 = public release ready** として分離

### 1.4 UI-only verification block Step を heavy 化する整合性

> **論点**: Step 6 は MCP server / `gh aw` runtime を動的に verify しない (= V1-V4 / gh-aw verification block 適用外)。それでも heavy 5 sub-step ~15min にする整合性は?

**回答**:
- Step 6a の核 = **Repo Admin permission / Copilot Code Review setting visible / Branch protection rule editable / Required reviewer setting visible** の **4 項目 UI 確認** (= UI-only verification block、D09-12)。これは MCP / `gh aw` の動的 verification とは別経路だが、**Trust thread Layer 5/6 の前提条件** として明示的に確認する必要がある
- Plan / org policy 依存で UI が出ない学習者向けに **degraded path** を §3 baked-in (D09-11、Blocking 3 = Phase 06 "Pro plan degraded complete" pattern 継承) → これにより heavy 構成でも全プロファイルが完走可能
- Step 6b は **light appendix (~3-5min)** に圧縮 (Important 11 = 15min 過密対策、§3 Appendix workflow も別退避)、`.agent.md` sample 提示 + Path A/B "Not today" box + Trust thread Layer 4→5/6 接続表のみ
- 任意性は §1 / §3 冒頭 / §4 完了確認の **3 箇所で明示** (Step 6b は発展題材、§3 Appendix workflow は任意発展)

---

## 2. Scope

### 2.1 IN SCOPE

| 対象 | 何を作るか |
|---|---|
| `content/step-6-gate/README.md` | heavy 6a + light 6b appendix + §3 Appendix workflow 発展題材 (~450 行) 必須 7 セクション準拠、§2 NOTE に **UI-only verification block 4 項目** + **GitHub plan vs Copilot plan 分離** + **Repo Admin permission 前提** + **degraded path 救済**、§3 = **3.A 前提整理 + UI verification block** (Important 6/12) / **3.B Branch protection rule 作成** (semantic anchor、Suggestion 13) / **3.C Copilot Code Review を Required Reviewer 化** (Important 5 = Required Review Gate 用語統一) / **3.D 実機 PR 作成 → review observe** (= Step 6a minimum complete) / **3.E Trust thread Layer 4→5/6 接続表** (Suggestion 14) / **3.F Custom Agent `.agent.md` sample 紹介** (Important 8 = copy target + invocation path 明示 + read/search のみ) / **3.G Path A/B (Check Run Agents) 将来展望 + R11 状況** (Suggestion 17 "Not today" box) / **§3 Appendix A 概念紹介** (Step 4 `triage-issue.md` workflow を Required Status Check 化することは設計上不可) + **§3 Appendix B `templates/pr-required-check.yml` 任意発展** (Blocking 2)、§4 完了確認は **4 状態 done** (Setup ready / Step 6a minimum complete / Step 6a full complete / Step 6b complete) + plan/permission completion matrix (Full / Degraded path) |
| `content/step-6-gate/agents/code-reviewer.agent.md` | canonical sample (Important 8 = copy target = `.github/agents/code-reviewer.agent.md` + invocation path = `@code-reviewer` mention or Copilot Chat Agents palette + 用途 = reusable reviewer persona)、frontmatter は **`tools` で `read` / `search` のみ許可** (★ Important 7 = `edit` / `shell` / broad write tool は含めない、Group D negative gate 対象)、"今日 Required Check ではない" 明示文 (Suggestion 17 "Not today" box の本体) |
| `content/step-6-gate/templates/pr-required-check.yml` | 任意発展 sample (Blocking 2 = Step 4 `issues.opened` workflow を Required Status Check 化することの代替)、最小 `pull_request` trigger workflow (`on: pull_request: { branches: [main] }`)、教育目的の no-op (echo "Required check placeholder") に留める。学習者が自分の playground でこれを Required Status Check に追加する **E11-Workflow-Advanced** で利用 |
| `content/step-6-gate/recordings/README.md` | placeholder file (Phase 06/07/08 同型 = Q6 = `placeholder_internal`)、Step 6 README 内の録画 link は本 file への相対 link、Phase 10 着手前に踏んでも 404 にならない future-proof 形 (Phase 08 D08-10 継承) |
| `content/README.md` | Step 6 行を **2 行 (`step-6a-required-check/` + `step-6b-custom-agent/`) → 1 行に畳み込み** = `[6](./step-6-gate/) | Gate — Required Review + Custom Agent` (★ Blocking 1)、anchor link は `./step-6-gate/#3a-前提整理--ui-verification-block` 等で接続。escape hatch 表に `step-6-complete` 行追加 (documentation + canonical template state、active branch protection rule は branch に乗らない、各学習者の playground で設定要)、IMPORTANT note で「Step 6a は必須、Step 6b は発展題材、§3 Appendix workflow は任意発展」 |
| `content/prerequisites.md` | **P12 新設** (Important 12 = GitHub plan vs Copilot plan 分離): ① **GitHub plan** (Free / Pro / Team / Enterprise) と **branch protection / rulesets 利用可否** の対応、② **Copilot plan** (Pro / Pro+ / Business / Enterprise) と **Copilot Code Review 利用可否** の対応、③ **org policy** で Copilot Code Review が org level disable されている場合の degraded path、④ **playground repo の Admin permission 前提** (Settings → Branches へアクセスできる必要)、⑤ **Codespaces 起動不要** (UI-only Step、ただし Step 4-5 で playground repo を準備済が前提)。環境チェックに **⑪ playground repo Admin permission 確認 (`gh repo view --json viewerPermission`)** + **⑫ Copilot Code Review setting visible 確認 (Settings → Code & automation → Copilot 表示)** を追加 |
| `docs/planning/VERSIONS.md` | **§10 新規** (Suggestion 13 = Branch protection / Required Review UI canonical labels semantic anchor): ① Settings → Branches (or Rulesets) の最新 UI ラベル全文、② "Require pull request reviews" + "GitHub Copilot - Code Review" の Required Reviewer 表示名、③ org level Copilot setting label、④ Phase 09 publish 時点の v202604 snapshot 注記 + Phase 11 で UI drift 再検証申し送り |
| `docs/planning/00-master-plan.md` | §4.5 強化 (Step 6a/6b refine: 6a 5 sub-step heavy 構成 + 6b light appendix 構成 + §3 Appendix workflow 発展題材分離) + **§4.5.3 訂正** (Important 6 = Step 6 を **MCP verification block 必須対象から外し、UI-only verification block Step として再分類**、Step 6 固有の UI verification block 4 項目を §4.5.3 に追記) + §6 **R5 ✅ final** (Step 6a = Copilot Code Review Required Review canonical 確定) + §6 **R11 status final** (`.agent.md` Path A/B = preview/未公開のまま、Step 6b は再利用可能なレビュアー人格として並列紹介、Phase 11 で再検証) + §9 Phase 09 ✅ + 改訂履歴 + **M4 達成 entry** (Important 9 = "content-complete" のみ宣言、release readiness は Phase 10/11 持ち越し併記) |
| `.github/workflows/step-gate.yml` | top header に Step 6 追記 + `step-6-gate` job 追加 (T-601..605)。**Group A 構造/spec keyword (positive)** (`branch protection` / `Require pull request reviews` / `Copilot Code Review` / `Required reviewer` / `\.agent\.md` / `Required Review Gate` / `pr-required-check\.yml`)、**Group B Step 6 概念 (positive)** (`merge gate` / `Trust thread` / `human review` / `Path C` / `Path A/B preview` / `Required Review` / `Required Status Check`)、**Group C 4 状態 done (positive)** (`Setup ready` + `Step 6a minimum complete` + `Step 6a full complete` + `Step 6b complete` の 4 ヘッダ literal)、**Group D 禁止 token (negative、`.agent.md` 安全性 + 用語混同抑止)**: ① `content/step-6-gate/agents/*.agent.md` frontmatter に `tools:` 配下で `edit` / `shell` / broad write を含まない (read/search のみ)、② `content/step-6-gate/agents/*.agent.md` に GitHub Actions 風 `permissions:` field を含まない (これは workflow 用 field、`.agent.md` には不要)、③ `content/**` 内に "auto approve" / "merge automatically" / "bypass branch protection" / "Copilot Code Review は Required Status Check" / "`.agent.md` は今日 Required Check として登録できる" を 0 件 |
| `step-6-complete` branch | main 派生 push (D14 制約継承 = active branch protection rule は workshop repo に置かない、`content/step-6-gate/agents/` + `templates/` + `recordings/` の sample/placeholder のみ) |
| 本ドキュメント | Phase 09 詳細計画書 v1 |

### 2.2 OUT OF SCOPE (Phase 10+)

- 録画スクリプト本文 (Phase 10、本 Phase は内部 placeholder file のみ)
- E11 = ユーザー実機完走 marker (Phase 10/11 で回収、本 Phase は計画上完了扱い)
- step-6a-required-check/ + step-6b-custom-agent/ の 2 ディレクトリを残す案 (Blocking 1 = canonical `step-6-gate/` 単一に統一、旧 stub は本 Phase で削除 or anchor redirect)
- Path A/B (Check Run Agents) GA 待ち (R11 = preview/未公開、Phase 11 で再検証)
- Step 4 `triage-issue.md` workflow の **そのままの** PR Required Status Check 化 (Blocking 2 = trigger model 不整合のため設計上不可、§3 Appendix B 別 workflow に弱化)
- 公開リリース hardening = M5 (Phase 11、本 Phase は M4 = content-complete のみ)
- workshop repo 自身に branch protection rule を設定すること (D14 制約継承、各学習者の playground で設定)
- step-gate.yml CI 緑化 (R03-7 self-hosted runner 復旧持ち越し、Phase 11 で `ubuntu-latest` 化と同時に解決、本 Phase はローカル self-check のみ)

### 2.3 設計判断 (D09-1〜D09-13) — Phase 06/07/08 と同型 + Step 6 固有

| # | 論点 | 採用案 | 根拠 |
|---|---|---|---|
| **D09-1** | demo 厚さ | **heavy 15min 6a primary + light 3-5min 6b appendix** (Q1 = `combined` 確定 = 1 Phase で 6a + 6b 並列、Q2 = `heavy_15min` 確定。Step 5 = 5 sub-step ~20-25min との対比で、Step 6a は UI-only なので 5 sub-step ~15min に圧縮、6b appendix で 2 sub-step、§3 Appendix で 1 sub-step 退避) | Q1 / Q2、rubber-duck #1 Important 11 |
| **D09-2** | sub-step 順序 (6a) | **3.A 前提整理 + UI verification block 4 項目 (D09-12) → 3.B Branch protection rule 作成 (Settings → Branches or Rulesets、semantic anchor) → 3.C Copilot Code Review を Required Reviewer 化 (Required Review Gate 用語統一) → 3.D 実機 PR 作成 → review observe (= Step 6a minimum complete) → 3.E Trust thread Layer 4→5/6 接続表 (Suggestion 14)** | Q2 / S09-1 / Suggestion 14 |
| **D09-3** | sub-step 順序 (6b) | **3.F Custom Agent `.agent.md` sample 紹介 (copy target + invocation path 明示、read/search only) → 3.G Path A/B (Check Run Agents) 将来展望 + R11 状況 ("Not today" box)** | S09-3 / R11 / Important 8 / Suggestion 17 |
| **D09-4** | §3 Appendix workflow Required (Q3 = `optional_advanced_section`) | Step 4 `triage-issue.md` workflow をそのまま PR Required Status Check 化することは **trigger model 不整合のため設計上不可** (★ Blocking 2 = `issues.opened` / `workflow_dispatch` trigger は PR head に check run を発生させない)。代替として `templates/pr-required-check.yml` (最小 `pull_request` trigger workflow sample) を **§3 Appendix B** で提示、学習者が自分の playground でこれを Required Status Check に追加する任意手順 (E11-Workflow-Advanced)。S09-2 を弱化 = "Step 4 で学んだ safe-outputs と同じ Trust thread を、PR merge gate では Required Review / Required Status Check として再解釈する" | Blocking 2 / S09-2 / Q3 |
| **D09-5** ⚠ critical | escape hatch (`step-6-complete`) の意味 | **documentation + canonical template state** (Phase 07 D14 / Phase 08 D08-8 と同型) = workshop repo (本 repo) には **active branch protection rule を置かない** + **active workflow も置かない** (`templates/pr-required-check.yml` は template 配下の sample のみ)。`step-6-complete` branch を checkout すると README が "Step 6 完読 state"、template が即手元にあり、学習者は **playground repo に設定する形** で Step 6 を再現できる。**Branch protection rule + Required Reviewer 設定は branch に乗らない** (= Trust thread の一部) を §6 escape hatch 説明で明記 | Phase 07 D14 / Phase 08 D08-8 |
| **D09-6** | Trust thread 伏線 (Step 6 固有文言) | 冒頭 IMPORTANT に: 「Step 4 では `safe-outputs` がエージェントの **GitHub への書き込み経路** を制限した。Step 5 では engine を切り替えても safe-outputs invariant が維持されることを確認した。Step 6a では **`Required Review`** が **PR の merge 経路** を制限する = Trust thread Layer 4 → Layer 5/6 への自然な接続。Step 6b の `.agent.md` は **再利用可能なレビュアー人格** = 人間/Agent が同じ rubric で見るための共通 spec」 + Layer 4→5/6 接続表 (Suggestion 14、§3.E) | Phase 07 D12 / Phase 08 D08-12 継承 |
| **D09-7** ⚠ | done state checklist (§4) | **`Setup ready (= UI verification block 4 項目 PASS = Repo Admin / Copilot Code Review setting visible / Branch protection rule editable / Required reviewer setting visible)` / `Step 6a minimum complete (= Required Review 設定 + 1 PR で Copilot Code Review が起動して review gate が表示される)` / `Step 6a full complete (= satisfied / not satisfied 両状態を観察、E11-Degraded で代替可)` / `Step 6b complete (= .agent.md sample 読了 + Path A/B 概念理解)`** の **4 状態** (★ Important 10 / Suggestion 15)。**Step 6 最低完了 = `Step 6a minimum complete`**。`Step 6a full complete` は plan/permission completion matrix (D09-11) で Full path が成立する場合のみ、Degraded path は §10.3 RESULT block + 概念理解で代替し full complete 達成扱い | Q1 / rubber-duck #1 Important 10 / Suggestion 15 |
| **D09-8** | 録画 link future-proof | **「Phase 10 で提供予定」** placeholder を §1 / §3 冒頭 IMPORTANT box / §4 完了確認の 3 箇所に配置。**dead link 回避**: link は `content/step-6-gate/recordings/README.md` への **相対 link** に変える ⇒ Phase 10 着手前に学習者が踏んでも内部 placeholder file が表示される (Phase 08 D08-10 継承) | Q4 / Q6 / Phase 08 D08-10 継承 |
| **D09-9** ⚠ ★ Important 5 | 用語統一 | **タイトル/見出し/Group A keyword は "Required Review Gate" に統一** (= Reviews 経路 = `Require pull request reviews` の Required Reviewer)。"Required Status Check" (= Status Checks 経路 = check run / commit status) は **§3 Appendix B でのみ** 使用 (workflow 任意発展)。両者の混同を抑止する文 "**`Copilot Code Review` は Required Status Check ではなく Required Reviewer**" を §3.C 冒頭で明示 (Group D negative gate にも対応する禁止 token を含める) | Important 5 |
| **D09-10** ⚠ ★ Important 6 | Step 6 verification block | **MCP verification block (V1-V4)** ではなく **UI-only verification block 4 項目** (D09-12) として §4.5.3 に再分類。master-plan §4.5.3 旧記述「Step 0 / Step 6 が MCP 利用 Step」を訂正 = 「Step 0 のみ MCP verification block 必須対象、Step 6 は UI-only verification block (別経路)」 | Important 6 |
| **D09-11** ⚠ critical ★ Blocking 3 | Plan/permission completion matrix | **Full path**: Repo Admin + Copilot Code Review Required reviewer 設定可能 → 実 PR で satisfied / not satisfied 観察 → E11-Full / **Degraded path**: 設定 UI が出ない (org policy / personal repo 制限 / Copilot plan 制限) → screenshot / docs trace / setting availability check を §10.3 RESULT block に記録、概念理解 + `.agent.md` sample へ進む → **E11-Degraded で full complete 達成扱い** (Phase 06 "Pro plan degraded complete" pattern 継承) | Blocking 3 |
| **D09-12** ⚠ ★ Important 6/7 | UI verification block 4 項目 (Step 6 固有) | §3.A 冒頭で表形式: ① **Repo Admin permission** (`gh repo view --json viewerPermission --jq .viewerPermission` = `ADMIN`)、② **Copilot Code Review setting visible** (Settings → Code & automation → Copilot で設定 UI が見える、org level disable されていない)、③ **Branch protection rule editable** (Settings → Branches → "Add rule" / Rulesets → "New ruleset" UI が表示される)、④ **Required reviewer setting visible** ("Require pull request reviews" + "Require approval from specific actors" or "Require review from Code Owners" 系の UI が表示される)。各項目 NG 時の degraded path (D09-11) へのリンク | Important 6 / Important 7 |
| **D09-13** ⚠ ★ Important 7/8 | `.agent.md` sample 安全性 | `content/step-6-gate/agents/code-reviewer.agent.md` の frontmatter は **`tools: [read, search]`** のみ (= `edit` / `shell` / broad write tool は含めない、Group D negative gate)、本文に **copy target = `.github/agents/code-reviewer.agent.md`** + **invocation path = `@code-reviewer` mention (Copilot Chat / Issue/PR comment)** + **"今日 Required Check ではない"** (= Path A/B preview/未公開、R11) を明示。GitHub Actions 風 `permissions:` field は不要 (Group D negative gate) | Important 7 / Important 8 / R11 |

---

## 3. ディレクトリ構造 (本 Phase 完了時の差分のみ)

```
.github/workflows/step-gate.yml           # 拡張: top header に Step 6 追記 + step-6-gate job 追加 (T-601..605 + Group A/B/C/D)
content/
├── README.md                             # 更新: Step 6 行 1 行畳み込み (./step-6-gate/) + 🪂 escape hatch 表 step-6-complete 行追加 (documentation + canonical template state)
├── prerequisites.md                      # 更新: P12 新設 (GitHub plan vs Copilot plan 分離 5 項目) + 環境チェック ⑪ ⑫ 追加
├── step-6a-required-check/               # 既存 stub: 本 Phase で内容を step-6-gate/ に移行、stub README は anchor redirect note のみ残す (or 削除して content/README.md の link を anchor 化、後者を採択)
├── step-6b-custom-agent/                 # 既存 stub: 同上
└── step-6-gate/                          # 新規 canonical (Blocking 1)
    ├── README.md                         # 新規 (~450 行、6a heavy primary 5 sub-step + 6b light appendix 2 sub-step + §3 Appendix workflow 任意発展)
    ├── agents/
    │   └── code-reviewer.agent.md        # 新規 canonical sample (read/search only、copy target + invocation path 明示)
    ├── templates/
    │   └── pr-required-check.yml         # 新規 任意発展 (最小 pull_request trigger workflow sample、E11-Workflow-Advanced)
    └── recordings/
        └── README.md                     # 新規 placeholder (Phase 10 配置予定、broken link 防止)
docs/planning/
├── 00-master-plan.md                     # 更新: §4.5 強化 + §4.5.3 訂正 (Step 6 を UI-only verification block に再分類) + §6 R5/R11 final + §9 Phase 09 ✅ + M4 達成 entry (content-complete のみ宣言) + 改訂履歴
├── VERSIONS.md                           # 更新: §10 新規 (Branch protection / Required Review UI canonical labels semantic anchor)
└── phase-09-step6-gate.md                # 本ドキュメント (新規)

# branches:
#   main                                  (本 Phase の全 commit)
#   step-6-complete                       (新規 escape hatch、main 派生、documentation + canonical template state)
```

> **stub 処理方針**: `content/step-6a-required-check/` + `content/step-6b-custom-agent/` の既存 stub README は **C2b で削除** し、`content/README.md` の Step 6 行 link を `./step-6-gate/` 単一に畳み込む (Blocking 1)。anchor は `./step-6-gate/#3a-前提整理--ui-verification-block` / `./step-6-gate/#3f-custom-agent--code-reviewer-agent-md-紹介` で sub-step に直接接続できる形にする。

---

## 4. 実装タスク (7 commits + branch / 線形依存) ★ C2c は conditional slot (Phase 08 C2c pattern 継承)

| C# | Commit | 主ファイル | 自動テスト |
|---|---|---|---|
| **C1** | `docs(planning): Phase 09 = Step 6 (Gate) 詳細計画` | 本ファイル新規 (~500 行)、master-plan §9 Phase 09 を 🟡、改訂履歴着手行 | smoke 影響なし (paths 外) |
| **C2a** ★ truth migration | `docs: truth migration for Step 6 (Gate)` | `content/prerequisites.md` (P12 新設 = GitHub plan vs Copilot plan 分離 5 項目 + 環境チェック ⑪ ⑫)、`docs/planning/00-master-plan.md` (§4.5 強化 6a/6b refine + §4.5.3 訂正 = Step 6 を UI-only verification block に再分類 + §6 R5 final + §6 R11 status update)、`docs/planning/VERSIONS.md` (§10 新規 = Branch protection / Required Review UI canonical labels semantic anchor) | (C3 の Group A/B negative grep は C2b 後にローカル PASS) |
| **C2b** ★ README + sample + placeholder | `docs(content): Step 6 README publish + .agent.md sample + recordings placeholder` | `content/step-6-gate/README.md` 新規 (~450 行、6a heavy primary 5 sub-step + Trust thread Layer 4→5/6 接続表 + 6b light appendix 2 sub-step + §3 Appendix workflow 任意発展 + 4 状態 done + plan/permission completion matrix + UI verification block 4 項目 + 録画 placeholder (内部 file への相対 link) + "Not today" box + Required Review vs Required Status Check 用語分離)、`agents/code-reviewer.agent.md` (read/search only sample、copy target + invocation path 明示)、`templates/pr-required-check.yml` (最小 `pull_request` trigger workflow sample)、`recordings/README.md` placeholder file 新規、`content/README.md` (Step 6 行 1 行畳み込み + escape hatch 表 + IMPORTANT)、既存 stub `step-6a-required-check/` + `step-6b-custom-agent/` README を **削除** (Blocking 1) | (C3 の T-601..605 で連携) |
| **C2c** ★ conditional slot (Phase 08 C2c pattern 継承) | `docs(content): Step 6 discovery closure — drift confirmation` | C2b 後の discovery closure slot。drift があれば truth migration (UI label drift / Copilot Code Review Required Reviewer 表示名 drift / `.agent.md` frontmatter spec drift / R11 = Path A/B 状況 drift) を VERSIONS §10 / master-plan §6 R11 / `.agent.md` sample / Step 6 README §3.G に適用、なければ "no-drift confirmed / labels confirmed / degraded path confirmed" を **C5 統合** で本ファイル §10.3 に短く記録 (この場合 C2c commit は発生せず、Phase は **6 commits + escape hatch** で close) | (C3 の Group A/B/C で連携) |
| **C3** | `ci(step-gate): add step-6-gate job (T-601..605 + Group A/B/C/D)` | `.github/workflows/step-gate.yml` top header に Step 6 追記 + `step-6-gate` job 追加 (Group A/B/C positive + Group D 禁止 token negative)、ローカル self-check 全 PASS | step-gate.yml 緑化 (R03-7 復旧時) |
| **C4** | (no commit) `step-6-complete` branch push | `step-6-complete` branch を main から派生 push (D09-5、active branch protection rule + active workflow は置かず content/step-6-gate/{agents,templates,recordings}/ の sample/placeholder のみ、各学習者が自分の playground に設定要を明示) | T-604 緑化 |
| **C5** | `docs(planning): Phase 09 close — Step 6 publish + M4 content-complete achieved` | 本ファイル DoD ☑、master-plan §9 ✅ + R5 final + R11 final、改訂履歴、**M4 = content-complete 宣言** (Important 9 = "全 Step 公開済 = content-complete フルバージョン" のみ宣言、E10/E11 user dogfooding pending / recordings pending Phase 10 / public release hardening pending Phase 11 を併記)、C2c discovery closure note (no-drift の場合) | smoke + step-gate 緑、ユーザーへ E11 = 手動完走確認依頼 |

> **注**: 新規 PoC 不要 = E5 Path C で Code Review Agent Required Review 化を実機確定済 (master-plan §6 R6 / poc/learnings.md §6.1-6.2)。**E11 = ユーザー実機完走 marker** としてのみ使い、PoC 用 RESULT.md は作らない。**E11 は E11-Setup / E11-Minimum / E11-Full / E11-Degraded / E11-Workflow-Advanced の 5 段階に分離** (D09-7 / D09-11、★ rubber-duck #1 Important 10)。

---

## 5. テスト戦略 (L2 Step Gate Test)

| ID | 層 | 対象 | 方法 |
|---|---|---|---|
| T-PHASE09-601 | L2 | Step 6 README 必須 7 セクション | bash assert: §1〜§7 ヘッダ + Status badge 存在 (Phase 07/08 T-401/501 同型) |
| T-PHASE09-602 | L2 | Step 6 README 内部 link 死活 | grep ベース、相対 path のみ。**特に Step 4 §3 / Step 5 §3 への back-link** (D09-6 Trust thread Layer 4→5/6 接続)、**録画 placeholder link** (D09-8 future-proof)、**`.agent.md` sample link** (Important 8) を必須項目化 |
| T-PHASE09-603 ★ Important 10 | L2 | Step 6 README Done checklist 4 状態 | `Setup ready` + `Step 6a minimum complete` + `Step 6a full complete` + `Step 6b complete` の 4 ヘッダ存在、各 4+ items の `- [ ]` カウント。Phase 08 T-503 同型 |
| T-PHASE09-604 | L2 | escape hatch branch | `git ls-remote --heads origin step-6-complete` |
| **T-PHASE09-605** ★ Important 5/7/8 | L2 | Step 6 固有 **positive + negative** gate (D09-13 / Group D) | bash grep on **`content/**` only**: <br>**Group A (positive、構造/spec)**: `branch protection` / `Require pull request reviews` / `Copilot Code Review` / `Required reviewer` / `\.agent\.md` / `Required Review Gate` / `pr-required-check\.yml` の存在 <br>**Group B (positive、Step 6 概念)**: `merge gate` / `Trust thread` / `human review` / `Path C` / `Path A/B preview` / `Required Review` / `Required Status Check` (両者対比文の存在、Important 5) <br>**Group C (positive、4 状態 done)**: `Setup ready` + `Step 6a minimum complete` + `Step 6a full complete` + `Step 6b complete` 4 状態 done ヘッダ <br>**Group D (negative、`.agent.md` 安全性 + 用語混同抑止)**: ① `content/step-6-gate/agents/*.agent.md` frontmatter `tools:` 配下に `edit` / `shell` / broad write を含まない (read/search のみ)、② `content/step-6-gate/agents/*.agent.md` に GitHub Actions 風 `^permissions:\s*$` field を含まない、③ `content/**` 内に `auto approve` / `merge automatically` / `bypass branch protection` / `Copilot Code Review は Required Status Check` / `\.agent\.md` を Required Check として今日登録できる の 0 件 |

`paths` trigger 設計: Phase 04-08 と同じ `content/**` 維持 = **all-step gate** 運用継続 + Group D は `content/**` に絞る (Phase 07 D15 / Phase 08 D08-11 と同型)。

runner: self-hosted (R03-7 復旧 = Phase 11 で smoke と同時に ubuntu-latest 化)

---

## 6. Phase 09 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で M4 = content-complete 達成)

#### 動作確認
- [x] `content/step-6-gate/README.md` heavy + light appendix 教材 publish (5 sub-step 6a + 2 sub-step 6b + §3 Appendix workflow 任意発展、~284 行 actual、Trust thread Layer 4→5/6 接続表 + 4 状態 done (D09-7) + UI verification block 4 項目 (D09-12) + plan/permission completion matrix (D09-11) + Required Review vs Required Status Check 用語分離 (D09-9) + 録画 placeholder 内部相対 link + "Not today" box (Suggestion 17)) — C2b commit `97d7336`
- [x] `content/step-6-gate/agents/code-reviewer.agent.md` canonical sample (read/search only、copy target + invocation path 明示、D09-13) — C2b commit `97d7336`
- [x] `content/step-6-gate/templates/pr-required-check.yml` (最小 `pull_request` trigger workflow sample、§3 Appendix B / E11-Workflow-Advanced 用、D09-4) — C2b commit `97d7336`
- [x] `content/step-6-gate/recordings/README.md` placeholder file 配置 (broken link 防止、D09-8) — C2b commit `97d7336`
- [x] `content/step-6a-required-check/` + `content/step-6b-custom-agent/` の既存 stub README を削除 (Blocking 1 統一) — C2b commit `97d7336`
- [x] `step-gate.yml` top header に Step 6 追記 + `step-6-gate` job (T-601..605 + Group A/B/C positive + Group D negative `.agent.md` 安全性 + 用語混同抑止) 追加 + **ローカル self-check 全 PASS** — C3 commit `a30a9f6`。R03-7 持ち越し: CI 緑化は self-hosted 復旧時 (Phase 11)
- [x] `step-6-complete` branch push 済 (T-604 PASS、SHA 一致 `a30a9f6`、documentation + canonical template state、active branch protection rule + active workflow は置かない、D09-5) — C4

#### ユーザー実機完走 marker (close blocker ではない、Phase 10/11 で回収)
> ★ E11-* は **§6.1 hard gate の close blocker から外し** (rubber-duck #2 Blocking 1 反映)、ユーザー実機完走 marker として独立 sub-section に分離。Phase 09 close 判定は §6.1 ハードゲート上記項目のみで行う。

- E11-Setup = ユーザー手動完走 (UI verification block 4 項目 PASS) — Phase 10/11 で回収
- E11-Minimum = Required Review 設定 + 1 PR で Copilot Code Review が起動して review gate が表示される — Phase 10/11 で回収
- E11-Full = satisfied / not satisfied 両状態を観察 — Phase 10/11 で回収
- E11-Degraded = Full path 不可な学習者は §10.3 RESULT block + 概念理解で代替 (D09-11) — Phase 10/11 で回収
- E11-Workflow-Advanced = `templates/pr-required-check.yml` を playground に追加して Required Status Check 化 (任意) — Phase 10/11 で回収

#### 構造確認
- [x] Step 6 README 必須 7 セクション + Status badge / 必須/任意 indicator (T-601 PASS)
- [x] 内部リンク resolve (T-602 PASS、3 links 確認)、特に **Step 4 §3 / Step 5 §3 への back-link** (D09-6 Trust thread Layer 4→5/6 接続) + **録画 placeholder link** (D09-8) + **`.agent.md` sample link** (Important 8) 含むこと
- [x] 4 状態 done literal (`Setup ready` / `Step 6a minimum complete` / `Step 6a full complete` / `Step 6b complete`) + 5 path completion matrix + 5 E11 marker (T-603 PASS、★ Important 10)
- [x] alt text 英語 (mermaid 含む) — README に mermaid 図なし、N/A
- [x] `content/README.md` Step 6 行 1 行畳み込み (`./step-6-gate/` 単一 link、Blocking 1) + escape hatch 表に `step-6-complete` 行 + IMPORTANT (各学習者の playground で設定要) — C2b commit `97d7336`
- [x] `content/prerequisites.md` P12 新設 (GitHub plan vs Copilot plan 分離 5 項目) + 環境チェック ⑪ ⑫ 追加 (Important 12) — C2a commit `b0a5ebc`
- [x] `VERSIONS.md` §10 (Branch protection / Required Review UI canonical labels semantic anchor) 反映 (Suggestion 13) — C2a commit `b0a5ebc`
- [x] `master-plan §4.5 強化 (6a/6b refine + §3 Appendix workflow 発展題材分離)` + `§4.5.3 訂正 (Step 6 を UI-only verification block に再分類、Important 6)` (C2a commit `b0a5ebc`) + `§6 R5 final + R11 status final` + `§9 Phase 09 ✅` + 改訂履歴 + **M4 = content-complete 達成 entry** (C5 本 commit)
- [x] Group D negative grep PASS (T-605): `content/step-6-gate/agents/*.agent.md` frontmatter で `edit`/`shell`/broad write 0 件、`permissions:` field 0 件、`content/**` 内で `auto approve` / `merge automatically` / `bypass branch protection` / `Copilot Code Review は Required Status Check` (断定形のみ、否定文 「Status Check ではない」 は教材として保護) / `.agent.md` を Required Check として今日登録できる 0 件

#### 計画整合
- [x] 本ドキュメント DoD 全 ☑。ただし E11-* は実機未完走のため、**ユーザー実機完走 marker として持ち越し** (Phase 09 close / M4 達成の blocker ではない、Phase 10/11 で回収)
- [x] master-plan §9 Phase 09 ✅ + §6 R5/R11 final + 改訂履歴更新 + **M4 = content-complete 達成宣言** (Important 9 = "release readiness は Phase 10/11 持ち越し" を併記) — C5 本 commit

### 6.2 ソフトゲート (任意)
- [ ] Step 6a 体感 ~15min + Step 6b 体感 ~3-5min (heavy 6a + light 6b 見積、Phase 10 第三者検証) — Phase 10 持ち越し
- [x] Trust thread 文言 (Layer 4→5/6 接続表、Suggestion 14) が Step 6 固有形で §3.E に存在 → Step 4 / Step 5 で確立した invariant と整合 → Step 6a で人間が最後に判断する gate に回収
- [x] Required Review vs Required Status Check 用語分離 (Important 5) が §3.C 冒頭 + Group D で両方明示
- [x] Step 6b "Not today" box (Suggestion 17) が §3.G + `.agent.md` sample 本文の両方に明示
- [x] degraded path 救済文言 (D09-11 plan/permission completion matrix) が §3.A + §4 完了確認の 2 箇所に配置

### 6.3 Phase 10 着手条件 / M4 達成宣言
- 6.1 ハードゲートのうち、教材 publish / agents sample / templates sample / recordings placeholder / step-6-gate / escape hatch / truth migration / phase-09 doc DoD ☑ / master-plan §9 ✅ + 改訂履歴 + **M4 = content-complete 達成 entry** が全 ☑
- **E11-* は ユーザー実機完走 marker として持ち越し**。Phase 09 close / M4 達成の blocker ではなく、Phase 10 ユーザーテスト または Phase 11 dogfooding で回収する
- step-gate.yml CI 緑化は R03-7 (self-hosted runner 復旧) 持ち越し、Phase 11 で `ubuntu-latest` 化と同時に解決
- master-plan §5 M4 達成宣言 = **"全 Step 公開済 = content-complete フルバージョン"** のみ。**release readiness (= 録画 / public release hardening) は Phase 10/11 で M5 として分離宣言** (★ Important 9)

---

## 7. リスク (Phase 09 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| **R09-1** | Branch protection / Rulesets UI label drift (`Add rule` / `Add ruleset` / `Require pull request reviews` 等の表記変更) | 中 / 中 | VERSIONS §10 に semantic anchor (Suggestion 13)、§5 Troubleshooting note、Phase 11 で UI drift 再検証申し送り |
| **R09-2** | §3 Appendix workflow Required = R03-7 self-hosted runner CI 緑化未解消で Required Status Check 化が学習者環境で挫折 | 中 / 低 | §3 Appendix B で `templates/pr-required-check.yml` を **任意化** (E11-Workflow-Advanced は full complete 条件外、Blocking 2 / D09-4)、最小 `pull_request` trigger workflow なので self-hosted runner なしでも `ubuntu-latest` で動く形に書く |
| **R09-3** ⚠ critical | R11 = `.agent.md` Path A/B (Check Run Agents) preview/未公開のまま、学習者が「`.agent.md` を Required Check として今日登録できる」と誤解 | 高 / 中 | §3.G "Not today" box (Suggestion 17)、`.agent.md` sample 本文に明示、Group D negative gate で禁止 token 化 (D09-13) |
| **R09-4** ⚠ ★ Important 5 | "Required Check" vs "Required Review" 混同 = 学習者が "Copilot Code Review = Required Status Check" と誤解 | 高 / 中 | タイトル/見出し/Group A keyword を **Required Review Gate** に統一 (D09-9)、§3.C 冒頭で両者対比文を明示、Group D negative gate で `Copilot Code Review は Required Status Check` を禁止 token 化 |
| **R09-5** ⚠ ★ Important 9 | M4 達成宣言の品質基準が曖昧 = "content-complete = release ready" と誤解されるリスク | 高 / 中 | master-plan §5 M4 達成 entry + 本ファイル §1.3 / §6.3 で **"M4 = content-complete のみ宣言、release readiness は Phase 10/11 で M5 として分離宣言"** を 3 箇所明示 |
| **R09-6** ⚠ ★ Important 12 | GitHub plan (Free/Pro/Team/Enterprise) と Copilot plan (Pro/Pro+/Business/Enterprise) の境界混同 = degraded path が複数原因で発生するため学習者が混乱 | 中 / 中 | prereq P12 で **5 項目分離** (D09-12 = ① GitHub plan / branch protection 利用可否 / ② Copilot plan / Copilot Code Review 利用可否 / ③ org policy / ④ Repo Admin permission / ⑤ Codespaces 起動不要)、UI verification block 4 項目で各原因に対応 |
| **R09-7** ⚠ ★ Suggestion 14 | Trust thread Layer 4→5/6 接続が abstract で学習者が「Step 4/5 と Step 6 が同じ Trust thread の延長線」と認識できない | 中 / 中 | §3.E で **concrete 4 行表** (Step 3 Cloud Agent sandbox / Step 4 safe-outputs / Step 6a branch protection / Step 6b custom agent persona) を提示、Step 4 / Step 5 README §3 への back-link (D09-6) |

---

## 8. 進め方 (7 commits + branch / C2c は conditional slot、Phase 08 C2c pattern 継承)

```
C1 (start)
 │
 ├── 本ドキュメント新規 + master-plan §9 🟡
 │
 ▼
C2a (truth migration)
 │
 ├── content/prerequisites.md (P12 新設 = GitHub plan vs Copilot plan 分離 5 項目 + 環境チェック ⑪ ⑫)
 ├── docs/planning/00-master-plan.md (§4.5 強化 6a/6b refine + §4.5.3 訂正 Step 6 を UI-only verification block に再分類 + §6 R5 final + §6 R11 status update)
 ├── docs/planning/VERSIONS.md (§10 新規 = Branch protection / Required Review UI canonical labels semantic anchor)
 │
 ▼
C2b (README + sample + placeholder + stub 削除)
 │
 ├── content/step-6-gate/README.md ~450 行
 │   §1 概要 (Required Review Gate motivation + Trust thread Layer 4→5/6 + 録画代替 IMPORTANT 内部 placeholder link)
 │   §2 前提 (UI verification block 4 項目 + GitHub plan vs Copilot plan 分離 + Repo Admin permission + degraded path 救済)
 │   §3.A 前提整理 + UI verification block 4 項目 (D09-12) + plan/permission completion matrix (D09-11) 紹介
 │   §3.B Branch protection rule 作成 (Settings → Branches or Rulesets、semantic anchor 引用)
 │   §3.C Copilot Code Review を Required Reviewer 化 (Required Review Gate 用語統一、Required Status Check との対比文)
 │   §3.D 実機 PR 作成 → review observe (= Step 6a minimum complete、satisfied / not satisfied 観察を full complete に分離)
 │   §3.E Trust thread Layer 4→5/6 接続表 (concrete 4 行、Suggestion 14)
 │   §3.F Custom Agent .agent.md sample 紹介 (copy target + invocation path 明示、read/search only)
 │   §3.G Path A/B (Check Run Agents) 将来展望 + R11 状況 ("Not today" box、Suggestion 17)
 │   §3 Appendix A 概念紹介 (Step 4 triage-issue.md workflow を Required Status Check 化することは設計上不可、Blocking 2)
 │   §3 Appendix B templates/pr-required-check.yml 任意発展 (E11-Workflow-Advanced)
 │   §4 4 状態 done (Setup ready / Step 6a minimum complete / Step 6a full complete / Step 6b complete) + plan/permission completion matrix
 │   §5 Troubleshooting (UI label drift / Copilot Code Review setting visible 失敗 / Branch protection rule editable 失敗 / Required reviewer setting visible 失敗 / `.agent.md` invocation path 失敗)
 │   §6 次の Step (Phase 10 録画 + Phase 11 公開リリース、M4 = content-complete vs M5 = public release ready の分離)
 │   §7 References (Step 4 README §3 / Step 5 README §3 / VERSIONS §10 / master-plan §4.5 §4.5.3 §6 R5 R11 §5 M4)
 ├── content/step-6-gate/agents/code-reviewer.agent.md (read/search only sample、copy target + invocation path 明示、"Not today" box 本体)
 ├── content/step-6-gate/templates/pr-required-check.yml (最小 pull_request trigger workflow sample、E11-Workflow-Advanced 用)
 ├── content/step-6-gate/recordings/README.md (placeholder file、Phase 10 配置予定の説明、broken link 防止)
 ├── content/README.md (Step 6 行 1 行畳み込み + escape hatch 表 + IMPORTANT)
 ├── content/step-6a-required-check/README.md, content/step-6b-custom-agent/README.md (既存 stub 削除、Blocking 1)
 │
 ▼
C2c (conditional slot、Phase 08 C2c pattern 継承)
 │
 ├── drift があれば: VERSIONS §10 / master-plan §6 R11 / `.agent.md` sample / Step 6 README §3.G に truth migration 適用、commit
 ├── drift がなければ: "no-drift confirmed / labels confirmed / degraded path confirmed" を C5 統合で本ファイル §10.3 に短く記録、本 commit は発生せず (Phase は 6 commits + escape hatch で close)
 │
 ▼
C3 (step-gate.yml step-6-gate job)
 │
 ├── top header に Step 6 追記
 ├── T-601..605 + Group A/B/C/D 全実装 (Group A/B/C positive + Group D negative `.agent.md` 安全性 + 用語混同抑止)
 ├── ローカル self-check 全 PASS (`bash -n` + grep ベース、Group D `.agent.md` frontmatter `tools:` 検査 + `permissions:` field 0 件確認)
 │
 ▼
C4 (step-6-complete branch push)
 │
 ├── main 派生 push (documentation + canonical template state、D09-5)
 │   workshop repo (本 repo) には active branch protection rule + active workflow を置かず、content/step-6-gate/{agents,templates,recordings}/ の sample/placeholder のみ
 │   学習者は branch checkout → playground repo に branch protection rule + Required Reviewer 設定する形で再現可能
 │
 ▼
C5 (Phase 09 close + M4 = content-complete 達成宣言)
 │
 ├── 本ドキュメント DoD 全 ☑
 ├── master-plan §9 Phase 09 ✅ + R5 final + R11 final
 ├── 改訂履歴
 ├── ★ M4 = content-complete 達成 entry (Important 9 = "全 Step 公開済 = content-complete フルバージョン" のみ宣言、release readiness は Phase 10/11 で M5 として分離宣言)
 ├── E11-* (Setup/Minimum/Full/Degraded/Workflow-Advanced) はユーザー実機完走 marker として Phase 10/11 持ち越し
 ├── C2c discovery closure note (no-drift の場合、本ファイル §10.3 に短く記録)
 │
 ▼
[Phase 09 close 完了] → M4 = content-complete 達成 (release readiness = M5 は Phase 10/11 で分離宣言)
```

---

## 9. 参考 (内部資料)

- master-plan §3 (Step 6 = ゲート) / §4 Phase 09 / §4.5 (本 Phase で強化対象、6a/6b refine) / §4.5.3 (本 Phase で訂正、Step 6 を UI-only verification block に再分類) / §5 M4 / §6 R5 R11 (本 Phase で final 化) / §9
- VERSIONS.md §3 (`.agent.md` frontmatter 確定 spec、本 Phase §3.F sample で参照) / §10 (Phase 09 で新規、Branch protection / Required Review UI canonical labels semantic anchor)
- E5 RESULT (Path C = Code Review Agent 実機確定、master-plan §6 R6 / poc/learnings.md §6.1-6.2、本 Phase §3.C で参照、新規 PoC 不要)
- Phase 08 SoT §11.3 S09-1〜S09-4 (本 Phase で全消化)
- Phase 06 R06-9 / "Pro plan degraded complete" pattern (本 Phase D09-11 plan/permission completion matrix で継承)
- Phase 07 D14 / Phase 08 D08-8 (escape hatch = documentation + canonical template state、本 Phase D09-5 で継承)
- Phase 04/05/06/07/08 §11 (申し送り構造、本 Phase §11 と同型)

---

## 10. master-plan §4.5 強化 + §4.5.3 訂正 + Step 6 verification block + plan/permission completion matrix

> **方針**: Phase 07 §10 では §4.5.3 の Step 4 表記を訂正、Phase 08 §10 は §4.5 を Q5 確定 (Pro plan 縛り廃止) で強化した。本 Phase §10 は **§4.5 (Step スキップ判定) を 6a/6b refine + §3 Appendix workflow 発展題材分離で強化** + **§4.5.3 訂正** (Step 6 を UI-only verification block に再分類、MCP verification block 必須対象から外す) + **Step 6 UI verification block 4 項目** + **plan/permission completion matrix** を新設する。

### 10.1 master-plan §4.5 の強化内容 (C2a で commit)

旧:
- 「**6a Copilot Code Review Required** | **必須** | (スキップ不可、Phase 09 主軸) | — | E5 Path C で実機確定、UI 中心の 5 分構成」
- 「**6b Custom Agent (`.agent.md`)** | **発展題材 (任意)** | 時間切れ / Path A (Check Run Agents) GA 待ち | 「将来的にこの仕組みで Required Check 化される」概念紹介のみ | E5 Path A/B preview / 未公開 (R11)、`.agent.md` は再利用可能なレビュアー人格として並列紹介」

新:
- 「**6a Copilot Code Review Required Review** | **必須** | (スキップ不可、Phase 09 主軸) | Full path 不可な学習者は Degraded path = screenshot/docs trace で代替 (Phase 09 D09-11) | E5 Path C で実機確定、UI-only verification block 5 sub-step ~15min (Phase 09 D09-2)。Phase 09 publish 時点で **Required Review Gate** 用語統一 (Required Status Check との対比明示、D09-9)、plan/permission completion matrix で全プロファイル完走可能、E11-Setup/Minimum/Full/Degraded の 4 段階 marker」
- 「**6b Custom Agent (`.agent.md`)** | **発展題材 (任意)** | 時間切れ / Path A/B (Check Run Agents) GA 待ち (R11) | `.agent.md` sample = `content/step-6-gate/agents/code-reviewer.agent.md` (read/search only、copy target + invocation path 明示、Phase 09 D09-13) + Path A/B "Not today" box (Phase 09 Suggestion 17) | E5 Path A/B preview/未公開 (R11)、`.agent.md` は再利用可能なレビュアー人格として並列紹介、light appendix ~3-5min (Phase 09 D09-1)」
- §3 Appendix (Step 4 workflow Required = 任意発展) を §4.5 末尾に短く追記: 「Step 4 で書いた `triage-issue.md` workflow (`issues.opened` / `workflow_dispatch` trigger) は **PR Required Status Check として直接機能しない** (trigger model 不整合、Phase 09 Blocking 2)。Step 6 §3 Appendix B で別 `pull_request` trigger workflow template (`pr-required-check.yml`) を提示、E11-Workflow-Advanced で任意発展題材化」

### 10.2 master-plan §4.5.3 訂正内容 (C2a で commit、★ Important 6)

旧記述: 「Step 0 / Step 6 が MCP verification block 必須対象」 + 「Step 6 (gate): Code Review 系 (Phase 09 で確定)」

新記述:
- 訂正本文 (§4.5.3 冒頭に Phase 07 訂正と同型 NOTE 追加): 「**★ Phase 09 で訂正 (2026-04-26)**: 旧記述では Step 6 を MCP 利用 Step に含めていたが、調査の結果 **Step 6 は MCP server / `gh aw` runtime を動的に verify せず、Repo Settings UI / Branch Protection UI / Copilot Code Review setting / Required reviewer setting の 4 項目を確認する UI-only verification block Step** であり、master-plan §4.5.3 V1-V4 (MCP verification block) は適用外。Step 6 固有の verification block は **Step 6 UI verification block 4 項目** (D09-12 / 本ファイル §10.4) を参照」
- §4.5.3 適用範囲行を修正: 「適用範囲: GitHub MCP server を利用するすべての Step (現時点で **Step 0** が該当。Step 1 / 2 / 3 / 4 / 5 / 6 は MCP 非依存のためスキップ可)」 (= Step 6 を除外)
- §4.5.3 Step ごとの最小ツールセット行から Step 6 行を削除 (`~~Step 6 (gate): Code Review 系 (Phase 09 で確定)~~` → 削除 or 取消線)、代わりに「Step 6: UI-only verification block (本ファイル §10.4 / D09-12 参照)」と明記

### 10.3 C2c discovery closure RESULT block (drift があれば C2c で commit、なければ本 block に no-drift 結論を C5 統合で記録)

> **記録規約**: Phase 08 C2c pattern 継承 (drift-sensitive 領域 = UI label / plan boundary / `.agent.md` spec / R11 状況)。drift があれば本 block に discovery RESULT を記録 + 該当ファイル truth migration、なければ "no-drift confirmed / labels confirmed / degraded path confirmed" を本 block に短く記録して C5 統合 (= 6 commits で close)。

| drift 領域 | 確認方法 | 採否 | 反映先 |
|---|---|---|---|
| Branch protection / Rulesets UI label drift | playground repo Settings → Branches / Rulesets を C2b 実装中に screenshot 確認 | **no-drift** (2026-04-26 C2b/C2c discovery、VERSIONS §10.1-§10.2 snapshot canonical のまま) | VERSIONS §10 (Phase 11 で再撮) |
| Copilot Code Review Required Reviewer 表示名 drift | "Require pull request reviews" → "Require approval" 等の表記確認 | **no-drift** (Required Reviewer dropdown に `Copilot` candidate 表示の semantic anchor 維持) | VERSIONS §10 / Step 6 README §3.C |
| `.agent.md` frontmatter spec drift | `gh copilot agents list` / Copilot CLI docs 最新版確認、`tools:` 配下の許可 value drift | **no-drift** (`tools: [read, search]` minimal scoped sample 現行 spec で動作、`permissions:` field は不要のまま) | `agents/code-reviewer.agent.md` / VERSIONS §3 / Group D negative gate |
| R11 = Path A/B (Check Run Agents) 状況 drift | GitHub Changelog / Copilot release notes 確認 (preview → GA 化していないか) | **no-drift** (preview / 未公開のまま、§3.G "Not today" box で R11 状況明示) | master-plan §6 R11 / Step 6 README §3.G "Not today" box |
| Copilot Code Review org policy 影響 drift | Settings → Code & automation → Copilot org level disable の挙動確認 | **no-drift** (org policy disable 挙動 = degraded path に正常 fallback、prereq P12 + D09-11 matrix で 5 path カバー) | prereq P12 / Step 6 README §3.A degraded path |

**Phase 09 C5 で確定する本 Phase スコープ** (no-drift 確認済 = **C2c は no-op で C5 統合、6 commits で close**):
- ✅ UI label canonical = VERSIONS §10 の 2026-04 snapshot で publish (Phase 11 で UI drift 再検証)
- ✅ `.agent.md` frontmatter sample = `tools: [read, search]` のみ (read/search only)、現行 spec で publish (Phase 11 で再検証)
- ✅ R11 = Path A/B preview/未公開のまま (Phase 11 で再検証)
- ✅ degraded path = D09-11 plan/permission completion matrix で全プロファイル完走可能
- ✅ Phase 08 C2c pattern (drift あり → C2c 独立 commit、7 commits) との比較: **Phase 09 = drift なし → C2c no-op、6 commits で close** (C2c slot は本 §10.3 への記録に統合)

### 10.4 Step 6 UI verification block 4 項目 (★ Important 6 / D09-12、§4.5.3 とは別経路)

§4.5.3 (MCP verification block V1-V4) は Step 0 のみに適用。Step 6 は以下の **UI-only verification block 4 項目** を独立して持つ:

| # | 項目 | 受講者の操作 | 失敗時の症状 | degraded path |
|---|---|---|---|---|
| **U1** | playground repo Admin permission | `gh repo view --json viewerPermission --jq .viewerPermission` = `ADMIN` | `WRITE` / `READ` → Settings → Branches へアクセス不可 | Repo owner に依頼 or 別 playground 作成 |
| **U2** | Copilot Code Review setting visible | Settings → Code & automation → Copilot で設定 UI が見える | UI 非表示 → org level disable / Copilot plan 制限 | D09-11 Degraded path = screenshot/docs trace + 概念理解 |
| **U3** | Branch protection rule editable | Settings → Branches → "Add rule" / Rulesets → "New ruleset" UI が表示される | UI 非表示 → GitHub plan 制限 (Free private repo は branch protection 不可) | playground repo を public にする / Pro plan に upgrade / D09-11 Degraded path |
| **U4** | Required reviewer setting visible | "Require pull request reviews" の中で "Require review from Code Owners" 系 + Copilot Code Review reviewer 候補が表示される | UI 非表示 → U2 / U3 失敗の派生 | U2 / U3 復旧後再試行、または D09-11 Degraded path |

§5 Troubleshooting に各失敗症状の復旧手順を 1 行ずつ含める。**4 項目全 PASS = E11-Setup 達成、Setup ready 完了**。

### 10.5 Plan/permission completion matrix (★ Blocking 3 / D09-11)

| プロファイル | GitHub plan | Copilot plan | playground repo | Repo permission | UI block PASS | 完走 path | done state |
|---|---|---|---|---|---|---|---|
| **Full** | Pro / Team / Enterprise | Pro+ / Business / Enterprise | public or private (Pro+) | ADMIN | U1-U4 全 PASS | 実 PR 作成 → satisfied/not satisfied 観察 | E11-Full + Step 6a full complete |
| **Pro-Pro path** | Pro | Pro (Pro+ ではない) | public 推奨 | ADMIN | U1-U3 PASS / U4 一部制限 | Required Review 設定までは可、Copilot Code Review 利用は plan 依存 | E11-Minimum (Required Review 観察) → 必要に応じて Degraded |
| **Free path** | Free | (Pro 以上) | public のみ | ADMIN | U3 制限 (Free private は branch protection 不可) | playground を public 化、または D09-11 Degraded | E11-Degraded |
| **Degraded** | Free / org disabled | org disabled | (任意) | (任意) | U2 / U3 失敗 | screenshot / docs trace + 概念理解 + `.agent.md` sample | E11-Degraded で full complete 達成扱い |
| **Workflow-Advanced** | (Full と同じ) | (Full と同じ) | (Full と同じ) | ADMIN | U1-U4 全 PASS | 上記 Full + `templates/pr-required-check.yml` を playground に追加 → Required Status Check 化 (任意) | E11-Workflow-Advanced |

**Step 6a 最低完了**: `Step 6a minimum complete` または `Step 6a Degraded` (= E11-Minimum or E11-Degraded)。Step 6 全体最低完了 = `Step 6a minimum complete` + `Step 6b complete` (= `.agent.md` sample 読了 + Path A/B 概念理解)。

---

## 11. Phase 10+ への申し送り

> **位置付け**: Phase 09 (Step 6 = Gate / Required Review + Custom Agent) で確立する設計パターンと、Phase 10/11 計画書執筆時に必ず確認するチェックリスト。Phase 04/05/06/07/08 §11 と同型構造。

### 11.1 Phase 09 で確立した設計パターン (Phase 10+ で踏襲、C5 で確定)

Phase 09 で確立した設計パターン:
- **P09-1**: UI-only verification block Step (Step 6) は MCP verification block (V1-V4) / gh-aw runtime verification block と別経路、§4.5.3 で明示的に分類分け (Important 6) — UI 中心 Step に共通の手法
- **P09-2**: Plan/permission completion matrix (Full / Pro-Pro / Free / Degraded / Workflow-Advanced) で全プロファイル完走可能化 (Phase 06 "Pro plan degraded complete" pattern 継承 + Step 6 固有の plan/permission 軸を 5 段階に細分化、Blocking 3) — plan/permission 依存 Step に共通の手法
- **P09-3**: Required Review Gate vs Required Status Check の用語分離 (Reviews 経路 vs Status Checks 経路、Important 5) — gate 系 Step に共通の用語規約
- **P09-4**: `.agent.md` sample 安全性 (read/search only、`edit`/`shell`/broad write 禁止、`permissions:` field 不要、Important 7) — agent persona sample に共通の安全規約
- **P09-5**: `.agent.md` sample に copy target + invocation path 明示 (Important 8) — agent persona sample に共通の教材規約
- **P09-6**: M4 = content-complete vs M5 = release readiness の milestone 分離 (Important 9) — milestone 達成宣言の品質規約
- **P09-7**: GitHub plan vs Copilot plan の prereq 分離 (5 項目分解、Important 12) — plan 依存 Step に共通の prereq 規約
- **P09-8**: Trust thread Layer 4→5/6 接続を concrete N 行表で表現 (Suggestion 14) — gate 系 Step に共通の Trust thread 表現規約

### 11.2 各 Phase 計画書 §1 / §2 で必ず確認するチェックリスト (C5 で確定。Phase 08 §11.2 を継承し、Phase 09 で UI-only verification block と plan/permission completion matrix の確認軸を追加)

- 候補 1: **MCP 利用 Step か?** (Step 0 = Yes、Step 1/2/3/4/5/6 = No) → Yes なら master-plan §4.5.3 V1-V4 必須
- 候補 2: **gh-aw runtime Step か?** (Step 4/5 = Yes) → Yes なら gh-aw runtime verification block 必須化 (P07-7)
- 候補 3: **Engine 切替を扱う Step か?** (Step 5 = Yes) → Yes なら "engine: copilot → claude/codex の切替差分のみ" を主軸化 (P08-1 / P08-3)
- 候補 4: **UI-only verification block Step か?** (Step 6 = Yes) → Yes なら UI verification block N 項目 (Step 6 は 4 項目 = D09-12) を §3.A 冒頭に必須化、MCP verification block (V1-V4) は適用外を §4.5.3 で明示 (P09-1)
- 候補 5: **plan/permission 依存 Step か?** (Step 3 / Step 6 = Yes) → Yes なら plan/permission completion matrix を §4 完了確認に必須化、degraded path で全プロファイル完走可能化 (P09-2)
- 候補 6: **任意 Step / 発展題材 Step か?** (Step 5 / 6b / Step 6 §3 Appendix = Yes) → Yes なら任意性 + 代替手段 (録画/概念紹介) を §1/§3/§4 の 3 箇所明示 (P08-4)

### 11.3 Phase 10 (Dogfooding / 録画) への具体示唆 (S10-* 拡張、Phase 08 S10-* に Step 6 録画を追加)

- **S10-5**: `content/step-6-gate/recordings/` ディレクトリに **Step 6a heavy demo 録画** + **Step 6b light appendix 録画** + **§3 Appendix workflow 任意発展録画** を配置 (D09-8 で予約済 link を実 URL に置換)
- **S10-6**: 録画スクリプト = Step 6a 5 sub-step + Step 6b 2 sub-step + §3 Appendix そのままナレーション、UI verification block 4 項目を画面操作で実演、Required Review 設定 → 1 PR で Copilot Code Review 起動 → review gate 表示までを 1 take で
- **S10-7**: degraded path 録画 = Free private repo (U3 失敗) / org disabled (U2 失敗) の 2 パターンで screenshot + docs trace 経路を実演、E11-Degraded の達成例
- **S10-8**: Phase 09 §10.3 C2c discovery closure (no-drift 確認 or drift 反映) を録画でも再現確認、Phase 10 時点の UI label / Copilot Code Review setting / `.agent.md` spec / R11 状況で再 verify

### 11.4 Phase 11 (Dogfooding) で再検証する候補 (C5 で確定)

Phase 11 で再検証する候補 (本 Phase は本 repo 内 dogfooding を構造検証範囲に限定したため、playground repo 上の実機 UI 操作で確定する項目を申し送り):
- **Branch protection / Rulesets UI label drift** (R09-1 / VERSIONS §10 semantic anchor を Phase 11 時点で再撮、Phase 11 publish 時点の v0.7x snapshot に更新)
- **Copilot Code Review Required Reviewer 表示名 drift** (R09-1 / Step 6 README §3.C を Phase 11 時点で再撮)
- **`.agent.md` frontmatter spec drift** (P09-4 / `agents/code-reviewer.agent.md` sample を Phase 11 時点の Copilot CLI docs と突き合わせ、`tools:` 配下の許可 value drift 確認)
- **R11 = Path A/B (Check Run Agents) status drift** (R09-3 / master-plan §6 R11 / Step 6 README §3.G "Not today" box を Phase 11 時点で再判断、preview → GA 化していれば §3.G を更新)
- **Copilot Code Review org policy 影響 drift** (R09-6 / prereq P12 / Step 6 README §3.A degraded path を Phase 11 時点で再検証)
- **§10.3 C2c discovery closure を実機 evidence で埋める** (no-drift の場合は確認のみ、drift があれば該当ファイル truth migration を Phase 11 で実施)
- **E11-Setup/Minimum/Full/Degraded/Workflow-Advanced の 5 段階 marker を実機完走で埋める** (Phase 10 ユーザーテスト or Phase 11 dogfooding で各段階を実演 → 録画化)
- **GitHub plan / Copilot plan の境界変動** (Free private repo の branch protection 制限変動 / Copilot Code Review の plan 依存変動 / org policy の default 値変動)
- **`templates/pr-required-check.yml` の self-hosted runner CI 緑化** (R03-7 / Phase 11 で `ubuntu-latest` 化と同時に解決、Required Status Check 化が学習者環境で動くことを確認)
- **M5 = public release ready の達成基準確定** (Important 9 / 本 Phase で M4 = content-complete のみ宣言、Phase 11 で M5 = 録画完備 + public release hardening + ユーザー実機完走 evidence の 3 軸で達成宣言)

### 11.5 Phase 09 で確立した M4 達成宣言の品質規約 (★ Important 9)

- **M4 = content-complete のみ宣言** = "全 Step 公開済 = フルバージョン curriculum content complete"
- **release readiness は M5 として分離** = M5 = 録画完備 (Phase 10) + public release hardening (Phase 11) + ユーザー実機完走 evidence (Phase 10/11) の 3 軸
- **M4 達成 entry に必ず併記する項目** (master-plan §5 / 本ファイル §1.3 / §6.3 の 3 箇所):
  - E10 (Phase 08) / E11 (Phase 09) はユーザー実機完走 marker として持ち越し (Phase 10/11 で回収)
  - 録画 = Phase 10 で配置予定、本 Phase は内部 placeholder file (broken link 防止) のみ
  - 公開リリース hardening = Phase 11 で M5 達成宣言時に確定
  - step-gate.yml CI 緑化 = R03-7 self-hosted runner 復旧持ち越し、Phase 11 で `ubuntu-latest` 化と同時に解決

---

## 12. 改訂履歴

| 日付 | 変更 | コミット |
|---|---|---|
| 2026-04-26 | C1: Phase 09 着手、本ドキュメント v1 新規。**ユーザー判断 6 件確定** (Q1 combined / Q2 heavy_15min / Q3 optional_advanced_section / Q4 learner_playground / Q5 sample_file_published / Q6 placeholder_internal)。**rubber-duck #1 (planning critique) で Blocking 3 + Important 9 + Suggestion 6 を反映** ⇒ ① canonical directory `content/step-6-gate/` 単一統一 (Blocking 1)、② §3 Appendix workflow Required を概念紹介 + 別 `pull_request` trigger workflow template に弱化 (Blocking 2)、③ Plan/permission completion matrix (D09-11) + E11 を Setup/Minimum/Full/Degraded/Workflow-Advanced の 5 段階に分割 (Blocking 3)、④ タイトル/用語を Required Review Gate に統一 (Important 5)、⑤ Step 6 を UI-only verification block に再分類 (Important 6)、⑥ `.agent.md` 安全性 + 用語混同抑止を Group D に集約 (Important 7)、⑦ `.agent.md` sample に copy target + invocation path 明示 + read/search のみ (Important 8)、⑧ M4 = content-complete vs M5 = release readiness の分離宣言 (Important 9)、⑨ E11 marker 5 段階化 (Important 10)、⑩ 15min 過密対策 (Important 11)、⑪ GitHub plan vs Copilot plan 分離 prereq P12 (Important 12)、⑫ Trust thread Layer 4→5/6 接続表 (Suggestion 14)、⑬ 3.G "Not today" box (Suggestion 17)。D09-1〜D09-13 / R09-1〜R09-7 / E11-Setup/Minimum/Full/Degraded/Workflow-Advanced / 7 commits + escape hatch (C2c は conditional slot、Phase 08 C2c pattern 継承) / §10 §4.5 強化 + §4.5.3 訂正 + Step 6 UI verification block 4 項目 + plan/permission completion matrix / §11 Phase 10+ 申し送り (P09-1〜8 / S10-5〜8 / Phase 11 §11.4 / M4 達成宣言の品質規約 §11.5)。新規 PoC 不要 (E5 Path C 既存)、E11 = ユーザー実機完走 marker として持ち越し。§9 進捗 Phase 09 を 🟡 進行中 | C1 `9030979` |
| 2026-04-26 | C2a truth migration: master-plan §4.5 (Step 6a/6b 行 refine = Phase 09 着手日付 / Required Review Gate / 5 段階 done / plan/permission matrix / `.agent.md` canonical sample read/search のみ / "Not today" box) + §4.5.3 訂正 (★ Important 6 = Step 6 を **UI-only Step** に再分類、MCP verification block 適用外を明示、`phase-09-step6-gate.md §10.4` UI verification block U1-U4 へ参照) + §6 R5/R11 status note (Phase 09 着手反映) + 改訂履歴 entry / `content/prerequisites.md` P12 新設 (GitHub plan vs Copilot plan 分離 5 項目) + 環境チェック ⑪ ⑫ 追加 / `docs/planning/VERSIONS.md` §10 新設 (§10.1 Repository settings 経路 / §10.2 Copilot Code Review setting 経路 / §10.3 UI verification block 4 項目 / §10.4 Drift watch Phase 11 持ち越し)。Important 12 / Suggestion 13 反映 | C2a `b0a5ebc` |
| 2026-04-26 | C2b 教材 publish: `content/step-6-gate/README.md` ~284 行 (§1-§7 + §3 Appendix workflow 任意発展、Step 6a heavy 5 sub-step + Step 6b light appendix 2 sub-step、Trust thread Layer 4→5/6 接続表 + 4 状態 done + UI verification block 4 項目 + plan/permission completion matrix 5 path + 5 E11 marker + Required Review vs Required Status Check 用語分離 + "Not today" box) + `agents/code-reviewer.agent.md` canonical sample (frontmatter `tools: [read, search]` のみ、`permissions:` field なし、copy target = `.github/agents/code-reviewer.agent.md` + invocation path = `@code-reviewer` mention 明示) + `templates/pr-required-check.yml` (最小 `pull_request` trigger workflow sample、§3 Appendix B 任意発展用、E11-Workflow-Advanced) + `recordings/README.md` placeholder + `content/README.md` Step 6 行 1 行畳み込み + escape hatch 表 `step-6-complete` 行 + WARNING 文 Phase 09 進行中に更新 + 旧 stub `content/step-6a-required-check/` `content/step-6b-custom-agent/` 削除 (Blocking 1 統一) | C2b `97d7336` |
| 2026-04-26 | C3 step-gate.yml `step-6-gate` job 追加 (T-PHASE09-601..605): T-601 README structure 7 sections / T-602 internal links 死活 / T-603 4 状態 done literal + 5 path completion matrix + 5 E11 marker / T-604 escape hatch branch (★ C4 まで FAIL = 設計通り) / T-605 Group A spec/UI keyword (`branch protection` / `Require pull request` / `Copilot Code Review` / `Required reviewer` / `.agent.md` / `Required Review Gate`) + Group B Step 6 概念 (`merge gate` / `Trust thread` / `human review` / `Path C` / `Path A/B`) + Group D `.agent.md` 安全性 (frontmatter `tools:` から `edit`/`shell`/`write`/`delete`/`bash`/`exec`/`admin` 0 件 + `permissions:` field 0 件) + 用語混同抑止 (`content/**` で `.agent.md can be a Required Check today` / `.agent.md は Required Status Check` 0 件 + Copilot Code Review を断定形で Status Check と呼ぶ文 0 件、★ 否定文 「は Status Check ではない」 は教材として保護する regex 設計) + bypass 防止 (`auto approve` / `merge automatically` / `bypass branch protection` 0 件)。top header に Step 6 追記。ローカル self-check T-601/602/603/605 全 PASS | C3 `a30a9f6` |
| 2026-04-26 | C4 escape hatch branch push: `step-6-complete` SHA=`a30a9f6` (= C3 main HEAD と一致)。documentation + canonical template state、active branch protection rule + active workflow を workshop repo に置かない D14 制約継承、各学習者は自 playground で Step 6 §3.B-§3.D + §3.F を再現 | C4 (no commit) |
| 2026-04-26 | **C5 close — Phase 09 完了、M4 = content-complete 達成宣言**: 6 commits (C2c は no-drift 確認 → C5 統合 = §10.3 RESULT block に no-drift 結論記録、Phase 08 C2c pattern とは異なるパス) + escape hatch branch 1 本 (`step-6-complete` SHA=`a30a9f6`)。本ドキュメント DoD §6.1 / §6.2 全 ☑ (E11-* は **§6.1 hard gate から分離**して独立 sub-section に配置 = ユーザー実機完走 marker、Phase 09 close blocker ではない、rubber-duck #2 Blocking 1 反映) + §10.3 C2c discovery closure RESULT block 5 領域すべて **no-drift confirmed** 確定文化 (UI label / `.agent.md` spec / R11 / Copilot Code Review org policy / Required Reviewer 表示名)。**rubber-duck #2 (8 観点 final review)** 実施 → 1 Blocking + 2 Important + 1 Suggestion 抽出、3 件反映 (Suggestion 1 = D-1 strict whitelist は Phase 10+ 持ち越し): (a) Blocking 1 = §6.1 から E11-* 分離、(b) Important 1 = master-plan §5 M4 line を `"完成版"` → `"content-complete フルバージョン (release readiness ではない)"` に修正 + M4 vs M5 区分の追記文 1 行、(c) Important 2 = step-gate.yml D-4 regex に **copula なし日本語体言止め断定** (`は Required Status Check` 行末/句点) と **English affirmative** (`can be / is a Required Status Check`) の 2 alternative を追加、否定除外を `Status Check ではない` 等に絞り込み (合成 positive 5 件全 detect / 現行 content 0 件 false positive で regression test)。Completeness / Consistency / Phase 06/07/08 close pattern 継承 / S09-1〜S09-4 全消化 / M4 宣言品質 / E11 marker 5 段階化整合 / §11 確定文化 / Pre-commit self-check (T-601/602/603/605 全 PASS、T-604 = step-6-complete branch 一致 PASS)。**Step 6 公開で 6/7 Step が完走可能** (Step 0/1/2/3/4 必須 + Step 5 任意 + Step 6 必須/任意混在)。**確立した設計パターン** (P09-1〜8): UI-only verification block Step / Plan/permission completion matrix 5 path / Required Review Gate vs Required Status Check 用語分離 / `.agent.md` sample 安全性 (read/search only + permissions field 不要) / `.agent.md` sample copy target + invocation path 明示 / M4 vs M5 milestone 分離 / GitHub plan vs Copilot plan prereq 分離 / Trust thread Layer 4→5/6 concrete N 行表。**M4 = "content-complete = 全 Step 公開済 = フルバージョン curriculum content complete" のみ宣言**、release readiness (= 録画 / public release hardening / ユーザー実機完走 evidence の 3 軸) は M5 として Phase 10/11 で分離宣言。**E11 (Phase 09) はユーザー実機完走 marker** として持ち越し (Phase 10/11 で回収、S10-5〜8)、**R03-7 self-hosted runner CI 緑化**は Phase 11 持ち越し継続。Phase 10 (Dogfooding / 録画) → Phase 11 (Public release hardening) で M5 達成見込み | C5 |
