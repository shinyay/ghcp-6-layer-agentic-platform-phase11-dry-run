# Phase 05 — Step 2 教材化 (Skill ⭐ = keynote CTA)

> **このフェーズの本質**: keynote 60 分視聴者が、Step 1 で植え付けた triage 規約 (個人/ローカル/揮発な Memory) を、`.github/skills/issue-triage/SKILL.md` (repo/共有/versioned な Skill) に **格上げして commit** し、**Chat と CLI 2 surface** で invoke して「Skill = surface 非依存の再利用資産」を体験する Phase。
> Step 2 = 「SKILL.md の雛形作成 → frontmatter (`name` + `description`) を Chat 補助で記入 → 本文 (When to use / Workflow) 記入 → `git add/commit/push` (CLI 直接) → 新規 Chat で `Read skill [...]` トレース確認 → Copilot CLI で同等 invoke + before/after 比較 (Step 1 §3.E F5 想起) → 完了」。
> Phase 03/04 で確立した教材テンプレ (必須 8 セクション + Status badge + Trust thread 伏線) を継承し、Phase 04 と同様 **MCP 非依存** Step として §4.5.3 V1-V4 を §10 で exempt 明示マッピング。本リポジトリ最重要 Step (= keynote CTA、master-plan §1.2 / §3 / §4)。

---

## 1. Phase Goal

### 1.1 主目的
keynote 60 分視聴者が、Step 0 で MCP 接続 + Step 1 で Memory 体験を済ませた自分の Codespaces で、**約 20 分** の heavy demo (5 sub-step) を完走し、「Memory に置いていた triage 規約を **`SKILL.md` という repo 資産に格上げ** して commit し、**Chat と CLI の 2 surface で同じ Skill が invoke される**」を体験する。これにより keynote CTA「**自分のリポジトリに `SKILL.md` を 1 つ書いて commit し、Copilot から呼び出せる状態にする**」を達成する。

### 1.2 Phase 完了時に手元にあるもの
1. **`content/step-2-skill/README.md`** — heavy demo (5 sub-step) 必須 8 セクション準拠
2. **`docs/planning/VERSIONS.md` §2.7** — SKILL.md spec / path / E2 RESULT 引用 pin (検証日 2026-04-25、Phase 01 E2 検証スナップショット継承)
3. **`content/README.md` 更新** — Step 2 行 ✅ 公開中、`🪂 escape hatch` 表に `step-2-complete` 行追加
4. **`content/prerequisites.md` P8 新設** — Skill = `.github/skills/<name>/SKILL.md` の 1 文紹介
5. **`.github/workflows/step-gate.yml` 拡張** — `step-2-gate` job (T-201..**205**)
6. **`step-2-complete` ブランチ** — escape hatch (**SKILL.md commit 済 repo state**)
7. **本ドキュメント** (`phase-05-step2-skill.md`) — DoD 全項目 ☑
8. master-plan §9 Phase 05 を ✅ + 改訂履歴

### 1.3 マイルストーン
master-plan §5 の **M2 (Step 0-2 公開で keynote CTA カバー) を完成**。本 Phase 単独で keynote 視聴者が CTA を達成可能になる (= 学習者一般公開条件を満たす)。Step 3 以降は希望者向けツアー。

---

## 2. Scope

### 2.1 IN SCOPE
| 対象 | 何を作るか |
|---|---|
| `content/step-2-skill/README.md` | heavy demo (5 sub-step) 必須 8 セクション準拠、§2 NOTE に Memory bootstrap 誘導、§6 に Skill vs Surface 対比表 |
| `docs/planning/VERSIONS.md` §2.7 | SKILL.md spec (frontmatter 必須 2 + 推奨 3 + 発展 出さない) / path (`.github/skills/<name>/SKILL.md`) / E2 RESULT §3 引用 (検証日 2026-04-25、Phase 01 E2 スナップショット継承) |
| `content/README.md` | Step 2 行 🚧 → ✅、`🪂 escape hatch` 表に `step-2-complete` 行追加 (Memory bootstrap 注記は Step 1 §6 リンクで再利用) |
| `content/prerequisites.md` | P8 新設 (Skill = `.github/skills/<name>/SKILL.md`、frontmatter 必須キー = `name` / `description`、commit 後にコラボレーター全員が利用可能) |
| `.github/workflows/step-gate.yml` | `step-2-gate` job 追加 (T-201..205) |
| `step-2-complete` branch | main 派生 push (**SKILL.md commit 済 repo state**) |
| 本ドキュメント | Phase 05 詳細計画書 |
| master-plan §9 | Phase 05 を 🟡 → ✅ |

### 2.2 OUT OF SCOPE (Phase 06+)
- Step 3-6 本文 (Where to Run / Automate / Multi-engine / Gate)
- Cloud Agent / Custom Agent invoke (Phase 06 / 09)
- gh aw triage workflow (Phase 07)
- 実機スクリーンショット (Phase 11)
- Step 3 README の「playground repo に `step-2-complete` の `.github/skills/` を反映」誘導 (Phase 06 で実施、本 Phase では Step 2 §6 で「Step 3 を始める前に playground repo に反映 (clone or copy) してください」と誘導のみ)

### 2.3 設計判断 (D1-D20)

ユーザー判断 (D1-D3) と私の判断 (D4-D20):

| # | 論点 | 採用案 | 根拠 |
|---|---|---|---|
| **D1** | demo 厚さ | **heavy** = 5 sub-step (~20 分) | ユーザー判断 (U-A) |
| **D2** | git commit 経路 | **cli_direct** = `git add/commit/push` を Codespaces 内 CLI 直接 | ユーザー判断 (U-B) |
| **D3** | invoke surface 数 | **chat_plus_cli** = Copilot Chat + Copilot CLI 2 surface | ユーザー判断 (U-C) |
| D4 | MCP 依存性 | **MCP 非依存** (D2 cli_direct と整合)。本計画書 §10 で §4.5.3 V1-V4 exempt 明示マッピング | S05-4 / Phase 04 §11.1 P04-1 |
| D5 | escape hatch | `step-2-complete` を main 派生で push。**branch の意味は SKILL.md commit 済 repo state**、Memory はローカル状態なので branch には乗らない (Step 1 §6 と同型誘導を §2 NOTE で再掲) | P04-2 / S05-6 |
| D6 | 必須 8 セクション | 学習目標 / 前提 / 手順 / 完了確認 / 詰まったら / 次の Step / 参考 + Status badge (Phase 03/04 テンプレ継承) | Phase 04 D5 |
| **D7** ⚠ 再改訂 (E7 reframe) | 5 sub-step 構成 | **(E7 walkthrough F1-F18 受け再改訂)** **A**: 雛形作成 (`mkdir -p .github/skills/issue-triage` + `SKILL.md` 空ファイル) → **B**: frontmatter (`name` + `description: >-` folded scalar、列 0、2-space indent) を Chat 補助で記入 → **C**: 本文 (When to use / Workflow) 記入 + **C 末尾で Local 即効体感** (`gh copilot` で `/skills list` → uncommitted SKILL.md が既に出る = **Local invariance 体感**、F4/F15 で確証) → **D**: `git add/commit/push` (publication step、Cloud / 他人 / Actions に伝播させる ための step、Local 動作には不要) → **E**: CLI 同等 invoke (自然言語 / 明示 invoke `Use the /issue-triage skill ...` で動作確認、`gh copilot` interactive mode、TUI ログ取りは `script -q -c` で PTY 確保) | E2 RESULT §5 / E7-cli-skill RESULT F1-F18 / rubber-duck 10 採用 |
| D8 | SKILL.md 名前空間 | `name: issue-triage` (E2 RESULT §5 例の `triage-issue` から命名統一)、path = `.github/skills/issue-triage/SKILL.md`。**§3.B で「E2 例の `triage-issue` ではなく本教材は `issue-triage` (`<noun>-<verb>` = 対象オブジェクト先行) で統一」を 1 行注記** | E2 RESULT §3.4 / 教材一貫性 / R05-9 予防 |
| D9 | description 文言 | E2 RESULT §5 例文 (`Use this skill when a new GitHub issue is opened ...`) を **そのままコピペ可能な完成例として §3.B に提示**、加えて「自分の repo の triage 規約に合わせて 1 文だけカスタマイズしてみよう」の余地を §3.B 末尾に併記 | E2 RESULT §5 / 教材ハンズオン性 |
| D10 | 教える frontmatter フィールド | **必須 2 (name + description) のみ**。`license` `metadata.version` `compatibility` `user-invocable` は **Step 6 (Gate) で再登場予定** と §6 (次の Step) で予告 (※ `user-invocable` は E7-cli-skill PoC で発見、Copilot CLI 固有フィールド) | E2 RESULT §3.2 / S05-3 / E7-cli-skill PoC |
| D11 | 本文の 2 セクション | `## When to use` (箇条書き 2-3 行) + `## Workflow` (番号付き 4 ステップ)。E2 RESULT §5 の最小例をそのまま雛形提示 | E2 RESULT §5 / 教材ミニマル化 |
| **D12** ⚠ 再改訂 (E7 reframe) | Local invariance + Publication boundary | **(E7 walkthrough F4/F15/F17 受け再改訂)** 旧「commit gating の before/after」モデルは廃止。新モデル: **Local invariance** = ローカル surface (Chat / CLI) は workspace ファイルを uncommitted でも直読みする (= F4 file:// trace, F15 CLI /skills list, F17 commit 後も file:// が継続) / **Publication boundary** = `git commit + push` の意味は Cloud Agent / 他人 / Actions への propagation。Step 2 では §3.C の Local 即効体感で **Local invariance** を、§6 への接続で **Publication boundary** (= Step 3 の Cloud Agent demo) への問い立てを行う | E7-cli-skill RESULT F4/F15/F17 / rubber-duck 10 採用 |
| **D13** ✅ 再確定 (E7 walkthrough) | CLI invoke の具体コマンド | **(E7-cli-skill PoC + E7 walkthrough で再確定、観測 version v1.0.36)** `gh copilot` (v1.0.36 観測動作、Codespaces で auto pre-install されない場合あり、`gh extension install github/gh-copilot` で導入) interactive mode で **`/skills list`** → 出ない場合は **`/skills reload`** → `/skills info issue-triage` で詳細確認 → 自然言語 prompt または `Use the /issue-triage skill ...` 明示 invoke。観測可能 trace = `/skills list` 一覧 + interactive 中 `skill(issue-triage)` 表記 (英語、関数記法、F16/W4 で確証)。IDE Chat 側は `スキル [issue-triage] の読み取り` (日本語、`file:///` 直リンク、F4) — **両 surface で表記が違う点を §3.D / §3.E で併記** | E7-cli-skill PoC / E7 walkthrough W4 |
| D14 | Trust thread 伏線 | 冒頭 IMPORTANT に **Step 2 固有文言**: 「Skill は repo に commit される = **PR で人間がレビュー対象になる** = Step 6a (Required Check) で『**人間が最後に判断する**』に直結」 | S05-2 / P04-7 / Step 0 / Step 1 文言と差別化 |
| **D15** | Memory bootstrap 注記 (§2 前提) | 「Step 1 §6 から escape hatch (`step-1-complete`) で飛んできた場合、Memory は空でも本 Step は OK (Skill は Memory に依存しない)。Memory を再現したい場合は Step 1 §3.A の植え付け prompt をコピペ」を §2 末尾に **NOTE で明記** | S05-1 / R04-11 |
| **D16** ⚠ 再改訂 (E7 reframe) | step-gate.yml 拡張 | C8 (E7 reframe) で **T-205 を trace-string regex から概念 keyword + 構造 gate に作り替え**。維持 = `^name:` / `^description:` (frontmatter 必須) / `\.github/skills/` path / `git commit` 動詞 / Step 1 §6 Memory bootstrap link / `/skills list`。新規 = 概念 keyword (Local/ローカル, publication/push, uncommitted/未 commit, folded scalar/`>-`) + 構造 gate (§3.C/§3.D が Local 文脈, §4 が Local done / Published done 2 段階, §6 が Cloud Agent boundary motivation)。`Read skill` / `スキル.*読み取り` / `skill\(` の trace OR は **TIP 注記レベルにのみ降格** (主 gate ではない) | S05-5 / P04-5, P04-6 / rubber-duck 10 採用 / E7 walkthrough W4 |
| D17 | content/README.md 動線 | Step 2 行 🚧 → ✅ (Step 3-6 はそのまま 🚧)、`🪂 escape hatch` 表に `step-2-complete` 行追加 (P04-10) | Phase 04 D14 / S05-7 |
| D18 | Commits 数 | **5 commits + E7 mini-PoC RESULT 1 commit** (Phase 03 / 04 の 5 commits リズムを維持、E7-cli-skill RESULT は C2 と同 commit に同梱)。**refine 追加: C6-C10 = 5 commits (Step 2 README + RESULT / 横断 6 ファイル / step-gate.yml T-205 reframe / step-2-complete branch -f / Phase 05 close)** | Phase 04 D15 / レビュー粒度 / E7 reframe |
| **D19** ⚠ 再改訂 (E7 reframe) | prereq P8 新設 | prereq P7 (Memory) に並列で **P8 = 「Skill = `.github/skills/<name>/SKILL.md` の Markdown ファイル、frontmatter 必須キーは `name` / `description`、ローカル Chat / CLI は uncommitted でも直読み (Local invariance)、`git commit + push` は Cloud / 他人 / Actions への propagation step、Copilot CLI の `/skills list` でも参照可能」** を 1 文で追加 | S05-8 / P04-9 / E7-cli-skill PoC / E7 walkthrough F4/F15/F17 |
| **D20** ⚠ 再改訂 (E7 reframe) | 次の Step (§6) への接続 | §6 = **Skill vs Surface 対比表** (Skill = "**何を**やるかの定義" / Surface = "**どこで**実行するかの選択") + **Local invariance / Publication boundary 表** (新規追加)。Step 3 への動機づけを「**Cloud Agent は default branch しか見ない = publication boundary を体感する**」へ強化 (E7' で確証、Cloud Agent 正規トリガ = Issue Assignees → Copilot)。**playground repo の default branch に `.github/skills/issue-triage/` を push 済にする** ことを Step 3 必須前提として §6 / Step 3 §2 で明記 | Step 1 §6 = Memory vs Skill と並列構造 / rubber-duck 10 採用 / E7' verification |

---

## 3. ディレクトリ構造 (本 Phase 完了時の差分のみ)

```
.github/workflows/step-gate.yml         # 拡張: step-2-gate job 追加 (T-201..205)、paths は content/** 維持
content/
├── README.md                           # 更新: Step 2 行 ✅ + 🪂 escape hatch 表に step-2-complete 行追加
├── prerequisites.md                    # 更新: P8 (Skill 1 文紹介) 新設
└── step-2-skill/
    └── README.md                       # 全面書き換え (placeholder → heavy demo 5 sub-step)
docs/planning/
├── 00-master-plan.md                   # 更新: §9 Phase 05 ✅、改訂履歴
├── VERSIONS.md                         # 更新: §2.7 SKILL.md spec/path pin (新設、E2 RESULT §3 + E7-cli-skill PoC 引用)
├── phase-05-step2-skill.md             # 本ドキュメント (新規)
└── poc/
    └── E7-cli-skill/
        └── RESULT.md                   # 新規: D13 確定根拠 (gh copilot v1.2.0 / /skills list/info/reload / 自動 + 明示 invoke / user-invocable 観測)

# branches:
#   main                                (本 Phase の全 commit)
#   step-2-complete                     (新規 escape hatch、main 派生、SKILL.md commit 済 repo state)

# 注: 本 Phase で playground repo 側に作成される .github/skills/issue-triage/SKILL.md は
# 学習者の repo の差分であり、本 workshop repo の差分ではない。
# 教材執筆時に「学習者が書くべき完成形 SKILL.md」のサンプルは E2 RESULT §5 を §7 参考から
# 直接リンクする (本 repo に重複コピーは置かない、E2 RESULT を source-of-truth とする)。
```

---

## 4. 実装タスク (5 commits / 線形依存)

| C# | Commit | 主ファイル | 自動テスト |
|---|---|---|---|
| **C1** | `docs(planning): start Phase 05 — add phase-05-step2-skill.md` | 本ファイル新規、master-plan §9 Phase 05 を 🟡、改訂履歴着手行 | smoke 影響なし (paths 外) |
| **C2** | `docs(content): write Step 2 — Skill (keynote CTA: SKILL.md write + commit + 2-surface invoke)` | `content/step-2-skill/README.md` 全面書き換え (D7/D14/D15/D20 反映)、`VERSIONS.md` §2.7 新設 (D10 / E2 + E7 引用)、`content/README.md` Step 2 ✅ + escape hatch 表更新、`content/prerequisites.md` P8 新設 (D19)、**`docs/planning/poc/E7-cli-skill/RESULT.md` 新規** (D13 確定根拠) | (C3 の T-201..203/T-205 で連携) |
| **C3** | `ci(step-gate): add Step 2 job (T-201..205)` | `.github/workflows/step-gate.yml` に `step-2-gate` job 追加 (D16)、T-205 regex gate を含む | step-gate.yml 緑化 |
| **C4** | `chore(branch): publish step-2-complete escape hatch` | `step-2-complete` branch を main から派生 push (D5) | T-204 緑化 |
| **C5** | `docs(planning): close Phase 05 — Step 2 published, DoD ☑` | 本ファイル DoD ☑、master-plan §9 ✅、改訂履歴 | smoke + step-gate 緑 |

---

## 5. テスト戦略 (L2 Step Gate Test)

| ID | 層 | 対象 | 方法 |
|---|---|---|---|
| T-PHASE05-201 | L2 | Step 2 README 必須 8 セクション | bash assert: §1〜§7 ヘッダ + Status badge 存在 (Step 1 T-101 同型) |
| T-PHASE05-202 | L2 | Step 2 README 内部 link 死活 | grep ベース、相対 path のみ (Step 1 T-102 同型) |
| T-PHASE05-203 | L2 | Step 2 README Done checklist >=4 項目 | `- [ ]` カウント >=4 |
| T-PHASE05-204 | L2 | escape hatch branch | `git ls-remote --heads origin step-2-complete` |
| **T-PHASE05-205** | L2 | Step 2 固有文言の regex gate (D16) | bash grep: `^name:` / `^description:` (frontmatter 必須キー言及) / `\.github/skills/` (path 言及) / `git commit` (動詞言及) / Memory bootstrap link (Step 1 §6 への参照) / `/skills list` (CLI slash command 言及、D13 確定追加) / playground repo 反映誘導 (R05-7 強化追加、例: `playground.*push` or `playground.*default branch`) — いずれも README 内に存在すること |
| T-PHASE05-Manual (E7) | (手動) | ユーザー実機完走 | 5 sub-step 完走、`.github/skills/issue-triage/SKILL.md` を **playground repo の default branch に commit & push 確認** (R05-7 受け強化)、Chat invoke で `Read skill [...]` トレース確認、CLI invoke (`gh copilot` で `/skills list` + 自然言語/明示 invoke) 確認、§3.C 末尾の before observation (commit 前は invoke 失敗 / `Read skill` 出ない) を確認 |

`paths` trigger 設計: Phase 04 と同じ `content/**` を維持 = **all-step gate** 運用継続 (P04-5)。Phase 11 で paths 細粒化を再検討。

runner: self-hosted (R03-7 復旧 = Phase 11 で smoke と同時に ubuntu-latest 化)

---

## 6. Phase 05 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で Phase 06 着手可能)

#### 動作確認
- [x] **E7 ユーザー実機完走** = 5 sub-step を実機検証、`.github/skills/issue-triage/SKILL.md` commit 確認、Chat + CLI 2 surface で invoke 成功 (Chat = `スキル [issue-triage] の読み取り` 日本語トレース観察 / CLI = `/skills list` 表示 + 自動/明示 invoke 後の挙動確認)。**E7 walkthrough で F1-F18、E7' で F19-F21 を発見 → C6-C10 refine で反映済**
- [x] **playground repo の default branch に `.github/skills/issue-triage/SKILL.md` が push 済** (E7 で playground = `shinyay/ghcp-6-layer-agentic-platform-phase3-dry-run` に push 済確認、Step 3 = E7' で Cloud Agent が同 branch を読んで起動することを確証)
- [x] **E7' Cloud Agent propagation verification** = playground Issue #7 を作成 + Issue Assignees に Copilot を追加 → Cloud Agent が `copilot/fix-search-results-pagination` branch + draft PR #8 作成、boundary (push 済 = Cloud Agent 起動可能) を実証 (Actions quota 制限により skill 完全実行までは未確証、F20 として記録)
- [x] step-gate.yml `step-2-gate` job (T-201..205) を C3 で追加、C8 (E7 reframe) で T-205 を概念 keyword + 構造 gate に作り替え、ローカル self-check 全 PASS (Group A 8 + Group B 5 + Group C 2 = 13 checks)
- [x] T-205 reframe 後ローカル self-check PASS (CI 緑化は R03-7 復旧時、機能影響なし)

#### 構造確認
- [x] Step 2 README 必須 8 セクション存在 (T-201 ローカル PASS)
- [x] Done checklist 5 項目 (T-203 ローカル PASS、>=4)
- [x] alt text 英語 (mermaid 含む)
- [x] `step-2-complete` branch push 済 (T-204 PASS、C9 で新 main から `git push -f origin step-2-complete` 実施、SHA = 841d6073fc34a2a8b9873b0bf7c04939ff07fb35 で main と一致)
- [x] `content/README.md` Step 2 行 ✅ + 🪂 escape hatch 表に `step-2-complete` 行追加 (R05-7 IMPORTANT 併設)
- [x] `content/prerequisites.md` P8 追記済 + 環境チェックに `gh copilot --version` 追加
- [x] `VERSIONS.md` §2.7 追記済 (SKILL.md spec / path / CLI slash commands / `user-invocable` 観測 / 検証日 2026-04-25、E2 + E7-cli-skill 引用)

#### 計画整合
- [x] 本ドキュメント DoD 全 ☑ (E7 walkthrough + E7' Cloud Agent verification 完了、F1-F21 を C6-C10 refine で全反映)
- [x] master-plan §9 Phase 05 ✅
- [x] master-plan 改訂履歴更新

### 6.2 ソフトゲート (任意)
- [ ] ⏳ Step 2 体感 ~20min 以内 (heavy demo の見積、Phase 10 で第三者検証)
- [x] Trust thread 伏線が Step 2 固有文言で冒頭に明示 (Step 0 / Step 1 文言とは差別化、Step 6a で回収) ← README §0 IMPORTANT で "PR で人間がレビュー対象 → Step 6a (Required Check) 直結" 明記
- [x] D20 Skill vs Surface 対比表が §6 に存在 (Step 3 への自然接続) ← Step 2 README §6 で 5 行表 ("何を" vs "どこで")
- [x] D15 Memory bootstrap 誘導が §2 NOTE に存在 (escape hatch 経由学習者ケア) ← Step 2 README §2 NOTE で Step 1 §6 link 明示

### 6.3 Phase 06 着手の最低条件
- 6.1 ハードゲート 全 ☑ または ⚠ (step-gate.yml 自動緑化のみ runner 復旧待ち、機能影響なし)
- ユーザー手動完走 (E7) 確認完了 + findings refine commits 完了

---

## 7. リスク (Phase 05 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| **R05-1** | SKILL.md spec drift (`description` の trigger 仕様 / frontmatter 必須キーが Phase 01 検証時から変わる) | 中/**高 (CTA 直撃)** | VERSIONS §2.7 で 2026-04-25 pin (E2 RESULT §3 + E7-cli-skill PoC 引用)、Phase 11 で再検証、§5 に「changelog 確認」誘導 |
| **R05-2** | Skill が Chat / CLI で invoke しない (description の trigger phrasing が緩い / repo に push されていない / プラン未該当 / CLI で `/skills reload` 必要) | 中/高 | §5 Troubleshooting に確認手順 (① `.github/skills/<name>/SKILL.md` が main に push 済か / ② description に明示的な trigger 動詞があるか / ③ プラン確認 / ④ CLI で `/skills list` `/skills reload` `/skills info issue-triage` で切り分け、rubber-duck Optional 5 受け追加) |
| **R05-3** | `Read skill [...]` トレースが Chat 応答に出ない (個体差) | 中/中 | §5 にフォールバック: 「明示的に `issue-triage skill を使って triage して` と invoke、CLI なら `Use the /issue-triage skill ...` 形式」、Step 1 R04-9 と同型 |
| **R05-4** | 学習者が `.github/skills/` ディレクトリ命名で typo (`.github/skill/` 等) | 中/中 | §3.A で `mkdir -p .github/skills/issue-triage` をコピペ可能なコマンドで提示、§5 にも path 確認手順 (`/skills list` で出ないなら path 誤りを疑う) |
| **R05-5** | step-gate.yml runner 復旧待ち (R03-7 継続) | 中/低 | Phase 11 で smoke と同時に ubuntu-latest 化、本 Phase では機能影響なしと記録 |
| **R05-6** | heavy demo (~20min) が Step 0+1 (各 ~15min) と合算 50min となり keynote 60min に収まらない | 中/中 | §1 で「Step 2 完了 = keynote CTA 達成、ここで離脱可」明示、§6 末尾に「残り時間で Step 3 を覗くか、自分の repo に SKILL.md を書くかは自由」誘導。Phase 10 で計測 |
| **R05-7** ⚠ 強化 | escape hatch (`step-2-complete`) で Step 3 に飛ぶと SKILL.md は本 workshop repo には乗っているが、playground repo (= 学習者が triage 対象とする別 repo) 側にも push が必要 (= Step 3 invoke の前提) | 中/**高** (rubber-duck Important 3 で重大化) | **二段構え対処**: ① **Phase 05 (本 Phase)**: §6 escape hatch 説明で「workshop repo branch だけでは不十分、**playground repo の default branch に SKILL.md があること**が Step 3 の前提」と明記 + DoD §6.1 動作確認に「playground repo に push 済」項目追加 + E7 manual gate にも追加 / ② **Phase 06 (Step 3)**: §2 でハード前提化 (S06-1 で確定) |
| ~~R05-8~~ | (D13 確定により消滅、E7-cli-skill PoC で CLI invoke 仕様確定済) | — | — |
| **R05-9** | `name` 値の命名 (`issue-triage` vs `triage-issue`) が E2 RESULT §5 と微妙に違う = 学習者の混乱 | 低/低 | §3.B で「E2 RESULT 例の `triage-issue` ではなく本教材は `issue-triage` で統一する旨」を 1 行注記、合理性 (`<noun>-<verb>` = 対象オブジェクト先行) を併記 |
| **R05-10** | `gh copilot` CLI が Codespaces に pre-installed でない | 低/中 | E7-cli-skill PoC で本 dev container 環境では pre-installed 確認済 (v1.2.0)。Codespaces base image でも pre-installed 想定だが、prereq §環境チェックに `gh copilot --version` を追加して未 installed 時は `gh extension install github/gh-copilot` を §3.E 冒頭で誘導 |

---

## 8. 進め方 (5 commits + refine 5 commits = 10 commits)

1. **C1**: 本ドキュメント新規 + master-plan §9 Phase 05 を 🟡 + 改訂履歴 → push (smoke 影響なし)
2. **C2**: `content/step-2-skill/README.md` 本文執筆 + `VERSIONS.md` §2.7 新設 + `content/README.md` Step 2 ✅ + escape hatch 表更新 + `content/prerequisites.md` P8 新設 → push
3. **C3**: `step-gate.yml` `step-2-gate` job 追加 (T-201..205) → push → 緑化反復
4. **C4**: `step-2-complete` branch を main から派生 push → T-204 緑化
5. **C5**: DoD ☑ + master-plan §9 ✅ + 改訂履歴 → push、ユーザーへ手動完走確認 (E7) 依頼

### refine (E7 walkthrough findings F1-F21 + E7' Cloud Agent verification)

6. **C6**: `content/step-2-skill/README.md` 大幅 refactor (新 5 sub-step / Local invariance 1 canonical experiment / Local done + Published done 2 段階 / pitfall x6) + `docs/planning/poc/E7-cli-skill/RESULT.md` 全面更新 (F1-F21 集約 / version v1.0.36 / Local/Published 表 / Cloud Agent trigger 条件) → push
7. **C7**: 横断 truth migration 6 ファイル (`content/step-3-surfaces/README.md` 前提改訂 / `content/prerequisites.md` P8 + version / `docs/planning/VERSIONS.md` §2.7 YAML 構文 4 要件 + §2.7.6 surface 別トレース + §2.7.7 Cloud Agent トリガ条件 / 本ドキュメント D7/D12/D13/D16/D19/D20 改訂 / `00-master-plan.md` §9 + 改訂履歴 / `content/README.md` escape hatch + IMPORTANT note) → push
8. **C8**: `step-gate.yml` T-205 reframe (trace-string regex → 概念 keyword + 構造 gate) → push → ローカル self-check 全 PASS
9. **C9**: `step-2-complete` branch を新 main から強制 push (`git push -f origin step-2-complete`)
10. **C10**: phase-05 DoD ☑ + master-plan §9 行に `(refine 含む)` + 改訂履歴 final entry → push、最終 self-check

---

## 9. 参考 (内部資料)

- master-plan §1.2 / §3 / §4 (Phase 05 = Step 2 ⭐ keynote CTA)、§4.5 (Step 2 必須)、§4.5.3 (MCP verification block — Phase 05 は **exempt**)、§9 (進捗)
- learnings §8 (SKILL.md / `.agent.md` spec 関連の "教材化注意")、§10 (Memory / Step 1 教材化、Phase 05 で並列構造を踏襲)
- E2 RESULT.md (★PASS、§3 確定 spec、§4 教材への反映方針、§5 学習者完成形 SKILL.md、§7 学び)
- **E7-cli-skill RESULT.md (mini-PoC、本 Phase 05 W2 で実施)**: D13 (CLI invoke 仕様) の根拠、`gh copilot` v1.2.0 / `/skills list/info/reload` / 自動 + 明示 invoke / `user-invocable` 観測
- phase-04-step1-memory.md §10 (V1-V4 exempt 参照実装)、§11.2 (8 項目チェックリスト)、§11.3 (S05-1〜S05-8 示唆)
- VERSIONS.md §2.5 (MCP) / §2.6 (Memory) — §2.7 はこれを継承
- 教材テンプレ source-of-truth: `content/step-1-memory/README.md` (必須 8 セクション + Status badge + Trust thread 伏線、Memory bootstrap §6)
- prereq P7 (Memory) に並列で P8 (Skill) を新設 (D19)

---

## 10. Phase 04 §11.2 8 項目チェックリスト適用結果 (D4 明示マッピング)

Phase 04 §11.2 で固定された **MCP 利用 Step か?** から **VERSIONS.md §2.X pin** までの 8 項目を、本 Phase 05 (Step 2 = MCP **非依存** = D2 cli_direct) に適用した結果:

| # | 8 項目 | 本 Phase での回答 |
|---|---|---|
| 1 | MCP 利用 Step か? | **No** (D2 cli_direct = git CLI 直接、MCP 経由しない) |
| 2 | Yes → §「前提条件」に V1-V4 準拠明記 | N/A |
| 3 | Yes → MCP ツール最小セット明示 | N/A |
| 4 | **No → §10 で V1-V4 exempt 明示マッピング** | **本 §10 で実施** (Phase 04 §10 参照実装と同型、下記マッピング表) |
| 5 | §5 Troubleshooting に「Trust thread が出ない」 or 「機能未利用時のトラブル行」 | R05-2 (Skill invoke 失敗) / R05-3 (`Read skill` トレースなし) に対応する troubleshooting 行を §5 に必須化 (= Step 1 §5 R04-* と同型) |
| 6 | escape hatch branch 意味明記 + bootstrap 動線 | D5 で確定: SKILL.md commit 済 repo state、§2 NOTE で Memory bootstrap (Step 1 §6 link) 再掲、§6 で playground repo 反映誘導 (R05-7) |
| 7 | Step 固有 regex gate (T-N05) を step-gate.yml に | D16 / T-205 で実施 |
| 8 | VERSIONS.md §2.X に tool 名/パス pin | §2.7 新設 (D17 ※注: D10 と整合) |

### 10.1 §4.5.3 V1-V4 exempt 明示マッピング (D4 の根拠)

master-plan §4.5.3 は MCP 利用 Step (Step 0 / Step 4 / Step 6) を念頭に書かれた verification block であり、**MCP 非経由の Step 2** には適用しない。Phase 04 §10 と同型で、各項目を以下に対応付ける:

| §4.5.3 項目 | Step 2 (MCP 非依存) での扱い | 代替体験 |
|---|---|---|
| **V1 Trust UI ダイアログ** | exempt | Step 0 で体験済、Step 4 / Step 6 で再登場 |
| **V2 MCP server registration 確認** | exempt | Step 0 で確認済、Step 4 / Step 6 で再登場 |
| **V3 MCP tools 最小セット ON** | exempt | Step 4 / Step 6 で再登場 |
| **V4 Trust thread (`Used <tool>`) 観測** | exempt → **代替: `Read skill [...]` トレース観測** (= Step 1 `Read memory` の延長線、本 Step 固有の Trust thread 体験) | §3.D で必須体験 |

**結論**: Step 2 は MCP 経由しないので V1-V4 は **適用 exempt**。代わりに「Skill が読まれた事実 = `Read skill [...]` トレース」を §3.D で必須観測とし、「Agent が何を使ったかを人間が見える」という Trust thread の本質を Step 2 固有の形で体験させる。

---

## 11. Phase 06+ への申し送り

> **位置付け**: Phase 05 (Step 2 ⭐ Skill = keynote CTA) で確立される設計パターンと、Phase 06 以降の各 Phase 計画書執筆時に必ず確認するチェックリスト。Phase 04 §11 と同型構造。詳細根拠は本 Phase 完了後に `learnings.md §11` に章追加 (Pre-Phase-06 prep の責務)。

> **注**: 本 §11 は Phase 05 完了 (C5) 時に **設計パターン P05-1〜N が確定した時点で書く**。本計画書 (C1) 着手時点では空欄、Step 2 教材執筆 (C2) や step-gate (C3) で見つかった追加パターンを織り込んで C5 で完成させる。

### 11.1 Phase 05 で確立する見込みの設計パターン (Phase 06+ で踏襲、C5 で確定)
(C5 で確定。現時点での見込み):
- **P05-1**: Skill 紹介の「対比表 (個人 → 共有 / Memory → Skill / Skill → Surface) を §6 に必ず置く」(Step 1 §6 = Memory vs Skill / Step 2 §6 = Skill vs Surface)
- **P05-2**: MCP 非依存だが Trust thread を **Step 固有トレース** で代替体験 (`Read memory` / `Read skill` / 後続は `Used <tool>` 等)
- **P05-3**: 2 surface invoke 教材は「**1 つの資産が surface 非依存**」を体験させる構造で組む (Step 3 = 3 surface 比較とは責務分離)
- **P05-4**: playground repo への反映指示 (Step 2 で commit した `.github/skills/` を Step 3 で利用するため) は §6 で明示誘導
- **P05-5**: prereq P8 のような「事前知識 1 文」は Step 本文の責務分担として prereq 側に置き、本文ではリンク参照のみ (P04-9 の継承)

### 11.2 Phase 06+ 計画書チェックリスト (C5 で確定、Phase 04 §11.2 8 項目を必要なら更新)

(C5 で確定。Phase 04 §11.2 の 8 項目に追加すべき項目があれば本 Phase の経験を踏まえて追記):
- 候補 1: **playground repo への反映指示が必要な Step か?** (Step 2 = Yes、Step 3+ で SKILL.md / `.github/agents/` 等が必要なら同様)

### 11.3 Phase 06 (Step 3 = Where to Run) への具体示唆 (E7 reframe で更新)
(C5 で確定 + C7 で E7 reframe 反映):
- **S06-1**: Step 3 §2 (前提) に「playground repo に `.github/skills/issue-triage/SKILL.md` が push 済」を必須化、未済なら Step 2 §6 から戻る誘導
- **S06-2**: Step 3 §1 (学習目標) で「**同じ Skill を 3 surface (Chat / CLI / Cloud Agent) で invoke して、surface 特性差を体験**」と明示。Step 2 = "**Local invariance** の体感" / Step 3 = "**Publication boundary** の体感 + surface 特性差の体験" の責務分担を冒頭で明確化 (E7 reframe)
- **S06-3**: Step 3 で初出の Cloud Agent (= coding agent / cloud agent) は learnings §4 + master-plan R10 (firewall default deny) を必読資料に
- **S06-4** (改訂): T-301..305 = surface 別 invoke 確認の 構造 gate (例: `gh copilot` / `Issue Assignees` / IDE Chat 等の言及)。trace-string regex は使わない (= T-205 reframe と同型)
- **S06-5**: `step-3-complete` branch = Step 3 で追加される教材構造 (もしあれば) を含む repo state、playground repo 反映指示は Step 2 §6 と同型
- **S06-6** (新規 / E7' verification): Cloud Agent 正規トリガ = **Issue Assignees に Copilot を追加** (Web UI 推奨、`gh issue edit --add-assignee Copilot` は環境により fail)。`@copilot` mention だけでは起動しない (F19)。Plan 要件 = Pro+ / Business / Enterprise
- **S06-7** (新規 / E7' verification): Cloud Agent は **GitHub Actions minutes を消費** (F20) し、quota 制限下では Initial plan commit 後すぐ finish_failure になる。教材中の Step 3 demo 推奨条件 = quota 残あり、または Step 3 demo の必須要件を **Cloud Agent が起動して branch + draft PR を作る所まで** に絞る (skill 完全実行までは optional 扱い)
- **S06-8** (新規 / E7' verification): Cloud Agent は **default で code-fix mode に解釈** (F21)。Issue body / title が "fix bug" 型だと triage skill ではなく code-fix モードで動く可能性がある。Step 3 demo では Issue body に「Use the issue-triage skill to triage this issue」を明示する誘導をテンプレ化

### 11.4 Phase 11 (Dogfooding) で再検証する候補 (C5 で確定)
(C5 で確定。現時点での見込み):
- SKILL.md spec drift (R05-1)
- `gh copilot` CLI での skill invoke 仕様 (R05-8 / D13)
- Skill invoke 個体差 (R05-3)
- heavy demo (~20min) が Step 0+1+2 = 50min 内に収まるか (R05-6)

---

## 12. 改訂履歴

| 日付 | 変更 | コミット予定 |
|---|---|---|
| 2026-04-25 | C1: Phase 05 着手、本ドキュメント新規。U-A heavy / U-B cli_direct / U-C chat_plus_cli ユーザー判断確定、D1-D20 / R05-1〜10 / 8 項目チェックリスト適用結果 §10 / §11 申し送り見込み記載 | C1 |
| 2026-04-25 | C1 (refine): rubber-duck Critical 1 + Important 2/3/4 + Optional 5 反映。**D7** 5 sub-step 改訂 (C 末尾に commit 前 before 観察を挿入)、**D12** 順序組み替えで実機 before/after 実現 (`_disabled` 退避不採用)、**D13 確定** (E7-cli-skill PoC 完了 = `gh copilot` v1.2.0 + `/skills list/info/reload` + 自動/明示 invoke、IDE Chat fallback 削除)、**R05-7 強化** (二段構え: Phase 05 で警告 + DoD/E7 entry / Phase 06 でハード前提化)、**T-205 拡張** (`/skills list` + playground 反映誘導 regex 追加)、**E7-cli-skill RESULT.md 新規** (D13 根拠を C2 と同 commit)、R05-8 削除 (D13 確定で消滅)、`user-invocable` キー観測 → 教材スコープ外 (VERSIONS §2.7 注記のみ) | C1 |
| 2026-04-25 | **C6 着手 (E7 reframe)**: E7 walkthrough findings F1-F18 + E7' Cloud Agent verification (F19-F21) で「commit gating」前提が崩壊、新コア「**Local invariance / Publication boundary**」に書き換え。`content/step-2-skill/README.md` 全面 refactor (新 5 sub-step / 2 段階 done / pitfall x6) + `docs/planning/poc/E7-cli-skill/RESULT.md` 全面更新 (F1-F21 集約 / version `v1.0.36 observed` / surface 別 trace 表 / Cloud Agent trigger 条件) | C6 (`7583892`) |
| 2026-04-25 | **C7 (E7 reframe 横断 truth migration)**: D7/D12/D13/D16/D19/D20 を **Local invariance / Publication boundary** モデルに再改訂、§8 進め方を C6-C10 に拡張、§11.3 S06-* を E7' findings (F19-F21) で更新。横断 6 ファイル (Step 3 README 前提 / prerequisites.md P8 + version / VERSIONS.md §2.7 YAML 構文 4 要件 + §2.7.6 surface 別 trace + §2.7.7 Cloud Agent トリガ / 本ドキュメント / master-plan §9 + 改訂履歴 / content/README.md escape hatch + IMPORTANT note) を 1 commit で migrate | C7 (`01055aa`) |
| 2026-04-25 | **C8 (T-205 reframe)**: `.github/workflows/step-gate.yml` T-205 を trace-string regex から **概念 keyword + 構造 gate** に再構成。Group A (spec facts 8 token、維持) + Group B (E7 reframe 概念 5 token = Local invariance / publication / uncommitted / folded scalar / Cloud Agent) + Group C (構造 2 = Local done / Published done) の 13 checks。`Read skill` 等の trace OR は廃止 (W4 で英語形は実物観測されないため)。ローカル self-check 全 PASS | C8 (`841d607`) |
| 2026-04-25 | **C9 (escape hatch refresh)**: `step-2-complete` branch を新 main (`841d607`) から強制 push (`git push -f origin main:step-2-complete`)。SHA = 841d6073fc34a2a8b9873b0bf7c04939ff07fb35 で main と一致確認 | C9 |
| 2026-04-25 | **C10 (Phase 05 refine close)**: 本ドキュメント DoD §6.1 全 ☑、master-plan §9 行に `(refine 含む)` 補記 + 改訂履歴 final entry。**Phase 05 refine 完全クローズ**: E7 walkthrough findings F1-F21 を全反映、教材コアを「commit gating」から「**Local invariance / Publication boundary**」に migrate、新 mental model + canonical SKILL.md template (folded scalar) + 13-check structural gate で安定化。M2 (keynote CTA) は維持されたまま、semantics が学習者の実機観測と整合 | C10 |
