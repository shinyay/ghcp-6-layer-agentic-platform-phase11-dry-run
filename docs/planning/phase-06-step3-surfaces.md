# Phase 06 — Step 3 教材化 (Where to Run = 3 surfaces)

> **このフェーズの本質**: Phase 05 (Step 2 ⭐ Skill = keynote CTA) の **直後**。Step 2 で commit した同じ `SKILL.md` を **3 つの実行 surface** (IDE Chat / Copilot CLI / Cloud Agent) から呼び、surface 特性差 + **publication boundary** を体感する **必須 Step**。M2 (keynote CTA) は Step 2 完了で達成済 → Phase 06 は **Standard / Full プロファイル学習者** をゴールへ運ぶ Step。
> Step 3 = 「Chat (IDE) で `file:///` 直読みを再観察 (Local invariance が published 後も維持) → CLI (`gh copilot`) で `/skills list` + 自然言語/明示 invoke の 2 形式 → Cloud Agent で Issue Assignees → Copilot 起動 (publication boundary 越境のクライマックス) → suggestedActors で Multi-engine teaser → 6 観点比較表で完了確認」。
> Phase 03/04/05 で確立した教材テンプレ (必須 8 セクション + Status badge + Trust thread 伏線 + escape hatch branch) を継承し、Phase 04/05 と同様 **MCP 非依存** Step として §4.5.3 V1-V4 を §10 で exempt 明示マッピング。
> **rubber-duck critique 12/12 全採用** (Blocking 5 / Non-blocking 4 / Suggestion 3) を baked-in。truth migration / Cloud 2 段階成功条件 / Pro plan degraded complete 正式化 / T-305 positive + negative gate / actor invariance 緩和を本計画書で確定。

---

## 1. Phase Goal

### 1.1 主目的
Step 0 で MCP 接続 + Step 1 で Memory + Step 2 で `SKILL.md` commit を済ませた学習者が、**約 18 分** の heavy demo (5 sub-step) を完走し、「**Skill = file 1 つ。それを Chat (IDE) / CLI / Cloud Agent の 3 surface から呼べる。Local invariance は Step 2 で見た — Step 3 では `commit + push + Issue に Copilot を assign` という publication boundary 越境を体感する**」を体験する。これにより keynote CTA の Standard / Full プロファイル学習者を **Cloud Agent 体験まで** 運ぶ。

### 1.2 Phase 完了時に手元にあるもの
1. **`content/step-3-surfaces/README.md`** — heavy demo (5 sub-step) 必須 8 セクション準拠 (~320 行)
2. **`docs/planning/VERSIONS.md` §2.8 新設** — Cloud Agent surface pin (起動方法 / Plan 要件 / Actions minutes / default code-fix mode / firewall default deny / suggestedActors GraphQL / 検証日 2026-04-25、E4 + E7' 引用)
3. **`docs/planning/VERSIONS.md` §6.3 P4 改訂** — 旧 truth (`copilot-swe-agent` / 「CLI が確実」) を E7' superseded note に書き換え
4. **`content/README.md` 更新** — Step 3 行 ✅ 公開中、`🪂 escape hatch` 表に `step-3-complete` 行追加 (documentation state only 文言)、Cloud Agent plan IMPORTANT 1 行
5. **`content/prerequisites.md` P4 改訂 + P9 新設** — P4 から旧 truth 削除 → P9 に集約、P9 = Cloud Agent (Pro+ / Business / Enterprise / Settings → Coding agent enable / Issue Assignees → Copilot 起動 (F19) / Actions minutes 消費 (F20) / default code-fix mode (F21) / firewall default deny (R10))
6. **`docs/planning/00-master-plan.md` §6 R3 superseded note** — E7' で正規トリガが Issue Assignees → Copilot に確定
7. **`docs/planning/poc/E4-cloud-skill/RESULT.md` 先頭 superseded note** — トリガ truth は E7' で更新
8. **`.github/workflows/step-gate.yml` 拡張** — `step-3-gate` job (T-301..305 + Group A/B/C positive + **Group D negative**)
9. **`step-3-complete` ブランチ** — escape hatch (**documentation state only — Cloud 観察は branch では再現できない**)
10. **本ドキュメント** (`phase-06-step3-surfaces.md`) — DoD 全項目 ☑
11. master-plan §9 Phase 06 を ✅ + 改訂履歴

### 1.3 マイルストーン
master-plan §5 の **M3 (Step 0-3 公開で Standard プロファイルが Cloud Agent 体験まで完走)** を達成。Step 4 以降は希望者向けツアー。Pro plan 学習者は Step 3 §3.C を screenshot/録画代替で完走 (= **Step 3 degraded complete**)、Step 4 §3.X で初の Cloud Agent 実機体験へ接続 (S07-6)。

---

## 2. Scope

### 2.1 IN SCOPE

| 対象 | 何を作るか |
|---|---|
| `content/step-3-surfaces/README.md` | heavy demo (5 sub-step ~18min) 必須 8 セクション準拠、§2 NOTE に Memory bootstrap 誘導 + playground repo preflight (public + Actions 有効 + clean repo)、§3 = 3.A Chat / 3.B CLI / 3.C Cloud Agent / 3.D Multi-engine teaser / 3.E 比較表、§4 完了確認は **2 段階** (Local crossed / Cloud crossed (minimum) / Cloud triage observed (full)) |
| `content/README.md` | Step 3 行 🚧 → ✅、`🪂 escape hatch` 表に `step-3-complete` 行追加 (documentation state only)、Cloud Agent plan IMPORTANT 1 行 |
| `content/prerequisites.md` | **P4 改訂** (旧 truth 削除 → P9 参照)、**P9 新設** (Cloud Agent)、環境チェックに「Settings → Copilot → Coding agent Enabled 確認」+「Issue Assignees に Copilot が picker 表示されるか確認」を追加 |
| `docs/planning/VERSIONS.md` | **§2.8 新設** (Cloud Agent surface pin)、**§6.3 P4 改訂** (旧 truth → superseded note) |
| `docs/planning/00-master-plan.md` | §9 Phase 06 ✅ + §6 R3 superseded note + 改訂履歴 (着手 + 完了) |
| `docs/planning/poc/E4-cloud-skill/RESULT.md` | 先頭に "⚠ Superseded by E7' (2026-04-25) for trigger truth" note (本体は動作根拠として有効、起動方法のみ E7' 優先) |
| `.github/workflows/step-gate.yml` | `step-3-gate` job 追加 (T-301..305 + Group A/B/C positive + **Group D negative**) |
| `step-3-complete` branch | main 派生 push (**documentation state only — Cloud 観察は branch では再現できない**) |
| 本ドキュメント | Phase 06 詳細計画書 |

### 2.2 OUT OF SCOPE (Phase 07+)

- Step 4-6 本文 (Automate / Multi-engine / Gate)
- Step 3 §3.D での **実 invoke** (= Multi-engine teaser は **suggestedActors 一覧確認のみ、実 invoke 禁止** = カニバリ防止、Step 5 が責務)
- gh aw triage workflow (Phase 07)
- 実機スクリーンショット (Phase 11)
- Pro plan 学習者向け Cloud Agent 録画 (Phase 10、本 Phase では文字 + screenshot 引用のみ)
- 新規 PoC (E8 等) は **不要** = E4 RESULT + E7' (PR #8) で根拠十分、E8 はユーザー手動完走 marker としてのみ使用

### 2.3 設計判断 (D1-D20)

ユーザー判断 (D1-D2 + U-C/U-D) と私の判断 (D3-D20、rubber-duck critique 12/12 全採用):

| # | 論点 | 採用案 | 根拠 |
|---|---|---|---|
| **D1** | demo 厚さ | **heavy ~18min** = 5 sub-step | ユーザー判断 (U-A) |
| **D2** | surface 順序 | **Chat → CLI → Cloud Agent → Multi-engine teaser → 比較表** | ユーザー判断 (U-B) |
| **D3** ⚠ | Cloud Agent assign 方法 | **Web UI 推奨** (Issue 右サイド Assignees → Copilot)、CLI (`gh issue edit N --add-assignee Copilot`) は **TIP 扱い** (環境により "Bot does not have access" で fail することを §5 Troubleshooting に明記)。**`@copilot` mention だけでは起動しない (F19) を §5 で明示** | F19 (E7' 実機) / critique #1, #5 |
| **D4** ⚠ | Cloud Agent Issue body 必須テンプレ | **Issue body 冒頭に `Use the issue-triage skill to triage this issue.`** (slash 無し、E7' 実証文言) を明示。本文に triage 対象の状況描写を 2-3 行。**Good/Bad Issue body の対比例**を §3.C に併記 (Bad 例 = "Fix the pagination bug" 単独 → code-fix mode に落ちる)。Troubleshooting に「slash 付き `/issue-triage` は CLI 文化、Cloud Agent では未保証」 | F21 (E7' 実機) / critique #2 |
| **D5** ⚠ | playground repo prereq | §2 で playground repo の default branch に `.github/skills/issue-triage/SKILL.md` が **push 済** であることをハード前提化 + **verify コマンド** (`gh api repos/<owner>/<repo>/contents/.github/skills/issue-triage/SKILL.md --jq .name`) を提示 (200 OK = ready)。**追加: playground repo は public + Actions 有効 + clean repo 推奨** (既存 `.github/copilot-instructions.md` / auto-label workflow / 独自 workflow が無いこと) | S06-1 / R05-7 引き継ぎ / critique #9 |
| **D6** ⚠ | 比較表 (§3.E) | **6 観点 × 3 surface**: ① 実行場所 / ② publication 要件 / ③ 観測トレース / ④ レイテンシ / ⑤ **読む state / source of truth** (= workspace file / current branch state / default branch pushed state) / ⑥ 適用シーン。**(改訂 critique #6: 旧 ⑤「共有可視性」を「読む state」に置換)**。1 表で keynote 視聴者向けの "持ち帰り資料" 化、Step 3 核心 = "どの state を読むか" を表で可視化 | S06-2 改訂版 / critique #6 |
| **D7** ⚠ | Multi-engine teaser sub-step (§3.D) | `gh api graphql -f query='{ repository(...) { suggestedActors(capabilities: CAN_BE_ASSIGNED) { ... } } }'` で **利用可能 actor の観察**。**期待値: Copilot 必須 / Claude (`anthropic-code-agent`) / Codex (`openai-code-agent`) は bonus** (plan/org/repo rollout 状況で actor 一覧は変わる、3 並列 invariant は不可)。**実 invoke は禁止** (Step 5 とのカニバリ防止)、actor が 1 つしか見えなくても §3.D は完了扱い (screenshot/reference で補完)。§6 で「Step 3 = actor discoverability / Step 5 = head-to-head 比較実験」と責務分離明記 | U-D / E4 §2 / Step 5 との責務分離 / critique #7 |
| **D8** ⚠ **2 段階定義** | Cloud Agent observation 観点 (§3.C 後半) | **Cloud crossed (minimum)** = (a) Assignees → Copilot で起動 (b) `copilot/<auto-named>` branch 自動生成 (c) draft PR 自動生成 → ここまで観察できれば §3.C 完了扱い (= F20 quota 切れでも到達可能、E7' PR #8 で実証済)。**Cloud triage observed (full)** = (d) PR title が triage 内容反映 (e) PR body に "Initial plan" + "Tasks" checklist (f) Used skill 参照 (g) firewall default deny → workflow file PR で迂回の Trust thread 観察 (E4 §4) (h) Verified Signed Commits (E4 §7) → quota 余裕がある Pro+ 学習者向けの拡張観察 | E4 RESULT §3-§7 / critique #3 |
| **D9** ⚠ | Cloud Agent quota-block escape valve (★ R06-1) | D8 の **Cloud crossed (minimum) = branch + draft PR 生成まで** が達成できれば boundary 実証成立。Initial plan commit 直後に `copilot_work_finished_failure` (= F20) になっても問題なし、と §3.C に明示。E7' PR #8 の実機証跡を §5 に提示 (`copilot/...` branch + draft PR が生成された状態) | F20 (E7' 実機) / critique #3 |
| **D10** | Cloud Agent 有効化前提 | §2 で Settings → Copilot → Coding agent → Enabled を確認 (E7' UI walk)、Plan = Pro+ / Business / Enterprise を明記 | E7' / R06-4 |
| **D11** ⚠ **完走定義 2 分岐** | Pro plan 学習者ケア (★ U-C) | §3.C 冒頭に IMPORTANT box: 「Cloud Agent は Pro+ 以上が必要。Pro plan の方は **本 sub-step を screenshot + 録画視聴で代替** (録画 link は Phase 10 で追加予定、現時点では E7' PR #8 + E4 RESULT §3-§5 の実機証跡を読む)」。**Step 3 完了の 2 分岐を §4 で正式化**: **Step 3 complete (Standard/Full プロファイル) = Cloud crossed (minimum) を含む 5 sub-step 完走** / **Step 3 degraded complete (Pro plan) = §3.A Chat + §3.B CLI + §3.D Multi-engine + §3.E 比較表 の 4 sub-step 完走 (§3.C は screenshot 視聴で代替)**。Step 4 prereq は「Pro 学習者は Step 4 §3.X で初めて Cloud Agent を実機体験」と明記 (S07-6 として申し送り) | U-C / critique #4 |
| **D12** ⚠ | IDE Chat sub-step (§3.A) の冗長性回避 | **Step 2 §3.D と差別化する観察点 1 つを固定**: **「push 後 (publication 後) でも Chat trace が `file:///` のまま」 = Local invariant が published 後も維持される** ことを確認。これは Step 2 では未観察 (Step 2 では未 push の状態で Local 即効を観察した)。**新規 Chat session を開いて再 invoke、トレース表記 (`スキル [issue-triage] の読み取り` 日本語、`file:///` link) を §3.E の比較表 Chat 行に書き写す**。冒頭で "Step 2 で見た Local 即効が、push 後も同じ場所 (`file:///`) を読み続けるか確認" と目的明示 | R06-6 / critique #8 |
| **D13** ⚠ **表現緩和** | step-3-complete escape hatch | main から派生 push (Step 2 と同型、内容は本 workshop repo の README 更新のみ含む)。**Step 3 は学習者の playground repo に新規ファイルを書かない** (skill 既 push 済が前提) ため、branch の意味は「**documentation state only — Step 3 README を読み終わった repo state のみ。Cloud 観察 (Assignees → Copilot で起動した branch + draft PR の現物) は branch では再現できない、各学習者が playground で実体験する必要あり**」と明文化 | P05-1 継承 / R06-5 / critique #11 |
| **D14** | Trust thread 伏線 (Step 3 固有文言) | 冒頭 IMPORTANT に: 「Cloud Agent は default で外部 API を叩こうとして **firewall でブロック** され、その代わりに **workflow ファイルを PR で提案** する = **人間の review を強制**する。これが Step 6a (Required Check) の "**人間が最後に判断する**" へ直結」 | E4 §4-§5 / Trust thread P05-2 継承 |
| **D15** | Memory bootstrap 注記 (§2) | "escape hatch (`step-2-complete`) で飛んできた場合、Memory が空でも本 Step は OK (Skill は Memory 非依存)。Memory 再現したい場合は Step 1 §3.A 参照" を §2 末尾 NOTE に置く (Step 2 と同型) | D15 of phase-05 継承 / P05-1 |
| **D16** ⚠ **positive + negative** | step-gate.yml 拡張 (T-301..305 + reframe) | C8 (T-205 reframe) と同型 + critique #5: **Group A 構造/spec keyword (positive)** (`Issue Assignees` / `Copilot` (assignee 文脈) / `gh copilot` / `default branch` / `playground` / `.github/skills/` / `GitHub Actions minutes`) + **Group B E7 reframe 概念 (positive)** (`publication boundary` / `propagation` / `firewall` / `default deny` / `code-fix mode` / `suggestedActors`) + **Group C 構造** (`Local crossed` + `Cloud crossed (minimum)` + `Cloud triage observed (full)` の 3 段階 done) + **Group D 禁止 token (negative)** (`copilot-swe-agent` / `@copilot mention だけで起動` / `CLI が確実` を learner-facing docs で grep して 0 件であること)。**gate 対象拡張**: `content/step-3-surfaces/README.md` だけでなく `content/prerequisites.md` / `docs/planning/VERSIONS.md` / `content/README.md` も Group D の対象に含める | S06-4 改訂 / C8 reframe pattern 継承 / critique #5 |
| **D17** | content/README.md 更新 | Step 3 行 🚧 → ✅ + escape hatch 表に `step-3-complete` 行追加 (意味 = "Step 3 README 完読 repo state、playground 側の SKILL.md push は学習者に依存") + IMPORTANT note で Cloud Agent plan 要件 1 行注記 | P05-1 継承 |
| **D18** | Commits 数 | **6 commits + escape hatch branch 1 本** (Phase 03/04/05 = 5 commits リズム + critique #10 で C2 を C2a/C2b 分割)。新規 PoC は **不要** (E4 RESULT + E7' 実証が再活用可能) | E4 / E7' 既存 / critique #10 |
| **D19** ⚠ | prereq P4 改訂 + P9 新設 | **P4 改訂**: `copilot-swe-agent` / 「CLI が確実」を削除 → P9 への参照に置換 + 「旧情報、F19 で更新」note。**P9 新設** (Cloud Agent): Pro+ / Business / Enterprise plan、Settings → Copilot → Coding agent enable、Issue Assignees → Copilot 起動 (F19)、Actions minutes 消費 (F20)、default code-fix mode (F21)、firewall default deny (R10)。環境チェックに "Settings 確認 + Issue Assignees に Copilot 表示確認" を追加 | F19-F21 / E4 / E7' / critique #1 |
| **D20** | Step 4 (gh aw) 接続 (§6) | "Step 3 の Cloud Agent は **手動で assign** が必要。Step 4 では **Issue opened で自動 assign** = `gh aw` が gate 役を担う" を §6 で 1 行接続。R10 (firewall default deny) も Step 4 で自動化対象として再登場予定 | Step 4 motivation / E3 / R10 |

---

## 3. ディレクトリ構造 (本 Phase 完了時の差分のみ)

```
.github/workflows/step-gate.yml         # 拡張: step-3-gate job 追加 (T-301..305 + Group A/B/C/D)、paths は content/** 維持
content/
├── README.md                           # 更新: Step 3 行 ✅ + 🪂 escape hatch 表に step-3-complete (documentation state only) + Cloud Agent plan IMPORTANT
├── prerequisites.md                    # 更新: P4 改訂 (旧 truth 削除 → P9 参照) + P9 新設 (Cloud Agent) + 環境チェック拡張
└── step-3-surfaces/
    └── README.md                       # 全面書き換え (現 38 行 stub → heavy demo 5 sub-step ~320 行)
docs/planning/
├── 00-master-plan.md                   # 更新: §6 R3 superseded note + §9 Phase 06 ✅ + 改訂履歴
├── VERSIONS.md                         # 更新: §2.8 新設 (Cloud Agent surface pin) + §6.3 P4 改訂 (旧 truth → superseded note)
├── phase-06-step3-surfaces.md          # 本ドキュメント (新規)
└── poc/
    └── E4-cloud-skill/
        └── RESULT.md                   # 更新: 先頭に superseded note (E7' で trigger truth を更新)

# branches:
#   main                                (本 Phase の全 commit)
#   step-3-complete                     (新規 escape hatch、main 派生、documentation state only)

# 注: 本 Phase で playground repo 側に新規ファイルは作らない (Step 2 で push 済の SKILL.md を読むのみ)。
# Cloud 観察 (Assignees → Copilot で起動した branch + draft PR の現物) は学習者が playground で実体験する必要あり。
```

---

## 4. 実装タスク (6 commits + branch / 線形依存)

| C# | Commit | 主ファイル | 自動テスト |
|---|---|---|---|
| **C1** | `docs(planning): start Phase 06 — add phase-06-step3-surfaces.md` | 本ファイル新規、master-plan §9 Phase 06 を 🟡、改訂履歴着手行 | smoke 影響なし (paths 外) |
| **C2a** | `docs(content): write Step 3 — Where to Run (3 surfaces)` | `content/step-3-surfaces/README.md` 全面書き換え (~320 行、5 sub-step + Trust thread + 比較表 D6 改訂版 + 2 段階 done + Pro plan IMPORTANT + Multi-engine teaser + Good/Bad Issue body 対比 + slash 無しテンプレ) | (C3 の T-301..303/T-305 で連携) |
| **C2b** | `docs: migrate Cloud Agent trigger truth (E7' findings F19-F21)` | **truth migration 群** (critique #1, #5 主要対応): `content/README.md` Step 3 ✅ + escape hatch + IMPORTANT、`content/prerequisites.md` P4 改訂 + P9 新設、`docs/planning/VERSIONS.md` §2.8 新設 + §6.3 P4 改訂、`docs/planning/00-master-plan.md` §6 R3 superseded note、`docs/planning/poc/E4-cloud-skill/RESULT.md` 先頭 superseded note | (C3 の Group D negative grep で連携) |
| **C3** | `ci(step-gate): add Step 3 job (T-301..305 + Group D negative)` | `.github/workflows/step-gate.yml` `step-3-gate` job 追加 (Group A 構造/spec + Group B E7 reframe 概念 + Group C 3 段階 done + Group D 禁止 token negative grep)、ローカル self-check 全 PASS | step-gate.yml 緑化 (R03-7 復旧時) |
| **C4** | `chore(branch): publish step-3-complete escape hatch (documentation state only)` | `step-3-complete` branch を main から派生 push (D13、documentation state only と明示) | T-304 緑化 |
| **C5** | `docs(planning): close Phase 06 — Step 3 published, DoD ☑` | 本ファイル DoD ☑、master-plan §9 ✅、改訂履歴 | smoke + step-gate 緑、ユーザーへ E8 = 手動完走確認依頼 |

> **注**: 新規 PoC (E8 等) は **不要** (E4 + E7' で根拠十分)。E8 は **ユーザー実機完走 marker** としてのみ使い、PoC 用 RESULT.md は作らない (= Phase 04 の E6 と同型扱い)。E7 walkthrough のような **想定外発見** が出たら Phase 06 内で refine commit を追加する余地は残す。

---

## 5. テスト戦略 (L2 Step Gate Test)

| ID | 層 | 対象 | 方法 |
|---|---|---|---|
| T-PHASE06-301 | L2 | Step 3 README 必須 8 セクション | bash assert: §1〜§7 ヘッダ + Status badge 存在 (Step 1/2 T-N01 同型) |
| T-PHASE06-302 | L2 | Step 3 README 内部 link 死活 | grep ベース、相対 path のみ (Step 1/2 T-N02 同型) |
| T-PHASE06-303 | L2 | Step 3 README Done checklist 3 段階 | `Local crossed` + `Cloud crossed (minimum)` + `Cloud triage observed (full)` の 3 ヘッダ存在、各 4+ items の `- [ ]` カウント |
| T-PHASE06-304 | L2 | escape hatch branch | `git ls-remote --heads origin step-3-complete` |
| **T-PHASE06-305** | L2 | Step 3 固有 **positive + negative** gate (D16) | bash grep: <br>**Group A (positive、構造/spec)**: `Issue Assignees` / `Copilot` (assignee 文脈) / `gh copilot` / `default branch` / `playground` / `\.github/skills/` / `GitHub Actions minutes` <br>**Group B (positive、E7 reframe 概念)**: `publication boundary` / `propagation` / `firewall` / `default deny` / `code-fix mode` / `suggestedActors` <br>**Group C (positive、構造)**: `Local crossed` + `Cloud crossed (minimum)` + `Cloud triage observed (full)` の 3 段階 done ヘッダ <br>**Group D (negative、禁止 token)**: `copilot-swe-agent` / `@copilot mention だけで起動` / `CLI が確実` を learner-facing docs (`content/step-3-surfaces/README.md` / `content/README.md` / `content/prerequisites.md` / `docs/planning/VERSIONS.md`) で grep して **0 件** |
| T-PHASE06-Manual (E8) | (手動) | ユーザー実機完走 | **Standard/Full プロファイル**: 5 sub-step 完走 (§3.A `file:///` 維持確認 + §3.B `/skills list` + 自動/明示 invoke + §3.C **Cloud crossed (minimum)** = Issue Assignees → Copilot 起動 + branch + draft PR 生成 + §3.D suggestedActors で Copilot actor 確認 + §3.E 比較表書き写し)。**Pro plan (degraded complete)**: §3.A + §3.B + §3.D + §3.E の 4 sub-step 完走 (§3.C は E7' PR #8 + E4 RESULT §3-§5 の screenshot 視聴で代替) |

`paths` trigger 設計: Phase 04/05 と同じ `content/**` を維持 = **all-step gate** 運用継続 (P04-5)。Phase 11 で paths 細粒化を再検討。

runner: self-hosted (R03-7 復旧 = Phase 11 で smoke と同時に ubuntu-latest 化)

---

## 6. Phase 06 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で Phase 07 着手可能)

#### 動作確認
- [x] ✅ `content/step-3-surfaces/README.md` heavy 教材 publish (5 sub-step + 比較表 + Trust thread + 3 段階 done + Pro plan IMPORTANT + Good/Bad Issue body 対比) ← C2a `31c708c`
- [x] ✅ `step-gate.yml` `step-3-gate` job (T-301..305 + Group D negative) 追加 + **ローカル self-check 全 PASS** ← C3 `205e7a2` (T-301/T-302 9 links/T-303 12 items/T-305 全グループ clean)。R03-7 持ち越し: CI 緑化は self-hosted 復旧時
- [x] ✅ `step-3-complete` branch push 済 (T-304 PASS、SHA=205e7a2、documentation state only と明示) ← C4
- [x] ✅ E8 = ユーザー手動完走 (Standard / Full プロファイル: §3.A IDE Chat + §3.B CLI + §3.C Cloud Agent on **ACI ephemeral self-hosted runner** ghrunner-aci-07 で完走、PR #11 commit `e371502`, 約 8 分。途中で発生した 4 つの障害 (firewall / ephemeral / private+token / setup-steps.yml 不在) はすべて §5 Troubleshooting に回収済)

#### 構造確認
- [x] ✅ Step 3 README 必須 7 セクション + Status badge / 必須 Step indicator (T-301)
- [x] ✅ 内部リンク resolve (T-302、9 links checked)
- [x] ✅ 3 段階 done checklist (Local crossed / Cloud crossed (minimum) / Cloud triage observed (full)) 各 4+ items (T-303、合計 12 items)
- [x] ✅ alt text 英語 (mermaid 含む)
- [x] ✅ `content/README.md` Step 3 ✅ + escape hatch 表に `step-3-complete` (documentation state only 文言) + Cloud Agent plan IMPORTANT ← C2b
- [x] ✅ `content/prerequisites.md` P4 改訂 (旧 truth 削除) + P9 (Cloud Agent) 追加 ← C2b
- [x] ✅ `VERSIONS.md` §2.8 (Cloud Agent surface pin) 追加 + §6.3 P4 改訂 ← C2b
- [x] ✅ `master-plan §6 R3` superseded note + `E4 RESULT` 先頭 superseded note (truth migration 完了) ← C2b
- [x] ✅ Group D negative grep: `copilot-swe-agent` / `@copilot mention だけで起動` / `CLI が確実` が learner-facing docs (`content/`) で 0 件 ← C3 self-check confirmed

#### 計画整合
- [x] ✅ 本ドキュメント DoD 全 ☑ (E8 のみユーザー実機完走待ち、計画上は完了扱い)
- [x] ✅ master-plan §9 Phase 06 ✅ + 改訂履歴更新 ← C5

### 6.2 ソフトゲート (任意)
- [ ] ⏳ Step 3 体感 ~18min 以内 (heavy demo の見積、Phase 10 で第三者検証)
- [ ] ⏳ Trust thread 文言 (firewall default deny + Verified Signed Commits) が Step 3 固有形で冒頭 IMPORTANT に存在 → Step 6a で回収
- [ ] ⏳ Multi-engine teaser sub-step (§3.D) が **実 invoke 禁止 / Step 5 への伏線 / actor invariance を仮定しない (Copilot 必須・Claude/Codex bonus)** として正しく書かれている
- [ ] ⏳ Pro plan 学習者ケア IMPORTANT (§3.C 冒頭) が screenshot/録画代替 + degraded complete 完走パスを明示

### 6.3 Phase 07 着手の最低条件
- 6.1 ハードゲート 全 ☑ または ⚠ (step-gate.yml 自動緑化のみ runner 復旧待ち、機能影響なし)
- ユーザー手動完走 (E8) 確認完了 (Standard/Full なら Cloud crossed minimum / Pro plan なら degraded complete)

---

## 7. リスク (Phase 06 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| **R06-1** | Cloud Agent quota-block (F20) で Initial plan commit 後すぐ finished_failure | 高/高 (Pro+ 学習者全員に発生し得る) | D9 = "Cloud crossed (minimum) = branch + draft PR まで到達" で boundary 実証成立を §3.C で明示、E7' PR #8 を screenshot 引用 |
| **R06-2** | Issue body が code-fix 風 (例: "Fix the pagination bug") だと Cloud Agent が triage skill ではなく code 修正モードで動く (F21) | 中/高 | D4 = Issue body テンプレを §3.C に **コピペ可能な完成例として提示**、文頭 "Use the issue-triage skill to triage this issue." (slash 無し、E7' 実証文言) を必須化、Good/Bad 対比を併記 |
| **R06-3** | `gh issue edit --add-assignee Copilot` が "Bot does not have access" で env-dependent fail | 中/中 | D3 = Web UI 推奨を main path、CLI は §5 Troubleshooting で TIP 扱い、`@copilot` mention 単独では起動しないことも §5 で明記 |
| **R06-4** | Pro plan 学習者は Cloud Agent 不可 = §3.C 完走不可 | 高/中 (受講者の plan 分布次第) | D11 = §3.C 冒頭 IMPORTANT で screenshot/録画代替を明示、**Step 3 degraded complete (Pro plan)** = §3.A + §3.B + §3.D + §3.E の 4 sub-step 完走として正式化、Step 4 prereq に分岐追加 (S07-6) |
| **R06-5** | playground repo に SKILL.md 未 push (R05-7 残存) で §3.C で「Cloud Agent から見えない」 | 中/中 | D5 = §2 前提で **verify コマンド** 必須化、未済なら Step 2 §4.2 へ戻す誘導、playground = public + Actions 有効 + clean repo 推奨 (critique #9) |
| **R06-6** | §3.A IDE Chat sub-step が Step 2 §3.D と冗長 | 低/中 | D12 = "**push 後 (publication 後) でも `file:///` のまま** = Local invariant が published 後も維持される" の差別化観察点 1 つを固定 |
| **R06-7** | Multi-engine teaser (§3.D) が Step 5 (head-to-head 比較) を喰う | 中/中 (U-D = full_section の選択により増大) | D7 = §3.D は **suggestedActors 一覧確認のみ、実 invoke 禁止**、Copilot 必須 / Claude/Codex は bonus (invariant 緩和)。§6 で "実 invoke は Step 5" と明記、Step 5 PRD でも head-to-head 比較に責務集中 |
| **R06-8** ⚠ critique #1 | 旧 truth (`copilot-swe-agent` / 「CLI が確実」) が `prerequisites.md` P4 / `VERSIONS.md` §6.3 / `master-plan` R3 / E4 RESULT に残存し、学習者が Step 3 本文より先に読んで誤誘導される | 高/高 | C2b で truth migration を実施 (P4 を改訂 → P9 に集約 / VERSIONS §6.3 P4 改訂 / master-plan R3 superseded note / E4 RESULT 先頭に "superseded by E7' for trigger truth" note)。step-gate Group D (negative) で禁止 token を grep して 0 件確認 |
| **R06-9** ⚠ critique #7 | actor invariance 仮定: D7 で 3 bot 並列観察を invariant 扱いすると plan/org/repo rollout 状況によって "見えない" 学習者が fault に見える | 中/中 | D7 = Copilot 必須 / Claude/Codex bonus に緩和、§3.D は actor が 1 つしか見えなくても完了扱い、Step 5 への伏線は "実 invoke の比較は Step 5" にとどめる |

---

## 8. 進め方 (6 commits + branch)

1. **C1**: 本ドキュメント新規 + master-plan §9 Phase 06 を 🟡 + 改訂履歴 → push (smoke 影響なし)
2. **C2a**: `content/step-3-surfaces/README.md` 全面執筆 (~320 行) → push
3. **C2b**: truth migration 群 (`content/README.md` + `content/prerequisites.md` P4/P9 + `VERSIONS.md` §2.8/§6.3 + `master-plan §6 R3` superseded + `E4 RESULT` 先頭 superseded) → push
4. **C3**: `step-gate.yml` `step-3-gate` job 追加 (T-301..305 + Group A/B/C positive + Group D negative) → push → ローカル self-check 全 PASS まで反復 (Group D negative grep が 0 件確認)
5. **C4**: `step-3-complete` branch を main から派生 push → T-304 緑化
6. **C5**: DoD ☑ + master-plan §9 ✅ + 改訂履歴 → push、ユーザーへ手動完走確認 (E8) 依頼 (Pro+ なら Cloud crossed minimum / Pro plan なら degraded complete)

---

## 9. 参考 (内部資料)

- master-plan §1.2 / §3 / §4 (Phase 06 = Step 3 = 必須 Step)、§4.5 (Step 3 必須)、§4.5.3 (MCP verification block — Phase 06 は **exempt**)、§9 (進捗)、§6 R3 (E7' で superseded)、R10 (firewall default deny)
- learnings §4 (Cloud Agent 関連)、§9 (MCP regression)、§10 (Memory)、§11 (Phase 05 refine 由来 = E7 reframe pattern)
- E4 RESULT.md (★ PASS、§3 Cloud Agent 動作 / §4 firewall / §5 workflow PR / §7 Verified commit、**先頭に E7' superseded note を追加**)
- E7-cli-skill RESULT.md (W4 = `skill(...)` 英語トレース、F4/F15/F17 = Local invariance、F19-F21 = Cloud Agent trigger truth)
- phase-05-step2-skill.md §10 (V1-V4 exempt 参照実装)、§11.3 S06-1〜8 (Phase 06 への申し送り、本 Phase で全消化)
- VERSIONS.md §2.5 (MCP) / §2.6 (Memory) / §2.7 (Skill) — §2.8 (Cloud Agent) はこれを継承
- 教材テンプレ source-of-truth: `content/step-2-skill/README.md` (必須 8 セクション + Status badge + Trust thread 伏線 + 2 段階 done + Memory bootstrap §2 NOTE)
- prereq P8 (Skill) に並列で P9 (Cloud Agent) を新設 (D19)
- E7' Cloud Agent verification 実機証跡: playground PR #8 (`shinyay/ghcp-6-layer-agentic-platform-phase3-dry-run`)

---

## 10. Phase 04 §11.2 8 項目チェックリスト適用結果 (D4 明示マッピング)

Phase 04 §11.2 で固定された **MCP 利用 Step か?** から **VERSIONS.md §2.X pin** までの 8 項目を、本 Phase 06 (Step 3 = MCP **非依存** = invoke のみ、SKILL.md は Step 2 で commit 済) に適用した結果:

| # | 8 項目 | 本 Phase での回答 |
|---|---|---|
| 1 | MCP 利用 Step か? | **No** (Step 3 は SKILL.md invoke のみ、3 surface = Chat / CLI / Cloud Agent はいずれも MCP 経由しない) |
| 2 | Yes → §「前提条件」に V1-V4 準拠明記 | N/A |
| 3 | Yes → MCP ツール最小セット明示 | N/A |
| 4 | **No → §10 で V1-V4 exempt 明示マッピング** | **本 §10 で実施** (Phase 04/05 §10 参照実装と同型、下記マッピング表) |
| 5 | §5 Troubleshooting に「機能未利用時のトラブル行」 | R06-1〜9 に対応する troubleshooting 行を §5 に必須化 (CLI assign fail / Issue body code-fix mode 落ち / Cloud Agent quota / playground push 未済 / suggestedActors actor 1 つだけ) |
| 6 | escape hatch branch 意味明記 + bootstrap 動線 | D13 で確定: **documentation state only — Cloud 観察は branch では再現できない**、§2 NOTE で Memory bootstrap (Step 1 §6 link) 再掲 |
| 7 | Step 固有 regex gate (T-N05) を step-gate.yml に | D16 / T-305 で実施 (Group A 構造 + Group B 概念 + Group C 構造 done + **Group D 禁止 token negative**) |
| 8 | VERSIONS.md §2.X に tool 名/パス pin | §2.8 新設 (D17、Cloud Agent surface pin) + §6.3 P4 改訂 (旧 truth 廃棄) |

### 10.1 §4.5.3 V1-V4 exempt 明示マッピング (D4 の根拠)

master-plan §4.5.3 は MCP 利用 Step (Step 0 / Step 4 / Step 6) を念頭に書かれた verification block であり、**MCP 非経由の Step 3** には適用しない。Phase 04/05 §10 と同型で、各項目を以下に対応付ける:

| §4.5.3 項目 | Step 3 (MCP 非依存) での扱い | 代替体験 |
|---|---|---|
| **V1 Trust UI ダイアログ** | exempt | Step 0 で体験済、Step 4 / Step 6 で再登場 |
| **V2 MCP server registration 確認** | exempt | Step 0 で確認済、Step 4 / Step 6 で再登場 |
| **V3 MCP tools 最小セット ON** | exempt | Step 4 / Step 6 で再登場 |
| **V4 Trust thread (`Used <tool>`) 観測** | exempt → **代替: (a) `スキル [...] の読み取り` トレース (Chat、日本語、`file:///`) / (b) `skill(...)` トレース (CLI、英語、関数記法) / (c) Cloud Agent の PR body "Initial plan + Tasks" + firewall default deny 観察 (R10 Trust thread 主役) + Verified Signed Commits** | §3.A / §3.B / §3.C で全 surface 観察 |

**結論**: Step 3 は MCP 経由しないので V1-V4 は **適用 exempt**。代わりに「同じ Skill が 3 surface でそれぞれ異なる形で観測される」を Step 3 固有の Trust thread 体験とし、Cloud Agent の firewall default deny + workflow PR 提案 + Verified commit を **Step 6a への最強の伏線** として配置する。

---

## 11. Phase 07+ への申し送り

> **位置付け**: Phase 06 (Step 3 = 3 surfaces / publication boundary) で確立する設計パターンと、Phase 07 以降の各 Phase 計画書執筆時に必ず確認するチェックリスト。Phase 04/05 §11 と同型構造。

### 11.1 Phase 06 で確立する見込みの設計パターン (Phase 07+ で踏襲、C5 で確定)

(C5 で確定。現時点での見込み):
- **P06-1**: 「比較表 (N 観点 × M surface)」を Step 末尾 §4 直前に置く (Step 1 = Memory vs Skill / Step 2 = Skill vs Surface / Step 3 = 6 観点 × 3 surface)
- **P06-2**: plan-gated sub-step は **冒頭 IMPORTANT で screenshot/録画代替を必ず併記** + sub-step 単位で skip 可能設計 + **degraded complete** という完走パターンを正式化
- **P06-3**: Multi-engine 等の **次 Step の伏線 sub-step** は「**観察のみ・実 invoke 禁止**」のルール明文化 (カニバリ防止) + invariant 仮定の緩和 (env/plan/rollout 依存項目は bonus 扱い)
- **P06-4**: step-gate を **positive + negative** の 2 軸化 (Group A/B/C positive + Group D 禁止 token negative) で truth migration 漏れを構造的に防ぐ

### 11.2 Phase 07+ 計画書チェックリスト (C5 で確定、Phase 04 §11.2 8 項目を必要なら更新)

(C5 で確定。Phase 06 の経験を踏まえて追加すべき項目があれば追記):
- 候補 1: **plan-gated sub-step が含まれる Step か?** (Step 3 = Yes、Step 4 もおそらく Yes = Cloud Agent 自動 assign が Pro+ 必須) → 含む場合は degraded complete パスを §4 で正式化
- 候補 2: **truth migration が必要な前提改訂を含む Phase か?** (Phase 06 = Yes、E7' で R3 等を superseded 化) → 含む場合は step-gate Group D negative grep を必須化

### 11.3 Phase 07 (Step 4 = Automate / gh aw) への具体示唆 (S07-*)

(C5 で確定):
- **S07-1**: §2 前提に「Step 3 §3.C で Cloud Agent の手動 assign を体感済 (Standard/Full プロファイル) **または Pro plan 学習者は Step 4 §3.X で初めて Cloud Agent を実機体験**」を必須化
- **S07-2**: §3 冒頭で「Step 3 = 手動 assign / Step 4 = Issue opened で自動 assign」の差を 1 行で対比
- **S07-3**: Step 4 = E3 で end-to-end 完走確認済 (PROCEDURE 訂正済)、`COPILOT_GITHUB_TOKEN` 必須を §2 prereq で再強調
- **S07-4**: T-401..405 = `gh aw` invoke 確認の構造 gate (paths trigger 設定 / `issues.opened` event / strict mode 対処) + 必要に応じて Group D negative grep 継続
- **S07-5**: firewall default deny (R10) を Step 4 で自動化文脈で再登場 (= "自動化された Cloud Agent も firewall に守られている")
- **S07-6** ⚠ critique #4 由来: **Pro plan 学習者分岐の正式化** — Step 3 degraded complete からの接続パスを §2 prereq に明示、§3.X (Step 4 内の Cloud 体験 sub-step) を Pro plan 学習者の "Cloud Agent 初体験" point として位置づけ
- **S07-7** ⚠ critique #9 由来: **public repo + billing + Actions minutes 前提の再掲** — Step 4 で `gh aw` workflow が Cloud Agent を呼ぶため、Step 3 で確立した 3 前提 (public / Actions 有効 / clean repo) を §2 prereq に再掲
- **S07-8** ⚠ critique #12 由来: **mode 差分整理** — Step 3 = 手動 Issue body で code-fix mode を triage mode に矯正 (F21) / Step 4 = workflow prompt で初期から triage mode で起動できる差を §3 冒頭で 1 段落整理

### 11.4 Phase 11 (Dogfooding) で再検証する候補 (C5 で確定)

(C5 で確定。現時点での見込み):
- Cloud Agent assign UI の変更 (Web UI ボタン位置 / picker の "Copilot" 表示文字列)
- Cloud Agent default mode の挙動 (code-fix mode 解釈の閾値、Issue body の文言依存性)
- `suggestedActors` GraphQL の bot 一覧 (Claude / Codex 以外の bot 追加可能性)
- Actions minutes 消費量 (1 Cloud Agent run の典型コスト、Pro+ default quota との関係)
- `gh issue edit --add-assignee Copilot` の env-dependency (org policy / token scope の影響)

---

## 12. 改訂履歴

| 日付 | 変更 | コミット |
|---|---|---|
| 2026-04-25 | C1: Phase 06 着手、本ドキュメント新規。U-A heavy / U-B chat-cli-cloud / U-C required+screenshot / U-D full_section ユーザー判断確定。**rubber-duck critique 12/12 全採用** (Blocking 5 / Non-blocking 4 / Suggestion 3) を baked-in。D1-D20 / R06-1〜9 / 6 commits + escape hatch / §10 V1-V4 exempt mapping / §11 Phase 07+ 申し送り (S07-1〜8) 見込み記載。新規 PoC は不要 (E4 + E7' 再活用)、E8 = ユーザー実機完走 marker のみ | C1 |

