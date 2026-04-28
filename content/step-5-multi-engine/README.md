# Step 5 — Multi-engine (engine 切替: Copilot / Claude / Codex)

> **任意 Step (OPTIONAL、Full プロファイル)** ・ 対応 Layer: **Layer 5 (Agent HQ)** ・ 体感 ~25-35 分 (3 engine head-to-head full 完走時)
>
> **このステップで何が起きるか (3 行)**
> 1. Step 4 で書いた `triage-issue.md` の **`engine` stanza のみ** を `copilot` → `claude` → `codex` に切り替えて、**同じトリガ (`issues.opened`) ・同じ skill 文脈** で複数 LLM の振る舞いを **head-to-head 比較**する。
> 2. **Skill / Workflow は engine 非依存** = `safe-outputs` ガードレール (= Trust thread Layer 4) は engine 横断で維持される ことを **verification target** として観測する (本 Step を抜けた時点で `confirmed` / `partially confirmed` のいずれかに昇格判断、§3.E)。
> 3. **`engine: copilot` baseline 1 engine ぶんを動かせれば minimum done**、3 engine 比較表を埋めれば full done。**API key 不所持なら録画視聴で代替** (後続 Phase で提供予定、§3.F)。

> [!NOTE]
> **この Step は任意です。** スキップしても **keynote CTA (Step 2)** と **Required Review Gate 体感 (Step 6a)** は達成できます。Anthropic / OpenAI API key を持っていない場合や、Premium Request 枠が逼迫している場合は、**録画視聴と比較表テンプレート** (§3.F) で代替できます。Q5 確定: **Pro plan 縛り廃止 = API key 条件のみ追加** (Copilot license + `COPILOT_GITHUB_TOKEN` baseline は Step 4 から継承)。

---

## 1. 学習目標 (Learning Objectives)

このステップを終えると、以下を **自分の言葉で説明** できるようになります:

- **`engine` stanza の役割**: `gh aw` workflow の `engine: copilot` / `engine: claude` / `engine: codex` が **どの LLM が agentic job を走らせるか** を 1 行で切り替える設計上の hinge であり、`on:` / `permissions:` / `safe-outputs:` (= Step 4 で組み立てたガードレール) は engine 非依存で再利用される。
- **engine x secret マトリクス**: `copilot` = `COPILOT_GITHUB_TOKEN` (Step 4 継承) / `claude` = `ANTHROPIC_API_KEY` / `codex` = `OPENAI_API_KEY` (canonical) + `CODEX_API_KEY` (accepted alternative)。**workshop repo に登録しない、必ず playground repo に登録**する Trust thread。
- **観測場所別 4 グループ**で engine 差分を読む: ① **このランで観測** (latency / output style / label-comment / run status) ② **post-run / optional** (各 console の billing/usage visibility) ③ **設計 invariant として inspect** (`safe_outputs` job boundary 維持) ④ **トラブルシュート時のみ** (error mode 例)。
- **Trust thread Layer 4 invariant の verification**: 全 engine で `safe_outputs` job 経由が維持されるか = agent の生出力が直接 GitHub に書かれないか を `.lock.yml` と Actions log で確認。
- **任意 Step だが質量を確保した教材 (Q1 = heavy_full)** = `engine` 切替は Layer 5 (Agent HQ) 体感の core であり、**Step 4 (single engine 自動起動) と Step 5 (head-to-head 比較) の責務分離** を Phase 06 §3.D の `suggestedActors` 観察 (Cloud Agent UI 路線) と区別して理解する。

---

## 2. 前提 (Prerequisites)

- [Step 4](../step-4-automate/) を **full / minimum どちらでも完走** していること、または `step-4-complete` ブランチで飛んできていること。
- 自分の **playground repo の default branch** に Step 4 の `triage-issue.md` + `.lock.yml` が push 済 (Step 4 §3.C と同じ verify):
  ```bash
  gh api repos/<owner>/<repo>/contents/.github/workflows/triage-issue.md --jq .name
  gh api repos/<owner>/<repo>/contents/.github/workflows/triage-issue.lock.yml --jq .name
  ```
- playground repo は **public + GitHub Actions 有効** (Step 4 と同じ前提を継承)。
- **playground preflight**: workshop repo ではなく playground repo の clone 上にいることを確認:
  ```bash
  pwd && git remote -v
  # → /workspaces/<your-playground-repo> + origin = https://github.com/<you>/<playground>.git
  ```
- 学習者前提 **P10 + P11** ([`prerequisites.md`](../prerequisites.md)):
  - **P10** = `COPILOT_GITHUB_TOKEN` 登録 4 経路 (Step 4 から継承、本 Step `engine: copilot` 再走に必須)
  - **P11** = `ANTHROPIC_API_KEY` (Claude) / `OPENAI_API_KEY` (Codex canonical) + `CODEX_API_KEY` (accepted alternative) 登録 4 経路 (本 Step §3.A で確認)

> [!IMPORTANT]
> **API key cost (R08-2)**: Anthropic / OpenAI API key は **利用量に応じて Anthropic Console / OpenAI Platform で請求が発生**します。本 Step は **1 engine 1 invocation で十分** な構成にしてあるので想定外請求は起きにくいですが、各 console の billing/usage visibility (§3.E Group 2) で実測コストを確認してください。**Step 5 は任意なので、未取得でも CTA は達成済**です (録画視聴で代替、§3.F)。

> [!IMPORTANT]
> **`triage-issue.md` の保存** (R08-8): 本 Step では Step 4 で書いた `triage-issue.md` を **engine 切替で複数回 edit + compile + push** します。**Step 4 動作を壊さないため**に以下のいずれかを採択:
> - **方法 A (推奨)**: `triage-issue.md` を engine 別に **コピー** してから edit (`cp triage-issue.md triage-issue-claude.md` など、複数 workflow 並列共存) — 最終 §3.E で全 engine の `.lock.yml` が同時に repo に存在
> - **方法 B**: 同一 `triage-issue.md` の `engine` 行のみ書き換えて再 compile → 直後に invoke → 観測 → 次 engine に書き換え (= シーケンシャル、git diff の世界で head-to-head)
> 
> **Step 4 backward compat (R08-9)**: Step 4 の `triage-issue.md` には `engine:` キーが暗黙 (= `copilot`)。Step 5 で `engine: copilot` を **明示** する書き方に切り替えても **Step 4 の動作は変わらない** (compile 結果同等、`COPILOT_GITHUB_TOKEN` 参照同等)。

> [!NOTE]
> **Trust thread (この旅の縦糸 — Step 5 編)** — Step 4 では `gh aw` strict mode + safe-outputs が **agentic job に write 権限を渡さない** ガードレールであることを体感した。Step 5 では **engine が変わっても `safe_outputs` job 経由が維持されるか** を verification target として inspect します。本 Step を抜けた時点で「engine 横断 invariant」を **`confirmed` (全 engine PASS or Safe-output fail なし) / `partially confirmed` (Safe-output fail 1 engine あり)** に昇格判断します (§3.E)。

---

## 3. 演習 (5 sub-step + 録画 fallback)

> [!NOTE]
> **Done state は 4 段階** (Phase 08 D08-7):
> 1. **Setup ready** = §3.A 完了 (engine 別 secret 登録確認、§3.A の verify が PASS)
> 2. **Step 5 minimum live complete** = §3.B + 最低 1 つの非 Copilot engine (§3.C か §3.D のどちらか) で 1 invoke 成功
> 3. **Step 5 full live complete** = §3.B + §3.C + §3.D + §3.E 比較表記入完了 (3 engine head-to-head)
> 4. **Step 5 fallback complete** = §3.A 完了 + §3.F 録画視聴 + §3.E 比較表を録画から書き写し (API key 不所持時の代替パス)

### 3.A Setup — engine 別 secret 確認 (5 分)

playground repo に Step 5 用 secret が登録済かを 1 コマンドで確認:

```bash
# playground repo にいることを確認
gh repo view --json nameWithOwner --jq .nameWithOwner

# Step 4 baseline (P10) + Step 5 追加 (P11) を同時確認
gh secret list -R <your-org>/<your-playground-repo> | grep -E "COPILOT_GITHUB_TOKEN|ANTHROPIC_API_KEY|OPENAI_API_KEY|CODEX_API_KEY"

# gh aw が認識する engine 別 secret 一覧
gh aw secrets list
```

**期待出力**:
- `COPILOT_GITHUB_TOKEN` (Step 4 から継承、必須)
- `ANTHROPIC_API_KEY` (Claude engine 用、§3.C を回す場合に必須)
- `OPENAI_API_KEY` (Codex engine 用、§3.D を回す場合に必須、`CODEX_API_KEY` でも可)

未登録の場合は [`prerequisites.md` P11](../prerequisites.md) の **登録経路 4 種** (UI / `gh aw secrets set` / `gh aw secrets bootstrap` / `gh secret set` fallback) のいずれかで登録。

✅ **Setup ready 達成**: 上記 grep で必要な secret 行が表示されたら次 §3.B へ。Step 5 fallback (§3.F) を選ぶ場合もここまでは必須。

---

### 3.B Copilot baseline 再走 (~5-7 分、minimum 達成の片翼)

Step 4 の `triage-issue.md` をベースに、`engine` を **明示** で `copilot` にした workflow を作成 (= R08-9 backward compat 確認も兼ねる)。

**Step 1**: `triage-issue.md` をコピーまたは engine 行のみ追記 (上記 IMPORTANT 方法 A or B):

```bash
cd .github/workflows
cp triage-issue.md triage-issue-copilot.md   # 方法 A 採択時
```

**Step 2**: [`templates/triage-issue-engine-swap.md`](./templates/triage-issue-engine-swap.md) を参考に `engine: copilot` 行を追加。**unified diff patch 形式**で示すと:

<!-- step5-final-workflow-start -->

```diff
 ---
 on:
   issues:
     types: [opened]
   ...
 permissions:
   contents: read
   issues: read
+engine: copilot
 safe-outputs:
   ...
 ---
```

(§3.C / §3.D で同じ位置の `engine` 行のみを `claude` / `codex` に書き換えます。)

```diff
-engine: copilot
+engine: claude
```

```diff
-engine: copilot
+engine: codex
```

<!-- step5-final-workflow-end -->

> [!CAUTION]
> 以下は **やってはいけない** 例です。`safe-outputs` を bypass して `permissions: issues: write` を agentic job 自身に与えると Trust thread Layer 4 が崩れます。Step 5 では engine を切り替えても **この invariant は維持される** ことを §3.E Group 3 で観測します。
>
> <!-- step5-engine-fail-start -->
> ```diff
> -permissions:
> -  contents: read
> -  issues: read
> +permissions:
> +  contents: read
> +  issues: write   # ❌ NG: agentic job に直接 write 権限を与えると safe_outputs ガードレールが無意味化
> ```
> <!-- step5-engine-fail-end -->

**Step 3**: compile + commit + push:

```bash
gh aw compile
git add .github/workflows/triage-issue-copilot.md .github/workflows/triage-issue-copilot.lock.yml
git commit -m "step 5: copilot engine baseline (explicit)"
git push
```

**Step 4**: Issue を新規作成して invoke、または `workflow_dispatch` で specific issue re-run:

```bash
gh issue create --title "Step 5 baseline: README is missing license info" --body "Could you add the license section?"
# または:
gh workflow run triage-issue-copilot.lock.yml -f issue_number=<N>
```

**Step 5**: 結果を観測し、§3.E の 5 軸比較表 row "copilot" に書き込む:
- **latency** (Actions log の elapsed)
- **output style** (label + comment 文体)
- **run status** (success / fail)
- (E3 RESULT §8.2 / §8.4 が Copilot baseline の reference data、~3 分 elapsed が目安)

✅ **§3.B 完了 = Step 5 minimum live complete の片翼**。次に §3.C か §3.D の **どちらか 1 つ** を完走すれば minimum done。

---

### 3.C Claude engine 切替 (~7-10 分)

`triage-issue.md` の engine 行のみを `claude` に書き換え (方法 A: `cp triage-issue-copilot.md triage-issue-claude.md` 推奨):

```diff
-engine: copilot
+engine: claude
```

**重要 (R08-1 = engine stanza canonical syntax)**: `gh aw` v0.68.3 では engine stanza の **canonical syntax** が **scalar** (`engine: claude`) か **object** (`engine:\n  id: claude`) かが文脈で異なります。`model` / `version` 併記時は object 形が必要な場合があります。

```yaml
# (A) scalar 形 (model 暗黙)
engine: claude

# (B) object 形 (model 明示時の canonical)
engine:
  id: claude
  # model: claude-3-5-sonnet-20241022   # ← Phase 11 dogfooding で世代切替を再検証
```

> [!IMPORTANT]
> **どちらが canonical かは playground repo で `gh aw compile` を実行した結果で決定してください**。両形ともサポートされる場合は scalar 形を推奨 (簡素)。`unknown engine` / schema error が出る場合は object 形を試す → なお compile-fail なら §4 fallback decision tree へ。

**compile + commit + push + invoke** は §3.B Step 3-5 と同じ手順。Issue タイトル / body は **同じ** にすると比較しやすい (e.g. "README is missing license info")。

**観測ポイント** (§3.E 表 row "claude" に記入):
- **latency**: copilot vs claude で elapsed がどう変わったか (Actions log)
- **output style**: comment 文体 (より説明的か簡潔か / 引用部の使い方 / label の選び方)
- **run status**: success / fail (Auth-fail / Compile-fail / Runtime timeout / Safe-output fail のどれか、§4 decision tree)

---

### 3.D Codex engine 切替 (~7-10 分)

`triage-issue.md` の engine 行を `codex` に書き換え (方法 A: `cp triage-issue-copilot.md triage-issue-codex.md` 推奨):

```diff
-engine: copilot
+engine: codex
```

**secret canonical**: `OPENAI_API_KEY` が canonical、`CODEX_API_KEY` も gh-aw 側で accepted alternative として受理される実装の場合があります (P11 参照、`.lock.yml` 内 secret 参照名は **playground repo で `gh aw compile` 結果から実機確認**)。

**compile + commit + push + invoke** は §3.B Step 3-5 と同じ手順。同じ Issue タイトル / body で再現性を確保。

**観測ポイント** (§3.E 表 row "codex" に記入): §3.C と同一 5 軸。

---

### 3.E 5 軸比較表 — 観測場所別 4 グループ (~5 分、full done のゴール)

[`templates/compare-runs.md`](./templates/compare-runs.md) を playground repo にコピーして engine x 5 軸で埋めます。**5 軸は観測場所別 4 グループ** (Phase 08 D08-14):

#### Group 1: Observed in this run (1 invocation 完結で観測)

| engine | latency (elapsed) | output style (label + comment) | run status |
|---|---|---|---|
| copilot | (記入: ~Xm Ys) | (記入: 簡潔 / 説明的 / 引用部 etc) | (success / fail) |
| claude | | | |
| codex | | | |

#### Group 2: Post-run / optional (各 console の billing/usage visibility)

| engine | console URL | observed cost (1 invocation) | observed tokens (input / output) |
|---|---|---|---|
| copilot | (Premium Request usage) | — | — |
| claude | https://console.anthropic.com/ → Usage | (記入) | (記入) |
| codex | https://platform.openai.com/usage | (記入) | (記入) |

(Group 2 は省略可、API key 不所持時はスキップ)

#### Group 3: Design invariant to inspect (= verification target)

3 engine 全部の `.lock.yml` を `diff` で並べ、以下が **engine 横断で維持されているか** を inspect:

```bash
diff triage-issue-copilot.lock.yml triage-issue-claude.lock.yml | grep -E "safe_outputs|permissions:|add-labels|add-comment"
diff triage-issue-copilot.lock.yml triage-issue-codex.lock.yml  | grep -E "safe_outputs|permissions:|add-labels|add-comment"
```

| invariant | 維持されたか |
|---|---|
| `safe_outputs` job boundary (agentic job ≠ writer job) | (Yes / Partial / No) |
| `permissions: contents: read` (agentic 側 write 無し) | (Yes / Partial / No) |
| `add-labels.allowed` allowlist 不変 | (Yes / Partial / No) |

**昇格判断 (Phase 08 C5 でも本 Step README 末尾でも)**:
- 全 Yes & 全 engine が PASS → **`confirmed` (engine 横断 invariant 確証)**
- いずれか Partial / No、または Safe-output fail が 1 engine ある → **`partially confirmed` (条件付確証)**

#### Group 4: Troubleshooting-only (error mode 例、§4 decision tree と対応)

| engine | error mode 観測有無 | 対処 (§4 decision tree のどの分岐) |
|---|---|---|
| copilot | (なければ —) | — |
| claude | | |
| codex | | |

---

### 3.F 録画 fallback パス (API key 不所持時の代替、後続 Phase で提供予定)

API key を取得しない / 取得できない学習者は、§3.B (Copilot baseline 再走) のみ実機で完走し、§3.C + §3.D は **録画視聴 + §3.E 表を録画から書き写し** で代替できます。

[`recordings/README.md`](./recordings/README.md) (内部 placeholder) — 後続 Phase (Phase 11 以降) で録画コンテンツへの link が提供されます。それまでは本 placeholder file が表示されます (broken link 化を防止)。

✅ **Step 5 fallback complete**: §3.A + §3.B 実機 + §3.E 録画書き写しで本 Step 完了扱い。

---

## 4. Fallback decision tree (engine 切替が動かないとき)

invoke 結果に応じて以下のいずれか 1 分岐に進む (再試行は最大 1 回):

| 観測 | 分岐 | 対処 |
|---|---|---|
| **PASS** | success | §3.E 比較表に記入、次 engine へ |
| **Compile-fail** (`gh aw compile` で `unknown engine` / schema error) | (a) syntax 切替: scalar `engine: claude` ⇄ object `engine:\n  id: claude` を交互に試す。(b) `gh aw version` で v0.68.3 を再確認。(c) なお fail なら本 Step §3.F 録画 fallback | engine stanza canonical syntax 未確定 (R08-1) のため両形 OR で試す |
| **Auth-fail** (401 / 403、key valid 確認後再現) | (a) `gh aw secrets list` で対応 secret 名を確認 (e.g. `CODEX_API_KEY` のみ受理されるケース)。(b) console で key を再発行。(c) なお fail なら録画 fallback | 該当 engine のみ skip 可、minimum done は別 engine で達成可能 |
| **Runtime timeout** (job-level または 20min) | playground の rate limit / quota を console で確認、数分待って再試行 1 回 | rate limit 時は §3.F 録画 fallback |
| **Safe-output fail** (agent 成功だが `safe_outputs` job が fail) | invariant `partially confirmed` 確定 evidence。§3.E Group 3 行に Partial 記入し次 engine へ | engine 横断 invariant が崩れた observation = 教材的に重要 |

---

## 5. Troubleshooting

| 症状 | 対処 |
|---|---|
| `gh aw secrets list` で `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` が出ない | [`prerequisites.md` P11](../prerequisites.md) の登録 4 経路を参照、UI 経路が最も確実 |
| Issue 作成しても workflow が起動しない | (a) `gh aw compile` 後に push したか確認 (lock.yml も commit) (b) `triage-issue-<engine>.lock.yml` が enable されているか Actions タブで確認 (c) `on: issues.opened` が含まれているか |
| 各 console で usage / cost が見えない (Group 2) | Anthropic Console は `Settings → Usage`、OpenAI Platform は `Usage` ページ。Workshop 中は Group 2 省略可 |
| 「Step 4 の triage-issue.md を壊した」 | Step 4 §3.C 末尾の canonical サンプルから上書き復旧、または `step-4-complete` branch から該当 file を `git restore` |
| `engine: claude` / `engine: codex` が org / plan / repo policy で unavailable (R08-4) | rollout 状況による。本 Step を §3.F 録画 fallback で完走 (= Step 5 fallback complete) |

---

## 6. 完了確認 (Done check)

以下のいずれかに該当すれば本 Step 完了:

- [ ] **Setup ready** = §3.A の `gh aw secrets list` で必要 secret 確認済
- [ ] **Step 5 minimum live complete** = §3.B + (§3.C OR §3.D のどちらか 1 つ) で 1 invoke 成功
- [ ] **Step 5 full live complete** = §3.B + §3.C + §3.D + §3.E 比較表 (Group 1 + Group 3) 記入完了 (= 3 engine head-to-head)
- [ ] **Step 5 fallback complete** = §3.A + §3.B 実機 + §3.F 録画視聴 + §3.E 比較表書き写し

**engine 横断 invariant の昇格判断** (Group 3 結果に基づき):
- [ ] `confirmed` (全 engine で `safe_outputs` job boundary + `permissions` invariant 維持、Safe-output fail なし)
- [ ] `partially confirmed` (1 engine 以上で Partial / Safe-output fail observed)

✅ いずれかが ☑ できたら次 Step へ:
- [Step 6 — Gate](../step-6-gate/) (必須 Step、API key 不要)

---

## 7. 参考 (内部資料)

- 設計根拠: [phase-08-step5-multi-engine.md](../../docs/planning/phase-08-step5-multi-engine.md) (Phase 08 SoT)
- engine canonical samples: [VERSIONS.md §4.2](../../docs/planning/VERSIONS.md#42-phase-08-step-5--multi-engine-で確定する追加パターン-engine-stanza-canonical-samples)
- engine 別 secrets 登録: [VERSIONS.md §9](../../docs/planning/VERSIONS.md#9-step-5-multi-engine任意-secrets-登録経路-phase-08)
- 学習者前提: [`prerequisites.md` P11](../prerequisites.md)
- リスク: [master-plan §6 R4 / R6 (R14 sub-risk = engine stanza spec drift)](../../docs/planning/00-master-plan.md)
- ベース PoC (Copilot baseline): [E3 RESULT](../../docs/planning/poc/E3-gh-aw/RESULT.md) (Phase 08 §3.B 再利用 reused note 参照)

[← 目次に戻る](../README.md)
