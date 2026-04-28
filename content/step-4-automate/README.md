# Step 4 — Automate (gh aw で Issue opened を gate にして自動起動)

> **必須 Step (MUST、Standard / Full プロファイル)** ・ 対応 Layer: **Layer 4 (gh aw / Agentic Workflows)** ・ 体感 ~25-35 分 (happy path で ~20-25 分)

> **このステップで何が起きるか (3 行)**
> 1. Step 3 までは「**人** が `@copilot` Issue assignee で **手動起動**」だった。Step 4 は **`gh aw` workflow が `Issue opened` イベントを gate にして triage を自動起動** する状態を作る (= **イベント駆動 triage**)。
> 2. **strict mode + safe-outputs** = エージェント (= agentic job) には `permissions: contents: read` だけを与え、`safe_outputs` job だけが Issue に label / comment を書き戻す。**エージェントに直接書き込み権限を渡さない** Trust thread の **別表現** を体感する。
> 3. `workflow_dispatch.inputs.issue_number` を併記したテンプレで「**任意の Issue 番号に対して triage workflow を手動再実行 (specific issue re-run)**」する運用 entrypoint も併せて手に入れる。

> [!IMPORTANT]
> **Trust thread (この旅の縦糸 — Step 4 編)** — Step 3 では Cloud Agent sandbox の **firewall default deny** を観察した。Step 4 では別の guardrail として、**`gh aw` strict mode が agentic job に `permissions: write` を渡さず、`safe_outputs` job だけが label / comment を書き戻す**。どちらも **「エージェントに直接書き込み権限を渡さない」** という Trust thread の **別表現** であり、Step 6a (Required Review Gate) の **「人間が最後に判断する」** へ直結します。

---

## 1. 学習目標 (Learning Objectives)

このステップを終えると、以下を **自分の言葉で説明** できるようになります:

- **手動起動 → 自動起動 (イベント駆動 triage)** の境界が `gh aw` workflow の `on: issues.opened` で表現される。Step 3 の "Issue Assignees に `@copilot` を追加" とは別の triggering 概念。
- **strict mode + safe-outputs ガードレール** = agentic job (= Copilot CLI engine が走る job) には `permissions: contents: read` のみ、`safe_outputs` job だけが label / comment を書き戻す。
- **`safe-outputs.add-labels.allowed:` allowlist** が agent の生出力を制限する canonical 仕組み (= "agent が好き勝手に label を作れない")。
- **`workflow_dispatch.inputs.issue_number` 併記**で **specific issue re-run** が可能になり、demo 再現性 + 運用 entrypoint が手に入る。
- **PAT (Resource owner=個人 / Repository access=Public Repositories (read-only) / Permissions=Copilot Requests=Read-only)** = `COPILOT_GITHUB_TOKEN` 専用の "秘伝の手順"。間違えると `Copilot Requests` permission が UI に出ず詰む。
- **gh-aw runtime verification 4 項目** (= `gh aw version` / `compile` / `.lock.yml` / secret) = Step 4 固有の preflight (Step 0 / Step 6 で扱う VS Code MCP V1-V4 とは別軸)。
- **Copilot CLI engine が Actions runner 上で server-side triage を実行**する世界観 (Pro 単体プランの方も Cloud Agent UI を経由せず本 Step を full 完走できる)。

---

## 2. 前提 (Prerequisites)

- [Step 3](../step-3-surfaces/) を完走していること、または `step-3-complete` ブランチで飛んできていること。
- 自分の **playground repo の default branch** に `.github/skills/issue-triage/SKILL.md` が push 済 (Step 3 §2 と同じ verify):
  ```bash
  gh api repos/<owner>/<repo>/contents/.github/skills/issue-triage/SKILL.md --jq .name
  ```
- playground repo は **public + GitHub Actions 有効 + clean repo 推奨** (Step 3 §2 と同じ前提を継承)。
- **playground preflight (重要)**: 以下を Codespaces ターミナルで実行し、**workshop repo ではなく playground repo の clone 上にいること** を確認してください:
  ```bash
  pwd && git remote -v
  # → /workspaces/<your-playground-repo> + origin = https://github.com/<you>/<playground>.git
  ```
- fine-grained PAT を **作成可能な状態** にしてあること (Settings → Developer settings → Personal access tokens → Fine-grained tokens にアクセス可能)。
- Copilot プラン: **Copilot Pro / Pro+ / Business / Enterprise のいずれか**。
  - Pro 単体プランの方も、本 Step は **Copilot CLI engine が Actions runner 上で動く** ため **full 完走可能** (Cloud Agent UI = Issue assignee は不要)。
  - Step 3 §3.C を Pro plan で degraded complete (= screenshot 代替) で完走した方は、**Step 4 §3.D で初めて Copilot CLI engine 由来の server-side triage を実機体験** することになります。
- `gh aw` CLI が install 済 (`gh aw version` で `v0.68.3` を確認、devcontainer 既定済)。
- 学習者前提 **P2 / P3 / P10** ([`prerequisites.md`](../prerequisites.md)) を理解していること:
  - **P2** = PAT 要件 1 行サマリ
  - **P3** = PAT 作成後の sanity check スニペット
  - **P10** = `COPILOT_GITHUB_TOKEN` 登録経路 4 種 (UI / `gh aw secrets set` / `gh aw secrets bootstrap` / `gh secret set`)

> [!NOTE]
> **gh-aw runtime verification block** (= Step 4 固有の preflight、Step 0 / Step 6 で扱う VS Code MCP V1-V4 とは別軸)。§3 に進む前に以下 4 項目が揃っていることを順次確認します。各項目はこの後の §3.A〜§3.C の中で自然に達成されます。
>
> | 項目 | 確認方法 | 失敗時の対処 |
> |---|---|---|
> | **V1' gh aw version** | `gh aw version` → `v0.68.3` を確認 | バージョン不一致 → §5 Troubleshooting |
> | **V2' gh aw compile** | (workflow 編集後) `gh aw compile` でエラーなし | strict mode error → §3.C Step 3 で safe-outputs 追加 |
> | **V3' .lock.yml diff folded** | GitHub UI で `triage-issue.lock.yml` の diff が折りたたまれる | `.gitattributes` 未設定 → §3.C 末尾 NOTE |
> | **V4' COPILOT_GITHUB_TOKEN 登録** | `gh secret list` で `COPILOT_GITHUB_TOKEN` が表示される | 未登録 → §3.B Step 3 |

> [!NOTE]
> **Memory bootstrap (escape hatch で飛んできた場合)** — `step-3-complete` ブランチで飛んできた / Codespace を作り直した場合、Memory は **空** から始まります。Step 4 は **Memory に依存しない** ので Memory が空でも問題なく完走できます。Memory も再現したい場合は [Step 1 §3.A](../step-1-memory/#3a-植え付け--copilot-にリポ慣習を覚えさせる) を参照してください。

---

## 3. 手順 (Steps)

6 つの sub-step (A → B → C → D → E → F) で進めます。**§3.A〜§3.C で setup と workflow を確定** し、**§3.D で自動起動を実機観察**、**§3.E で specific issue re-run** を体感し、**§3.F で 4 surface 比較表** に書き写して持ち帰ります。

### 3.A `gh aw init` で workflow scaffold を生成する

> **目的**: `gh aw init` で Agentic Workflows の **core files 一式** を playground repo に scaffold する。

playground repo の clone 上で:

```bash
gh aw init
```

実行後、以下の **core files** が生成されます (v0.68.3 時点、checklist の全文は [`templates/expected-files.md`](./templates/expected-files.md) 参照):

- `.github/workflows/copilot-setup-steps.yml` — Cloud Agent setup script (gh aw scaffold 版)
- `.github/agents/agentic-workflows.agent.md` — dispatcher agent
- `.github/aw/actions-lock.json` — Actions のバージョン pin
- `.vscode/mcp.json` — playground 側で **新規生成** (workshop repo の既存版とは別物)
- `.gitattributes` — `*.lock.yml linguist-generated=true` が追記される

> [!NOTE]
> 将来 v0.69+ で artifacts が追加されても、上記 core files が揃っていれば本 Step は完走できます (drift 余地)。

> [!NOTE]
> **`.vscode/mcp.json` 衝突対処** — `gh aw init` を **playground repo 上で**実行する限り、新規生成されるだけで衝突は起きません。preflight (`pwd && git remote -v`、§2 参照) で workshop repo でないことを必ず確認してから実行してください。

### 3.B `COPILOT_GITHUB_TOKEN` (PAT) を作成して playground repo に登録する

> **目的**: `gh aw` workflow の Copilot CLI engine が server-side で triage を呼ぶための PAT を作成し、playground repo に `COPILOT_GITHUB_TOKEN` という名前で secret 登録する。

#### Step 1: PAT を作成する (★ "秘伝の手順")

GitHub.com → **Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token** で以下を **そのまま** 設定します:

- **Token name**: 任意 (例: `ghcp-workshop-step4`)
- **Resource owner**: ★ **個人アカウント (組織ではない)** を選ぶこと
- **Repository access**: ★ **Public Repositories (read-only)** を選ぶこと
  - ※ "Selected repositories" や "All repositories" を選ぶと **`Copilot Requests` permission が UI に出てこなくなり詰みます**
- **Permissions** → "Account permissions" を展開:
  - **Copilot Requests**: **Read-only** ★ これが本 Step の核
- **Generate token** をクリック → 表示された PAT をクリップボードにコピー (1 回しか見られません)

#### Step 2: Sanity check (= PAT が正しくコピーされたか確認)

ターミナルで以下を実行 (`<PASTE_YOUR_PAT>` に貼る):

```bash
TOKEN="<PASTE_YOUR_PAT>"
curl -sH "Authorization: Bearer $TOKEN" https://api.github.com/user | jq .login
```

**自分の GitHub username** が返れば PAT は正しい状態です。`{"message": "Bad credentials", ...}` が返る場合は **コピーミス** = Step 1 からやり直してください。

#### Step 3: `COPILOT_GITHUB_TOKEN` を playground repo に登録する

playground repo にいることを再確認:

```bash
gh repo view --json nameWithOwner --jq .nameWithOwner
# → <you>/<playground> が表示されること
```

登録経路は環境別に **以下の優先順** で選んでください:

| 順位 | 環境 | コマンド |
|---|---|---|
| ① | **Codespaces (推奨)** | GitHub.com で対象 playground repo の **Settings → Secrets and variables → Actions → New repository secret** から `COPILOT_GITHUB_TOKEN` という名前で Step 1 の PAT を貼り付ける |
| ② | ローカル CLI shortcut | `gh aw secrets set COPILOT_GITHUB_TOKEN --value "$TOKEN"` |
| ③ | fallback | `gh secret set COPILOT_GITHUB_TOKEN -R <owner>/<playground>` |
| ④ | diagnostic | `gh aw secrets bootstrap` (既存 secret の不足を check) |

登録確認 (= V4' 緑化):

```bash
gh secret list
# → COPILOT_GITHUB_TOKEN 行が表示されれば OK
```

> [!IMPORTANT]
> 登録先は **必ず playground repo** です (workshop repo に登録しても workflow は playground 側で動くため意味がありません)。

### 3.C `triage-issue.md` を書く — strict mode を **わざと** 失敗させて safe-outputs 必須化を体感する

> **目的**: 教材の中核。`gh aw` strict mode の意図を **失敗 → 修正の流れ** で体感し、`safe-outputs` がエージェントの書き込み経路を制御する Trust thread Layer 4 ガードレールであることを腹落ちさせる。

> [!IMPORTANT]
> このステップは **わざと一度失敗させます**。教材ミスではなく **Trust thread Layer 4 を体感するための演習** です。**`gh aw compile` が PASS するまで `git add / commit / push` してはいけません** (= **compile-before-commit 原則**)。

#### Step 1: `permissions: issues: write` を入れた状態で書く (★ あえて strict mode 違反)

`.github/workflows/triage-issue.md` を新規作成し、以下の "悪い例" を貼ります (canonical sample との差分は `permissions:` の `issues: write` 行):

<!-- step4-demo-fail-start -->
```yaml
---
on:
  issues:
    types: [opened]
permissions:
  contents: read
  issues: write          # ★ わざとこれを入れる
safe-outputs:
  add-labels:
    allowed: [bug, enhancement, question, documentation]
---

You are a triage agent. Read the issue body and ...
```
<!-- step4-demo-fail-end -->

ここで `git status --short` を実行すると、`triage-issue.md` だけが untracked / modified に出ているはずです。**まだ `git add` しないでください** — `gh aw compile` が失敗することを観察するのが目的です。

```bash
git status --short
# → ?? .github/workflows/triage-issue.md
```

#### Step 2: `gh aw compile` を実行 → strict mode error

```bash
gh aw compile
```

すると以下のような error が出ます (E3 RESULT §3 で実観測した実文言):

```
strict mode: write permission 'issues: write' is not allowed for security reasons.
Use 'safe-outputs.create-issue', 'safe-outputs.create-pull-request',
'safe-outputs.add-comment', or 'safe-outputs.update-issue' to perform write operations safely.
```

**この失敗が `safe-outputs` 必須化の正体です。** agentic job (= Copilot CLI engine が走る job) には `permissions: write` 系を一切渡せず、書き込みは別途 `safe_outputs` job だけが担う設計を strict mode が強制しています。

#### Step 3: 修正する (= `permissions: issues: write` を削除、safe-outputs に集約)

正しい canonical sample は [`templates/triage-issue.md`](./templates/triage-issue.md) にあります。`triage-issue.md` を以下の状態に上書きしてください:

<!-- step4-final-workflow-start -->
```yaml
---
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
  issues: read              # ★ read は OK (write ではないので strict mode 違反ではない)
safe-outputs:
  add-labels:
    allowed: [bug, enhancement, question, documentation]
    target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
  add-comment:
    target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
---

You are a triage agent for an open-source repository.

When invoked, you will triage an issue. There are TWO trigger paths:

1. `on: issues.opened` — the new issue's full payload (title, body) is
   available in the event context.
2. `on: workflow_dispatch` with `inputs.issue_number` — only the issue
   number is provided. You MUST read that issue from the **current
   repository** (using the `issues: read` permission) before classifying it.
   **Do not classify from the issue number alone.**

Then: classify the issue into exactly ONE of the allowed labels
(`bug` / `enhancement` / `question` / `documentation`) and post a brief
comment that **references concrete content from the issue's title or body**
(so it is clear you read the issue, not just labeled it from the number).
```
<!-- step4-final-workflow-end -->

> [!NOTE]
> `permissions: issues: read` は **read** なので strict mode 違反ではありません。`workflow_dispatch` 経由で起動した場合に agent が指定 Issue を読むために **必須** です。詳細は [`templates/triage-issue.md`](./templates/triage-issue.md) のヘッダコメント参照。

#### Step 4: `gh aw compile` 再実行 → PASS

```bash
gh aw compile
# → error が消え、.github/workflows/triage-issue.lock.yml が生成される
```

成功を `git status --short` で確認:

```bash
git status --short
# → ?? .github/workflows/triage-issue.md
# → ?? .github/workflows/triage-issue.lock.yml
# → (gh aw init 後の core files も並ぶ)
```

#### Step 5: PASS を確認してから初めて commit + push

```bash
git add .github .vscode .gitattributes
git commit -m "feat: add triage-issue workflow"
git push origin main
```

> [!NOTE]
> **`.lock.yml` の diff (~63 KB)** が GitHub UI で巨大に見えても、`.gitattributes` の `*.lock.yml linguist-generated=true` で diff は **自動で折りたたまれます** (= V3' verification 項目)。

### 3.D Issue opened で workflow が **自動起動** する瞬間を観察する

> **目的**: 「Issue が開かれた瞬間」をトリガに workflow が自動起動し、約 3 分後に Issue に label / comment が **safe_outputs job 経由で** 書き戻されることを実機確認する。

#### Step 1: (preflight) playground repo に default labels が揃っているか確認

```bash
gh label list --limit 100 | grep -E '^(bug|enhancement|question|documentation)\b'
```

4 行表示されれば OK。足りない場合は `gh label create documentation --color 0075ca` のように作成してください (canonical sample の `allowed:` allowlist と完全一致が必要)。

#### Step 2: テスト用 Issue を立てる

playground repo の Issues タブで新規 Issue を作成 (本文は数行で OK、例: `Title: Login button is broken on mobile / Body: Tapping the login button does nothing on iOS Safari.`)。

#### Step 3: Actions タブで workflow run を観察

Actions タブを開き、`Triage Issue` workflow が **自動起動** していることを確認 (= 「自動起動 / イベント駆動 triage」)。

run 全体は **6 job** で構成されます (gh aw v0.68.3 時点、E3 RESULT §8.4):

| Job | 役割 | 期待結果 |
|---|---|---|
| `pre_activation` | gh aw が trigger condition を再評価 | SUCCESS |
| `activation` | agentic job 起動準備 (env / secret 解決) | SUCCESS |
| `agent` | ★ **Copilot CLI engine が triage prompt を実行 (~1m20s)** | SUCCESS |
| `detection` | ★ **safe-outputs の出力候補を検査 (~50s)** | SUCCESS |
| `safe_outputs` | ★ **allowlist 内の label を Issue に付与 + comment 投稿 (~10s)** | SUCCESS |
| `conclusion` | run 全体の最終結果集約 | SUCCESS |

**run 全体 SUCCESS** + **主要観察対象 3 job** (★印 = `agent` / `detection` / `safe_outputs`) **全 SUCCESS** + Issue に **label 1 件** + **Copilot 由来の comment 1 件** が付いていれば PASS (合計 約 3 分、E3 RESULT §8.4 ベース)。

> [!NOTE]
> `pre_activation` / `activation` / `conclusion` は gh-aw runtime の前後処理 (trigger 再評価 / env-secret 解決 / 結果集約) です。本 Step で学習者が観察すべき **triage 本体 + guardrail 経路** は `agent` (= Copilot CLI engine の triage 実行) → `detection` (= safe-outputs schema 検査) → `safe_outputs` (= label / comment の書き戻し) の **3 job**、と覚えてください。

> [!NOTE]
> **Pro plan 学習者の方** — これが Cloud Agent UI 経由ではなく、**Actions runner 上の Copilot CLI engine が `COPILOT_GITHUB_TOKEN` PAT 経由で server-side triage を実行** している瞬間です。Step 3 §3.C を screenshot 代替で完走した方は、本ステップが **初の Copilot CLI engine 由来 server-side triage 実機体験** になります。

### 3.E `workflow_dispatch -f issue_number=<N>` で **任意の Issue に対して手動再実行** する

> **目的**: 自動起動だけでなく **specific issue re-run の運用 entrypoint** を手に入れる。demo の再現性 + 後日 triage を再走させたいケースに対応。

```bash
# 既存 Issue 番号を 1 つ選ぶ (例: #2)
gh workflow run triage-issue.lock.yml -f issue_number=2

# 起動確認
gh run list --workflow=triage-issue.lock.yml --limit 3
```

§3.D と同じ ~3 分後に、**指定した Issue 番号** (例: #2) に対して新しく label / comment が付与されます。

> [!IMPORTANT]
> **完了確認**: 付与された comment が **指定 Issue (#2) の title / body の具体的な内容に言及している** ことを目視確認してください (例: Issue 本文に "login button" と書いてあれば comment にも "login button" が出てくる)。これにより agent が `permissions: issues: read` で指定 Issue を **読んで** 分類したことが確認できます (= `workflow_dispatch` 経路が機能している証拠、★ canonical template の核心仕様)。

> [!NOTE]
> safe-outputs target = `${{ github.event.issue.number || github.event.inputs.issue_number }}` の **`||` 短絡評価** が、`on: issues.opened` 経路 (= `github.event.issue.number` あり) と `workflow_dispatch` 経路 (= `inputs.issue_number` のみ) の **両方を 1 行で解決** します。

### 3.F 4 surface × 6 観点 — workshop の **最終比較表**

> **目的**: Step 3 で確立した 3 surface (IDE Chat / CLI / Cloud Agent) に **gh aw workflow runner** を加えた **4 surface** を **6 観点** で対比し、「どの surface を、いつ使うか」を持ち帰る。

| 観点 | IDE Chat | Copilot CLI | Cloud Agent | **gh aw workflow runner** |
|---|---|---|---|---|
| ① 実行場所 | Local IDE | Local CLI | GitHub.com sandbox | **Actions runner (gh-aw + Copilot CLI engine)** |
| ② 起動可能にするための公開条件 | workspace に SKILL.md 存在 | current branch に SKILL.md 存在 | default branch に SKILL.md push + Issue Assignees に Copilot 追加 | **default branch に `triage-issue.lock.yml` push + `COPILOT_GITHUB_TOKEN` secret 登録** |
| ③ 観測トレース | `file:///` link (日本語) | `/skills` 出力 (英語) | branch + draft PR | **Actions run UI: 全 6 job + 主要 3 job (`agent` / `detection` / `safe_outputs`) 全 SUCCESS + 最終 Issue label/comment** |
| ④ レイテンシ | 即時 | 即時 | 数十秒〜分 | **約 3 分 (E3 RESULT §8.4)** |
| ⑤ 実行時に agent が読む入力 | workspace ファイル (uncommitted も含む) | current branch のファイル | default branch (pushed) のファイル | **trigger event payload + default branch (pushed) のファイル + workflow input `issue_number` (workflow_dispatch 経由時)** |
| ⑥ 適用シーン | 作業中の対話 | コマンドラインから | 探索的 manual triage | **イベント駆動の定常運用 triage / specific issue re-run** |

§3.D / §3.E で観測した結果を、**この表の最右列に書き写してください** (持ち帰り資料)。

---

## 4. 完了確認 (Done Checklist) — 3 段階

### 4.1 Setup ready (= scaffold + PAT + secret 完了、まだ workflow 未 push)

- [ ] §3.A `gh aw init` で core files (`.github/workflows/copilot-setup-steps.yml` / `.github/agents/agentic-workflows.agent.md` / `.github/aw/actions-lock.json` / `.vscode/mcp.json` / `.gitattributes`) が生成済
- [ ] §3.B Step 2 PAT sanity check `curl -sH "Authorization: Bearer $TOKEN" https://api.github.com/user | jq .login` で **自分の GitHub username** が表示された
- [ ] §3.B Step 3 `gh secret list` の出力に `COPILOT_GITHUB_TOKEN` 行が表示される (= V4' 緑化)
- [ ] §3.C Step 1 で `triage-issue.md` を作成済 (まだ `gh aw compile` PASS していない場合は **minimum 未達**)

### 4.2 Step 4 minimum complete (= **Auto-trigger crossed**) ★ 最低完了

- [ ] §3.C Step 4 で `gh aw compile` が PASS し、`triage-issue.lock.yml` が生成された
- [ ] §3.C Step 5 で workflow + lock + scaffold 全部を `git push origin main` 済
- [ ] §3.D Step 2 で playground repo に新規 Issue を立てた
- [ ] §3.D Step 3 で約 3 分後に **Issue に label 1 件 + Copilot 由来 comment 1 件 が自動付与** されたことを確認 (Actions UI で run 全体 SUCCESS + 主要 3 job `agent` / `detection` / `safe_outputs` 全 SUCCESS)
- [ ] §3.F 比較表の **gh aw workflow runner 列** に観測結果 (label 名 + comment の冒頭 1 行抜粋) を書き写し済

### 4.3 Step 4 full complete (= **Manual-trigger crossed** + 全完走)

- [ ] §3.E で `gh workflow run triage-issue.lock.yml -f issue_number=<N>` を実行した
- [ ] `gh run list --workflow=triage-issue.lock.yml --limit 3` で **dispatch run** が一覧に出る
- [ ] dispatch run が完走し、run 全体 SUCCESS + 主要 3 job 全 SUCCESS
- [ ] 指定 Issue #N に label / comment が付与された
- [ ] 付与された comment が **指定 Issue #N の title / body の具体的な内容に言及している** (= `permissions: issues: read` + dispatch 経路 prompt が機能している証拠)
- [ ] §3.F 比較表 6 観点 × 4 surface を **全部書き終えた**

### Step 4 complete — 4.1 Setup ready + **4.2 Step 4 minimum complete (Auto-trigger crossed)** で達成扱い 🎉  4.3 (Manual-trigger crossed) で full 完走です。

---

## 5. 詰まったら (Troubleshooting)

| 症状 | 原因 / 切り分け | 対処 |
|---|---|---|
| `Bad credentials` が `curl /user` で返る (§3.B Step 2) | PAT コピーミス (空白文字混入など) | §3.B Step 1 から PAT を再作成 |
| `Copilot Requests` permission が UI に出ない (§3.B Step 1) | Repository access が "Selected" / "All" になっている | **Public Repositories (read-only)** に変更 (★ 秘伝の手順) |
| `gh aw compile` で `strict mode: write permission ... is not allowed` (§3.C Step 2) | `permissions:` に `issues: write` 等が入っている | 教材想定通りの失敗。§3.C Step 3 で `safe-outputs` に集約 + `permissions: contents: read` + `issues: read` のみに修正 |
| `.lock.yml` (~63 KB) の diff が巨大に見える (§3.C Step 5) | `.gitattributes` 未適用 | `gh aw init` 時に自動設定済のはず。手動なら `*.lock.yml linguist-generated=true` を `.gitattributes` に追記 |
| 3 分待っても Issue に label / comment が付かない (§3.D) | Actions UI で run 全体を開き、どの job で止まっているか確認 | `agent` failed → `COPILOT_GITHUB_TOKEN` 未設定 / PAT bad credentials / Copilot license 不足 / `detection` failed → agent output が safe-outputs schema に合わない / `safe_outputs` failed → label 不存在 (preflight `gh label list` で確認) / target issue number 不正 |
| `safe_outputs` job だけ failed で label が無いと怒られる (§3.D) | playground repo に default labels が無い (例: `documentation` を消してある) | §3.D Step 1 の `gh label list` preflight に戻って `gh label create documentation --color 0075ca` 等で作成 |
| §3.E dispatch run の comment が Issue 内容に言及していない | `permissions: issues: read` 未設定 / prompt body が dispatch 経路を扱っていない | canonical sample ([`templates/triage-issue.md`](./templates/triage-issue.md)) と完全一致させる |
| `gh aw version` が `v0.68.3` と異なる (V1') | devcontainer のバージョン drift | [VERSIONS.md §1](../../docs/planning/VERSIONS.md) 参照、`gh extension upgrade aw` で揃える |
| GitHub-hosted runner の **Actions minutes / quota** で弾かれる | playground repo が private、または month limit 超過 | playground repo を **public** に切り替え、または self-hosted runner へ逃がす ([Step 3 §5 参照](../step-3-surfaces/#5-詰まったら-troubleshooting) — quota 切れ時のみ) |

---

## 6. 次の Step

進む: **[Step 5 — Multi-engine](../step-5-multi-engine/)** (任意 — 同じ workflow の `engine:` を Copilot CLI / Claude / Codex に切り替えて head-to-head 比較)
または: **[Step 6 — Gate](../step-6-gate/)** (Required Review Gate で Copilot Code Review を merge gate に)

### Step 5 / Step 6a への動機 — 自動起動の次は何か

Step 4 で見たのは:

- **`gh aw` workflow が `Issue opened` を gate にして triage を自動起動** する。
- **strict mode + safe-outputs** が agent の書き込み経路を制御する Trust thread Layer 4 ガードレール。
- **`workflow_dispatch.inputs.issue_number`** で specific issue re-run できる運用 entrypoint。

Step 5 / Step 6a で見るのは:

- **Step 5 (任意)**: `triage-issue.md` の `engine:` を `copilot` → `claude` / `codex` に切り替える **差分のみ** で multi-engine head-to-head 比較。**Step 4 で書いた workflow がそのまま出発点** になる。
- **Step 6a (必須)**: **Required Review Gate** で PR の merge を gate する (Path C = Copilot Code Review = Reviews 経路)。Step 4 = `safe-outputs` がエージェントの **書き込み経路** を制限 / Step 6a = Required Review Gate が PR の **merge 経路** を制限。**Trust thread Layer 4 → Layer 5/6 への接続**。

一覧に戻る: [📚 シナリオ目次](../README.md)

---

## 7. 参考 (References)

- 内部設計根拠: [`docs/planning/00-master-plan.md`](../../docs/planning/00-master-plan.md) §4 (Phase 07) / §4.5.3 (Step 4 = gh-aw runtime Step) / §6 R6 / §6 R9
- Phase 07 計画書 SoT: [`docs/planning/phase-07-step4-automate.md`](../../docs/planning/phase-07-step4-automate.md)
- 検証ログ (gh aw end-to-end PASS、本 Step 教材化の SoT): [`docs/planning/poc/E3-gh-aw/RESULT.md`](../../docs/planning/poc/E3-gh-aw/RESULT.md)
  - §8.2 = all PASS proof
  - §8.4 = ~3 分 elapsed proof (6 job 構成 + 主要 3 job timing)
  - §3 = strict mode proof
  - §5 / §8.3 = PAT 秘伝の手順 proof
- バージョン pin: [`docs/planning/VERSIONS.md`](../../docs/planning/VERSIONS.md) §1 (gh aw v0.68.3) / §4.1 (`triage-issue.md` canonical sample) / §7 (Trust thread ガードレール)
- 学習者前提: [`../prerequisites.md`](../prerequisites.md) P2 / P3 / P10
- canonical template: [`./templates/triage-issue.md`](./templates/triage-issue.md) / [`./templates/expected-files.md`](./templates/expected-files.md)
- 公式: [GitHub Agentic Workflows (gh aw)](https://github.com/githubnext/gh-aw)
