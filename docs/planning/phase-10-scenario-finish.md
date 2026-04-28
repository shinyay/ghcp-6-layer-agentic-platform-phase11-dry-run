# Phase 10 詳細計画書 — シナリオ完成 (静的品質推敲)

> **位置付け**: Phase 09 (Step 6 = Gate) §11.3 で示唆していた **S10-1〜S10-8 (録画) と E10/E11 ユーザー実機完走 marker 回収** は、**ユーザー判断 (2026-04-26) で全て Phase 11 へ移送**。Phase 10 は **シナリオ完成 = 全 7 Step 教材 (Step 0〜6) と planning truth (master-plan / VERSIONS / prerequisites) の静的品質推敲のみ** に再定義する Phase。
> **本ファイルは Phase 06 / 07 / 08 / 09 SoT と同型構造** (§1 Goal → §2 Scope/D → §3 Dir → §4 Commits → §5 Test → §6 DoD → §7 Risks → §8 進め方 → §9 Refs → §10 推敲方針 + drift 取扱規則 → §11 申し送り → §12 履歴)。
> **特殊性**: Phase 10 は **新 Step を追加しない / 新 step-gate job を追加しない / Codespaces 起動不要 / 録画不要 / ユーザー実機完走不要** の "リファクタ Phase"。drift / 用語ゆれ / link 切れ / trust thread 連結漏れ / pattern 遡及適用漏れ / 重複記述を **静的に発見し、blocking のみ即修正、cosmetic は Phase 11 持ち越し台帳に積む**。
> **commit 構成**: **6 commits + escape hatch branch `scenario-complete`** = C1 plan / C2 light Step (0/1/2/3) / C3 heavy Step (4/5/6) / C4 planning truth / **C5 rubber-duck #2 remediation** / **C6 close** (★ rubber-duck #1 反映で C5/C6 分離、close commit を肥大化させずに rubber-duck #2 Blocking 反映の commit を独立化)。rubber-duck は C1 直後 (#1 = 計画レビュー) と C5 着手前 (#2 = 8 観点 final review) の **計 2 回** + post-C2/C3/C4 の lightweight self-checkpoint 3 回 (Phase 06〜09 同型 + 拡張)。

---

## 1. Phase Goal

### 1.1 主目的

`content/step-{0..6}/` 全 7 Step + `content/README.md` (scenario entrypoint) + `docs/planning/00-master-plan.md` + `docs/planning/VERSIONS.md` + `content/prerequisites.md` を **M4 (= content-complete) 達成後の通読視点で静的に推敲**し、以下の品質軸を揃える:

- **A 軸 (教材内一貫性)**: 用語統一 / Trust thread 連結 / prereq ↔ 本文整合 / クロス step link 健全 / Phase 04〜09 で確立した型 (P04-* ~ P09-*) の遡及適用
- **B 軸 (planning truth 整合)**: master-plan §1〜§12 + §6 R 表 + VERSIONS §1〜§10 + prerequisites P1〜P12 を M4 達成後視点で再検査、Phase 09 で確立した M4 vs M5 区分の波及確認、重複記述の集約
- **C 軸 (drift 取扱)**: 推敲過程で見つかった drift を **blocking** (学習者完走を阻害 / 事実矛盾 / broken link) と **cosmetic** (表記ゆれ / cosmetic UI label / 章立て改善余地) に分類、blocking は Phase 10 内で即 fix commit、cosmetic は **§10.3 持ち越し台帳** に積んで Phase 11 へ送る

中核メッセージ:
- **Phase 10 は新規生産物を増やさず、既存生産物の品質を確定する Phase**
- **録画 / 実機完走 / 公開リリース hardening の 3 軸はすべて Phase 11 で M5 として一括達成**
- M4 達成後の通読は **rubber-duck 1 回では拾い切れない** ため、3 commits (C2/C3/C4) で領域を分けて推敲し、最後に C5 で drift 取扱規則を確定文化する

### 1.2 Phase 完了時に手元にあるもの

- 推敲済み 7 Step README (`content/step-{0..6}/README.md`)
  - 用語統一 (Required Review Gate / Required Status Check / Trust thread Layer 名 / `.agent.md` 用語 / 4 状態 done 表現 / verification block 名 / engine canonical 表現 / etc.)
  - Trust thread Layer 1→2→3→4→5→6 の橋渡しが各 Step §6 「次の Step」で **転記齟齬なく繋がる**
  - クロス step link / planning truth link / 外部 link が **全件 alive** (broken link 0 件)
  - Phase 04〜09 で確立した P04-* / P05-* / P06-* / P07-* / P08-* / P09-* (合計 ~30 件) の **遡及適用が必要な箇所**を Step 0〜3 に反映 (例: P09-1 UI-only verification block を Step 0 / 3 に適用するか判断、P08-4 任意 Step の 3 箇所明示を Step 5 だけでなく Step 6b §3 Appendix にも遡及確認)
  - 同一説明の冗長記述を **SoT 圧縮** (例: Trust thread 表 / 4 状態 done テンプレ / verification block テンプレ)

- 推敲済み planning truth (`docs/planning/00-master-plan.md` + `docs/planning/VERSIONS.md` + `content/prerequisites.md`)
  - master-plan §1〜§12 / §6 R 表 (R1〜R13) の **古い表現 / 進行中表現 / 暫定対処 status note** を M4 達成後 final 表記に更新
  - VERSIONS §1〜§10 の各 §X が Phase 04〜09 publish 時点 snapshot を反映、Phase 11 dry-run 前に揃える価値のある **観察可能な範囲での最新化** (実機 verify は Phase 11)
  - prerequisites P1〜P12 を **M4 達成後の 7 Step 全通し視点**で過不足検査 (Step 0〜5 側の prereq に冗長/陳腐化がないか、Step 6 P12 の追記で Step 0 環境チェック ①〜⑫ が全件揃っているか)
  - escape hatch branch 表 (`step-{0..6}-complete` × 7) の整合確認 (全 N 揃っていて push 済みであること)

- `phase-10-scenario-finish.md` (本ファイル) DoD 全 ☑、§10.3 RESULT block (blocking 修正済 commit 一覧 + cosmetic 持ち越し台帳)、Phase 11 への申し送り §11

- master-plan §9 Phase 10 ✅ + 改訂履歴 + Phase 11 で M5 達成宣言する 3 軸を §11.5 に明記

- **新規 step-gate job は追加しない** (静的推敲 Phase のため、既存 step-{0..6}-gate が緑のまま維持されることが Phase 10 完了 gate)

### 1.3 マイルストーン

master-plan §5 の **M4 = "content-complete" は Phase 09 で達成済**。Phase 10 は **M4 を維持しつつ "content-complete" を品質軸で確定文化**する位置付け。

Phase 10 完了時点での milestone 状態:
- **M4 = content-complete** = ✅ 達成済 (Phase 09)、Phase 10 で品質確定
- **M5 = release ready** = ❌ 未達成、Phase 11 で 3 軸一括達成
  - **M5 軸 1**: 録画完備 (Phase 11)
  - **M5 軸 2**: ユーザー実機完走 evidence (E10 + E11-* = Step 5 / Step 6 5 段階 marker、Phase 11 dry-run で動画/スクショと一緒に取得)
  - **M5 軸 3**: public release hardening (README 公開トーン化 / CONTRIBUTING / LICENSE 確定 / リリース note / R03-7 self-hosted runner CI 緑化)

### 1.4 "シナリオ完成" を Phase として独立させる整合性

> **論点**: 「教材推敲 + planning truth 整合 + drift 整理」を Phase 11 の `dogfooding` に統合せず、独立した Phase 10 として切り出す合理性は?

**回答**:
- **静的推敲 (Phase 10) と動的検証 (Phase 11) は性質が異なる**: 静的推敲は通読 + grep + 構造検査で完結、Phase 11 dry-run は実機 + 録画 + ユーザー視点で動的に検証。これらを統合すると Phase 11 が肥大化し、blocking 発見時の commit 範囲が混在する
- **drift 取扱規則を Phase 10 で確定し、Phase 11 で運用する**: Phase 10 §10.3 持ち越し台帳に積まれた cosmetic drift は Phase 11 dry-run 中に発見される実機 drift と **統一台帳**で扱える。これは Phase 06 / 07 / 08 / 09 で確立した「静的 verify → 動的 verify」の段階分離を Phase 全体に踏襲する型
- **rubber-duck #2 のスコープが明確化**: Phase 10 = 静的推敲のみのため、rubber-duck #2 は「7 Step 一貫性 + planning truth 整合 + drift 取扱規則の妥当性」に絞れる。Phase 11 統合だと rubber-duck が散漫になる
- **commit 履歴が clean**: Phase 10 = 静的推敲 commits / Phase 11 = 動的検証 commits の境界が `git log --oneline` で明示される

---

## 2. Scope

### 2.1 IN SCOPE

| 対象 | 推敲 / 修正方針 |
|---|---|
| `content/step-0-setup/README.md` | A 軸: 用語統一 + prereq ① 〜 ⑫ ↔ 本文整合 + Trust thread Layer 0/MCP プロローグの言語確認 + クロス link 健全性 + P09-1 UI-only verification block 適用判断 (MCP verification block 必須対象継続だが UI 項目があれば §4.5.3 と整合) |
| `content/step-1-memory/README.md` | A 軸: Trust thread Layer 1 → Layer 2 接続の §6 「次の Step」転記検査 + R12 (Memory ファイル削除手順) の本文反映確認 + P05-* 遡及 (Step 2 で確立した型を Step 1 にも適用すべき箇所) |
| `content/step-2-skill/README.md` | A 軸: ⭐ M2 keynote CTA Step として用語/構造の安定化、Trust thread Layer 2 → Layer 3 接続検査 + Skills frontmatter 2 フィールド (R1) の表現統一 |
| `content/step-3-surfaces/README.md` | A 軸: 3 surfaces 用語統一 (Suggest / Edits / Agent / Cloud Agent / Coding agent / Path A/B/C の混同抑止) + R3 / E7' findings F19-F21 の本文反映確認 + Pro plan degraded complete pattern (P06-*) の整合確認 + Cloud Agent publication boundary 越境体験文言の精度確認 |
| `content/step-4-automate/README.md` | A 軸: gh aw heavy demo 6 sub-step + canonical templates (`triage-issue.md` / `safe-outputs`) の用語安定化 + R9 (PAT 秘伝の手順 + sanity check) の prereq P10 ↔ 本文整合 + Trust thread Layer 4 = 書き込み経路ガードレールの説明統一 |
| `content/step-5-multi-engine/README.md` | A 軸: engine stanza 両形 OR canonical 表現 (D08-13) の安定化 + 4 状態 done (Setup ready / minimum live / full live / fallback complete) テンプレ統一 + 任意 Step 救済 §1 / §3 / §4 の 3 箇所明示 (P08-4) + COPILOT_GITHUB_TOKEN baseline (Q5) の表現統一 + recordings/README.md placeholder link 健全性 |
| `content/step-6-gate/README.md` | A 軸: Required Review Gate vs Required Status Check 用語分離 (Important 5) の表現安定化 + 4 状態 done (Setup ready / Step 6a minimum complete / Step 6a full complete / Step 6b complete) + 5 段階 path (Full / Pro-Pro / Free / Degraded / Workflow-Advanced) + plan/permission completion matrix + .agent.md sample 安全性 (read/search only) の表現統一 + recordings/README.md placeholder link 健全性 + 5 E11 marker の表現統一 |
| `content/README.md` | クロス step link / escape hatch 表 / IMPORTANT note / 任意 Step 表記 (Step 5 / Step 6b / Step 6 §3 Appendix) を全 7 Step 推敲後の view で再点検 |
| `content/prerequisites.md` | B 軸: P1〜P12 全件を **M4 達成後の通読視点**で過不足検査、環境チェック ①〜⑫ が全件揃っていて陳腐化なし、各 P が対応する Step 番号への back-link 健全 |
| `docs/planning/00-master-plan.md` | B 軸: §1〜§12 + §6 R1〜R13 全行を M4 達成後 view で再検査、status note の "進行中" / "Phase NN で再検証" 等の暫定表現を Phase 09 完了後の final 表記に統一、§4.5 / §4.5.3 と各 phase doc の重複記述があれば master-plan を SoT として圧縮、§9 Phase 10 ✅ + 改訂履歴 + §11.5 で M5 達成宣言 3 軸を最終確定文化 |
| `docs/planning/VERSIONS.md` | B 軸: §1〜§10 の各 §X が Phase 04〜09 publish 時点 snapshot を反映、Phase 11 dry-run 前に揃える価値のある **観察可能な範囲での最新化** (CLI version / API version / UI label の **再撮なしで判断可能な領域のみ**)、Phase 11 で実機再撮する候補は §10.4 Drift watch に追記 |
| `phase-10-scenario-finish.md` (本ファイル) | Phase 10 SoT、§10.3 RESULT block (blocking 修正済 commit + cosmetic 持ち越し台帳)、Phase 11 申し送り §11 |
| `scenario-complete` branch | main 派生 push、Phase 10 完了時点 snapshot (D14 制約継承 = active branch protection rule は workshop repo に置かない、推敲 commits まで含めて 1 branch で固定) |

### 2.2 OUT OF SCOPE (Phase 11 / Phase 10 範囲外)

- **動画収録 (S10-*)**: 録画スクリプト本文 / 録画 hosting 方針確定 / recordings/README.md への実 URL 流し込み — **Phase 11 dry-run と統合**
- **ユーザー実機完走 (E10 / E11-Setup〜Workflow-Advanced)**: 全 6 marker 回収 — **Phase 11 dry-run で動画/スクショと一緒に取得** (ユーザー判断 2026-04-26)
- **public release hardening**: README 公開トーン化 / CONTRIBUTING / LICENSE 確定 / リリース note / org level 設定 / 公開リポ準備 — **Phase 11**
- **R03-7 self-hosted runner CI 緑化**: Phase 11 で `ubuntu-latest` 化と同時に解決
- **新規 step-gate job 追加**: Phase 10 は静的推敲のみ、新 job は追加しない (既存 step-{0..6}-gate が緑のまま維持を確認)
- **新規教材 Step 追加**: Phase 10 は推敲のみ、新 Step / 新 sub-step は追加しない
- **R5 / R11 等の status 確定**: Phase 09 で final 化済、Phase 10 は status note の表現統一のみ (再判断は Phase 11)
- **playground repo / 録画用 dummy repo の準備**: Phase 11

#### 歴史的 phase-XX docs の凍結方針 (★ RD#2-I2 反映)

> `docs/planning/phase-03-step0.md` 〜 `docs/planning/phase-09-step6-gate.md` の 7 個の Phase 詳細計画書は **各 Phase close-time の planning truth snapshot** として凍結する。Phase 10 再定義後の最新 SoT は **`00-master-plan.md` + `VERSIONS.md` + `prerequisites.md` + `content/README.md` + `phase-10-scenario-finish.md` (本ファイル)** の 5 ファイルに集約する。
>
> - 歴史 docs 内の旧「Phase 10 = Dogfooding / 録画」「S10-1〜S10-8」「Phase 10 で再検証」等の表現が残存していても **Phase 10 blocking 対象外** (= 各 Phase が当時持っていた planning truth を破壊しない discipline)
> - ただし **learner-facing content (`content/**/*.md`) に転記された場合は Phase 10 blocking** (RD#2-B1 対応で C5 で `content/step-*/recordings/README.md` の stale wording を最小置換済)
> - Phase 11 で旧 S10-* を S11-* (旧 S10-*) と表記し直し、申し送りの番号空間を統一する (Phase 11 計画書 §11.3 で正規化)
> - T-PHASE10-001 broken-link self-check の対象は historical phase docs を含むが、**判定は raw regex hit ではなく whitelist 適用後** (=  inline code / image placeholder / historical snapshot の意図的記述は除外、§10.1 末尾の whitelist 規則参照、★ RD#2-B5 反映)

### 2.3 設計判断 (D10-1〜D10-9)

| # | 判断 | 理由 |
|---|---|---|
| **D10-1** | Phase 10 は **6 commits + escape hatch** (C1 plan / C2 light / C3 heavy / C4 planning / C5 rubber-duck #2 remediation / C6 close)。Phase 09 と同じ 6 commits パス | 新規 step-gate job 追加なし、新 Step 追加なし、3 commits (C2/C3/C4) で領域分割推敲 + C5 で rubber-duck #2 findings 反映 + C6 で close。**C5 と C6 を分離** (RD#1 Blocking 2 反映): rubber-duck #2 で Blocking が出ても close commit を肥大化させず、再検査タイミングを明確化 |
| **D10-2** | Phase 10 では **A 軸推敲 commit を 2 つに分割** (C2 = Step 0/1/2/3 light Step 群、C3 = Step 4/5/6 heavy Step 群) | 1 commit に 7 Step まとめると diff が肥大化し review 困難、light Step 群 (短) と heavy Step 群 (長) で粒度を揃える |
| **D10-3** | drift 深刻度判定基準を §10.1 で確定文化 (★ RD#1 Important 4 で **3 質問 → 5 質問** に拡張) | rubber-duck #2 final review で「blocking / cosmetic 判定が曖昧」を防ぐため。5 質問 = 学習者完走 or copy/paste 実行 or gate 通過阻害 / 事実矛盾 or SoT 矛盾 or evidence 矛盾 / broken link / security boundary 弱化 / M5 evidence 取得誤誘導 |
| **D10-4** | Phase 11 持ち越し台帳 (§10.3 後半) は **8 列構造化 table** (★ RD#1 Important 5 反映、5 列 → 8 列): # / drift 種別 / 該当 doc / 行番号 / 現状表現 / 推奨修正 / 優先度 / **Phase 11 処理方針** (`recording-before` / `dry-run-during` / `release-hardening` / `after-evidence` / `needs-dynamic-verify` のいずれか) | Phase 11 着手者がそのまま commit plan に落とせる粒度を確保 |
| **D10-5** | step-gate.yml は触らない (新 job 追加なし、既存 job の regex 調整も避ける) | 推敲過程で本文表現を変えても既存 regex に引っかからない範囲で修正する原則。引っかかる場合は **本文側を既存 regex に合わせる** か **rubber-duck #2 で判断後 Phase 11 で regex 強化** |
| **D10-6** | Pattern 遡及適用は **judgment call** + **明示 decision rule** (★ RD#1 Important 6 反映) | apply 条件 4 件 (learner-visible workflow に直接関係 / 同じ concept-artifact-command を扱う / 適用しないと SoT と本文が分岐 / 学習順序-負荷-前提を壊さない) すべて Yes ⇒ apply。1 つでも No ⇒ skip。skip 判断は §10.2 mini decision log table で記録 (Pattern / 対象 Step / Apply? / 理由) |
| **D10-7** | 重複記述の SoT 圧縮は **構造化テンプレに限定** (★ RD#1 Important 7 で範囲拡張) | 初期対象 = Trust thread 表 / 4 状態 done / verification block テンプレ。**追加対象** = branch / escape hatch table / secret 名 / env var 名 / engine stanza canonical examples / Required Review Gate vs Required Status Check matrix / 5 段階 path matrix / evidence marker naming / canonical command invocation。説明文の意図的重複は触らない |
| **D10-8** | 録画 link を含む **`content/step-*/recordings/README.md` placeholder file 自体は触らない** (Phase 11 で実 URL に置換) | Phase 10 は録画範囲外、placeholder file の文言推敲も Phase 11 で実 URL 流し込みと同時に行う方が無駄が少ない。ただし placeholder file への link 自体は alive 必須 (T-PHASE10-001 対象) |
| **D10-9** | rubber-duck #1 (post C1) と #2 (pre C5) の **2 回実施を計画書 §8 に明記** + **C2/C3/C4 後に 3-5 質問 mini self-checkpoint** (★ RD#1 Suggestion 9 反映) | Phase 06 / 07 / 08 / 09 で確立した「計画着手時 + close 直前」型を踏襲。各 commit 後の lightweight checkpoint で C5 の負荷を下げる (rubber-duck full ではなく self-review、§8.1 に質問定義) |
| **D10-10** | **`agents/` / `templates/` は原則編集しないが、blocking static consistency inspection の対象に含む** (★ RD#1 Important 3 反映) | README と sample/template の file path 不一致 / secret 名 / engine stanza / canonical command の事実不一致 / `.agent.md` safety boundary 違反 / broken link / copy-paste failure を誘発する drift は Phase 10 blocking として修正対象。大規模推敲は Phase 11 持ち越し |
| **D10-11** | **Phase 11 計画時点で M5 3 軸一括達成が overload と判断されたら、Phase 12 = Public Release Hardening を新設** (★ RD#1 Important 8 反映) | Phase 11 の commit plan が巨大化する場合、Phase 11 = dogfooding + recording + evidence collection に集中、Phase 12 = LICENSE / CONTRIBUTING / release note / final tag / M5 declaration に分離。判断 gate は §11.2 に明示 |

---

## 3. ディレクトリ構造 (本 Phase 完了時の差分のみ)

> Phase 10 は新規ファイル作成 = `phase-10-scenario-finish.md` (本ファイル) のみ。**既存ファイルの推敲 commit のみで構成**。新規ディレクトリ追加なし。

```
docs/
└── planning/
    └── phase-10-scenario-finish.md      # 新規 (本ファイル、C1)

# 推敲対象 (既存ファイル、C2/C3/C4 で修正)
content/
├── README.md                             # 推敲対象 (C2 or C3 で内含)
├── prerequisites.md                      # 推敲対象 (C4)
└── step-{0..6}/README.md                 # 推敲対象 (C2 = 0/1/2/3、C3 = 4/5/6)

docs/planning/
├── 00-master-plan.md                     # 推敲対象 (C4) + close 編集 (C6)
└── VERSIONS.md                           # 推敲対象 (C4)

# 触らない (Phase 11 持ち越し)
content/step-*/recordings/README.md       # placeholder のまま (D10-8、ただし link alive は T-PHASE10-001 対象、stale wording の最小置換は C5 で例外的に許可 = RD#2-B1)
.github/workflows/step-gate.yml           # 新 job 追加なし、既存 job 調整も避ける (D10-5)

# 原則編集しないが、blocking static consistency inspection 対象 (D10-10、★ RD#1 Important 3)
content/step-*/agents/                    # README ↔ sample 間の file path / secret / command 不一致、safety boundary 違反、copy-paste failure は Phase 10 blocking
content/step-*/templates/                 # 同上 (例: pr-required-check.yml の secret 名 / engine stanza が README と一致するか)

# 不変 (close-time SoT snapshot として凍結、★ RD#2-I2 反映)
docs/planning/phase-0[3-9]-*.md           # 各 Phase 完了時点の planning truth を保存。旧 "Phase 10 = Dogfooding / 録画提供" 等の表現が残存していても Phase 10 blocking 対象外 (= learner-facing には転記されていない前提)。learner-facing content/* に転記がある場合のみ blocking、その場合は learner-facing 側を修正する

# escape hatch
scenario-complete                         # main 派生、C6 commit 後 push (D14 継承)
```

---

## 4. 実装タスク (6 commits + branch / 線形依存、★ RD#1 Blocking 1+2 反映で C5/C6 分離)

| # | コミットメッセージ (例) | 主な内容 | 完了条件 |
|---|---|---|---|
| **C1** | `docs(planning): Phase 10 plan v1 — scenario finish (static refinement)` | 本ドキュメント新規作成、master-plan §9 Phase 10 🟡 + §5 milestone block の M5 軸文言を 3 軸明示形に明確化 (録画 / 実機完走 evidence / public release hardening)、改訂履歴に Phase 10 着手 entry。**rubber-duck #1 (計画レビュー)** finding 反映済 | smoke + step-gate 緑 (新 job なし)、rubber-duck #1 計画レビュー実施、Blocking/Important 反映 |
| **C2** | `docs(content): Phase 10 C2 — Step 0/1/2/3 polish (terms / trust thread / cross link)` | A 軸 = light Step 群推敲: Step 0/1/2/3 README に対し用語統一 + Trust thread Layer 0→1→2→3 接続検査 + クロス link 全件 alive 確認 + prereq ↔ 本文整合 + P04〜P09 遡及適用判断 (D10-6 judgment + decision log) + 重複記述 SoT 圧縮 (D10-7 拡張範囲)。`content/README.md` のクロス link / escape hatch 表は本 commit に内含可 (Step 0/1/2/3 関連行)。**`agents/` / `templates/` の static consistency inspection** (D10-10): file path / secret / command 不一致 / safety boundary 違反 / copy-paste failure があれば本 commit で blocking 修正 | step-{0..3}-gate 全緑、broken link 0 件 (T-PHASE10-001 spec)、用語統一 §10.2 ✅、**post-C2 mini checkpoint 3 質問 PASS** (§8.1) |
| **C3** | `docs(content): Phase 10 C3 — Step 4/5/6 polish (terms / trust thread / cross link)` | A 軸 = heavy Step 群推敲: Step 4/5/6 README に対し用語統一 + Trust thread Layer 4→5→6 接続検査 + クロス link 全件 alive 確認 + prereq ↔ 本文整合 + 4 状態 done テンプレ統一 + 5 段階 path matrix 表現統一 + 任意 Step 救済 3 箇所明示確認 (P08-4) + 重複記述 SoT 圧縮 (D10-7 拡張範囲)。`content/README.md` の Step 4/5/6 関連行は本 commit に内含可。**`agents/code-reviewer.agent.md` / `templates/pr-required-check.yml` の static consistency inspection** (D10-10) | step-{4..6}-gate 全緑、broken link 0 件、用語統一 §10.2 ✅、**post-C3 mini checkpoint 3 質問 PASS** (§8.1) |
| **C4** | `docs(planning): Phase 10 C4 — master-plan / VERSIONS / prerequisites polish` | B 軸 = planning truth 推敲: master-plan §1〜§12 + §6 R1〜R13 の status note final 表記化 (R10-4 で「Phase 11 で再検証」を残す項目を明示)、§4.5 / §4.5.3 と各 phase doc の重複記述があれば master-plan を SoT として圧縮、VERSIONS §1〜§10 の **観察可能な範囲** での最新化 (RD#1 Suggestion 11 = Phase 10 OK / Phase 11 boundary 明示、§10.2 B 軸 checklist)、prerequisites P1〜P12 全件過不足検査 + 環境チェック ①〜⑫ 整合 | smoke 緑、planning truth grep で陳腐化文言 0 件、§10.2 B 軸 ✅、**post-C4 mini checkpoint 3 質問 PASS** (§8.1) |
| **C5** | `docs: Phase 10 C5 — rubber-duck #2 findings remediation` | **rubber-duck #2 final review (C5 着手前) を実施**、抽出 finding を本 commit で反映: Blocking ⇒ 必ず反映 (該当 README / planning truth / `agents/` `templates/` を修正)、Important ⇒ 反映 (case-by-case で Phase 11 持ち越し可)、Suggestion ⇒ Phase 11 持ち越し可。本 commit は close commit ではなく **remediation 専用** (★ RD#1 Blocking 2 反映、C6 と分離) | T-PHASE10-001〜008 partial re-check (修正領域のみ)、rubber-duck #2 Blocking/Important 反映完了 |
| **C6** | `docs(planning): Phase 10 close — scenario finish + drift handling rules established` | close commit: phase-10 doc DoD §6.1 全 ☑、§10.3 RESULT block 確定 (blocking 修正済 commit 一覧 = C2/C3/C4/C5 SHA + cosmetic 持ち越し台帳 8 列 table)、master-plan §9 Phase 10 ✅ + §11.5 M5 達成宣言 3 軸 + §11.2 Phase 12 split criteria gate (RD#1 Important 8) + 改訂履歴最終 entry、Phase 11 申し送り §11 確定 | smoke + step-gate 緑、T-PHASE10-001〜008 全件 PASS literal 再検査 + commit message 転記、ユーザーへ Phase 11 着手準備完了報告 |
| **branch** | `git push origin scenario-complete` | C6 commit 後の main 派生 branch を push (D14 継承、新規 active rule は乗らない) | `git ls-remote --heads origin scenario-complete` で SHA = C6 一致確認 |

> **commit slot は線形 6 + branch**。C2 と C3 は両方とも A 軸推敲のため独立性が高く、**並行作業も可能**だが、`content/README.md` への内含 commit を片方に絞る整合のため **C2 → C3 の順序を明示**。C4 は B 軸 (planning truth) のため C2/C3 と独立。C5 は rubber-duck #2 remediation 専用、C6 は pure close commit (RESULT block + master-plan ✅ + 改訂履歴のみ)。**rubber-duck #2 で no Blocking / no Important なら C5 は空 commit にせず、`docs: Phase 10 C5 — rubber-duck #2 review pass (no remediation needed)` の minimal commit (改訂履歴 entry のみ) に縮退**。

---

## 5. テスト戦略 (L1 Smoke + 既存 step-gate 維持 + 構造 self-check)

### 5.1 既存 CI gate の維持

Phase 10 は **新規 step-gate job を追加しない** (D10-5)。代わりに、推敲過程で本文表現を変えても **既存の全 step-N-gate が緑のまま維持される** ことが Phase 10 完了 gate。

- **L1 smoke**: 既存テストを維持
- **step-{0..6}-gate**: C2/C3/C4 各 commit ごとに `act` または PR 上で緑であることを確認 (regex に引っかかる修正をした場合は本文側を既存 regex に合わせる、または §10.2 で記録して Phase 11 で regex 強化判断)

### 5.2 Phase 10 構造 self-check (T-PHASE10-001〜T-PHASE10-008、§6.1 ハードゲートに含む)

新 step-gate job ではなく、**ハードゲート §6.1 内のセルフチェックリスト**として運用:

- **T-PHASE10-001 (broken link 0 件)**: `content/**/*.md` + `docs/planning/**/*.md` の link 検査仕様 (★ RD#1 Suggestion 10 拡張):
  - **local relative path**: 全件存在確認 (`find . -name "*.md" -exec grep -oE '\]\([^)]+\)' {} \;` 抽出 → 相対 path 解決)
  - **local anchor (`#heading`)**: 可能な範囲で heading slug 照合
  - **external URL**: Phase 10 では HTTP 200 を必須にせず "syntactically valid" のみ確認 (実 URL は Phase 11 dry-run で再検査、§10.3 持ち越し台帳に `needs-dynamic-verify` で積む)
  - **image link**: 含む
  - **placeholder recording URL** (`content/step-*/recordings/README.md` 経由): D10-8 で本文編集対象外だが、**placeholder file 自体への link は alive 必須**
- **T-PHASE10-002 (用語統一)**: §10.2 用語統一 checklist の全項目 ✅ (Required Review Gate / Required Status Check / Trust thread Layer 名 / `.agent.md` 用語 / 4 状態 done 表現 / verification block 名 / engine canonical 表現 / 任意 Step 表記)
- **T-PHASE10-003 (Trust thread 連結)**: 各 Step §6 「次の Step」セクションが Layer 1→2→3→4→5→6 を転記齟齬なく繋いでいる (各 Step を順に読んで前 Step の終端と次 Step の冒頭が文言整合)
- **T-PHASE10-004 (prereq ↔ 本文整合)**: 各 Step §2 前提が `content/prerequisites.md` の P1〜P12 と back-link 健全、環境チェック ①〜⑫ が全件揃っていて陳腐化 0 件
- **T-PHASE10-005 (escape hatch 表整合)**: `content/README.md` の escape hatch 表に `step-{0..6}-complete` 全 7 行 + `scenario-complete` 1 行が揃って push 済み
- **T-PHASE10-006 (planning truth status final)**: master-plan §6 R1〜R13 の status note に "進行中" / "Phase 09 着手" / "Phase 09 で再検証" 等の Phase 09 進行中表現が 0 件 (= Phase 09 完了後 final 表記、ただし「Phase 11 で再検証」は意図的に残す = R10-4 対策)
- **T-PHASE10-007 (重複記述 SoT 圧縮)**: §10.2 重複記述 checklist (D10-7 拡張範囲 = Trust thread 表 / 4 状態 done テンプレ / verification block テンプレ / branch table / secret naming / engine stanza / gate matrix / 5 段階 path matrix / evidence marker naming / canonical command invocation) の各 SoT が 1 箇所に集約され、他箇所は SoT への link で参照
- **T-PHASE10-008 (drift 取扱規則確定文化)**: §10.1 drift 深刻度判定基準 (5 質問) が確定、§10.3 RESULT block に blocking 修正済 commit 一覧 + cosmetic 持ち越し台帳 8 列 table が記録、Phase 11 持ち越し台帳が読み取り可能 (Phase 11 処理方針列で着手者が commit plan に落とせる)

### 5.3 検査主体

- **C2/C3/C4 各 commit**: 該当領域の T-PHASE10-* を commit 前に self-check (commit message 末尾に PASS literal 記録) + **post-commit mini checkpoint 3 質問** (§8.1、★ RD#1 Suggestion 9 反映)
- **C5 commit 直前**: rubber-duck #2 final review 8 観点
- **C5 commit**: rubber-duck #2 抽出 Blocking/Important 反映 (T-PHASE10-* partial re-check)
- **C6 commit 直前**: T-PHASE10-001〜008 全件を一括再検査、結果を §10.3 RESULT block に記録 + commit message 転記

---

## 6. Phase 10 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で Phase 10 close、M5 達成は Phase 11)

- [x] `phase-10-scenario-finish.md` 計画書 v1 publish (rubber-duck #1 反映済) — C1 commit (`f2f4d62`)
- [x] Step 0/1/2/3 README 推敲完了 + post-C2 mini checkpoint PASS — C2 commit (`ad59e17`)
- [x] Step 4/5/6 README 推敲完了 + post-C3 mini checkpoint PASS — C3 commit (`d35a75b`)
- [x] master-plan + VERSIONS + prerequisites 推敲完了 + post-C4 mini checkpoint PASS — C4 commit (`6608b09`)
- [x] **rubber-duck #2 (C5 着手前) 実施完了** + Blocking/Important 反映 — C5 commit (`137217f`、5 Blocking + 7 Important + S1 全反映、S2/S3 は Phase 11 持ち越し)
- [x] T-PHASE10-001〜008 全件 PASS (broken link 0 / 用語統一 / Trust thread 連結 / prereq 整合 / escape hatch 整合 / planning truth status final / 重複圧縮 / drift 規則確定) — C6 commit 直前再検査
- [x] step-{0..6}-gate / L1 smoke が C2/C3/C4/C5 commit 後すべて緑のまま維持 (workflow ファイル touch なし、ローカル static self-check 全 PASS。GitHub Actions runner queue 状態 = self-hosted runner offline は R03-7 = Phase 11 持ち越し既知事項であり Phase 10 close 判定対象外、★ RD#3-B3 反映)
- [x] `scenario-complete` branch push (D14 継承、SHA = C6 commit 一致) — C6 commit 後
- [x] §10.3 RESULT block 確定 (blocking 修正済 commit 一覧 = C2/C3/C4/C5 SHA + cosmetic 持ち越し台帳 8 列 table) — C6 commit
- [x] master-plan §9 Phase 10 ✅ + §11.5 M5 達成宣言 3 軸の最終確定文化 + §11.2 Phase 12 split criteria gate (RD#1 Important 8) + 改訂履歴更新 — C6 commit
- [x] **rubber-duck #1 (C1 直後) と #2 (C5 着手前) の 2 回実施完了**、各 finding を計画書本体 / commits に反映済
- [x] **`agents/` / `templates/` static consistency inspection 完了** (D10-10、blocking 修正は C2/C3、または C5 で rubber-duck #2 抽出 finding 経由)

### 6.2 ソフトゲート (任意)

- [ ] master-plan §6 R 表 status note の final 表記が Phase 09 完了後 view で **読み手にとって直感的** (= rubber-duck #2 で「自然な日本語か」軸でレビューしてもらう)
- [ ] §10.3 cosmetic 持ち越し台帳が **Phase 11 でそのまま order して処理できる程度に粒度が揃っている** (= rubber-duck #2 で「Phase 11 着手者視点で台帳を読んだら作業計画が立つか」軸でレビュー)
- [ ] Phase 10 commits の diff size が想定範囲 (各 commit 100〜400 行程度) — 超過時は推敲対象が広すぎる可能性

### 6.3 Phase 11 着手条件 / Phase 10 完了宣言

- 上記 §6.1 ハードゲート全項目 ☑ で Phase 10 close
- **§10.3 cosmetic 持ち越し台帳** が Phase 11 着手者にとって参照可能な状態であること (Phase 11 = dry-run 中に発見される drift と統一台帳で扱う土台)
- master-plan §5 milestone block: **M4 維持、M5 はまだ** (Phase 11 で達成宣言)
- Phase 11 で M5 達成宣言する 3 軸 (録画 / 実機完走 evidence / public release hardening) を §11.5 に明確化

---

## 7. リスク (Phase 10 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| **R10-1** | 推敲過程で **静かに blocking drift を見逃す** = 用語ゆれや link 切れを「cosmetic」と分類して Phase 11 持ち越し台帳に積んでしまうが、実は学習者完走を阻害する | 中/中 | §10.1 drift 深刻度判定基準の **5 質問** を **必ず通す** (即答できない場合は blocking 寄りに判断)、rubber-duck #2 で持ち越し台帳の判定を再 review |
| **R10-2** | A 軸推敲で **本文表現を変えた結果、既存 step-gate regex に引っかかる** = 推敲後に CI が壊れる | 中/低 | C2/C3 各 commit 前に local で `step-{N}-gate` を `act` で実行、引っかかる場合は本文を regex に合わせるか、§10.2 で記録して Phase 11 で regex 強化判断 (D10-5) |
| **R10-3** | Pattern 遡及適用 (P04-* ~ P09-* を Step 0/1/2/3 に適用するか判断) で **過剰適用** = 既存 Step の構成を壊して学習者の累積文脈を崩す | 中/中 | D10-6 judgment call 方針を §10.2 推敲チェックリストで明示、適用しない判断もログ化、rubber-duck #2 で過剰適用がないかレビュー |
| **R10-4** | B 軸推敲で **master-plan §6 R 表 status note を final 化したが、Phase 11 で再判断対象だった項目を確定文言にしてしまう** | 中/中 | §10.2 B 軸 checklist で「Phase 11 で再検証する項目は status note に "Phase 11 で再検証" を残す」を明示、rubber-duck #2 で各 R 項目の Phase 11 持ち越し可否を確認 |
| **R10-5** | 重複記述の SoT 圧縮で **学習者の文脈切替を減らすために意図的に置いていた重複** を機械的に削除 | 中/低 | D10-7 で SoT 圧縮対象を **構造化テンプレ (Trust thread 表 / 4 状態 done テンプレ / verification block テンプレ) に限定**、説明文の重複は触らない |
| **R10-6** | rubber-duck #2 で **Blocking 抽出が出たが C5 commit 内で反映時間が取れず Phase 11 へ送ってしまう** | 中/中 | rubber-duck #2 を C5 commit の **直前** (= C4 完了後 / C5 着手前) に実施、Blocking 反映を C5 commit に必ず内含、Important 以下のみ Phase 11 持ち越し可 |
| **R10-7** | Phase 11 持ち越し台帳が **粒度ばらつきで Phase 11 着手者が処理計画を立てられない** | 低/中 | §10.3 後半 (持ち越し台帳) を **8 列構造化 table** で固定 (# / drift 種別 / 該当 doc / 行番号 / 現状表現 / 推奨修正 / 優先度 / Phase 11 処理方針)、ソフトゲート §6.2 で rubber-duck #2 にレビュー依頼 |
| **R10-8** | rubber-duck #2 で **Blocking 抽出が出たが C5 close commit に混ざって commit graph が複雑化**、再 review しづらくなる (★ RD#1 Blocking 2) | 中/中 | C5 = rubber-duck #2 remediation 専用、C6 = pure close commit に分離。no Blocking / no Important なら C5 を minimal commit (改訂履歴 entry のみ) に縮退 |
| **R10-9** | `agents/` `templates/` の README ↔ sample 不一致 / safety boundary 違反 / copy-paste failure を **Phase 10 で見逃して Phase 11 dry-run で初発覚** (★ RD#1 Important 3) | 中/中 | D10-10 で blocking static consistency inspection を C2/C3 内に組み込み、§5.2 T-PHASE10-002 / 003 / 004 の検査範囲に含める。post-C2/C3 mini checkpoint 質問 3 で再確認 |

---

## 8. 進め方 (6 commits + branch / 線形依存 / rubber-duck 2 回 + post-commit mini checkpoint)

```
[Phase 10 着手 = ユーザー判断 2026-04-26 確定: 録画/実機完走/dry-run = Phase 11]
 │
 ▼
C1 = phase-10-scenario-finish.md plan v1 + master-plan §9 🟡 + §5 M5 軸明示化
 │
 ├── ★ rubber-duck #1 (C1 直後 = 計画レビュー)
 │     - スコープ妥当性 (A/B/C 軸 = 静的推敲のみ、動的検証は Phase 11)
 │     - 6 commits 分割の妥当性 (C1 plan / C2 light / C3 heavy / C4 planning / C5 RD#2 remediation / C6 close)
 │     - drift 取扱規則 (§10.1) の 5 質問判定が機能するか (RD#1 Important 4)
 │     - 持ち越し台帳 (§10.3 後半) の 8 列構造化 table が Phase 11 で使えるか (RD#1 Important 5)
 │     - rubber-duck 抽出 finding を計画書本体 + master-plan に反映 (C1 内)
 │
 ▼
C2 = Step 0/1/2/3 README 推敲 + content/README.md 該当行 + agents/templates static inspection (D10-10)
 │   - 用語統一 / Trust thread 連結 / クロス link / prereq 整合 / 重複圧縮 (D10-7 拡張範囲)
 │   - step-{0..3}-gate 緑 + broken link 0 件 self-check
 │   - ★ post-C2 mini checkpoint (§8.1 = 3 質問 self-review、★ RD#1 Suggestion 9)
 │
 ▼
C3 = Step 4/5/6 README 推敲 + content/README.md 該当行 + agents/templates static inspection (D10-10)
 │   - 用語統一 / Trust thread 連結 / 4 状態 done テンプレ / 5 段階 path / 任意 Step 救済
 │   - step-{4..6}-gate 緑 + broken link 0 件 self-check
 │   - ★ post-C3 mini checkpoint (§8.1)
 │
 ▼
C4 = master-plan / VERSIONS / prerequisites 推敲
 │   - status note final 化 / 重複圧縮 / 観察可能な範囲での最新化 (§10.2 B 軸 Phase 10/11 boundary 明示)
 │   - smoke 緑 + planning truth grep 陳腐化 0 件 self-check
 │   - ★ post-C4 mini checkpoint (§8.1)
 │
 ├── ★ rubber-duck #2 (C5 着手前 = final review、★ Phase 09 §11.5 同型)
 │     8 観点で final review:
 │     1. 7 Step 一貫性 (用語 / Trust thread / 4 状態 done / verification block / 任意 Step)
 │     2. master-plan §6 R 表 status final 表記の自然さ + Phase 11 持ち越し可否判定
 │     3. drift 取扱規則 §10.1 の 5 質問が blocking/cosmetic を分けられているか
 │     4. §10.3 RESULT block (blocking 修正済 + cosmetic 持ち越し台帳 8 列) が Phase 11 で使えるか
 │     5. T-PHASE10-001〜008 全件 PASS literal が C6 commit message に反映可能か
 │     6. M4 vs M5 分離宣言 (§11.5) が Phase 09 §11.5 から後退していないか + Phase 12 split gate (§11.2) 妥当性
 │     7. Pattern 遡及適用 (P04-* ~ P09-*) で過剰適用がないか + decision log の説得力 (D10-6)
 │     8. 重複記述 SoT 圧縮 (D10-7 拡張範囲) で意図的な重複を消していないか
 │   - Blocking 抽出 ⇒ C5 commit 内で必ず反映
 │   - Important 抽出 ⇒ C5 commit 内で反映 (Phase 11 持ち越しは判断 case-by-case)
 │   - Suggestion 抽出 ⇒ Phase 11 持ち越し可
 │
 ▼
C5 = rubber-duck #2 findings remediation (★ RD#1 Blocking 2 反映で C6 と分離)
 │   - 該当 README / planning truth / agents-templates の修正
 │   - T-PHASE10-* partial re-check (修正領域のみ)
 │   - no Blocking / no Important なら minimal commit に縮退 (改訂履歴 entry のみ)
 │
 ▼
C6 = phase-10 doc DoD ☑ + §10.3 RESULT block + master-plan §9 ✅ + §11.5 + §11.2 Phase 12 split gate + 改訂履歴
 │   + scenario-complete branch push (D14 継承、SHA = C6)
 │   - T-PHASE10-001〜008 全件 PASS 一括再検査、commit message に literal 記録
 │   - rubber-duck #2 反映点を改訂履歴 entry に詳細記録
 │
 ▼
[Phase 10 close 完了] → M4 維持 + Phase 11 着手準備完了
                       (M5 達成宣言は Phase 11 で 3 軸一括、または overload 時 Phase 12 で軸 3 分離)
```

### 8.1 post-commit mini checkpoint (★ RD#1 Suggestion 9 反映、C2/C3/C4 後)

各 commit 後に 3 質問 + 共通 Q4 (= 4 質問) self-review を実施 (rubber-duck full ではなく軽量 self-check、C5 の負荷を下げる):

**post-C2 mini checkpoint (Step 0/1/2/3 推敲後)**
1. C2 diff に Step 4/5/6 の概念を不用意に持ち込んでいないか?
2. Step 0/1/2/3 の prereq / Trust thread / link が C3 前提と矛盾していないか?
3. C2 で発見した C3/C4 対象 drift を §10.3 candidate に積んだか?

**post-C3 mini checkpoint (Step 4/5/6 推敲後)**
1. C3 diff に C2 で確定した Step 0/1/2/3 の用語 / 構造を逆引きで壊していないか?
2. 4 状態 done テンプレ / 5 段階 path matrix が D10-7 拡張範囲の SoT (master-plan §4.5 等) と齟齬なく繋がるか?
3. `agents/code-reviewer.agent.md` / `templates/pr-required-check.yml` の static consistency (D10-10) を README と照合済か?

**post-C4 mini checkpoint (planning truth 推敲後)**
1. master-plan §6 R 表で「Phase 11 で再検証」を残すべき項目を確定文言にしてしまっていないか? (R10-4)
2. VERSIONS の最新化が「観察可能な範囲」(§10.2 B 軸 boundary) を超えて実機 verify 必要範囲に踏み込んでいないか?
3. prereq P1〜P12 と本文 (Step 0〜6) の back-link が双方向健全か?

**共通 Q4 (post-C2/C3/C4 全 mini checkpoint で必須、★ RD#2-I6 反映)**
- T-PHASE10-* の PASS 判定に手動除外 / historical snapshot 除外 / false positive がある場合、その理由と対象行を §10.1 whitelist 規則 + §10.3 もしくは decision log に記録したか? historical phase docs を close-time snapshot として扱う対象 / 対象外境界を明記したか? (= raw regex hit 0 ではなく whitelist 適用後 0 を T-PHASE10-001 PASS の根拠にする運用)

---

## 9. 参考 (内部資料)

- `docs/planning/00-master-plan.md` §4.5 / §4.5.3 / §5 milestone / §6 R 表 / §9 進捗 / §11.5
- `docs/planning/phase-09-step6-gate.md` §11.1〜§11.5 (P09-1〜8 + §11.3 S10-* 申し送り = 全て Phase 11 へ移送 / §11.4 Phase 11 で再検証候補 / §11.5 M4 達成宣言の品質規約)
- `docs/planning/phase-08-step5-multi-engine.md` §11.3 S10-1〜S10-4 (録画関連、全て Phase 11 へ移送)
- `docs/planning/VERSIONS.md` §1〜§10
- `content/prerequisites.md` P1〜P12 + 環境チェック ①〜⑫
- `content/step-{0..6}/README.md` (推敲対象本体)
- ユーザー判断 (2026-04-26): 録画 / dry-run / 実機完走 = Phase 11 統合、Phase 10 = シナリオ完成 (静的推敲) のみ

---

## 10. 推敲方針 + drift 取扱規則 + RESULT block

### 10.1 drift 深刻度判定基準 (★ D10-3、5 質問に拡張 = RD#1 Important 4 反映)

推敲過程で見つかった drift は以下の **5 質問** を順に通して判定。**1 つでも Yes ⇒ Blocking** (Phase 10 内で即修正)、**全 No ⇒ Cosmetic** (Phase 11 持ち越し台帳に積む):

1. **学習者完走 / copy/paste 実行 / gate 通過を阻害するか?** — 完走できる場合でも、コマンド / file path / secret 名が誤っていて学習者が copy/paste でつまずくなら Yes
2. **事実矛盾 / SoT 矛盾 / evidence 矛盾を含むか?** (例: master-plan の記述と本文の記述が食い違う / 計画書 commit SHA が間違っている / link 先が削除されている / Phase 09 で確定した P09-* と本文が分岐 / **commit order・branch push timing・close criteria 等の process drift も含む**、★ RD#2-S1 反映) — Yes ⇒ Blocking
3. **broken link / broken anchor か?** (相対 link / anchor link が解決できない / リダイレクト先 404 / heading slug 不一致) — Yes ⇒ Blocking
4. **security / privacy / secret handling / agent permission boundary を弱めるか?** (★ RD#1 追加: `.agent.md` sample が write 権限を示唆 / PAT secret 扱いが不適切 / `tools:` に `edit`/`shell`/broad write が混入)
5. **Phase 11 の M5 evidence 取得を誤誘導するか?** (★ RD#1 追加: 録画シナリオで撮るべき UI 画面の labeling と本文 labeling が分岐 / E10/E11 marker 取得位置が本文と矛盾 / GitHub plan / Copilot plan の境界記述が public release と齟齬)

**Cosmetic (全 No)** = Phase 11 持ち越し台帳に積む (§10.3 8 列 table):

#### Broken-link self-check whitelist 規則 (★ RD#2-B5 / RD#2-I7 反映、T-PHASE10-001 PASS 判定の前提)

T-PHASE10-001 の PASS 判定は **raw regex hit count = 0** ではなく、**whitelist 適用後の unresolved local link = 0** とする。raw regex `\[[^\]]+\]\((?!https?://|mailto:|file://|#)([^)\s#]+)(#[^)]*)?\)` を全 `.md` に適用後、以下を whitelist として除外:

1. **inline code span / fenced code block 内の例示 link**: 学習者向けの記述例 (例: `[label](path)` 形の syntax 説明) は除外
2. **image placeholder syntax**: shields.io 等の `![Status](...)` で `...` を URL として書く慣例 (例: §10.3 L01 cosmetic 行内の badges 列挙) は除外
3. **歴史的 phase docs (`docs/planning/phase-0[3-9]-*.md`) 内の close-time relative path**: 凍結方針 (§2.2) により blocking 対象外、判定は learner-facing 転記の有無で行う (転記がなければ Phase 11 持ち越し)
4. **Phase 10 §10.3 持ち越し台帳行内の `現状表現` 列 / `推奨修正` 列**: 修正対象自体を引用するため raw hit するが、これは指摘文章内の例示

判定は人手で whitelist 該当性を確認し、§10.3 もしくは C6 RESULT block の "known false positives / excluded" subtable に記録する。**Phase 10 では外部 URL の HTTP status check は対象外** (= syntax のみ、Phase 11 dry-run で `curl -I` 一括検査)。
- 表記ゆれ (例: "Cloud Agent" と "Coding agent" の混在で意味は通じる、ただし統一が望ましい)
- cosmetic UI label (例: GitHub UI のボタン文言が semantic anchor と微妙に違うが操作可能)
- 章立て改善余地 (例: §3.A と §3.B の順序入れ替えで読みやすくなる、ただし現行で完走可能)
- 説明文の冗長性 (D10-7 で構造化テンプレ以外は触らない方針のため Phase 11 持ち越し)

### 10.2 推敲チェックリスト (各 commit で参照)

#### A 軸 (Step README) — C2 / C3 で参照

- [ ] **用語統一 軸**: 以下の用語が Step 0〜6 全 README で同一表現
  - Required Review Gate (Reviews 経路) / Required Status Check (Status Checks 経路) — Important 5
  - Trust thread Layer 0 (MCP) / Layer 1 (Memory) / Layer 2 (Skill) / Layer 3 (Surfaces) / Layer 4 (Automate) / Layer 5 (Multi-engine) / Layer 6 (Gate)
  - `.agent.md` 用語: "再利用可能なレビュアー人格" / "Path C = Copilot Code Review" / "Path A/B = Check Run Agents (preview/未公開)"
  - 4 状態 done テンプレ: 各 Step の done 状態名が `Setup ready` / `Step N minimum complete` / `Step N full complete` / `Step N {fallback,degraded,...} complete` 型に揃う
  - verification block 名: "MCP verification block (V1-V4)" / "gh-aw runtime verification block" / "UI-only verification block" の 3 種類が混同されない
  - engine canonical 表現: "scalar form (`engine: claude`) / object form (`engine:\n  id: claude`) の両形 OR" — D08-13
  - 任意 Step 表記: "Step 5 = 任意" / "Step 6b = 発展題材" / "Step 6 §3 Appendix = 任意発展" — P08-4

- [ ] **Trust thread 連結 軸**: 各 Step §6 「次の Step」セクションが転記齟齬なく繋がる
  - Step 0 §6 → Step 1 冒頭 / Step 1 §6 → Step 2 冒頭 / ... / Step 5 §6 → Step 6 冒頭

- [ ] **クロス link 軸**: 全相対 link が alive (T-PHASE10-001 = `find . -name "*.md" -exec ...`)

- [ ] **prereq ↔ 本文整合 軸**: 各 Step §2 前提が `content/prerequisites.md` の P1〜P12 と back-link 健全

- [ ] **Pattern 遡及適用 軸 (D10-6 judgment call)**:
  - P04-* (Memory ファイル削除手順 = R12) → Step 1 で反映済か確認、他 Step に波及不要
  - P05-* (Skill 最小 frontmatter 2 フィールド = R1) → Step 2 で反映済か確認、他 Step に波及不要
  - P06-* (Pro plan degraded complete pattern) → Step 3 で反映済、Step 6 で 5 段階 path に拡張済 (P09-2 経由)
  - P07-* (gh aw heavy demo + canonical templates) → Step 4 で反映済、Step 5 で engine 切替 + 4 状態 done に拡張済
  - P08-* (任意 Step 救済 §1/§3/§4 の 3 箇所明示 = P08-4) → Step 5 で反映済、Step 6b §3 Appendix にも遡及適用済か確認
  - P09-* (UI-only verification block = P09-1 / 5 段階 path matrix = P09-2 / Required Review Gate vs Required Status Check 用語分離 = P09-3 / `.agent.md` 安全性 = P09-4 / `.agent.md` copy target + invocation path = P09-5 / M4 vs M5 = P09-6 / GitHub plan vs Copilot plan = P09-7 / Trust thread Layer 接続表 = P09-8) → Step 6 で確立、他 Step への遡及適用判断 (例: P09-8 Trust thread Layer 接続表 を Step 5 §6 にも適用するか)

- [ ] **重複記述 SoT 圧縮 軸 (D10-7 限定)**:
  - Trust thread 表 (Layer 1〜6 全体図): SoT を `content/README.md` または `docs/planning/00-master-plan.md` §4.5 に集約、各 Step は概要のみ + SoT への link
  - 4 状態 done テンプレ説明: SoT を `content/README.md` または `docs/planning/00-master-plan.md` §4.5.3 に集約 (該当する場合)
  - verification block テンプレ説明: SoT を `docs/planning/00-master-plan.md` §4.5.3 に集約 (Phase 09 で確立済、Step 6 README で参照済か確認)

#### B 軸 (planning truth) — C4 で参照

- [ ] **master-plan §6 R 表 status final 化 軸 (R10-4 対策)**:
  - R1 / R2 / R3 / R4 / R5 / R6 / R7 / R8 / R9 / R10 / R11 / R12 / R13 の status note を Phase 09 完了後 view で確認
  - "進行中" / "Phase 09 着手" / "Phase 09 で再検証" 等の Phase 09 進行中表現 → "Phase 09 完了" / "Phase 11 で再検証" 等の final 表記に統一
  - **Phase 11 で再判断対象の項目** (例: R6 = engine x secret マトリクス確定 / R11 = Path A/B GA 状況再判断 / R3 = self-hosted runner CI 緑化) は status note に **"Phase 11 で再検証"** を必ず残す (R10-4 対策)

- [ ] **§4.5 / §4.5.3 vs phase doc 重複圧縮 軸**:
  - master-plan §4.5 (Step 構成定義) と各 phase-NN-*.md §1.1 〜 §1.4 の重複部分を確認、master-plan を SoT として圧縮可能ならば phase doc は SoT への link で参照
  - master-plan §4.5.3 (verification block 規約) と phase-09 §10.4 (Step 6 UI verification block 4 項目) の重複確認、master-plan を SoT として phase-09 は SoT 参照型に圧縮可能

- [ ] **VERSIONS 観察可能な範囲での最新化 軸 (★ RD#1 Suggestion 11 = Phase 10 / Phase 11 boundary 明示)**:
  - **Phase 10 OK** = 公開情報のみで確認できる更新:
    - GitHub release page / docs / changelog で確認できる公開情報 (例: gh aw release page で v0.69+ 確認)
    - repo 内の現在ファイルから確認できる情報
    - 既存 CI logs から確認できる情報
  - **Phase 11 持ち越し** = 動的検証が必要な更新:
    - UI 操作が必要 / screenshot / recording が必要
    - user account / plan / org policy に依存
    - live invocation / 実機 verify が必要
  - 対象範囲: §1 (gh aw v0.68.3) / §2 (Skills frontmatter) / §3 (Memory パス) / §4 (engine x secret) / §5 (Cloud Agent firewall) / §6 (E5 Path C) / §7 (E7' Cloud Agent 正規トリガ) / §8 (Trust thread Layer 規約) / §9 (engine canonical 両形 OR) / §10 (Branch protection / Required Review UI canonical labels)
  - Phase 11 持ち越し対象は §10.4 Drift watch に追記、§10.3 持ち越し台帳に `needs-dynamic-verify` 方針で積む

- [ ] **prerequisites P1〜P12 過不足検査 軸**:
  - P1 (env) / P2 (gh CLI) / P3 (PAT sanity check) / P4 (VS Code 拡張) / P5 (Codespaces 起動) / P6 (Cloud Agent firewall allowlist) / P7 (Memory 削除手順) / P8 (Skills frontmatter) / P9 (Surfaces 3 種) / P10 (`gh aw secrets set` 主導線) / P11 (engine secret 命名規約) / P12 (GitHub plan vs Copilot plan 5 項目)
  - 環境チェック ①〜⑫ が全件揃って陳腐化 0 件
  - 各 P が対応する Step 番号への back-link 健全

#### C 軸 (drift 取扱) — C5/C6 で参照

- [ ] **drift 深刻度判定 (§10.1 5 質問) を全 drift に適用**: blocking 判定された drift は C2/C3/C4 内で修正済、cosmetic 判定された drift は §10.3 持ち越し台帳に積み済
- [ ] **持ち越し台帳が 8 列構造化 table で記録** (★ D10-4): # / drift 種別 / 該当 doc / 行番号 / 現状表現 / 推奨修正 / 優先度 / Phase 11 処理方針
- [ ] **rubber-duck #2 で持ち越し判定を再 review**: Blocking 抽出 ⇒ C5 内で必ず反映、Important ⇒ C5 反映 (Phase 11 持ち越しは判断 case-by-case、R10-6 対策)、Suggestion ⇒ Phase 11 持ち越し可
- [ ] **D10-6 Pattern 遡及適用 decision log** (mini table): 適用した Pattern と適用しなかった Pattern を理由付きで記録 (rubber-duck #2 で過剰/過小適用判定の根拠資料に)

| Pattern | 対象 Step | Apply? | 理由 |
|---|---|---:|---|
| (P09-1 UI verification block) | (Step 0) | (No / Yes) | (Step 0 は MCP verification block 主軸のため適用しない、等) |

### 10.3 RESULT block (C6 で記入)

> **記入規則**: C5 (rubber-duck #2 remediation) 完了後、C6 commit 直前に本 block を確定記入する。

#### Blocking 修正済 commit 一覧 (Phase 10 内で完了)

| commit SHA | 該当 doc | drift 内容 | 修正方針 |
|---|---|---|---|
| `ad59e17` (C2) | content/step-{0,1,2,3}/README.md | Step 1 broken link `../step-3-where-to-run/` (相対 path 1 段ずれ)、Step 2 broken link `../templates/triage-issue.md` 同型、Step 3 broken link `../step-2-skill/templates/triage-issue.md` 同型 | 全 3 件相対 path を `../../step-X-Y/` 形に補正、broken-link self-check 0 件確認 |
| `d35a75b` (C3) | content/step-{4,5,6}/README.md + content/README.md + phase-10 §10.3 | Step 4 line 401 + Step 5 line 331 broken link `../step-6a-required-check/` → `../step-6-gate/` (Q1)、Step 5 line 8/281/285 + Step 6 line 275/277 + content/README.md line 65 「Phase 10 提供予定」 → 「後続 Phase で提供予定」(Q2 SoT)、Step 6 line 284 M5 達成 path を Phase 10 = 静的推敲のみ + 録画 Phase 11 移送 と整合 (Q4)、§10.3 backlog L02 = Step 6 sample wording drift 新規記録 | broken link 7 → 0 件、Phase 10 → 後続 Phase 6 件、M5 path 1 件、§10.3 backlog 8 列構造で L01 確定形 + L02 追加 |
| `6608b09` (C4) | docs/planning/00-master-plan.md + docs/planning/VERSIONS.md + content/prerequisites.md + content/README.md | master-plan §4 Phase 10/11 行定義 = 旧「検証 / Dogfooding」「公開準備 / リリース」 → 新「シナリオ完成 (静的品質推敲)」「Dogfooding / 公開リリース hardening」(Q2 SoT)、§4.5 Step 5 row 録画 reference + §6 R4 録画 reference を Phase 11 以降 (Q2)、VERSIONS L92 / L115 / L569 「Phase 10 (Dogfooding)」「Phase 10 で提供予定」 → Phase 11 dogfooding (Q2)、prereq L45 / L87 「Phase 10 提供予定」 → 後続 Phase (Q2)、content/README L6 outdated 「Phase 09 進行中時点」「録画 (Phase 10) と公開リリース hardening (Phase 11) は持ち越し」 → 「Phase 10 進行中時点 + シナリオ完成 = 静的品質推敲中」「Phase 11 以降に持ち越し」 (Q2) | 全 8 箇所 SoT 整合、broken-link self-check 0 件 (新規 broken link 導入なし)、§9 Phase 10 進捗行は C6 で ✅ に更新予定 (本 commit では touch せず) |
| `137217f` (C5) | content/step-{5,6}/recordings/README.md + docs/planning/00-master-plan.md + docs/planning/VERSIONS.md + docs/planning/phase-10-scenario-finish.md (本ファイル) | rubber-duck #2 抽出 5 Blocking + 主要 Important: RD#2-B1 = recordings placeholder learner-facing stale wording (Phase 10 → Phase 11 以降、S10-* → S11-* / 旧 S10-*、Step 5 / Step 6 計 13 行修正)、RD#2-B2 = master-plan §4.5 line 101 + §6 R4 line 167 + §6 R6 line 169 (Phase 10/11 で回収 / S10-* / Phase 10 で再検証 / Phase 08 動画スクリプト並行 = 4 箇所修正)、RD#2-B3 = phase-10 doc 3 質問 vs 5 質問 inconsistency (line 239 R10-1 + line 489 P10-2 = 2 箇所を 5 質問に統一)、RD#2-B4 = branch / close timing C5/C6 矛盾 (line 134 + line 146 = 2 箇所を C6 へ訂正)、RD#2-B5 = broken-link self-check whitelist 規則明文化 (§10.1 末尾 4 項目 whitelist subsection 新設)。Important: I1 = 本ファイル §1.1 line 14 に content/README.md 追加、I2 = §2.2 末尾に歴史 phase docs 凍結方針 note 新設、I3 = §10.3 L03 = historical docs row 追加、I4 = VERSIONS.md L560 S10-* → S11-* / 旧 S10-*、I5 = §11.5 M5 達成宣言条件に Phase 12 split fallback note 追加、I6 = mini checkpoint 共通 Q4 = whitelist / false positive 記録質問追加、I7 = §10.1 whitelist 規則で raw regex hit ≠ PASS を明文化 (B5 と統合)、S1 = §10.1 Q2 + P10-2 に process drift 含意を明記 | RD#2 の Blocking 5 件すべて反映、Important 7 件すべて反映、Suggestion 1 件 (S1) 反映。Suggestion 2 (Phase 11 hardening bucket: i18n/accessibility/licensing/external link rot) は Phase 11 計画書で対応、Suggestion 3 (§10.3 owner / target commit / evidence required 列追加) は Phase 11 持ち越し時に転記で追加。broken-link self-check 新規 broken link 0 件 (whitelist 適用後)、step-gate 全緑維持 (workflow touch なし) |

#### Cosmetic 持ち越し台帳 (Phase 11 で処理、★ D10-4 = 8 列構造化 table、RD#1 Important 5 反映)

| # | drift 種別 | 該当 doc | 行番号 | 現状表現 | 推奨修正 | 優先度 | Phase 11 処理方針 | owner | target commit | evidence required |
|---|---|---|---|---|---|---|---|---|---|---|
| L01 | 章立て / header style 不統一 | content/step-{0,1,2,3,4,5,6}-*/README.md | 各 README L3 | Step 0/1 = shields.io badges (`![Status](...)![Required](...)![Layer](...)![Time](...)`)、Step 2/3/4/5/6 = blockquote text (`> **必須 Step (...)** ・ 体感 ~XX 分` 系) | 7 Step すべて同型 (badges もしくは blockquote text のいずれか) に統一 | 中 | `release-hardening` (README 公開トーン化 commit と同 commit、視覚一貫性は keynote 視聴者向けに重要) | CLI agent | C4 (`ec1b7fa`) | git diff で Step 0/1 が blockquote 形式 (Step 2-6 と同型) になっていること確認 = **済** |
| L02 | sample 抜粋 vs canonical file の description 行 wording drift | content/step-6-gate/README.md L139 vs content/step-6-gate/agents/code-reviewer.agent.md L3 | README L139 = `(Step 6b sample、Required Check には未対応 = Path A/B GA 待ち)` / 実 file L3 = `(Step 6b sample、Required Check には未対応 = Path A/B GA 待ち = R11)` | README §3.F.minimum-sample を実 file 全文と完全一致 (`= R11` 末尾を追記) させ、`canonical sample 1 ファイル分の内容` の SoT 性を回復 | 低 | `release-hardening` (公開前最終整合チェック commit と同 commit、概念は伝わるため学習者完走には影響なし) | CLI agent | C4 (`ec1b7fa`) | `diff <(sed -n 'X,Yp' README.md) agents/code-reviewer.agent.md` で差分 0 確認 = **済** |
| L03 | 歴史的 phase docs (`docs/planning/phase-03〜phase-09-*.md`) 内 close-time SoT snapshot 記述 | docs/planning/phase-{03,04,05,06,07,08,09}-*.md 各所 | `Phase 10 (Dogfooding)` / `Phase 10 で再検証` / `S10-1〜S10-8` / `Phase 10 で録画提供` 等 | **C6 で master-plan §改訂履歴 Phase 10 完了 entry に「歴史 docs は close-time snapshot として保存、最新 SoT は master-plan / VERSIONS / prereq / content README / phase-10/11 doc に集約」1 段落 = 反映済**。Phase 11 残作業 = ① master-plan §4 Phase 11 行に同方針の 1 行明記、② phase-11 計画書 §1 で同方針を冒頭明示 (各 phase docs 自体は変更しない) | 低 | `phase11-plan-start` (Phase 11 計画書 C1 commit と同 commit、各 phase docs の旧 Phase 10/11 表現は変更しない、★ RD#2-I2 + RD#3-I3 反映) | CLI agent | C1 (`eb36271`) + C4 (`ec1b7fa`) | master-plan §4 Phase 11 行に凍結方針 1 行 + phase-11 §1 で同方針冒頭明示 = **済** |

**Phase 11 処理方針** の凡例:
- `recording-before`: 録画前に修正必須 (画面に映る本文が drift)
- `dry-run-during`: dry-run 中に発見される実機 drift と一括処理
- `release-hardening`: README 公開トーン化 / LICENSE / CONTRIBUTING と同 commit
- `phase11-plan-start`: Phase 11 計画書 C1 commit と同 commit (= Phase 11 §1 / §2 設計時に同時反映、★ RD#3-I3 反映)
- `after-evidence`: 実機 evidence 取得後に判断
- `needs-dynamic-verify`: 動的検証が必要 (UI screenshot / live invocation)

> **Phase 11 着手時の運用**: 本台帳を Phase 11 dry-run で発見される実機 drift と統一台帳で扱う。Phase 11 の最初の commit で本台帳を `phase-11-*.md` の §10.3 持ち越し台帳セクションへ転記し、優先度順に処理する。

#### T-PHASE10-001〜008 全件 PASS literal (C6 commit message に転記)

```
T-PHASE10-001 (broken link 0 件): PASS
T-PHASE10-002 (用語統一): PASS
T-PHASE10-003 (Trust thread 連結): PASS
T-PHASE10-004 (prereq ↔ 本文整合): PASS
T-PHASE10-005 (escape hatch 表整合): PASS
T-PHASE10-006 (planning truth status final): PASS
T-PHASE10-007 (重複記述 SoT 圧縮): PASS
T-PHASE10-008 (drift 取扱規則確定文化): PASS
```

---

## 11. Phase 11+ への申し送り

> **位置付け**: Phase 10 (シナリオ完成) で確立する設計パターンと、Phase 11 計画書執筆時に必ず確認するチェックリスト。Phase 04〜09 §11 と同型構造。

### 11.1 Phase 10 で確立する設計パターン (Phase 11+ で踏襲、C5 で確定)

- **P10-1**: 静的推敲 Phase は新 Step / 新 step-gate job を追加せず、推敲 commits + 既存 gate 維持で完走 (D10-5)
- **P10-2**: drift 深刻度判定は **5 質問** (完走/copy-paste/gate 阻害 / 事実-SoT-evidence 矛盾 / broken link / safety boundary 弱化 / M5 evidence 誤誘導) を blocking 判定の規約とする。即答できない場合は blocking 寄りに判断、Q2 には commit order / branch push timing / close criteria 等の **process drift も含む** (★ RD#2-S1 反映)。歴史的拡張経緯は P10-8 参照 (D10-3)
- **P10-3**: 推敲 commits は領域分割 (light Step 群 / heavy Step 群 / planning truth) で diff size を制御 (D10-2)
- **P10-4**: Pattern 遡及適用は judgment call + apply 4 条件 (learner-visible / 同 concept-artifact-command / SoT 分岐回避 / 学習順序非破壊) すべて Yes で apply、skip 判断は decision log に記録 (D10-6 / R10-3 対策)
- **P10-5**: 重複記述 SoT 圧縮は構造化テンプレに限定 (Trust thread 表 / 4 状態 done / verification block / branch table / secret naming / engine stanza / gate matrix / 5 段階 path matrix / evidence marker / canonical command invocation)、説明文の意図的重複は触らない (D10-7 / R10-5 対策)
- **P10-6**: cosmetic drift は 8 列構造化 table 持ち越し台帳で Phase 11 へ送り、dry-run drift と統一台帳で扱う (D10-4 / R10-7 対策、Phase 11 処理方針列で `recording-before` / `dry-run-during` / `release-hardening` / `after-evidence` / `needs-dynamic-verify` 分類)
- **P10-7**: rubber-duck #2 final review は **C5 着手前** に実施し、Blocking/Important 反映を **C5 commit 専用** に分離 (close commit C6 と分離、Phase 09 同型「rubber-duck → close 直結」を改善)
- **P10-8**: drift 深刻度判定は **5 質問** (RD#1 Important 4 反映、3 質問 → 5 質問に拡張 = 完走/copy-paste/gate / 事実-SoT-evidence 矛盾 / broken link / safety boundary / M5 evidence 誤誘導)
- **P10-9**: 静的推敲 Phase でも `agents/` `templates/` 等の sample/canonical asset は **大規模推敲対象外だが blocking static consistency inspection の対象** (D10-10、README ↔ sample 不一致 / safety boundary 違反 / copy-paste failure)

### 11.2 Phase 11 計画書 §1 / §2 で必ず確認するチェックリスト + Phase 12 split criteria gate (★ RD#1 Important 8 反映、C6 で確定)

**Phase 11 計画時の split decision gate** (overload 防止):

> Phase 11 計画書執筆時に、以下のいずれかが該当すれば **Phase 12 = Public Release Hardening を新設** し、M5 達成宣言を Phase 12 に分離する:
>
> - public release hardening の対象が N commits / N files を超える (例: README 公開トーン化大規模 + CONTRIBUTING 新規 + LICENSE 確定 + release note + tag automation + org policy 設定 が 5+ commits 必要)
> - 録画再撮影 + dry-run 全 7 Step 通し + release hardening の 3 軸を 1 Phase で並走させると commit graph が複雑化して相互 blocking する
> - rubber-duck #1 (Phase 11) で「3 軸一括は overload」と判定された
>
> 該当しない場合は **Phase 11 で M5 3 軸一括達成** (現行プラン継続)。
>
> Phase 12 分割案 (該当時のみ採用):
> - **Phase 11**: Dogfooding + dry-run + recording + E10/E11 marker 回収 (M5 軸 1 + 軸 2)
> - **Phase 12**: Public release hardening + LICENSE / CONTRIBUTING / release note / final tag (M5 軸 3 のみ)
> - M5 達成宣言は Phase 12 close commit で行う (master-plan §5 milestone block + §11.5 を Phase 12 で更新)

**Phase 11 計画書 §1 / §2 で確認するチェックリスト**:

- 候補 1: **M5 達成宣言の 3 軸**: 録画完備 / 実機完走 evidence (E10 + E11-*) / public release hardening の **すべてを 1 Phase で達成**するスコープ妥当性確認 (上記 split gate を必ず通す)
- 候補 2: **dry-run scenario 設計**: 全 7 Step を 1 take で通すか / Step ごと分割するか / heavy Step (4/5/6) のみ重点的に dry-run するか
- 候補 3: **録画 hosting 方式確定**: YouTube unlisted / Vimeo / GitHub Pages MP4 / git LFS / アスキーキャストのみ (Phase 09 §11.4 で持ち越した軸)
- 候補 4: **§10.3 持ち越し台帳の処理計画**: Phase 10 で積まれた cosmetic drift を Phase 11 のどの commit で処理するか (8 列 table の Phase 11 処理方針列を commit plan へ転記)
- 候補 5: **R03-7 self-hosted runner CI 緑化**: Phase 11 で `ubuntu-latest` 化と同時に解決する commit を計画書に明示
- 候補 6: **public release hardening 範囲**: README 公開トーン化 / CONTRIBUTING / LICENSE 確定 / リリース note / org level 設定 / 公開リポ準備の各項目を §2 IN SCOPE / OUT OF SCOPE に分類 + split gate 判定資料
- 候補 7: **external URL HTTP status check / link rot hardening** (★ RD#3-I6 反映): Phase 10 §10.1 で out-of-scope とした external URL の HTTP status / redirect / 404 / auth-required 分類検査を Phase 11 dry-run で `curl -I` 一括実行 + 結果記録、§2 IN SCOPE として明示 (i18n / accessibility / licensing と同 hardening bucket)
- 候補 8: **P10-1〜9 設計パターンの転記** (★ RD#3-S1 反映): 本ドキュメント §11.1 の P10-1〜9 を Phase 11 計画書 §1.1 / §8 / §10.3 に転記 (drift 5 質問 / §10.3 8 列構造化 / broken-link whitelist 4 項目 / 歴史 phase docs 凍結方針 / 6 commits + branch + rubber-duck 2 回 + mini checkpoint 3 回 / Pattern 遡及 decision rule / D10-7 SoT 拡張 / Phase 12 split criteria gate / static consistency inspection)
- 候補 9: **歴史的 phase-03〜09 docs 凍結方針の Phase 11 側適用** (★ L03 残作業 = RD#3-I3 反映): master-plan §4 Phase 11 行に「歴史 docs は close-time SoT snapshot」1 行明記 + phase-11 計画書 §1 冒頭で同方針明示 (各 phase docs 自体は変更しない)

### 11.3 Phase 11 (Dogfooding + 録画 + Public release hardening) への具体示唆

Phase 09 §11.3 / Phase 08 §11.3 で示唆していた **S10-1〜S10-8 の全項目を Phase 11 に移送** (ユーザー判断 2026-04-26):

- **S11-1〜S11-8 (旧 S10-1〜S10-8)**:
  - S11-1〜S11-4: Step 5 multi-engine 録画関連 (3 engine head-to-head / API key 黒塗り / dogfooding discovery 再現確認 / `compare-runs.md` 書き写しテンプレ)
  - S11-5〜S11-8: Step 6 gate 録画関連 (Step 6a heavy demo / Step 6b light appendix / §3 Appendix workflow 任意発展 / degraded path screenshot + docs trace 実演 / §10.3 C2c discovery closure 録画再現)
- **S11-9〜S11-N (新規)**:
  - Step 0/1/2/3/4 の録画 (Phase 04〜07 §11.3 で示唆済の各 Step recordings/ への配置)
  - dry-run scenario 全 7 Step 通し実演 (1 take or 分割は計画書で確定)

### 11.4 Phase 11 で再検証する候補 (Phase 09 §11.4 から継承 + Phase 10 で追加)

Phase 09 §11.4 から継承:
- Branch protection / Rulesets UI label drift (R09-1)
- Copilot Code Review Required Reviewer 表示名 drift (R09-1)
- `.agent.md` frontmatter spec drift (P09-4)
- R11 = Path A/B (Check Run Agents) status drift (R09-3 / master-plan §6 R11)
- Copilot Code Review org policy 影響 drift (R09-6 / prereq P12)
- §10.3 C2c discovery closure を実機 evidence で埋める (Phase 09 で no-drift confirmed、Phase 11 で再 verify)
- E11-Setup/Minimum/Full/Degraded/Workflow-Advanced の 5 段階 marker を実機完走で埋める (Phase 11 dry-run で動画/スクショと一緒に取得)
- GitHub plan / Copilot plan の境界変動 (Free private repo の branch protection 制限変動 / Copilot Code Review の plan 依存変動 / org policy の default 値変動)
- `templates/pr-required-check.yml` の self-hosted runner CI 緑化 (R03-7 / Phase 11 で `ubuntu-latest` 化と同時に解決)
- M5 = public release ready の達成基準確定 (Important 9 / Phase 09 で M4 = content-complete のみ宣言、Phase 11 で M5 = 3 軸一括達成)

Phase 10 で追加:
- **§10.3 cosmetic 持ち越し台帳の全項目** (Phase 10 で積んだ cosmetic drift を Phase 11 dry-run drift と統一台帳で処理)
- **R6 = engine x secret マトリクス確定** (Phase 08 で実機 invocation evidence を持ち越し、Phase 11 dry-run で確定)
- **E10 (Standard / Minimum / Fallback) Step 5 ユーザー実機完走 marker** 回収 (Phase 08 から持ち越し、Phase 11 dry-run で動画/スクショと一緒に取得)

### 11.5 Phase 10 で確立する M5 達成宣言の品質規約 (★ Phase 09 §11.5 を継承 + Phase 10 で確定文化)

- **M4 = content-complete** = ✅ Phase 09 で達成済、Phase 10 で品質確定 (= 静的推敲完了)
- **M5 = release ready** は **3 軸一括** (Phase 11 で達成宣言、または §11.2 split gate 採択時は Phase 12 close commit で達成宣言。後者の場合 master-plan §5 milestone block / 本 §11.5 を Phase 12 で更新):
  - **M5 軸 1**: 録画完備 (Phase 11、ユーザー判断で Phase 10 から移送)
  - **M5 軸 2**: ユーザー実機完走 evidence (E10 + E11-Setup/Minimum/Full/Degraded/Workflow-Advanced = 計 6 marker、Phase 11 dry-run で動画/スクショと一緒に取得)
  - **M5 軸 3**: public release hardening (README 公開トーン化 / CONTRIBUTING / LICENSE 確定 / リリース note / R03-7 self-hosted runner CI 緑化)
- **M5 達成 entry に必ず併記する項目** (master-plan §5 / phase-11 §1.3 / §6.3 の 3 箇所):
  - 3 軸すべて達成された evidence link (commit SHA / 録画 URL / dry-run RESULT block)
  - Phase 10 持ち越し台帳の全項目処理済確認
  - 最終 release version tag (例: `v1.0.0`) を `git tag` で打って push、master-plan §9 Phase 11 ✅ + 改訂履歴に最終 entry

---

## 12. 改訂履歴

| 日付 | 変更 | コミット |
|---|---|---|
| 2026-04-26 | C1: Phase 10 着手、本ドキュメント v1 新規。**ユーザー判断 (2026-04-26) 確定**: 録画 / dry-run / 実機完走 = 全て Phase 11 へ移送、Phase 10 = シナリオ完成 (静的品質推敲) のみに再定義。**rubber-duck #1 (計画レビュー) 反映** (Blocking 2 + Important 6 + Suggestion 4 = 全 12 件) | C1 (`f2f4d62`) |
| 2026-04-26 | C2: Step 0/1/2/3 README 推敲。Step 1/2/3 broken relative link 3 件修正、Step 1 done step 用語統一、Trust thread Layer 1→2 wording 微調整、§10.3 cosmetic 台帳に L01 = section header style 不統一 (badges vs blockquote) を 8 列構造で記録。post-C2 mini checkpoint PASS | C2 (`ad59e17`) |
| 2026-04-26 | C3: Step 4/5/6 README 推敲 + agents/templates static consistency inspection (D10-10)。Step 4/5 broken link `../step-6a-required-check/` → `../step-6-gate/` 補正 (Q1)、Step 5/6 + content/README の「Phase 10 提供予定」 → 「後続 Phase で提供予定」(Q2 SoT)、Step 6 §3.F sample wording drift を §10.3 L02 として cosmetic 台帳記録。post-C3 mini checkpoint PASS | C3 (`d35a75b`) |
| 2026-04-26 | C4: master-plan + VERSIONS + prerequisites + content/README 推敲。master-plan §4 Phase 10/11 行再定義 (静的推敲 / dogfooding+release hardening)、§4.5 Step 5 row + §6 R4 録画 reference を Phase 11 以降、§6 R6 Phase 11 dogfooding 表記化、VERSIONS L92/L115/L569 + prereq L45/L87 + content/README L6 を Phase 11 以降表記に統一。broken-link self-check 0 件確認。post-C4 mini checkpoint PASS | C4 (`6608b09`) |
| 2026-04-26 | C5: rubber-duck #2 findings remediation 専用 commit (5 Blocking + 7 Important + S1 = 13 件反映)。RD#2-B1 = recordings placeholder learner-facing stale wording → content/step-{5,6}/recordings/README.md 全文書き換え、B2 = master-plan §4.5 line 101 + §6 R4/R6 残存 Phase 10 4 箇所、B3 = phase-10 doc 3/5 質問 inconsistency → 5 質問統一、B4 = branch / close timing C5/C6 矛盾 → C6 訂正、B5 = broken-link whitelist 規則明文化 (§10.1 末尾 4 項目 subsection 新設、whitelist 適用後 unresolved local link 0 を T-PHASE10-001 PASS 判定に再定義)。Important 7 件: I1 = §1.1 scope に content/README.md 追加、I2 = §2.2 末尾に歴史 phase docs 凍結方針 note 新設、I3 = §10.3 L03 = historical docs row 追加、I4 = VERSIONS L560 S10-* → S11-*/旧 S10-*、I5 = §11.5 M5 達成宣言条件に Phase 12 split fallback note、I6 = mini checkpoint 共通 Q4 (whitelist / false positive 質問) 追加、I7 = B5 と統合。S1 = §10.1 Q2 + P10-2 に process drift 含意明記。Suggestion 2 (i18n/accessibility/licensing/external link rot) と 3 (§10.3 owner / target commit / evidence required 列追加) は Phase 11 持ち越し | C5 (`137217f`) |
| 2026-04-26 | **C6 (close): Phase 10 完了**。T-PHASE10-001〜008 全件 PASS literal 確定 (broken-link self-check whitelist 適用後 0 件 + raw regex hit 2 件 = phase-10 §10.3 L01 placeholder syntax + phase-09:67 historical relative path、いずれも whitelist 該当)、§6.1 ハードゲート 12 項目全 ☑、§10.3 RESULT block 確定 (blocking 修正済 commit 表 = C2 `ad59e17` / C3 `d35a75b` / C4 `6608b09` / C5 `137217f` 全 SHA 確定 + cosmetic 持ち越し台帳 L01/L02/L03 確定)、§11.5 M5 達成宣言の品質規約 3 軸 + Phase 12 split fallback 確定文化、§11.2 Phase 12 split criteria gate 確定文化 (Phase 11 計画書 §1/§2 で必ず確認)。master-plan §9 Phase 10 進捗行 ✅ + §改訂履歴 entry に **歴史的 phase docs (phase-03〜09-*.md) は close-time SoT snapshot として保存、最新 SoT は master-plan / VERSIONS / prereq / content README / phase-10 doc に集約** を 1 段落明記 (RD#2-I3 master-plan 側適用)。**`scenario-complete` branch を C6 commit SHA に push** (D14 継承、documentation + canonical template state、Phase 09 同型 6 commits パス完成)。**Phase 10 完了 = M4 維持 + Phase 11 着手準備整、M5 達成宣言は Phase 11 (3 軸一括) または Phase 12 (split 採択時) で実施** | C6 (`5bc6490`) |
| 2026-04-26 | **C7 (post-close polish): rubber-duck #3 (post-close review) findings 反映**。8 観点 (close 状態整合性 / 用語統一 / 歴史 docs 凍結 / cosmetic 台帳受入 / Phase 11 申し送り / broken-link whitelist / master-plan §5/§9/改訂履歴 / Phase 10 self-consistency) で 4 Blocking + 6 Important + 3 Suggestion 抽出、うち 9 件反映: **B1** = `content/step-5-multi-engine/README.md` L338-339 VERSIONS anchor から存在しない `-skeleton` suffix 削除 (broken anchor → `#42-...-engine-stanza-canonical-samples` / `#9-step-5-multi-engine任意-secrets-登録経路-phase-08`)、**B2** = `content/README.md` escape hatch 表に `scenario-complete` row 追加 (C6 SHA `5bc6490`)、**B3** = §6.1 line 225 CI green claim soft 化 (workflow touch なし / local static checks PASS / GitHub Actions runner queue は self-hosted runner offline = R03-7 Phase 11 持ち越し既知事項)、**B4** = Step 0/1/2/3/4/5 README の "Required Check" shorthand drift 全 8 occurrences を "Required Review Gate" もしくは "Step 6 (Gate)" に置換 (Phase 09 用語分離 = Required Review Gate vs Required Status Check の Step 0〜5 への遡及適用)、**I1** = `content/README.md` L6 "Phase 10 進行中" → "Phase 10 完了 / 静的品質推敲完了"、**I2** = `VERSIONS.md` L24-26 "Phase 08 着手中" → "Phase 08 C2c 確定済 / Phase 11 dogfooding 再検証"・"S10-* 申し送り" → "S11-* / 旧 S10-* 申し送り"、**I3** = §10.3 L03 推奨修正を "C6 master-plan §改訂履歴 1 段落明記済 / Phase 11 では §4 Phase 11 行 + phase-11 計画書 §1 に転記" に更新 + target commit `release-hardening` → `phase11-plan-start` 移動 + escape hatch 表に新規 commit hint 追加、**I6** = §11.2 候補 7 = external URL HTTP status check / link rot hardening を Phase 11 §2 IN SCOPE 候補として bullet 追加、**S1** = §11.2 候補 8 = P10-1〜9 設計パターン全 9 項目を Phase 11 計画書 §1.1 / §8 / §10.3 に転記する受入 hook を bullet 追加。受容 4 件 (I4 = Phase 12 split criteria の N commits/N files placeholder は Phase 11 §1.2 で確定 / I5 = E10 marker family vs variants の曖昧性は Phase 11 で resolve / S2 = §6.2 ソフトゲート `[ ]` のままは任意 gate のため受容 / S3 = recordings README "Phase 10 では更新しない" 文言は cosmetic、SoT 整合性影響軽微) | C7 (本 commit) |
