# Phase 08 詳細計画書 v2 — Step 5 (Multi-engine) 教材化

> **位置付け**: Phase 07 (Step 4 = Automate / `gh aw`) の S08-1〜S08-5 申し送りを **本 Phase で全て学習者文書に降ろす**。Step 5 = "**1 つの engine 単独実行 (Step 4) から、`engine:` キー切替で複数 engine head-to-head 比較するターニングポイント**"。
> **本ファイルは Phase 06 / 07 SoT と同型構造** (§1 Goal → §2 Scope/D → §3 Dir → §4 Commits → §5 Test → §6 DoD → §7 Risks → §8 進め方 → §9 Refs → §10 §4.5 + Step 5 verification block + R08-1 discovery RESULT block → §11 申し送り → §12 履歴)。
> **特殊性**: Step 5 は master-plan §4.5 で **任意 Step**。任意 Step を heavy 化することの整合性 (§1.4) と、API key 不所持学習者向け録画代替パス (§3.0 / §4 / §1) を 3 箇所に明示。
> **v2 (rubber-duck #1 反映)**: Blocking 5 件 + Important 10 件すべて反映 ⇒ ① engine stanza canonical syntax は C2b discovery で確定 (D08-13 新設、scalar/object 両対応 gate)、② R08-1 fallback decision tree を §10.3.1 に明文化、③ "engine 横断 invariant" を **verification target** に弱め、C5 で confirmed に昇格、④ truth migration を **C2a (skeleton + R14 placeholder) + C2c (discovery closure 新規)** に分離、⑤ 録画 placeholder を **`content/step-5-multi-engine/recordings/README.md` 内蔵 file** に変更 (broken link 防止)、⑥ 5 軸比較表を **観測場所別** に分類 (D08-14 新設)、⑦ done state に **`Step 5 fallback complete`** を追加、⑧ Group D marker を 3 engine 同時囲み形に確定、⑨ Codex secret は `OPENAI_API_KEY` canonical + `CODEX_API_KEY` accepted alternative、⑩ template は **unified diff patch 形式**、⑪ Pro plan 縛り廃止は API key 条件のみ追加 (`COPILOT_GITHUB_TOKEN` + Copilot license baseline は継承)、⑫ §10.3 RESULT block に証跡列拡充、⑬ R14 を **R6 sub-risk** として master-plan に書く。
> **commit 構成変更**: C2b と C3 の間に **C2c (discovery closure + final truth migration)** を新設 ⇒ **6 commits → 7 commits + escape hatch branch**。

---

## 1. Phase Goal

### 1.1 主目的

`content/step-5-multi-engine/` を **heavy demo (~20–25min, 5 sub-step)** に書き上げ、**Step 4 で書いた `triage-issue.md` の `engine:` キーを `copilot` / `claude` / `codex` に切り替えるだけで** 同じ trigger / 同じ skill 文脈での head-to-head 比較が成立する状態を 7 commits + escape hatch branch (`step-5-complete`) で公開する。

中核メッセージ:
- **Step 4** = 「`gh aw` workflow が **Copilot CLI engine 単独** で server-side triage を実行」
- **Step 5** = 「**同じ workflow の `engine:` キーを書き換えるだけで** Claude / Codex / Copilot を head-to-head 比較」(★ 新規 workflow を作らない、diff-only 編集が中核)
- 任意 Step だが **heavy 設計** = engine 切替の現物挙動を最低 1 回観察することが Step 6a への自然な導線
- API key 不所持学習者には **録画視聴 + 比較表書き写し** のパスを必ず維持 (Phase 10 で録画提供)
- Trust thread Layer 4 (strict mode + safe-outputs) は **engine 横断 invariant 候補 = verification target** ⇒ engine を切り替えても safe-outputs ガードレールが維持されるかを §3 で観察、§10.3 RESULT block で確認、Phase 08 C5 で **`partially confirmed` で publish** (構造的検証 PASS、実機 evidence は Phase 11 で `confirmed` 再昇格判断、※未検証断言を回避)

### 1.2 Phase 完了時に手元にあるもの

- 学習者が Codespaces で開いて **20–25 分** で完走できる Step 5 README (~250 行、heavy 構成)
- 学習者の playground repo に commit される **engine 切替の最小差分**:
  - `triage-issue.md` の `engine` stanza を copilot → claude → codex に切替 commit 3 本 (Step 4 で書いた同一ファイルへの diff-only 編集、**stanza canonical syntax (scalar `engine: claude` か object `engine:\n  id: claude` か) は C2b discovery で確定 ⇒ D08-13**)
  - `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` (Codex は `CODEX_API_KEY` accepted alternative) の playground secret 登録 (各 1 回)
- `step-5-complete` branch (**documentation + canonical template state**: workshop repo 上では `content/step-5-multi-engine/templates/` 配下に `triage-issue-engine-swap.md` (engine 別 frontmatter サンプル) + `compare-runs.md` (5 軸 × 3 engine 比較表テンプレ) を置き、active workflow は意図的に置かない。Phase 07 D14 と同型)
- `step-gate.yml` `step-5-gate` job (T-501..505 + Group A/B/C positive + Group D negative、**marker block 抽出方式**)
- prereqs **P11 新設** (`ANTHROPIC_API_KEY` / `OPENAI_API_KEY` 登録 4 経路、Phase 07 P10 と並列構造)
- master-plan §9 Phase 08 ✅ + §6 R4 status final + **§6 R14 新規** (engine: spec drift) + §4.5 強化 (Q5 = Pro plan 縛り廃止) + 改訂履歴
- VERSIONS.md **§4.2 新規** (3 engine canonical samples = C2b discovery で確定した stanza 形式に従って `engine: copilot` / claude / codex の frontmatter 差分を unified diff 形式で記載) + **§9 新規** (engine 別 secret マトリクス、Phase 07 §9 strict mode 段落と並列、`OPENAI_API_KEY` canonical + `CODEX_API_KEY` accepted alternative も併記) + **§1 R6 status note 更新** (Phase 08 publish 時点の v0.68.3 `engine` stanza 3 値の **discovery RESULT** = PASS or fallback 採択を記録)

### 1.3 マイルストーン

master-plan §5 の **M4 = Phase 08 + Phase 09 完了 = "ツアー後半まで配布可能 (フルバージョン直前段階)"** に向けた半分。Phase 09 (Step 6a = Required Check) 並行完了で M4 達成、API key 保持者は Step 0→1→2→3→4→5→6a 完走、API key 不所持者は Step 0→1→2→3→4→6a 完走 (Step 5 は録画視聴で代替) パスが両方成立する。

### 1.4 任意 Step を heavy 化する整合性

> **論点**: master-plan §4.5 で Step 5 は「任意」確定。Step 4 (必須) と同等の heavy 構成 (5 sub-step ~250 行) にする整合性は?

**回答**:
- 「任意 = 飛ばしても CTA 達成可」と「heavy = 飛ばさない学習者には実体的価値を提供」は **直交する** 設計軸
- 任意 Step を light 化すると、API key 保持者にとっても「触ってみる気になれない薄い体験」になり、Step 6a に向けた Trust thread の伏線 (= engine 横断 invariant) が伝わらない
- 任意性は §1 / §3 冒頭 / §4 完了確認の **3 箇所で明示** (R08-5 の対策と同じ)、heavy 設計は API key 保持者向けの実体的価値の保証として両立
- API key 不所持学習者には **録画視聴 + 比較表書き写し** のパスを保証 (Phase 10 で録画提供)、本 Phase は録画 placeholder link のみ配置

---

## 2. Scope

### 2.1 IN SCOPE

| 対象 | 何を作るか |
|---|---|
| `content/step-5-multi-engine/README.md` | heavy demo (5 sub-step ~20–25min) 必須 7 セクション準拠、§2 NOTE に **Step 4 §3.D 完走の前提** + **API key 取得 + secret 登録の前提** + **engine x secret マトリクス** + **任意 Step + 録画代替の救済文言**、§3 = 3.A 前提整理 (engine x secret マトリクス + Step 4 で書いた `triage-issue.md` の `engine:` キーを明示する書き換え) / 3.B `engine: copilot` baseline で再走 / 3.C `engine: claude` 切替 + `ANTHROPIC_API_KEY` 登録 + 1 invoke / 3.D `engine: codex` 切替 + `OPENAI_API_KEY` 登録 + 1 invoke / 3.E **head-to-head 比較表 5 軸 × 3 engine** (cost / latency / output style / safety guardrails / error mode)、§4 完了確認は **3 段階** (Setup ready / minimum (1 engine 切替成功) / full (3 engine head-to-head)) |
| `content/step-5-multi-engine/templates/triage-issue-engine-swap.md` | canonical sample = **unified diff patch 形式** (新規ファイル全体ではなく、Step 4 の `triage-issue.md` frontmatter に追加する `engine` stanza のみを `+` 行で示す)、3 engine 分の patch を順に提示 (`engine: copilot` baseline → claude diff → codex diff)、各 patch は `engine` stanza のみ追加し `on` / `permissions` / `safe-outputs` 等は触らないことを WARNING で明示 (★ rubber-duck #1 Important 7)。**新規 workflow を作らない** = Step 4 で書いた `triage-issue.md` への diff-only 編集を強調する short sample |
| `content/step-5-multi-engine/templates/compare-runs.md` | 5 軸 × 3 engine 比較表テンプレート、**観測場所別に分類** (D08-14): ① Observed in this run = latency / output style / label-comment 結果 / run status、② Post-run / optional = provider console usage/cost、③ Design invariant to inspect = safe_outputs job boundary、④ Troubleshooting-only = error mode 例。学習者は §3.E でこのテンプレに観測値を書き写す |
| `content/step-5-multi-engine/recordings/README.md` | **新規 placeholder file** (rubber-duck #1 Blocking 5)。Step 5 README 内の録画 link は **本ファイルへの相対 link** に変える ⇒ Phase 10 着手前に踏んでも 404 にならず「Phase 10 で配置予定」を読ませる future-proof 形 |
| `content/README.md` | Step 5 行 ⏳ → ✅、`🪂 escape hatch` 表に `step-5-complete` 行追加 (**documentation + canonical template state**、workshop repo には active workflow を置かない、`ANTHROPIC_API_KEY`/`OPENAI_API_KEY` は別途設定要)、IMPORTANT note で「Step 5 は任意。API key 不所持者は録画視聴で代替可 (Phase 10 提供予定)」 |
| `content/prerequisites.md` | **P11 新設**: `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` (Codex は `CODEX_API_KEY` accepted alternative) 登録 4 経路 = ① UI method (Codespaces で確実、Settings → Secrets → Actions → New) ② **`gh aw secrets set ANTHROPIC_API_KEY --value "$ANTHROPIC_KEY"`** (主導線、Phase 07 P10 同型) ③ `gh aw secrets bootstrap` (existing secrets check) ④ fallback `gh secret set ANTHROPIC_API_KEY -R <owner>/<playground>`。**playground repo に設定**を `gh repo view --json nameWithOwner` で確認させる手順を組み込み。環境チェックに **⑨ Anthropic / OpenAI API key 保有 (任意)** + **⑩ `gh aw secrets list` で engine 別 secret 表示確認** を追加。**baseline 前提として Step 4 で登録した `COPILOT_GITHUB_TOKEN` + Copilot license は継承** (Q5 の Plan 縛り廃止は API key 条件のみ追加するという意味であり、Copilot baseline は不変、★ rubber-duck #1 Important 8) |
| `docs/planning/VERSIONS.md` | **§1 R6 status note 更新** (Phase 08 publish 時点の `engine:` キー 3 値 discovery RESULT を記録: PASS or fallback)、**§4.2 新規** (3 engine canonical samples = `engine: copilot` / `engine: claude` / `engine: codex` の frontmatter 差分。各 engine の典型 model identifier も併記)、**§9 新規** (engine 別 secret マトリクス: `COPILOT_GITHUB_TOKEN` = Copilot engine 専用 PAT / `ANTHROPIC_API_KEY` = Claude engine API 認証 / `OPENAI_API_KEY` = Codex engine API 認証、Phase 07 §9 strict mode 段落と並列) |
| `docs/planning/00-master-plan.md` | §9 Phase 08 ✅ + §6 R4 status final (任意化 + 録画代替 + Phase 10 申し送り) + **§6 R14 新規** (`engine:` キー spec drift、Phase 11 で再検証) + §4.5 強化 (Q5 = Pro plan 縛り廃止、API key 有無のみで分岐) + 改訂履歴 |
| `docs/planning/poc/E3-gh-aw/RESULT.md` | 先頭に "✅ Reused as source-of-truth for Phase 07 §3 & Phase 08 §3.B baseline 教材化" note 追加 (Phase 08 §3.B = engine: copilot baseline は E3 §8.2/§8.4 を再利用) |
| `.github/workflows/step-gate.yml` | `step-5-gate` job 追加 (T-501..505)。**Group D negative grep は marker block 抽出方式で実装** (`<!-- step5-final-workflow-start --> ... <!-- step5-final-workflow-end -->` の中だけを検査、`<!-- step5-engine-fail-start/end -->` は除外)。Group D 対象 paths は **`content/**` のみに限定** (Phase 07 D15 と同型) |
| `step-5-complete` branch | main 派生 push (D08-08 = **documentation + canonical template state**、active workflow は workshop repo に置かない、template 配下に sample のみ) |
| 本ドキュメント | Phase 08 詳細計画書 v1 |

### 2.2 OUT OF SCOPE (Phase 09+)

- Step 6a/6b 本文 (Required Check / Custom Agent)
- Step 5 §3 で **新規 workflow を作る**こと (本 Phase は **Step 4 の `triage-issue.md` への engine: 差分のみ**、新規 workflow は §6 References 経由でも誘導しない)
- 実機スクリーンショット (Phase 11)
- gh aw v0.69+ 対応 (Phase 11 で再検証時に判断)
- API key 不所持学習者向け録画 (Phase 10、本 Phase では link placeholder のみ + 比較表書き写しパス)
- 新規 PoC (E10) は **不要** = Q3 確定 = Phase 08 内 dogfooding で engine swap を実機検証する built-in discovery 形 (R08-1 で fallback path も準備)
- gh-aw `network.allowed` allowlist 詳細 (Step 5/6 発展題材だが、本 Phase は engine: 切替に集中、network 制御は Phase 09+ または Phase 11)
- engine 別 typical cost / latency の **絶対値ベンチマーク** (環境依存が大きすぎるため、§3.E 比較表は **学習者の手元観測値** を書き写すリファレンス品質に留める)
- Step 4 で書いた `triage-issue.md` workflow の Required Check 化 (Phase 09 = S09-2 申し送り)
- 録画スクリプト本文 (Q4 = `out_of_scope` 確定、Phase 10 dogfooding 直前で作成)
- Pro plan 学習者向け degraded complete 分岐 (Q5 = `pro_no_special` 確定、Step 5 は API key 有無のみで分岐、Plan 縛り廃止)

### 2.3 設計判断 (D08-1〜D08-12) — Phase 06/07 と同型 + Step 5 固有

| # | 論点 | 採用案 | 根拠 |
|---|---|---|---|
| **D08-1** | demo 厚さ | **heavy 20–25min** = 5 sub-step (Q1 = `heavy_full` 確定。Step 4 = 6 sub-step だが Step 5 は engine 切替 diff-only 編集なので 5 で密度確保) | ユーザー判断 Q1 |
| **D08-2** | sub-step 順序 | **3.A 前提整理 (engine x secret マトリクス + Step 4 triage-issue.md の engine: キー明示書き換え) → 3.B `engine: copilot` baseline で再走 (Step 4 で動かしたものを baseline として観測) → 3.C `engine: claude` 切替 + `ANTHROPIC_API_KEY` + 1 invoke → 3.D `engine: codex` 切替 + `OPENAI_API_KEY` + 1 invoke → 3.E head-to-head 比較表 5 軸 × 3 engine** | Q1 / Q2 (3 engine) / S08-3 (engine: diff-only) |
| **D08-3** ⚠ | engine 切替の commit 構造 | **同じ `triage-issue.md` への diff-only 編集**、新規ファイル不作成。各 engine 切替で `gh aw compile` → push → trigger → 観測。**順序固定**: ① `engine:` キーのみ書き換え → ② `gh aw compile` PASS → ③ `git add/commit/push` → ④ Issue trigger → ⑤ 約 3 分後に label/comment 反映確認 | S08-3 / Phase 07 P07-2 (compile-before-commit) 継承 |
| **D08-4** ⚠ | API key cost 警告 | §2 prereq IMPORTANT box: 「**API key は Anthropic Console / OpenAI Platform で発行、利用量に応じて請求が発生**。Step 5 は任意なので未取得でも CTA は達成済。録画視聴で代替可 (Phase 10 提供予定)」。比較表 §3.E の cost 軸は **typical 値範囲** を例示するが、絶対ベンチマーク化しない (R08-2 / R08-7) | R08-2 |
| **D08-5** ⚠ | engine x secret マトリクス | §3.A 冒頭で表形式: \| engine \| 認証 secret (canonical) \| 認証 secret (alternative) \| 役割 \| \| copilot \| `COPILOT_GITHUB_TOKEN` \| (なし) \| Phase 07 で登録済 \| \| claude \| `ANTHROPIC_API_KEY` \| (なし) \| Anthropic Console で発行 \| \| codex \| `OPENAI_API_KEY` \| `CODEX_API_KEY` (gh-aw 側で優先される実装の場合あり、C2b discovery で確定) \| OpenAI Platform で発行 \|。**`COPILOT_GITHUB_TOKEN` は claude/codex engine では使われない**ことを明示 (R08-3、★ rubber-duck #1 Important 6) | R08-3 / S08-5 |
| **D08-6** ⚠ critical | R08-1 fallback path (engine: 仕様 drift) | C2b 実装中に **engine: claude / engine: codex の v0.68.3 実機挙動を verify**。**判定基準は §10.3.1 decision tree** に明文化 (PASS / Compile-fail / Auth-fail / Runtime timeout / Safe-output fail の 5 状態、再試行は最大 1 回、★ rubber-duck #1 Blocking 2)。**discovery RESULT** を §10.3 RESULT block に証跡列付きで記録 (`gh aw version` / workflow run id / engine stanza used / secret name observed in `.lock.yml` / job names+status / elapsed / label-comment 結果 / failure log 抜粋、★ rubber-duck #1 Important 9)。**fallback 採択時** (= claude/codex のいずれかが動かない場合): §3.C / §3.D を「engine stanza の存在と切替方法のみ示し、実 invoke は録画視聴で代替」に縮退、master-plan §6 R6 status note (R14 を sub-risk として付記) に「Phase 08 publish 時点で engine X が unavailable、Phase 11 再検証必須」を記録 | Q3 / R08-1 |
| **D08-7** ⚠ | done state checklist (§4) | **`Setup ready (= API key 取得 + secret 登録 + engine x secret マトリクス理解)` / `Step 5 minimum live complete (= 1 engine 切替成功 = 非 Copilot engine いずれか 1 つで invoke 完走)` / `Step 5 full live complete (= 3 engine head-to-head 完走 + 比較表 §3.E 書き写し済)` / `Step 5 fallback complete (= unavailable engine は §10.3 RESULT block + 録画/概念説明で代替)`** の **4 状態** (★ rubber-duck #1 Important 4)。**Step 5 最低完了 = `Step 5 minimum live complete` または `Step 5 fallback complete`** と明記、Step 6a 接続にはどちらかで十分。fallback 採択時の Phase 08 close 条件は §6.3 で別途明示 | Q1 / Phase 07 D7 同型 |
| **D08-8** ⚠ | escape hatch (`step-5-complete`) の意味 | **documentation + canonical template state** = workshop repo (本 repo) には **active workflow を置かない** (Phase 07 D14 と同型)。`content/step-5-multi-engine/templates/triage-issue-engine-swap.md` (unified diff patch 形式) + `compare-runs.md` を canonical sample として配置。`step-5-complete` branch を checkout すると README が "Step 5 完読 state"、template が即手元にあり、学習者は **playground repo に展開する形** で Step 5 を再現できる。**`ANTHROPIC_API_KEY` / `OPENAI_API_KEY` secret は学習者が自分の playground に設定する必要あり** (= secret は branch に乗らない、Trust thread の一部) を §6 escape hatch 説明で明記。**Copilot baseline (`COPILOT_GITHUB_TOKEN` + Copilot license) は Step 4 から継承** (★ rubber-duck #1 Important 8) | Phase 07 D14 / R08-3 |
| **D08-9** ⚠ ★ R08-9 | Step 4 backward compat | Step 4 の `triage-issue.md` は `engine` stanza 暗黙 (= `copilot`)。Step 5 §3.A で **明示形に書き換える** が、これは Step 4 の動作を壊さない。**§3.A 冒頭で「Step 4 では `engine` stanza を書かなかったが、これは暗黙 default = `copilot`。Step 5 では明示に切り替えるが Step 4 の動作は変わらない」を明記**。step-4-gate (Phase 07 C3) は `engine` stanza を明示しても **PASS 条件**であることを **step-5-gate T-PHASE08-505 Group A NOTE** で副次明記 (Done checklist 検査 T-503 ではなく Group A spec keyword 検査側、★ rubber-duck #1 Important 2) | R08-9 / S08-1 |
| **D08-10** ⚠ | 録画 link future-proof | **「Phase 10 で提供予定」** placeholder を §1 / §3 冒頭 IMPORTANT box / §4 完了確認の 3 箇所に配置。**dead link 回避**: link は外部 URL ではなく `content/step-5-multi-engine/recordings/README.md` への **相対 link** に変える ⇒ Phase 10 着手前に学習者が踏んでも内部 placeholder file が表示される (404 なし、★ rubber-duck #1 Blocking 5)。Phase 10 で実 URL に置換可能な形 | Q4 / R08-5 |
| **D08-11** ⚠ ★ I1 ★ I6 ★ I8 **positive + negative** | step-gate.yml 拡張 (T-501..505) | Phase 07 D15 同型 + Step 5 固有: **Group A 構造/spec keyword (positive)** (`gh aw` / `engine` (stanza、scalar `engine: copilot\|claude\|codex` と object `engine:\n  id: copilot\|claude\|codex` の **両形式を OR 条件で許容**、★ rubber-duck #1 Blocking 1) / `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` / `safe-outputs` / `triage-issue\.md` / Step 4 backward compat NOTE 文言の存在) + **Group B Step 5 概念 (positive)** (**`engine 切替`** / **`head-to-head`** / **`Multi-engine`** / **`engine 横断 invariant 候補`** または **`verification target`** ⇒ 未検証断言を回避 (★ rubber-duck #1 Blocking 3) / `Anthropic` / `OpenAI` / **`engine x secret`**) + **Group C 構造** (`Setup ready` + `Step 5 minimum live complete` + `Step 5 full live complete` + `Step 5 fallback complete` の 4 状態 done) + **Group D 禁止 token (negative、marker block 抽出方式、3 engine 同時囲み形)** ★ I1 = `<!-- step5-final-workflow-start --> ... <!-- step5-final-workflow-end -->` 内に **3 engine 全 snippet を含めて** 単一 marker 内で囲む形に確定 (3 engine の各 patch が `permissions:\s*\n.*issues:\s*write` 等を含まないことを 1 回でまとめて検査、★ rubber-duck #1 Important 5)、`<!-- step5-engine-fail-start/end -->` は除外。**Group D 対象 paths は `content/**` に限定** (★ I8、Phase 07 D15 と同型) | Phase 07 D15 継承 |
| **D08-12** | Trust thread 伏線 (Step 5 固有文言) | 冒頭 IMPORTANT に: 「Step 4 では Copilot CLI engine 単独で **strict mode + safe-outputs** ガードレールを観察した。Step 5 では engine を Claude / Codex に切り替えても **safe-outputs ガードレールが engine 横断 invariant として維持されるかを verify** (= **C2b discovery で確認、§10.3 RESULT block に記録、C5 で `invariant confirmed` に昇格**、★ rubber-duck #1 Blocking 3 によりリリース時の断言を回避)。確認できれば **Trust thread が engine に依存しない事実** が成立し、Step 6a (Required Check) の "**人間が最後に判断する**" へ直結する」 | Phase 07 D12 継承 |
| **D08-13** ⚠ ★ rubber-duck #1 Blocking 1 | engine stanza canonical syntax | gh-aw v0.68.3 で `engine` stanza は **scalar 形式** (`engine: copilot`) と **object 形式** (`engine:\n  id: copilot`、model/version 併記時) の 2 流儀あり。C2b discovery で **どちらを workshop canonical にするか確定**、§10.3 RESULT block + VERSIONS §4.2 + templates 全てを確定形式に揃える。step-5-gate Group A regex は **両形式を OR 条件** で許容しておき、確定後に絞り込み可能 | rubber-duck #1 Blocking 1 |
| **D08-14** ⚠ ★ rubber-duck #1 Important 3 | 5 軸比較表の観測場所分類 | `compare-runs.md` テンプレ + §3.E で観測軸を **観測場所別に 4 グループ** に分ける ⇒ ① **Observed in this run** = latency / output style / label-comment 結果 / run status (Actions log で 1 invocation 完結観測可能)、② **Post-run / optional** = provider console usage/cost (1 invocation 後に provider console で確認、遅延あり)、③ **Design invariant to inspect** = safe_outputs job boundary (job 構造を inspect、observation ではなく確認)、④ **Troubleshooting-only** = error mode 例 (成功 path では観測されない)。"cost" は "**billing/usage visibility**" に名称変更 (rubber-duck #1 Suggestion 3、where to view usage / 請求主体 / key revoke) | rubber-duck #1 Important 3 |

---

## 3. ディレクトリ構造 (本 Phase 完了時の差分のみ)

```
.github/workflows/step-gate.yml           # 拡張: step-5-gate job 追加 (T-501..505 + Group A/B/C/D、Group D は marker block 抽出方式 + content/** 限定)
content/
├── README.md                             # 更新: Step 5 行 ✅ + 🪂 escape hatch 表 step-5-complete (documentation + canonical template state、API key 別途設定要)
├── prerequisites.md                      # 更新: P11 新設 (ANTHROPIC_API_KEY / OPENAI_API_KEY 登録 4 経路) + 環境チェック ⑨ ⑩ 追加
└── step-5-multi-engine/
    ├── README.md                         # 全面書き換え (現 stub → heavy demo 5 sub-step ~250 行)
    └── templates/                        # 新規 (D08-8)
        ├── triage-issue-engine-swap.md   # canonical sample (3 engine の frontmatter 差分のみ)
        └── compare-runs.md               # 5 軸 × 3 engine 比較表テンプレ
docs/planning/
├── 00-master-plan.md                     # 更新: §4.5 強化 (Q5 Pro 縛り廃止) + §6 R4 status final + §6 R14 新規 (engine: spec drift) + §9 Phase 08 ✅ + 改訂履歴
├── VERSIONS.md                           # 更新: §1 R6 status note (engine: 3 値 discovery RESULT) + §4.2 新規 (3 engine canonical samples) + §9 新規 (engine 別 secret マトリクス)
├── phase-08-step5-multi-engine.md        # 本ドキュメント (新規)
└── poc/
    └── E3-gh-aw/
        └── RESULT.md                     # 更新: 先頭 reused note を Phase 07 + Phase 08 §3.B baseline で再利用に拡張

# branches:
#   main                                  (本 Phase の全 commit)
#   step-5-complete                       (新規 escape hatch、main 派生、documentation + canonical template state)
```

---

## 4. 実装タスク (7 commits + branch / 線形依存) ★ truth migration 二段階分割 (Phase 07 I5 継承 + rubber-duck #1 Blocking 4 反映)

| C# | Commit | 主ファイル | 自動テスト |
|---|---|---|---|
| **C1** | `docs(planning): start Phase 08 — Step 5 multi-engine plan` | 本ファイル新規 (v2)、master-plan §9 Phase 08 を 🟡、改訂履歴着手行 | smoke 影響なし (paths 外) |
| **C2a** ★ truth migration 前段 (skeleton + R14 placeholder) | `docs(content): Step 5 prerequisites + R14 placeholder` | `content/prerequisites.md` (P11 新設 = engine 別 API key 登録 4 経路 + 環境チェック ⑨ ⑩ + Copilot baseline 継承 NOTE)、`docs/planning/00-master-plan.md` (§4.5 強化 Q5 = API key 条件のみ追加 + Copilot baseline 不変 + §6 R6 status note に **R14 sub-risk placeholder** = "Phase 08 C2c で discovery 結果を記入" を予約)、`docs/planning/poc/E3-gh-aw/RESULT.md` (先頭 reused note を Phase 08 §3.B baseline で再利用に拡張)。**VERSIONS.md §1 R6 status note / §4.2 / §9 は本 commit では skeleton (未確定 placeholder) のみ**、確定 truth は C2c で記入 (★ rubber-duck #1 Blocking 4 = discovery 前に false truth を書かない) | (C3 の Group A/B negative grep は C2c 後にローカル PASS) |
| **C2b** ★ README + templates + dogfooding 内蔵 discovery | `docs(content): write Step 5 — Multi-engine` | `content/step-5-multi-engine/README.md` 全面書き換え (~250 行、5 sub-step + Trust thread (verification target 文言) + 5 軸 × 3 engine 比較表 (4 グループ観測場所別) + 4 状態 done + engine x secret マトリクス + 任意 Step 救済 3 箇所 + 録画 placeholder (内部 file への相対 link) + Step 4 backward compat NOTE)、`templates/triage-issue-engine-swap.md` (unified diff patch 形式) + `compare-runs.md` (4 グループ観測場所別)、**`recordings/README.md` placeholder file 新規**、`content/README.md` (Step 5 行 ✅ + escape hatch 表 + IMPORTANT)。**実装中に engine: claude / engine: codex の v0.68.3 実機挙動を verify** (= R08-1 dogfooding discovery)、結果を **§10.3 RESULT block に記録** (証跡列付き)、**§10.3.1 decision tree** に従い fallback 採択判定、fallback 採択時は §3.C/§3.D を縮退形に修正 | (C3 の T-501..505 で連携) |
| **C2c** ★ NEW: discovery closure + final truth migration | `docs(content): Step 5 discovery closure — VERSIONS truth migration` | C2b discovery RESULT を踏まえ **VERSIONS.md §1 R6 status note 確定** (両形 OR canonical 採択 / 実機 invocation evidence は Phase 11 持ち越し)、**§4.2 確定** (3 engine canonical samples = D08-13 で確定した stanza 形式)、**§9 確定** (engine 別 secret マトリクス、`OPENAI_API_KEY` canonical + `CODEX_API_KEY` accepted alternative、`.lock.yml` 内 secret 参照名は Phase 11 持ち越し)、**`00-master-plan.md` §6 R6 status note に R14 sub-risk 確定文 を記入** (placeholder → Phase 11 持ち越し記述)、**`phase-08-step5-multi-engine.md` §10.3 RESULT block 内の ⏳ を Phase 11 持ち越し記述に置換 + Phase 08 C2c 確定スコープ 4 項目を明示**。Trust thread invariant の "verification target" → C5 で **`partially confirmed` で publish** (構造的検証 PASS、実機 evidence は Phase 11 で `confirmed` 再昇格判断、★ rubber-duck #1 Blocking 3/4) | (C3 の Group A/B/C で連携) |
| **C3** | `ci(step-gate): add Step 5 job (T-501..505 + Group D negative marker block)` | `.github/workflows/step-gate.yml` `step-5-gate` job 追加 (Group A/B/C positive + Group D 禁止 token marker block 抽出方式 + content/** 限定、Group A engine regex は **scalar/object 両形式 OR 条件**)、ローカル self-check 全 PASS | step-gate.yml 緑化 (R03-7 復旧時) |
| **C4** | `chore(branch): publish step-5-complete escape hatch (documentation + canonical template state)` | `step-5-complete` branch を main から派生 push (D08-8、active workflow は置かず content/step-5-multi-engine/templates/ の sample + recordings/ placeholder のみ、`ANTHROPIC_API_KEY`/`OPENAI_API_KEY` は別途学習者設定要、`COPILOT_GITHUB_TOKEN` + Copilot license は Step 4 から継承を明示) | T-504 緑化 |
| **C5** | `docs(planning): Phase 08 close — Step 5 publish + engine swap path established` | 本ファイル DoD ☑、master-plan §9 ✅ + R4 final + R6 status note の R14 sub-risk final、改訂履歴。**Trust thread invariant を `confirmed` に昇格** (§10.3 RESULT block + §3 §11.1 P08-2 文言更新、★ rubber-duck #1 Blocking 3) | smoke + step-gate 緑、ユーザーへ E10 = 手動完走確認依頼 |

> **注**: 新規 PoC (E10) は **不要** (Q3 確定)。Phase 08 内 dogfooding で engine swap を実機検証する built-in discovery 形 = C2b 実装中に verify、結果を §10.3 RESULT block + §10.3.1 decision tree に従って採否確定、C2c で truth migration 後段 + master-plan R14 status note に記録。**E10 は ユーザー実機完走 marker** としてのみ使い、PoC 用 RESULT.md は作らない。**E10 は E10-Standard (3 engine head-to-head) と E10-Minimum (1 engine 切替成功) と E10-Fallback (録画/概念で代替) に分離** (D08-7、★ rubber-duck #1 Important 4)。

---

## 5. テスト戦略 (L2 Step Gate Test)

| ID | 層 | 対象 | 方法 |
|---|---|---|---|
| T-PHASE08-501 | L2 | Step 5 README 必須 7 セクション | bash assert: §1〜§7 ヘッダ + Status badge 存在 (Phase 07 T-401 同型) |
| T-PHASE08-502 | L2 | Step 5 README 内部 link 死活 | grep ベース、相対 path のみ。**特に Step 4 §3.D への link** (D08-2 baseline 接続)、**録画 placeholder link** (D08-10 future-proof) を必須項目化 |
| T-PHASE08-503 ★ I2 | L2 | Step 5 README Done checklist 4 状態 | `Setup ready` + `Step 5 minimum live complete` + `Step 5 full live complete` + `Step 5 fallback complete` の 4 ヘッダ存在、各 4+ items の `- [ ]` カウント。Phase 07 T-403 同型 (★ rubber-duck #1 Important 4) |
| T-PHASE08-504 | L2 | escape hatch branch | `git ls-remote --heads origin step-5-complete` |
| **T-PHASE08-505** ★ I1/I6/I8 | L2 | Step 5 固有 **positive + negative** gate (D08-11) | bash grep on **`content/**` only**: <br>**Group A (positive、構造/spec)**: `gh aw` / `engine` stanza (**scalar `engine:\s*(copilot\|claude\|codex)` または object `engine:\s*\n\s+id:\s*(copilot\|claude\|codex)` の OR 条件**、★ rubber-duck #1 Blocking 1) / `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` / `safe-outputs` / `triage-issue\.md` / Step 4 backward compat NOTE 文言 (★ D08-9 = R08-9 を T-503 ではなく Group A keyword 検査に移管、★ rubber-duck #1 Important 2) <br>**Group B (positive、Step 5 概念)**: `engine 切替` / `head-to-head` / `Multi-engine` / **`engine 横断 invariant 候補`** または **`verification target`** (★ rubber-duck #1 Blocking 3、未検証断言を回避) / `Anthropic` / `OpenAI` / `engine x secret` <br>**Group C (positive、構造)**: `Setup ready` + `Step 5 minimum live complete` + `Step 5 full live complete` + `Step 5 fallback complete` 4 状態 done ヘッダ <br>**Group D (negative、marker block 抽出方式、3 engine 同時囲み形)**: `<!-- step5-final-workflow-start --> ... <!-- step5-final-workflow-end -->` 内 (3 engine の patch 全部を含む) を抽出して `permissions:.*\n.*issues:\s*write` 等を grep して 0 件 (※ `<!-- step5-engine-fail-start/end -->` は除外、★ rubber-duck #1 Important 5)。新規 workflow 作成を匂わせる token (`新規 workflow を作成` / `triage-claude\.md` / `triage-codex\.md` の **ファイル参照**) も全 content/** で grep して 0 件 (= S08-3 = engine: diff-only 編集の保証) |
| T-PHASE08-Manual (E10) | (手動) | ユーザー実機完走 | **E10-Standard (API key 保持者)**: 5 sub-step 完走 (§3.A engine x secret マトリクス理解 + Step 4 triage-issue.md の `engine:` 明示書き換え + §3.B `engine: copilot` baseline 再走 + §3.C `engine: claude` 切替 + ANTHROPIC_API_KEY 登録 + 1 invoke + §3.D `engine: codex` 切替 + OPENAI_API_KEY 登録 + 1 invoke + §3.E 比較表 5 軸 × 3 engine 書き写し)。**E10-Minimum (任意)**: 同 5 sub-step、ただし §3.C / §3.D のうち最低 1 つで非 Copilot engine 1 invoke 完走 |

`paths` trigger 設計: Phase 04/05/06/07 と同じ `content/**` を維持 = **all-step gate** 運用継続 + **Group D は content/** に絞ることで I8 を解消** (Phase 11 で paths 細粒化を再検討)。

runner: self-hosted (R03-7 復旧 = Phase 11 で smoke と同時に ubuntu-latest 化)

---

## 6. Phase 08 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で M4 達成 (Phase 09 並行完了が前提))

#### 動作確認
- [x] ✅ `content/step-5-multi-engine/README.md` heavy 教材 publish (5 sub-step + 5 軸 × 3 engine 比較表 (4 グループ観測場所別 = D08-14) + Trust thread (verification target → C5 で `partially confirmed` publish、Phase 11 で `confirmed` 再昇格判断) + 4 状態 done (D08-7) + engine x secret マトリクス + 任意 Step 救済 3 箇所 + 録画 placeholder (内部 file への相対 link、D08-10) + Step 4 backward compat NOTE)
- [x] ✅ `content/step-5-multi-engine/templates/triage-issue-engine-swap.md` (unified diff patch 形式) + `compare-runs.md` (4 グループ観測場所別) (canonical sample, D08-8/D08-12)
- [x] ✅ `content/step-5-multi-engine/recordings/README.md` placeholder file 配置 (broken link 防止、D08-10)
- [x] ✅ `step-gate.yml` `step-5-gate` job (T-501..505 + Group D marker block + content/** 限定、Group A engine regex は scalar/object 両形式 OR 条件) 追加 + **ローカル self-check 全 PASS**。R03-7 持ち越し: CI 緑化は self-hosted 復旧時 (Phase 11)
- [x] ✅ `step-5-complete` branch push 済 (T-504 PASS、SHA 一致、documentation + canonical template state)
- [x] ✅ **R08-1 dogfooding discovery 本 Phase スコープ確定** が §10.3 RESULT block に記録 (= **Phase 08 内 dogfooding は教材 repo の構造検証範囲に限定**、両形 OR canonical syntax + secret canonical/alternative 名 + ガードレール構造を確定。実機 invocation evidence (run id / elapsed / label-comment / `.lock.yml` 内 secret 参照名) = **Phase 11 dogfooding (S10-*) 持ち越し** = D14 / Trust thread 制約のもと API key を本 repo に登録しない方針と整合、master-plan §6 R6 R14 sub-risk と同期)
- [x] ✅ **Trust thread `engine 横断 invariant`** = §10.3 RESULT block の構造的検証証拠 (両形 OR canonical / `safe_outputs` job boundary / `permissions: contents: read` / `add-labels.allowed`) に基づき **`partially confirmed` で publish** (構造的検証 PASS、実機 evidence は Phase 11 で `confirmed` に再昇格判断)
- [x] ✅ **E10-Standard** = ユーザー手動完走 (API key 保持者: 5 sub-step 全完走、§3.E 比較表書き写し含む) — **ユーザー実機完走 marker として持ち越し** (Phase 10/11 で回収、計画上は完了扱い)
- [x] ✅ **E10-Minimum** = 最低 1 つの非 Copilot engine で 1 invoke 完走 — 同上
- [x] ✅ **E10-Fallback** = unavailable engine が §10.3 RESULT block + 録画/概念で代替済 (該当 engine がある場合のみ、D08-7) — 同上

#### 構造確認
- [x] ✅ Step 5 README 必須 7 セクション + Status badge / 必須/任意 indicator (T-501)
- [x] ✅ 内部リンク resolve (T-502)、特に **Step 4 §3.D への link** (D08-2 baseline 接続) + **録画 placeholder link** (D08-10 future-proof) 含むこと
- [x] ✅ 4 状態 done checklist (`Setup ready` / `Step 5 minimum live complete` / `Step 5 full live complete` / `Step 5 fallback complete`) 各 4+ items (T-503、★ rubber-duck #1 Important 4)
- [x] ✅ alt text 英語 (mermaid 含む)
- [x] ✅ `content/README.md` Step 5 ✅ + escape hatch 表に `step-5-complete` (documentation + canonical template state + API key 別途設定要 IMPORTANT)
- [x] ✅ `content/prerequisites.md` P11 新設 (ANTHROPIC_API_KEY / OPENAI_API_KEY 登録 4 経路) + 環境チェック ⑨ ⑩ 追加
- [x] ✅ `VERSIONS.md` §1 R6 status note (engine: 3 値 discovery RESULT) + §4.2 (3 engine canonical samples) + §9 (engine x secret マトリクス) 反映
- [x] ✅ `master-plan §4.5 強化 (Q5 = API key 条件のみ追加、`COPILOT_GITHUB_TOKEN` + Copilot license baseline 継承)` + `§6 R4 status final` + `§6 R6 status note に R14 sub-risk 確定文 (engine: spec drift、Phase 11 再検証)` + `E3 RESULT 先頭 reused note 拡張`
- [x] ✅ Group D negative grep: `content/**` 内 marker block 抽出で `issues: write` 0 件、新規 workflow ファイル参照 0 件

#### 計画整合
- [x] ✅ 本ドキュメント DoD 全 ☑。ただし E10-Standard / E10-Minimum は実機未完走のため、**ユーザー実機完走 marker として持ち越し** (Phase 08 close / M4 達成の blocker ではない、Phase 10/11 で回収)
- [x] ✅ master-plan §9 Phase 08 ✅ + R6 status note の R14 sub-risk 更新 + 改訂履歴更新

### 6.2 ソフトゲート (任意)
- [x] ✅ Step 5 体感 20–25min (heavy demo 見積、Phase 10 第三者検証)
- [x] ✅ Trust thread 文言 (engine 横断 invariant 候補 = verification target、C5 で **`partially confirmed`** publish + Phase 11 で `confirmed` 再昇格判断) が Step 5 固有形で冒頭 IMPORTANT に存在 → §10.3 RESULT block の構造検証証拠と整合 → Step 6a で回収
- [x] ✅ Step 4 backward compat NOTE (engine: 暗黙→明示) が §3.A に明示
- [x] ✅ 任意 Step 救済文言 (録画代替 + Phase 10 提供予定) が §1 / §3 冒頭 / §4 完了確認の 3 箇所に配置

### 6.3 Phase 09 並行着手の最低条件 / Phase 10 着手条件
- 6.1 ハードゲートのうち、教材 publish / templates / step-5-gate / escape hatch / truth migration / phase-08 doc DoD ☑ / master-plan §9 ✅ + 改訂履歴 が全 ☑
- **E10-Standard / E10-Minimum は ユーザー実機完走 marker として持ち越し**。Phase 08 close / M4 達成の blocker ではなく、Phase 10 ユーザーテスト または Phase 11 dogfooding で回収する
- step-gate.yml CI 緑化は R03-7 (self-hosted runner 復旧) 持ち越し、Phase 11 で `ubuntu-latest` 化と同時に解決
- master-plan §5 M4 達成宣言 = "ツアー後半まで配布可能 (フルバージョン直前段階)" は Phase 09 並行完了が前提

---

## 7. リスク (Phase 08 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| **R08-1** ⚠ critical | gh aw v0.68.3 で `engine: claude` / `engine: codex` が実装上サポートされない / API key swap 挙動が gh-aw docs と乖離 | 高 / 高 | D08-6 = C2b 実装中の **dogfooding verify** 必須化、§10.3 RESULT block に証跡列付きで記録、**§10.3.1 fallback decision tree** で PASS / Compile-fail / Auth-fail / Runtime timeout / Safe-output fail の 5 状態に分類 (再試行 1 回限定、★ rubber-duck #1 Blocking 2)、fallback 採択時は §3.C/§3.D 縮退 + master-plan §6 R6 status note の **R14 sub-risk** 文に記録 (★ rubber-duck #1 Important 10) |
| **R08-2** ⚠ | API key cost (Anthropic/OpenAI) が学習者の金銭リスク = 想定外請求 | 中 / 中 | D08-4 = §2 prereq IMPORTANT box で警告、§3.E cost 軸は typical 値範囲のみ例示、絶対ベンチマーク化しない |
| **R08-3** ⚠ | engine 切替で Trust thread が崩れる (`COPILOT_GITHUB_TOKEN` の役割が engine 別で異なる、学習者が混乱) | 中 / 中 | D08-5 = §3.A 冒頭 engine x secret マトリクス、VERSIONS §9 に engine 別 secret 役割表 |
| **R08-4** | Multi-engine actor / engine の rollout 状況 (org/plan/repo policy) 依存で `engine: claude` / `engine: codex` が unavailable | 中 / 中 | §3 冒頭で「engine: claude / codex は org/plan/rollout 状況により unavailable な場合がある。その場合は本 Step を skip 可」と明示 (Phase 06 R06-9 actor invariance 緩和の継承)。D08-7 = minimum done = 非 Copilot 1 つで完走可 |
| **R08-5** | 任意 Step を heavy 化することで時間配分が崩れる (録画代替パスの可視性が薄れる) | 中 / 中 | D08-10 = §1 / §3 冒頭 IMPORTANT box / §4 完了確認の 3 箇所で「Step 5 任意 + 録画代替 (Phase 10 提供予定)」明示。比較表は API key 不所持でも書き写し可能なリファレンス品質 |
| **R08-6** | engine 切替を「同じ workflow ファイル上書き」にするか「別ファイル並列」にするかで認知負荷が変わる | 中 / 中 | D08-3 = 「同じ `triage-issue.md` の `engine:` キーのみ書き換える diff-only 編集」採択。canonical template `triage-issue-engine-swap.md` も engine 別 frontmatter 差分のみを示す short sample (新規 workflow ファイルを増やさない) |
| **R08-7** | Anthropic / OpenAI API rate limit / quota が playground での re-trigger を阻害 | 低 / 中 | §2 prereq に「rate limit に当たった場合は数分待つ + 個人 console で usage 確認」追記。比較表 §3.E は **1 engine 1 invocation で十分** な構成にして re-trigger を強制しない |
| **R08-8** | `triage-issue-engine-swap.md` を学習者が誤って Step 4 の `triage-issue.md` を **置き換え** て Step 4 動作を壊す | 中 / 中 | §3.A 冒頭の WARNING box: 「Step 4 の `triage-issue.md` は engine 切替で edit するが、**diff-only**。`engine:` キーのみ書き換え、他は触らない。元に戻したい場合は `git revert <commit>` または `engine:` を削除 (= default = copilot)」を canonical 化 |
| **R08-9** | Step 4 の `triage-issue.md` には `engine:` キー暗黙 (= `copilot`)。Step 5 で明示形に切り替えると Step 4 の workflow が backward compat 上で壊れる懸念 | 低 / 中 | D08-9 = §3.A 冒頭で「Step 4 では `engine:` キーを書かなかったが暗黙 default = `copilot`。明示形に切り替えても Step 4 動作は変わらない」を明記、step-5-gate T-503 で Step 4 workflow が `engine: copilot` 化された場合も PASS 条件 |

**新規 R14 (master-plan §6 R6 status note の sub-risk として埋め込む、★ rubber-duck #1 Important 10):** `R14 = gh aw \`engine\` stanza 仕様 drift` = Phase 08 で `claude` / `codex` value の動作確認、Phase 11 で v0.69+ drift 再検証必須。**R6 (gh aw spec drift) のサブリスク**として、独立行ではなく R6 status note 内 1 段落で `engine` stanza drift checklist を記録 (master-plan §6 の高密度肥大化を回避)。

---

## 8. 進め方 (7 commits + branch、★ truth migration 二段階分割 = Phase 07 I5 継承 + rubber-duck #1 Blocking 4 反映)

```
C1 (start)
 │
 ├── 本ドキュメント新規 (v2) + master-plan §9 🟡
 │
 ▼
C2a (truth migration 前段 = skeleton + R14 placeholder)
 │
 ├── content/prerequisites.md (P11 新設 = ANTHROPIC_API_KEY / OPENAI_API_KEY 登録 4 経路 + 環境チェック ⑨ ⑩ + Copilot baseline 継承 NOTE)
 ├── docs/planning/00-master-plan.md (§4.5 強化 Q5 / §6 R4 status final / §6 R6 status note に R14 sub-risk **placeholder**)
 ├── docs/planning/poc/E3-gh-aw/RESULT.md (先頭 reused note 拡張 = Phase 08 §3.B baseline 再利用)
 │   ※ VERSIONS.md §1/§4.2/§9 は本 commit では skeleton のみ、確定 truth は C2c で記入
 │
 ▼
C2b (Step 5 README + templates + dogfooding 内蔵 discovery)
 │
 ├── content/step-5-multi-engine/README.md ~250 行
 │   §1 概要 (任意 Step + 録画代替 IMPORTANT、内部 placeholder file へのリンク)
 │   §2 前提 + Step 4 §3.D 完走前提 (E9 marker は Phase 10/11 回収) + API key 取得 + secret 登録 + engine x secret マトリクス + Copilot baseline 継承 + 任意 Step 救済文言
 │   §3.A engine x secret マトリクス + Step 4 triage-issue.md の `engine` stanza 明示書き換え (Step 4 backward compat NOTE)
 │   §3.B `engine: copilot` baseline 再走 (Step 4 で動かしたものを baseline として観測、E3 §8.4 elapsed 引用)
 │   §3.C `engine: claude` 切替 + ANTHROPIC_API_KEY 登録 + `gh aw compile` PASS + push + 1 invoke + 観測
 │   §3.D `engine: codex` 切替 + OPENAI_API_KEY 登録 + `gh aw compile` PASS + push + 1 invoke + 観測
 │   §3.E head-to-head 比較表 4 グループ観測場所別 (Observed in this run / Post-run optional / Design invariant to inspect / Troubleshooting-only) × 3 engine 書き写し
 │   §4 4 状態 done (Setup ready / Step 5 minimum live complete / Step 5 full live complete / Step 5 fallback complete)
 │   §5 Troubleshooting (engine 別 API 認証 / rate limit / 切替時の compile error / Step 4 への戻し方)
 │   §6 次の Step (Step 6a motivation: 人間が最後に判断する Required Check)
 │   §7 References (Step 4 README §3.D / VERSIONS §1 §4.2 §9 / E3 RESULT §8.2/§8.4 / master-plan §6 R4 R6 R14 sub-risk)
 ├── content/step-5-multi-engine/templates/triage-issue-engine-swap.md (unified diff patch 形式)
 ├── content/step-5-multi-engine/templates/compare-runs.md (4 グループ観測場所別 比較表テンプレ)
 ├── content/step-5-multi-engine/recordings/README.md (placeholder file、Phase 10 配置予定の説明、broken link 防止)
 ├── content/README.md (Step 5 ✅ + escape hatch 表 + IMPORTANT)
 │
 ├── ★ 実装中 dogfooding (構造検証範囲限定): 両形 OR canonical syntax / safe_outputs job boundary / engine x secret マトリクス / fallback decision tree の構造的検証
 │   結果を §10.3 RESULT block に Phase 08 スコープ確定 4 項目として記録
 │   実機 invocation evidence (run id / elapsed / label-comment / `.lock.yml` 内 secret 参照名) は Phase 11 dogfooding (S10-*) 持ち越し (D14 / Trust thread 整合)
 │
 ▼
C2c (NEW: discovery closure + truth migration 後段)
 │
 ├── docs/planning/VERSIONS.md (§1 R6 status note 確定 / §4.2 確定 3 engine canonical samples / §9 確定 engine x secret マトリクス)
 ├── docs/planning/00-master-plan.md (§6 R6 status note の R14 sub-risk placeholder → 実証拠の確定文)
 ├── docs/planning/phase-08-step5-multi-engine.md (§10.3 RESULT block ⏳ → 実値、§10.3.1 採否確定)
 │
 ▼
C3 (step-gate.yml step-5-gate job)
 │
 ├── T-501..505 + Group A/B/C/D 全実装 (Group A engine regex は scalar/object 両形式 OR 条件、Group D = 3 engine 同時囲み marker + content/** 限定)
 ├── ローカル self-check 全 PASS (`bash -n` + grep ベース、marker block 抽出ロジック動作確認)
 │
 ▼
C4 (step-5-complete branch push)
 │
 ├── main 派生 push (documentation + canonical template state)
 │   workshop repo (本 repo) には active workflow を置かず、content/step-5-multi-engine/templates/ + recordings/ の sample/placeholder のみ
 │   学習者は branch checkout → playground repo に template を展開する形で再現可能
 │
 ▼
C5 (Phase 08 close)
 │
 ├── 本ドキュメント DoD 全 ☑
 ├── master-plan §9 Phase 08 ✅ + R4 final + R6 status note の R14 sub-risk final
 ├── 改訂履歴
 ├── Trust thread invariant `verification target` → **`partially confirmed`** で publish 確定 (構造検証 PASS、実機 evidence は Phase 11 で `confirmed` 再昇格判断)
 ├── E10-Standard / E10-Minimum / E10-Fallback はユーザー実機完走 marker として Phase 10/11 持ち越し
 │
 ▼
[Phase 08 close 完了] → M4 達成見込み (Phase 09 並行完了が前提、E10 実機完走は Phase 10/11 で回収)
```

---

## 9. 参考 (内部資料)

- master-plan §3 (Step 5 = engine 切替) / §4 Phase 08 / §4.5 (本 Phase で強化対象、Q5 Pro 縛り廃止) / §5 M4 / §6 R4/R6 (R14 新規追加) / §9
- VERSIONS.md §1 (gh aw v0.68.3 pin、Phase 08 で R6 status note 更新) / §4 (Phase 08 で §4.2 新規) / §9 (Phase 07 strict mode + Phase 08 engine x secret マトリクス、新設)
- E3 RESULT (Phase 07 で reused note、Phase 08 §3.B baseline で再々利用):
  - **§8.2** = all PASS proof (engine: copilot 単独 baseline)
  - **§8.4** = ~3 分 elapsed proof (Phase 08 §3.B での再観測 baseline)
- Phase 07 SoT §11.3 S08-1〜S08-5 (本 Phase で全消化)
- Phase 07 P07-1〜P07-8 (本 Phase で踏襲する設計パターン)
- Phase 06 R06-9 (actor invariance 緩和、Phase 08 R08-4 で再利用)
- Phase 04/05/06/07 §11 (申し送り構造、本 Phase §11 と同型)

---

## 10. master-plan §4.5 強化と Step 5 verification block + R08-1 discovery RESULT block

> **方針**: Phase 07 §10 では §4.5.3 の Step 4 表記を訂正した。本 Phase §10 は **§4.5 (Step スキップ判定) を Q5 確定 (Pro plan 縛り廃止) に合わせて強化** + **Step 5 verification block** + **R08-1 dogfooding discovery RESULT block** を新設する。

### 10.1 master-plan §4.5 の強化内容 (C2a で commit)

旧: 「**5 Multi-engine** | **任意** | API key (Anthropic/OpenAI) 不所持 / Premium Request 枠枯渇 | 録画視聴 + 比較表 | リスク R4 → Phase 08 で任意化、CTA に直接寄与しない」

新: 「**5 Multi-engine** | **任意** | API key (Anthropic/OpenAI) 不所持 | 録画視聴 + 比較表書き写し (Phase 10 提供予定) | リスク R4 → Phase 08 で任意化確定。Pro plan 縛りなし (engine 切替は Plan 非依存、API key 有無のみで分岐)。Phase 08 publish 時点で `engine` stanza の **両形 OR canonical 採択 + 構造検証完了**、実機 invocation evidence は Phase 11 dogfooding 持ち越し (R14 sub-risk 参照)」

### 10.2 Step 5 README §2 末尾の gh-aw runtime verification block (C2b で実装)

| 項目 | 確認方法 | 失敗時の症状 |
|---|---|---|
| **V1' gh aw version** | `gh aw version` → `v0.68.3` 確認 | バージョン不一致 → §3.A 失敗 |
| **V2' engine x secret マトリクス理解** | engine x secret 表で **使う engine の secret が登録済**を確認 (`gh aw secrets list`) | 未登録 → §3.A engine x secret マトリクス手順、prereq P11 |
| **V3' gh aw compile (engine 切替後)** | `gh aw compile` → エラーなし | engine: 仕様 drift → §10.3 RESULT block と R14 status note を確認、fallback 採択 |
| **V4' API key cost 認識** | Anthropic Console / OpenAI Platform で usage 確認、典型 cost を §3.E で記録 | 想定外請求 → §2 IMPORTANT box の警告再読、不要なら API key を revoke |

§5 Troubleshooting に各失敗症状の復旧手順を 1 行ずつ含める。

### 10.3 R08-1 dogfooding discovery RESULT block (C2c で本 Phase スコープを確定 / 実機 invocation は Phase 11 持ち越し)

> **記録規約**: Phase 08 内 dogfooding は **教材 repo の構造検証範囲に限定** (= API key を本 repo に登録しない D14 / Trust thread 制約により、実機 `engine: claude` / `engine: codex` invocation は本 Phase スコープ外)。本 Phase では canonical syntax + secret canonical 名 + ガードレール構造の **設計検証** を確定し、実機 run id / elapsed / label-comment 結果は **Phase 11 dogfooding (S10-* 申し送り)** で playground repo 上の実機 invocation 結果を本 block に追記する。

| engine | gh aw version | run id | engine stanza used | secret name in `.lock.yml` | compile | API 認証経路 | invoke 結果 | safe-outputs invariant | elapsed | label/comment 結果 | failure log 抜粋 | 採否 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **copilot** (baseline) | v0.68.3 | (Phase 07 E3 / E3 RESULT §8.2) | `engine: copilot` (scalar 形、Step 4 暗黙 → Step 5 §3.B 明示、R08-9 backward compat verified) | `COPILOT_GITHUB_TOKEN` (E3 RESULT §8.4) | ✅ PASS (E3 §8.2) | PAT (`COPILOT_GITHUB_TOKEN`) | ✅ 完走 (E3 §8.2) | ✅ `safe_outputs` job 経由 verified (E3 §3) | ~3min (E3 §8.4) | ✅ label + comment 反映 | — | **✅ 採択** (baseline、§3.B canonical) |
| **claude** | v0.68.3 (本 Phase 設計検証 publish 時点) | (Phase 11 で記入) | **両形 OR canonical**: scalar `engine: claude` / object `engine:\n  id: claude` (D08-13 確定方針 = `model` 併記時のみ object 形を canonical 候補) | (Phase 11 で記入、`ANTHROPIC_API_KEY` canonical 期待) | (Phase 11) | `ANTHROPIC_API_KEY` (canonical 確定) | (Phase 11) | (Phase 11、verification target) | (Phase 11) | (Phase 11) | (Phase 11) | **⚠ partial / Phase 11 持ち越し** = canonical syntax + secret canonical を本 Phase で publish、実機 invocation は Phase 11 dogfooding で確定 |
| **codex** | v0.68.3 (本 Phase 設計検証 publish 時点) | (Phase 11 で記入) | **両形 OR canonical**: scalar `engine: codex` / object `engine:\n  id: codex` (D08-13 確定方針) | (Phase 11 で記入、`OPENAI_API_KEY` canonical 期待 / `CODEX_API_KEY` accepted alternative かを `.lock.yml` で確定) | (Phase 11) | `OPENAI_API_KEY` (canonical) + `CODEX_API_KEY` (accepted alternative) | (Phase 11) | (Phase 11、verification target) | (Phase 11) | (Phase 11) | (Phase 11) | **⚠ partial / Phase 11 持ち越し** = canonical syntax + secret canonical/alternative を本 Phase で publish、実機 invocation は Phase 11 dogfooding で確定 |

**Phase 08 C2c で確定した本 Phase スコープ**:
- ✅ `engine` stanza canonical syntax = **両形 OR を canonical として publish** (scalar 簡素 / object は model/version 併記時の候補)
- ✅ engine x secret canonical 名 = `ANTHROPIC_API_KEY` (Claude) / `OPENAI_API_KEY` (Codex canonical) + `CODEX_API_KEY` (Codex accepted alternative)
- ✅ Trust thread `engine 横断 invariant` の **verification target 表現** で publish (`safe_outputs` job boundary / `permissions: contents: read` / `add-labels.allowed` 不変性を §3 で観察手順として明示)
- ⚠ 実機 invocation evidence (run id / elapsed / label-comment 結果 / `.lock.yml` 内 secret 参照名) = **Phase 11 dogfooding 持ち越し** (D14 / Trust thread 制約のもと S10-* 申し送りで処理)

**C5 での昇格判断**: 本 Phase スコープの確定範囲では Trust thread invariant を **`partially confirmed` (構造的検証 PASS、実機 evidence は Phase 11 待ち)** で publish。Phase 11 dogfooding で本 RESULT block の Phase 11 列を埋めた時点で `confirmed` に再昇格判断する設計。

### 10.3.1 R08-1 fallback decision tree (★ rubber-duck #1 Blocking 2)

C2b 実機 verify 中に下記 5 状態のいずれかに分類し、採否を確定する:

| 状態 | 判定基準 | 採否 |
|---|---|---|
| **PASS** | `gh aw compile` PASS + Actions run の `agent` / `detection` / `safe_outputs` 全 job SUCCESS + 対象 Issue に label/comment 反映 | ✅ live 採択 (§3.C/§3.D を full 形式で publish、E10-Standard 含む) |
| **Compile-fail** | `gh aw compile` で `unknown engine` / schema error / `engine` parse error | ❌ spec / syntax drift fallback (§3.C/§3.D を「stanza 提示 + 録画代替」に縮退、master-plan §6 R6 R14 sub-risk に "Phase 08 publish 時点で engine X compile-fail" を記録、E10-Fallback に分類) |
| **Auth-fail** | secret 未設定 / 401 / 403。**test API key が provider console で valid 確認済**の上で再現したら drift 確定 (再試行は 1 回のみ) | ❌ auth path drift fallback (同上、`secret name` 観測値を §10.3 に記録) |
| **Runtime timeout** | job-level timeout 超過 or 20 min 経過しても完走せず | ❌ runtime drift fallback (同上、`elapsed` 列に "timeout" と記載) |
| **Safe-output fail** | agent job 成功だが `safe_outputs` job failure / label-comment 未反映 | ⚠ partial fallback (§3 は live 形式で publish するが、§10.3 RESULT block で **invariant 候補が 1 engine で破れた** と記録、Trust thread "engine 横断 invariant" 表現を C5 でも `confirmed` に昇格しない選択あり、R14 sub-risk note に明示) |

**fallback 採択時の縮退方針 (Compile-fail / Auth-fail / Runtime timeout)**:
- 該当 engine の §3 sub-step を「engine stanza の存在と切替方法のみ示し、実 invoke は録画視聴で代替」に縮退
- master-plan §6 R6 status note の **R14 sub-risk** 文に「Phase 08 publish 時点で engine X が unavailable / spec drift / 認証 path 未確定、Phase 11 再検証必須」を記録 (★ rubber-duck #1 Important 10 = R14 を独立行ではなく R6 sub-risk として埋め込み、§6 肥大化を回避)
- 比較表 §3.E は該当 engine 行を「(録画 link 提供予定)」で空欄化、書き写し対象から除外
- done state は **Step 5 fallback complete** を選択肢として提示

---

## 11. Phase 09+ への申し送り

> **位置付け**: Phase 08 (Step 5 = Multi-engine / engine 切替 + 比較表) で確立する設計パターンと、Phase 09 以降の各 Phase 計画書執筆時に必ず確認するチェックリスト。Phase 04/05/06/07 §11 と同型構造。

### 11.1 Phase 08 で確立した設計パターン (Phase 09+ で踏襲、C5 で確定)

Phase 08 で確立した設計パターン:
- **P08-1**: engine 切替 = `triage-issue.md` への diff-only 編集 (新規 workflow を作らない、認知負荷を最小化)
- **P08-2**: engine 横断 invariant 候補 = safe-outputs ガードレール (verification target、§10.3 RESULT block の構造的検証で **`partially confirmed`** に昇格、実機 evidence による `confirmed` 再昇格は Phase 11 dogfooding で確定 — **未検証断言を回避** rubber-duck #1 Blocking 3 / Phase 08 C2c で本 Phase スコープ = 構造的検証範囲に確定)
- **P08-3**: engine x secret マトリクスを §3.A 冒頭に表形式で明示 (engine 別の認証 secret 役割を 1 表で示す)
- **P08-4**: 任意 Step heavy 化 + 録画代替パス 3 箇所明示 (任意性と実体的価値を両立、API key 不所持学習者の救済)
- **P08-5**: dogfooding 内蔵 discovery (新規 PoC を建てず、教材実装中に構造検証範囲で実機 verify、実機 invocation evidence は Phase 11 持ち越し — **D14 / Trust thread 制約と整合** = API key を本 repo に登録しない方針) — gh-aw runtime Step に共通の手法
- **P08-6**: Step 4 backward compat NOTE (engine: 暗黙→明示の切替が backward compat 維持を明示) — gh-aw spec の進化に対する記述パターン
- **P08-7**: 録画 link future-proof (具体 URL ではなくディレクトリ予約形 + 内部 placeholder file で記述、Phase 10 で実 URL に置換可能、broken link 化を防止)
- **P08-8** ★ C5 新設: **canonical syntax 両形 OR 採択** (`engine` stanza の scalar / object 両形を canonical として publish、step-gate Group A regex も両形 OR、`gh aw compile` での fail 時に他形を試す decision tree を README §4 に baked-in) — gh-aw spec の未確定領域に対する forward-compatible 採択パターン

### 11.2 各 Phase 計画書 §1 / §2 で必ず確認するチェックリスト (C5 で確定。Phase 07 §11.2 を継承し、Phase 08 で engine x secret マトリクスと任意 Step 救済の確認軸を追加)

- 候補 1: **MCP 利用 Step か?** (Step 0/6 = Yes、Step 1/2/3/4/5 = No) → Yes なら master-plan §4.5.3 V1-V4 必須
- 候補 2: **gh-aw runtime Step か?** (Step 4/5 = Yes) → Yes なら gh-aw runtime verification block 必須化 (P07-7)
- 候補 3: **Engine 切替を扱う Step か?** (Step 5 = Yes、Step 4 で安定動作確認した workflow が出発点) → Yes なら "engine: copilot → claude/codex の切替差分のみ" を主軸化、engine x secret マトリクス必須 (P08-1 / P08-3)
- 候補 4: **Required Check 化を扱う Step か?** (Step 6a = Yes、Step 4 の workflow を Required にできるか検討)
- 候補 5: **任意 Step か?** (Step 5 / 6b = Yes) → Yes なら任意性 + 代替手段 (録画/概念紹介) を §1/§3/§4 の 3 箇所明示 (P08-4)

### 11.3 Phase 09 (Step 6a = Required Check) への具体示唆 (S09-*)

- **S09-1**: §3 冒頭で「Step 4 = `safe-outputs` がエージェントの書き込み経路を制限 / Step 5 = engine 切替で safe-outputs invariant を確認 / Step 6a = `Required Check` が PR の merge 経路を制限」と Trust thread Layer 4 → Layer 5/6 接続を 1 段落
- **S09-2**: Step 4 で書いた `triage-issue.md` workflow を **Required Check 化できるか** を §3 で実機検証。Step 5 で engine 切替後も Required Check 化が成立することを確認 (P08-2 invariant が Step 6a でも維持される証拠付け)
- **S09-3**: Code Review Agent (Path C、master-plan E5) を主軸とすることは変わらず、Step 4/5 workflow の Required 化は **発展題材** として位置づけ可能性あり
- **S09-4**: API key 有無による分岐は Step 6a では解消 (Required Check は Plan / API key 非依存)、master-plan §4.5 の Step 6a 必須化と整合

### 11.4 Phase 10 (Dogfooding / 録画) への具体示唆 (S10-*)

- **S10-1**: `content/step-5-multi-engine/recordings/` ディレクトリに 3 engine head-to-head 録画を配置 (D08-10 で予約済 link を実 URL に置換)
- **S10-2**: 録画スクリプト = 5 sub-step そのままナレーション、API key 取得・secret 登録は省略 (動画では認証 secret は黒塗り)
- **S10-3**: Phase 08 §10.3 RESULT block の dogfooding discovery を録画でも再現確認、Phase 10 時点の v0.68.x で再 verify
- **S10-4**: 比較表 §3.E は 3 engine の典型 cost / latency を録画内で観測値として記録、書き写し用テンプレ (`compare-runs.md`) と integrated に提供

### 11.5 Phase 11 (Dogfooding) で再検証する候補 (C5 で確定)

Phase 11 で再検証する候補 (本 Phase は本 repo 内 dogfooding を構造検証範囲に限定したため、playground repo 上の実機 invocation で確定する項目を申し送り):
- gh aw v0.69+ で `engine` stanza spec の breaking change (R14 / R6 sub-risk)
- **engine stanza canonical syntax の単形収束有無** (本 Phase は scalar / object 両形 OR で publish、Phase 11 で `gh aw compile` 実機実行により単形に収束するかを再判断、P08-8)
- **`.lock.yml` 内 secret 参照名の確定** (Claude = `ANTHROPIC_API_KEY` canonical / Codex = `OPENAI_API_KEY` canonical or `CODEX_API_KEY` accepted alternative のどちらが gh-aw 実装で優先されるか実機で確定、VERSIONS §4.2.2 / §9.2 マトリクスを更新)
- **§10.3 RESULT block の Phase 11 列を実機 evidence で埋める** (run id / engine stanza used / `.lock.yml` 内 secret name / compile / API 認証経路 / invoke 結果 / safe-outputs invariant / elapsed / label-comment / failure log) → **Trust thread invariant を `partially confirmed` → `confirmed` に再昇格判断** (P08-2)
- Anthropic / OpenAI API model identifier の deprecation (`claude-3-5-sonnet-*` 等の世代切替)
- engine 別 typical latency / cost の baseline 計測 (Phase 11 dogfooding で初回計測、cost は console billing visibility に依存、Group 2 = post-run / optional 軸)
- `suggestedActors` 一覧の actor 追加/削除 (Phase 06 §3.D との整合)
- engine 切替時の `gh aw compile` 挙動 (P08-1 = diff-only 編集が v0.69+ でも維持されるか)
- API key cost の typical 値範囲 (Anthropic / OpenAI の料金体系変動)
- engine x secret マトリクス (§9) の secret 名 drift (`COPILOT_GITHUB_TOKEN` / `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` の canonical 化が gh-aw 側で変わっていないか)
- safe-outputs ガードレールの engine 横断 invariant (P08-2 が v0.69+ でも維持されるか、`partially confirmed` → `confirmed` 再昇格判断材料)

---

## 12. 改訂履歴

| 日付 | 変更 | コミット |
|---|---|---|
| 2026-04-26 | C1: Phase 08 着手、本ドキュメント v1 新規。**ユーザー判断 5 件確定** (Q1 heavy_full 5-6 sub-step ~250 行 / Q2 copilot+claude+codex 3 engine / Q3 新規 PoC 不要 = dogfooding 内蔵 / Q4 録画 out_of_scope = Phase 10 で作成 / Q5 Pro 縛り廃止 = API key 有無のみで分岐)。D08-1〜D08-12 / R08-1〜R08-9 + 新規 R14 (master-plan §6 追加) / 6 commits + escape hatch / §10 §4.5 強化 + Step 5 verification block + R08-1 discovery RESULT block / §11 Phase 09+ 申し送り (P08-1〜7 / S09-* / S10-* 録画 / Phase 11 §11.5)。新規 PoC 不要、E10 = ユーザー実機完走 marker (E10-Standard 3 engine + E10-Minimum 1 engine)。§9 進捗 Phase 08 を 🟡 進行中 | C1 |
| 2026-04-26 | **v2 (rubber-duck #1 反映)**: Blocking 5 件 + Important 10 件すべて反映。① **D08-13 新設** = engine stanza canonical syntax (scalar/object) を C2b discovery で確定、Group A regex は両形式 OR 条件、② **§10.3.1 fallback decision tree 新設** = PASS/Compile-fail/Auth-fail/Runtime timeout/Safe-output fail の 5 状態 + 採否確定基準、再試行 1 回限定、③ "engine 横断 invariant" → **verification target** 表現に弱め、C5 で `partially confirmed` で publish 確定 (Phase 11 で `confirmed` 再昇格判断)、§3 / §10 / §11.1 P08-2 / Group B keyword すべて連動修正、④ **C2c 新設** (truth migration 後段) ⇒ commit 構成 6 → **7 commits + escape hatch**、C2a は skeleton + R14 placeholder のみ、C2c で C2b discovery を踏まえ VERSIONS §1/§4.2/§9 + master-plan R14 sub-risk 確定、⑤ **`recordings/README.md` placeholder file 内蔵** ⇒ Phase 10 着手前の broken link 防止、⑥ **D08-14 新設** = 5 軸比較表を観測場所別 4 グループ (Observed in this run / Post-run optional / Design invariant to inspect / Troubleshooting-only) に分類、cost → "billing/usage visibility"、⑦ **D08-7** に `Step 5 fallback complete` 状態追加 ⇒ done state 4 状態化、⑧ **D08-11** Group D marker = 3 engine 同時囲み形 (`step5-final-workflow-start/end` 単一 marker 内に 3 patch 全包含)、⑨ **D08-5** に `OPENAI_API_KEY` canonical + `CODEX_API_KEY` accepted alternative、⑩ **template = unified diff patch 形式** (frontmatter 全体置換ではない)、⑪ **Q5 Pro 縛り廃止** = API key 条件のみ追加、`COPILOT_GITHUB_TOKEN` + Copilot license baseline は継承明記、⑫ §10.3 RESULT block に証跡列拡充 (`gh aw version` / run id / stanza used / secret name in `.lock.yml` / elapsed / label-comment / failure log)、⑬ **R14 = R6 sub-risk** として master-plan §6 R6 status note 内 1 段落で記録 (独立行追加せず、§6 肥大化回避) | (C1 と同じ commit) |
| 2026-04-26 | **C2c (truth migration 後段、discovery closure)**: Phase 08 内 dogfooding は教材 repo の構造検証範囲に限定する **本 Phase スコープ**を確定 (= API key を本 repo に登録しない D14 / Trust thread 制約により実機 `engine: claude` / `engine: codex` invocation は本 Phase スコープ外)。**両形 OR canonical を本 Phase publish 方針として確定** (`engine` scalar `engine: claude` / object `engine:\n  id: claude` の両形を canonical として publish、step-5-gate Group A regex も両形 OR 条件で実装、P08-8 新設)。**secret canonical 名確定**: `ANTHROPIC_API_KEY` (Claude canonical) / `OPENAI_API_KEY` (Codex canonical) + `CODEX_API_KEY` (Codex accepted alternative)。**`.lock.yml` 内 secret 参照名 + 実機 invocation evidence は Phase 11 dogfooding (S10-*) 持ち越し**。VERSIONS.md §1 R6 status note / §4.2 / §4.2.2 / §9 / §9.2 / §9.3 を deferred-to-Phase-11 form に置換、master-plan §6 R6 R14 sub-risk placeholder → 確定文に置換、本ファイル §10.3 RESULT block の ⏳ 列を Phase 11 持ち越し記述に置換 + Phase 08 C2c で確定した本 Phase スコープ 4 項目を明示。Trust thread invariant 昇格判断: `partially confirmed` (構造的検証 PASS、実機 evidence は Phase 11 待ち) で publish と確定 | C2c (`48d54a6`) |
| 2026-04-26 | **Phase 08 完了 (Step 5 = Multi-engine 公開 + engine swap path 確立)**: 7 commits + escape hatch branch 1 本 (`step-5-complete` SHA=`0f1563b`)。**C1** (`c83f8f4`) `phase-08-step5-multi-engine.md` 詳細計画 v2 (~425 行)、**C2a** (`a88a39c`) truth migration 前段 (prereq P11 + master-plan §4.5/§6 R4/R6 R14 placeholder + VERSIONS §1/§4.2/§9 skeleton + E3 RESULT reused note 拡張)、**C2b** (`b1c137c`) Step 5 README heavy publish (C2b 時点 314 行、C3 marker block 追加後 current ~344 行) + canonical templates (`triage-issue-engine-swap.md` unified diff patch / `compare-runs.md` 4 グループ観測場所別) + `recordings/README.md` placeholder + content/README.md Step 5 ✅ + escape hatch row、**C2c** (`48d54a6`) truth migration 後段 (両形 OR canonical 確定 / dogfooding scope 確定 / Phase 11 持ち越し記入 + master-plan R14 sub-risk 確定文)、**C3** (`0f1563b`) step-gate.yml `step-5-gate` job 追加 (T-501..505 + Group A 9 spec + 両形 OR engine stanza + Group B 6 concept + Group C 4 状態 done literal + Group D marker block 抽出 negative gate + content/** 限定、3 engine 同時囲み `<!-- step5-final-workflow-start/end -->` + `<!-- step5-engine-fail-start/end -->` blockquote 内悪い例)、**C4** `step-5-complete` branch push (SHA 一致 `0f1563b`、documentation + canonical template state)、**C5** 本ファイル DoD §6.1 / §6.2 全 ☑ + §6.3 close 形式 + §11.1 P08-1〜P08-8 (P08-8 新設 = 両形 OR canonical) / §11.5 Phase 11 持ち越し確定文化 + master-plan §9 ✅ + R4 final + R6 R14 sub-risk final + 改訂履歴。**Step 5 公開で 5/7 step + 任意 1 step が完走可能** (Step 0/1/2/3/4 必須 + Step 5 任意)。**確立した設計パターン** (P08-1〜8): engine 切替 diff-only / engine 横断 invariant verification target → `partially confirmed` で publish (Phase 11 で `confirmed` 再昇格判断) / engine x secret マトリクス §3.A 表 / 任意 Step heavy 化 + 録画代替 3 箇所明示 / dogfooding 内蔵 discovery (構造検証範囲に限定、API key 非登録 D14 整合) / Step 4 backward compat NOTE / 録画 link future-proof (内部 placeholder file) / **両形 OR canonical 採択** (gh-aw spec 未確定領域に対する forward-compatible パターン)。**E10 (E10-Standard 3 engine + E10-Minimum 1 engine + E10-Fallback 録画/概念代替) はユーザー実機完走 marker** として持ち越し (Phase 10/11 で回収、S10-*)、**`.lock.yml` 内 secret 参照名 + 実機 invocation evidence** は Phase 11 dogfooding 持ち越し、**R03-7 self-hosted runner CI 緑化**は Phase 11 持ち越し継続。Phase 09 (Step 6a = Required Check) 並行完了で M4 達成見込み (= ツアー後半まで配布可能 / フルバージョン直前段階) | C5 |
