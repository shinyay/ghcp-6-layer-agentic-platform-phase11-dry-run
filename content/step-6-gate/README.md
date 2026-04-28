# Step 6 — Gate (Required Review + Custom Agent)

> **必須 Step (Phase 09 主軸、Standard / Full プロファイル)** ・ 対応 Layer: **Layer 6 (ゲート)** ・ 体感 ~15-20 分 (Step 6a heavy 5 sub-step + Step 6b light appendix 2 sub-step)
>
> **このステップで何が起きるか (3 行)**
> 1. **Step 6a (heavy / 必須)** = playground repo の **Branch protection rule** と **Copilot Code Review を Required Reviewer** として組み合わせ、PR が **Required Review Gate** を越えなければ merge できない状態を構築する (= Trust thread Layer 6)。
> 2. **Step 6b (light appendix / 任意)** = `.agent.md` で再利用可能な **Custom Agent (レビュアー人格)** を 1 つ提示し、「将来 Required Check の主役になる世界」(Path A/B = Check Run Agents) を概念紹介する (R11 = preview / 未公開)。
> 3. **§3 Appendix workflow Required = 任意発展 (E11-Workflow-Advanced)** = Step 4 で書いた `triage-issue.md` を **そのまま** PR Required Status Check 化することは **trigger model の都合で設計上できない** (`issues.opened` / `workflow_dispatch` は PR check として成立しない) ため、別 `pull_request` trigger workflow template (`templates/pr-required-check.yml`) を任意で紹介する。

> [!NOTE]
> **用語の混同に注意 (D09-9 / Important 5)**: 本 Step は **2 つの merge gate 経路** を扱います。明確に分離してください。
> - **Required Review Gate** = Branch protection rule の `Require a pull request before merging` + `Required reviewers` で **Copilot Code Review** を必須化する経路 (= 本 Step 6a の主軸、**Reviews 経路**)
> - **Required Status Check** = Branch protection rule の `Require status checks to pass before merging` で **GitHub Actions workflow** を必須化する経路 (= §3 Appendix の任意発展、**Status Checks 経路**)
> 2 つは Branch protection UI の **別欄** で設定する別機能です。本 Step では **Required Review Gate を主軸** とします。

> [!NOTE]
> **この Step は M4 (= content-complete フルバージョン) の達成 Step** です。Step 6a を完走すれば 6 / 7 step 必須が完走、Step 6b appendix を読み終わると 7 / 7 step + 任意 1 step (Step 5) が完走可能になります。

---

## 1. 学習目標 (Learning Objectives)

このステップを終えると、以下を **自分の言葉で説明** できるようになります:

- **Required Review Gate vs Required Status Check の違い**: Branch protection の `Required reviewers` field で Copilot Code Review を identity として追加する **Reviews 経路** と、`Required status checks` field で GitHub Actions workflow を追加する **Status Checks 経路** の役割分担を区別できる。
- **Trust thread Layer 4→5/6 の接続**: Step 3 (sandbox egress) → Step 4 (`safe-outputs`) → Step 6a (branch protection) → Step 6b (custom agent persona) と続く **層を成すガードレール** の設計意図を、§3.E の 4 行表で説明できる。
- **Copilot Code Review を Required Reviewer 化する手順**: playground repo Settings → Branches (or Rulesets) → Add rule → `Require a pull request before merging` + `Required reviewers` に `Copilot` identity を追加 → 実 PR で Required Review Gate が表示される確認、を順に再現できる。
- **`.agent.md` Custom Agent の最小形**: `name` / `description` / `tools: [read, search]` のみで読み取り専用のレビュアー人格を定義でき、`@code-reviewer` mention で invoke できる。**`edit` / `shell` / broad write tool は Required Check に出す `.agent.md` には含めない** (Group D negative gate = Important 7、安全性原則)。
- **plan / permission completion matrix (D09-11)**: 自分の **GitHub plan** (Free / Pro / Team / Enterprise) と **Copilot plan** (Pro / Pro+ / Business / Enterprise) と **org policy** に応じて、Full / Pro-Pro / Free / Degraded / Workflow-Advanced のどの完走 path が利用可能かを §4 で判定できる。
- **R11 = `.agent.md` Path A/B preview / 未公開** の現状: 直接 PR の Required Check として `.agent.md` を登録する Path A (Check Run Agents) / Path B (Actions wrapper) は **2026-04 時点では未公開**。Step 6b は「将来この姿になる」概念紹介に留めることを §3.G で確認する。

---

## 2. 前提 (Prerequisites)

- [Step 4](../step-4-automate/) を **full / minimum どちらでも完走** していること、または `step-4-complete` ブランチで飛んできていること (Step 5 は任意のため未完走でも OK)。
- 自分の **playground repo** が public + GitHub Actions 有効 (Step 4 と同じ前提を継承、D14 制約 = workshop repo に branch protection を設定しないこと = Q4 learner_playground)。
- **playground preflight**: workshop repo ではなく playground repo の clone 上にいることを確認:
  ```bash
  pwd && git remote -v
  # → /workspaces/<your-playground-repo> + origin = https://github.com/<you>/<playground>.git
  ```
- 学習者前提 **P12** ([`prerequisites.md`](../prerequisites.md)): GitHub plan (Branch protection 利用可) と Copilot plan (Code Review 利用可) を分けて確認 + Repo Admin 権限 + org policy 影響なし + playground repo 推奨。

### 2.1 UI verification block (Step 6 = UI-only Step、4 項目 U1-U4)

> **★ master-plan §4.5.3 訂正 (Phase 09)**: Step 6 は **MCP server を利用しない UI-only Step** です。Step 0 のような MCP verification block (V1-V4) ではなく、以下 4 項目の **UI verification block (U1-U4)** を完走前に必ず満たしてください (D09-12)。

| # | 項目 | 確認方法 (Web UI) | 失敗時の状態 |
|---|---|---|---|
| **U1** | **Repo Admin 権限あり** (P12 (b)) | playground repo `Settings → Code and automation → Branches` (or `Settings → Rules → Rulesets`) を開けること | 開けない場合 = Repo Admin でない → Repo owner に依頼 or 別 playground repo を fork |
| **U2** | **Copilot Code Review setting visible** (P12 (c)(d)) | playground repo `Settings → Code & automation → Copilot → Code Review` で setting が **`Enabled`** または **`Disabled`** (= 編集可能) として visible (`Disabled by policy` / `Not available on your plan` = degraded path 誘導) | `Disabled by policy` = org policy 制限 → §4 plan/permission matrix で degraded path へ / `Not available on your plan` = Copilot plan 不足 → degraded path |
| **U3** | **Branch protection rule editable** (P12 (a)) | `Settings → Branches → Add branch protection rule` ボタン (or `Rulesets → New ruleset`) が押下可 | 押下できない場合 = 権限不足 (U1 失敗の派生) |
| **U4** | **Required reviewer setting visible** | U3 で開いた rule 編集画面で `Require a pull request before merging` + `Required reviewers` field が visible | 表示されない = GitHub plan 制限 (Free + Private 等) → playground を public 化 or §4 degraded path |

**canonical UI labels semantic anchor**: `docs/planning/VERSIONS.md §10` 参照 (Branches 経路 / Rulesets 経路の両表記、UI drift watch 含む)。

---

## 3. 手順 (Walkthrough)

### 3.A 前提整理 + UI verification (~3 分、E11-Setup)

1. §2 / §2.1 の UI verification block U1-U4 をすべて満たすことを確認。
2. **§4 plan / permission completion matrix** で自分が Full / Pro-Pro / Free / Degraded / Workflow-Advanced のどの path に該当するかを判定。
3. (Degraded path の場合) §4 の degraded 完走条件 (screenshot / docs trace / setting availability check を §10.3 RESULT block 同型で記録) を確認してから §3.B に進む。
4. (Full / Pro-Pro / Free path の場合) このまま §3.B に進む。

> [!IMPORTANT]
> **GitHub plan vs Copilot plan を混同しない (Important 12 / P12)**: Branch protection は **GitHub plan** (Free でも Public repo なら OK)、Copilot Code Review は **Copilot plan** (Pro 単体でも OK、Cloud Agent と異なり Pro+ 縛りなし、F19 と区別)。**(b) Repo Admin** と **(d) org policy** は独立。

### 3.B Branch protection rule を作成する (~3 分、E11-Minimum 前段)

1. playground repo の **`Settings → Branches`** (or `Settings → Rules → Rulesets`) を開く。
2. **`Add branch protection rule`** (Branches 経路) または **`New ruleset`** (Rulesets 経路) をクリック。
   - 両経路は **同じ機能の別 UI** (canonical labels semantic anchor = `docs/planning/VERSIONS.md §10.1`)。本 Step ではどちらでも OK。
3. **`Branch name pattern`** (Branches) または **`Target branches`** (Rulesets) に **`main`** を入力。
4. (まだ rule 自体は保存しない、§3.C で `Required reviewers` を追加してから保存)。

> [!NOTE]
> **UI drift watch (R09-1)**: GitHub UI は時期によって `Branches and tags` → `Branches` → `Rulesets` と表記変更があり得ます。本 Step が将来の UI 変更で動かなくなった場合、`docs/planning/VERSIONS.md §10.1` の semantic anchor 表で再確認してください (Phase 11 dogfooding で実機再 pin)。

### 3.C Copilot Code Review を Required Reviewer 化する (~4 分、E11-Minimum 主役)

1. §3.B で開いた rule 編集画面で、**`Require a pull request before merging`** (現行 UI) または `Require pull request reviews before merging` (旧表記) checkbox を ON。
2. **`Required reviewers`** (現行) または `Required approving reviewers` (旧表記) field を有効化、数値 = `1` に設定。
3. **`Required reviewers` の picker** に **`Copilot`** identity を追加 (UI で `Copilot` / `GitHub Copilot Code Review` として表示される、canonical labels = `docs/planning/VERSIONS.md §10.1` row 6)。
4. **`Create`** / **`Save changes`** をクリックして rule を保存。

> [!IMPORTANT]
> **「Copilot Code Review は Status Check ではない」 (D09-9 / Important 5 / Group D negative gate)**: §3.C で設定したのは **Required Review Gate** (Reviews 経路) です。Branch protection の `Require status checks to pass before merging` field (= Status Checks 経路) には Copilot Code Review は出てきません (= 別経路)。Status Checks 経路で workflow を Required 化したい場合は **§3 Appendix B (E11-Workflow-Advanced)** を参照。

### 3.D 実機 PR を作って Required Review Gate を観察する (~3 分、E11-Minimum 完了)

1. playground repo で適当な branch を切る:
   ```bash
   git checkout -b try-required-review
   echo "// trivial change" >> README.md
   git add README.md && git commit -m "chore: trigger required review"
   git push -u origin try-required-review
   ```
2. PR を作成 (`gh pr create --base main --head try-required-review --title "Try Required Review Gate" --body "Step 6a verification"`)。
3. PR ページで **`Reviewers` 欄に `Copilot` が自動的にリクエスト**されている (= §3.C の Required Reviewer 設定が効いている) ことを確認。
4. Copilot Code Review が走り、PR の Conversation tab に review コメントが投稿されるのを待つ (~1-2 分)。
5. PR 上部の merge box で **`Merging is blocked` + `Required review from GitHub Copilot Code Review`** (またはこれと同等のメッセージ) が表示されること = **Required Review Gate が満たされていない (`not satisfied`) 状態** を確認。
6. ここまで観察できたら **Step 6a minimum complete** (= E11-Minimum)。

#### 3.D.full (任意) — `satisfied` 状態まで観察する (E11-Full)

7. Copilot Code Review がレビューを完了し、自動で `Approved` (or `Commented`) の判定を出した場合、PR の merge box が **`All required reviewers have reviewed`** (= `satisfied`) に切り替わる。
8. **両状態 (`not satisfied` / `satisfied`)** を観察できたら **Step 6a full complete** (= E11-Full)。merge は学習目的なので **行わなくて OK** (PR は close してもよい)。

> [!NOTE]
> **`not satisfied` だけでも Step 6a 完走です**: Copilot Code Review が `Approved` を出さない場合 (= 改善提案がある場合) でも、Required Review Gate が **どのような UI で merge を blocking しているか** を観察できれば minimum 完了です。`satisfied` への遷移観察は full complete 条件 (Suggestion 15)、minimum 完了条件には含めません。

### 3.E Trust thread Layer 4→5/6 接続表 (~1 分)

| Step | Layer | 何を制限するか | 失敗時に何が止まるか |
|---|---|---|---|
| Step 3 (Where to Run) | Cloud Agent sandbox (egress default deny) | 外部 HTTP 通信 | Agent が直接 API を叩けない / firewall PR で迂回提案 (R10) |
| Step 4 (Automate) | gh aw `safe-outputs` job boundary | GitHub への書き込み (label / comment / branch / PR) | agentic job が直接 `gh` write を実行できない (Trust thread Layer 4 = strict mode + safe-outputs) |
| **Step 6a (Required Review Gate)** | **branch protection + Required Reviewer** | **PR merge** | **Required Review Gate 未満なら merge できない (Reviews 経路)** |
| Step 6b (Custom Agent persona、R11) | `.agent.md` tools 範囲 (read/search のみ) | review 観点 + tool アクセス | 人間 / Agent が同じ rubric で見る、persona 経由で `edit` / `shell` を呼ばない |

**観察のポイント**: Layer 4 (Step 4) が「何を **書き込めるか**」を絞り、Layer 6a (Step 6) が「**merge できるか**」を絞る。**役割の重ね合わせ** こそが Trust thread の価値であり、どちらか 1 層を外すとガードレールが破綻する。

### 3.F Custom Agent (`.agent.md`) sample を読む (~3 分、Step 6b 主役、light appendix)

1. `content/step-6-gate/agents/code-reviewer.agent.md` (本 step ディレクトリ) を開く。これは **再利用可能なレビュアー人格 (Custom Agent)** の最小形です。
2. **学習者の copy target** = 自分の playground repo の **`.github/agents/code-reviewer.agent.md`** に同じ内容をコピー (`mkdir -p .github/agents && cp <workshop>/content/step-6-gate/agents/code-reviewer.agent.md .github/agents/`)。
3. **invocation path** = Copilot Chat で **`@code-reviewer`** mention を入力すると、定義した persona が応答する (Local invariance、`name: code-reviewer` がそのまま mention 名になる)。
4. **Tools 範囲** = `tools: [read, search]` のみ。**`edit` / `shell` / broad write tool は含めない** (Group D negative gate / Important 7、安全性原則)。

#### 3.F.minimum-sample (canonical sample 1 ファイル分の内容)

```yaml
---
name: code-reviewer
description: Triage 専門レビュアー (Step 6b sample、Required Check には未対応 = Path A/B GA 待ち = R11)
tools: [read, search]
---

You are a triage-focused code reviewer. When invoked via @code-reviewer, you:

1. Read the diff (read tool) and identify changes to triage logic, label vocabulary,
   or workflow `permissions:` / `safe-outputs:` sections.
2. Search (search tool) for related skills (`.github/skills/issue-triage/SKILL.md`)
   and existing workflows (`.github/workflows/triage-issue.md`) for context.
3. Comment on potential mismatches between SKILL.md vocabulary and workflow allowlist.

You MUST NOT propose `edit` or `shell` operations — those require a separate human
review path (Step 6a Required Review Gate).
```

> [!NOTE]
> **`permissions:` field は `.agent.md` に書かない (Group D negative gate)**: GitHub Actions workflow の `permissions:` field とは別物です。`.agent.md` の権限境界は **`tools:` field** で表現します (read / search / edit / shell / ... の許可 list)。`permissions:` を書いても無視される (= 誤解防止)。

### 3.G Path A/B (Check Run Agents) 将来展望 + R11 状況 (~1 分、Step 6b 完了)

> [!NOTE]
> **Not today (R11)**: 2026-04 時点では、`.github/agents/<name>.agent.md` を **直接 PR の Required Check** として登録する機能 (Path A = Check Run Agents) は **preview / 未公開** です。Path B (Actions wrapper で `.agent.md` を起動) も公開 API がありません。Branch protection の Required Status Check picker にも `.agent.md` は出てきません (R11 = master-plan §6 で発動済)。
>
> 本 Step 6b は **「将来この姿になる」概念紹介** に留めます。**今日 Required Check として実機で動くのは Step 6a (Copilot Code Review = Path C) のみ** です。Path A/B の GA 状況は Phase 11 で再確認します (master-plan §6 R11 status note)。

これで **Step 6b appendix 完了** = 学習者は `.agent.md` を **再利用可能なレビュアー人格** として手元に持ち、将来 GA 時に Required Check への切り替え準備ができている状態になります。

---

## 3 Appendix — workflow を Required 化する任意発展 (E11-Workflow-Advanced)

> [!IMPORTANT]
> **Step 4 `triage-issue.md` をそのまま PR Required Status Check 化することは設計上できない (Blocking 2)**: Step 4 で書いた `triage-issue.md` の trigger は **`issues.opened` / `workflow_dispatch`** であり、PR 上で **commit ごとに必ず走る workflow** ではありません。Branch protection の `Required status checks` field は **PR の head commit に対して走った workflow check** を picker から選ぶ仕組みなので、`issues.opened` / `workflow_dispatch` trigger は **picker に出てきません** (= trigger model の不整合)。
>
> 本 Step 6 では Status Checks 経路を **必須完走条件から外し** (E11-Workflow-Advanced は full complete 条件外)、別 `pull_request` trigger workflow を **任意発展** として紹介します。

### Appendix A — 概念整理

- **Required Review Gate** (= Reviews 経路、§3.C) → identity (人 or Copilot Code Review) を Required Reviewer に追加
- **Required Status Check** (= Status Checks 経路、本 Appendix) → workflow check を Required Status Check に追加
- 後者を成立させるには **`pull_request` trigger** で動く workflow が必要 (= `issues.opened` 系は不可)

### Appendix B — `templates/pr-required-check.yml` を試す (任意)

1. `content/step-6-gate/templates/pr-required-check.yml` を開く (= 最小 `pull_request` trigger workflow sample、S09-2 弱化版)。
2. 自分の playground repo の `.github/workflows/pr-required-check.yml` にコピー + push。
3. 適当な PR を立てて、Actions tab で `pr-required-check` job が走ることを確認。
4. `Settings → Branches → <既存 main rule>` を編集 → `Require status checks to pass before merging` を ON → `pr-required-check` を picker から選択 → 保存。
5. 別の PR を立てて `pr-required-check` が **Required Status Check として表示**されることを確認 = **E11-Workflow-Advanced complete**。

> [!NOTE]
> **本 Appendix は任意発展 (full complete 条件外)**: §3 (3.A-3.G) のみで Step 6 完走条件 (E11-Setup + E11-Minimum + (任意で E11-Full) + E11-Degraded + Step 6b appendix) は満たします。Appendix B はオフラインで自学する人向け、または Step 4 workflow を **後日 PR check 化** したい人向けです。

---

## 4. 4 状態 done + plan / permission completion matrix

### 4.1 4 状態 done (D09-7 / E11-* marker)

| 状態 | E11 marker | 完了条件 |
|---|---|---|
| **Setup ready** | E11-Setup | UI verification block U1-U4 すべて PASS (§2.1 / §3.A) |
| **Step 6a minimum complete** | E11-Minimum | Required Reviewer に `Copilot` 追加 + 1 PR で Required Review Gate (`not satisfied` または `satisfied` UI) を観察 (§3.C / §3.D) |
| **Step 6a full complete** | E11-Full | `not satisfied` / `satisfied` の **両状態** を観察 (§3.D.full、Suggestion 15 = full complete に分離) |
| **Step 6b complete** | (no E11-marker、appendix) | `.agent.md` sample 読了 + Path A/B "Not today" box 確認 (§3.F / §3.G) |

**最低完了条件 (= "Step 6 完走" の必要十分)**: **Setup ready + (Step 6a minimum complete または degraded path に到達) + Step 6b complete**。Step 6a full complete は推奨。

### 4.2 Plan / permission completion matrix (D09-11 / Blocking 3)

| Path | GitHub plan | Copilot plan | org policy | 完走条件 | E11 marker |
|---|---|---|---|---|---|
| **Full path** | Pro / Team / Enterprise (private 含む) or Free + Public | Pro+ / Business / Enterprise | 制限なし | §3.A→3.G 全完走 + §3.D.full 両状態観察 | E11-Setup + E11-Minimum + E11-Full + Step 6b complete |
| **Pro-Pro path** | 上記いずれか | **Copilot Pro 単体** | 制限なし | §3.A→3.G 全完走 (Cloud Agent と異なり Pro 単体でも Code Review 利用可、F19 と区別) | E11-Setup + E11-Minimum + (任意 E11-Full) + Step 6b complete |
| **Free path** | Free + Public playground | Pro / Pro+ / Business / Enterprise | 制限なし | §3.A→3.G 全完走 (Branch protection は Public repo なら Free でも利用可) | E11-Setup + E11-Minimum + (任意 E11-Full) + Step 6b complete |
| **Degraded path** | Free + Private (Branch protection 不可) または **Copilot Code Review が org policy で disabled** | — | (disabled or 制限) | §3.A で **U2 / U3 / U4 のいずれかで失敗** → screenshot / docs trace / setting availability check を README §5 RESULT block に記録 → §3.E / §3.F / §3.G に概念だけ進む | E11-Setup partial + **E11-Degraded** (Phase 06 "Pro plan degraded complete" pattern 継承) + Step 6b complete |
| **Workflow-Advanced path** | Full / Pro-Pro / Free のいずれか | (上記いずれか) | 制限なし | 上記 path のいずれかを完走後、§3 Appendix B を完走 | (上記いずれか) + **E11-Workflow-Advanced** (full complete 条件外、任意上積み) |

> [!IMPORTANT]
> **Degraded path は降格ではなく正規完走 path** (Phase 06 §3.C で確立した pattern を Phase 09 に継承): U2 / U3 / U4 のいずれかが UI 制限で開けない場合でも、screenshot や docs trace を README §5 に記録すれば **degraded complete として正規に Step 6 完走** とみなします。Step 7 (= シナリオ完走) に進んで OK。

---

## 5. RESULT block (degraded path 用) + Troubleshooting

### 5.1 RESULT block テンプレート (Degraded path 該当者のみ)

§3.A で degraded 判定された方は、以下を自分の自学ノート (workshop repo には push しない) に記録してください:

```markdown
## Step 6 — Degraded path RESULT (date: YYYY-MM-DD)

- **U1 (Repo Admin)**: PASS / FAIL (理由)
- **U2 (Copilot Code Review setting visible)**: `Enabled` / `Disabled` / `Disabled by policy` / `Not available on your plan`
- **U3 (Branch protection rule editable)**: PASS / FAIL (理由)
- **U4 (Required reviewer setting visible)**: PASS / FAIL (理由)
- **どの path が利用可能だったか**: Full / Pro-Pro / Free / **Degraded**
- **Degraded の理由 (1 行)**: 例) "Copilot Code Review setting が `Disabled by policy` (org が policy で禁止)"
- **代替手段**: §3.E 接続表の概念理解 + §3.F の `.agent.md` sample 読解 で完走扱い
- **screenshot 添付**: U2 / U3 / U4 のうち失敗した項目の Settings 画面 screenshot (or docs trace コピペ)
```

### 5.2 Troubleshooting

| 症状 | 対処 |
|---|---|
| `Settings → Branches` が見つからない / Add ボタンが押せない | **U1 / U3 失敗** = Repo Admin 権限なし。playground repo を別途 fork して owner になる、または Repo owner に Admin 権限を依頼 |
| `Required reviewers` field が出ない | **U4 失敗** = GitHub plan 制限 (Free + Private 等)。playground を **public 化** (Settings → General → Danger Zone → Change visibility) すれば Free でも OK (= Free path) |
| `Required reviewers` picker に `Copilot` が出ない | **U2 失敗** = Copilot Code Review が org policy で disabled、または Copilot plan 不足。§4 Degraded path へ |
| Copilot Code Review が PR で走らない (= Reviewers 欄に Copilot が自動 add されない) | (a) §3.C で `Required reviewers` に `Copilot` を追加し直し (b) playground repo Settings → Copilot → Code Review が `Enabled` か再確認 (c) PR の base branch が rule の `Branch name pattern` と一致するか確認 (`main` 固定) |
| `Required Review Gate` の merge box が表示されない | (a) PR が `Draft` 状態だと merge box が違う表示になる場合あり → `Ready for review` に変更 (b) Branch protection rule 自体が無効化 (`Active` checkbox OFF) になっていないか確認 |
| `pr-required-check` workflow が Status Check picker に出ない (Appendix B) | 1 度も走っていない workflow は picker に出ない。先に PR を立てて 1 回 workflow を走らせてから picker を再表示 |
| **Required Review Gate ≠ Required Status Check の混同** (D09-9) | §3.C 冒頭 IMPORTANT 再読、§3 Appendix A の概念整理表を参照。Reviews 経路と Status Checks 経路は **Branch protection UI の別欄** で別機能 |

### 5.3 R11 / Path A/B 進捗確認の習慣 (Phase 11 申し送り)

`.github/agents/<name>.agent.md` の **直接 Required Check 化** は preview / 未公開のため、**Phase 11 dogfooding** で再確認します。学習者側でも GitHub Copilot release notes (`Copilot Code Review` / `Custom Agents` / `Check Run Agents`) を時々 watch する習慣を推奨。

---

## 6. Recap (このステップで何を達成したか)

- [x] **Required Review Gate** を Branch protection + Copilot Code Review identity で構築 (= Trust thread Layer 6)
- [x] **`not satisfied`** (任意で `satisfied` も) UI を実機 PR で観察
- [x] **Required Review Gate ≠ Required Status Check** の混同抑止 (Reviews 経路 vs Status Checks 経路)
- [x] **Trust thread Layer 4→5/6 接続表** で「層を成すガードレール」設計を理解
- [x] **`.agent.md` Custom Agent sample** を入手 + `@code-reviewer` invocation path 確認 (read/search のみ、`edit`/`shell`/broad write 禁止)
- [x] **R11 = Path A/B (Check Run Agents) preview / 未公開** 状況の理解 ("Not today" box)
- [x] **plan / permission completion matrix** (Full / Pro-Pro / Free / Degraded / Workflow-Advanced) で自分が利用できた path を判定

> [!IMPORTANT]
> **🎉 シナリオ完走 (M4 = content-complete フルバージョン)**: Step 0 → Step 1 → Step 2 (= keynote CTA) → Step 3 → Step 4 → Step 5 (任意) → Step 6 まで踏破して、6 層 Agentic Platform の **end-to-end 体験を完了** しました。次は実プロジェクトに **issue-triage skill + triage-issue.md workflow + Required Review Gate** を持ち込んで運用してみてください。

---

## 7. 録画 / 補助コンテンツ (後続 Phase で提供予定)

- 録画 placeholder: [`recordings/README.md`](./recordings/README.md) (後続 Phase (Phase 11 以降) で実コンテンツ収録予定、本 Step は内部 placeholder file で broken link 化を防止 = D09-13 / Suggestion 18 = Phase 08 D08-10 同型)

---

## このあとに進む Step

- 完了したら **シナリオ完走 + M4 = content-complete 達成** 🎊
- M5 (= 公開リリース版) 達成は Phase 11 以降 (録画 / dry-run / release hardening の 3 軸) で (master-plan §11.5 / phase-10-scenario-finish.md §11.5 参照)。
