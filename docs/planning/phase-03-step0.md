# Phase 03 — Step 0 教材化 (Setup & MCP 接続)

> **このフェーズの本質**: 学習者の「手の動き」の **原器** を確定する Phase。
> Step 0 = 「Codespaces を開く → Copilot に認証 → GitHub MCP を承認 → mini-triage 1 件完走」。
> ここで決まる README の **必須 8 セクション構造** / **コードブロック表記** / **Trust thread の打ち方** / **PAT を出さない方針** が、Phase 04-09 (Step 1-6) の全教材のテンプレートになる。

---

## 1. Phase Goal

### 1.1 主目的
keynote 60 分を視聴した学習者が、自分の GitHub アカウントから Codespaces 1-click ボタンを押し、**約 15 分で**「Issue を Copilot Chat 経由で 1 件 triage する」体験を完走できるようにする。
Step 1 (Memory) 以降に進むための **足場 (escape hatch `step-0-complete` ブランチ)** を提供する。

### 1.2 Phase 完了時に手元にあるもの
1. **`content/step-0-setup/README.md`** — 学習者向け本文 (mini-triage 完走、必須 8 セクション)
2. **`scripts/seed-issues.sh`** — seed Issue 3 件を冪等に作成
3. **`.github/workflows/step-gate.yml`** — L2 Step Gate Test (T-001..004)
4. **`step-0-complete` ブランチ** — escape hatch
5. **`docs/planning/VERSIONS.md` §2.5** — MCP tool 名スナップショット (2026-04-24 時点)
6. **`content/README.md` 更新** — Step 0 行を ✅ 公開中
7. **本ドキュメント** (`phase-03-step0.md`) — DoD 全項目 ☑
8. **(可能なら) workshop repo を template repo 化** — Phase 11 待たず前倒し

### 1.3 マイルストーン
master-plan §5 のマイルストーン上は M2 (Step 0-2 公開) の途中点。
本 Phase 単独では学習者公開はせず、Phase 04-05 (Step 1, Step 2) で初の公開 milestone。

---

## 2. Scope

### 2.1 IN SCOPE (作る)
| 対象 | 何を作るか |
|---|---|
| `content/step-0-setup/README.md` | mini-triage 完走版本文 (必須 8 セクション) |
| `scripts/seed-issues.sh` | Issue 3 件投入 (E1 PROCEDURE.md body 流用 + 冪等性) |
| `.github/workflows/step-gate.yml` | L2 Step Gate Test 初実装 (self-hosted、Phase 11 で ubuntu-latest 化) |
| `step-0-complete` ブランチ | main から派生、main にマージしないが push する |
| `docs/planning/VERSIONS.md` §2.5 | MCP tool 名 (`mcp_github_list_issues` 等) と検証日 |
| `content/README.md` | Step 0 行 🚧 → ✅ |
| 本ドキュメント | Phase 03 詳細計画書 |
| master-plan §9 | Phase 03 を 🟡 → ✅ |
| (試行) repo template 化 | `gh repo edit --template` |

### 2.2 OUT OF SCOPE (Phase 04+ で扱う)
- Step 1-6 の本文 (Memory / Skill / Surface / Automate / Multi-engine / Gate)
- 自動 triage skill (`SKILL.md` 本体、Phase 05)
- Cloud Agent / Custom Agent (`@copilot`, `.agent.md`、Phase 06/09)
- gh aw 関連 (`triage.aw.md`、Phase 07)
- 実機スクリーンショット (Phase 11 公開準備)
- Codespaces Prebuild 有効化 (Phase 11)
- branch protection / Required Check (Phase 11)
- 多言語化 (Phase 11)

### 2.3 設計判断 (本 Phase で確定)

ユーザー判断 (D1-D3) と私の判断 (D4-D14):

| # | 論点 | 採用案 | 根拠 |
|---|---|---|---|
| **D1** | Playground repo 戦略 | **A: workshop repo を template 化** (暫定で fork も併記) | 1-click ボタンと整合、ユーザー判断 |
| **D2** | Step 0 到達点 | **c: 厚 mini-triage 完走 (~15min)** | 「動いた」体験が次への動機、ユーザー判断 |
| **D3** | 画像 alt text | **英語のみ** | a11y / 国際化、ユーザー判断 |
| D4 | escape hatch | `step-0-complete` を main 派生で push (mainにマージしない) | master-plan P3 |
| D5 | seed 投入手段 | `scripts/seed-issues.sh` (E1 body 流用、`gh issue create` ループ、既存タイトル検出 skip) | 1 行で seed、Step 1-6 でも再利用可能 |
| D6 | README 必須 8 セクション | バッジ / 学習目標 / 前提 / 手順 / 完了確認 / 詰まったら / 次の Step / 参考 | Phase 04+ 全 Step の **テンプレートに固定** |
| D7 | PAT 言及 | **Step 0 では一切触れない** | E1 で OAuth 透過認証成立、PAT は Step 4 で初登場 |
| D8 | Trust thread 打ち方 | 冒頭 2-3 文「ツール承認 UI = Agent に許可する範囲を決める瞬間」 | E1 RESULT §4、Step 6a の伏線 |
| D9 | MCP tool 名 pin | VERSIONS.md §2.5 (新設) で 2026-04-24 スナップショット | R03-1 (rename ドリフト) 対策 |
| D10 | 画像方針 | mermaid シーケンス + 英語 alt のみ (実機スクショは Phase 11) | 本文最優先 |
| D11 | template 化のタイミング | C2 で `gh repo edit --template` 試行 (失敗なら Phase 11 持ち越し記録) | 動くなら前倒し |
| D12 | Commits 数 | **5 commits** (Phase 02 と同型リズム) | レビュー粒度 |
| D13 | L2 初実装 | `.github/workflows/step-gate.yml` 新規 | test-plan §1、Phase 02 で「Phase 03+ で実装」と合意済 |
| D14 | content/README.md 動線 | Step 0 行を ✅ 公開中、Step 1-6 はそのまま 🚧 | 学習者導線整合 |

---

## 3. ディレクトリ構造 (本 Phase 完了時の到達形 / 差分のみ)

```
.
├── .github/
│   └── workflows/
│       ├── smoke.yml              # 既存 (Phase 02、本 Phase で触らない)
│       └── step-gate.yml          # 新規 (L2 Step Gate Test 初実装)
├── content/
│   ├── README.md                  # 更新: Step 0 行 ✅
│   ├── prerequisites.md           # 既存 (P8 追加検討)
│   └── step-0-setup/
│       └── README.md              # 全面書き換え (placeholder → mini-triage 完走本文)
├── docs/
│   └── planning/
│       ├── 00-master-plan.md      # 更新: §9 Phase 03 ✅、改訂履歴
│       ├── VERSIONS.md            # 更新: §2.5 MCP tool 名 pin (新設)
│       └── phase-03-step0.md      # 本ドキュメント (新規)
└── scripts/
    └── seed-issues.sh             # 新規

# branches:
#   main                          (本 Phase の全 commit がここに乗る)
#   step-0-complete               (新規 escape hatch、main 派生)
```

---

## 4. 実装タスク (5 commits / 依存順)

| C# | 内容 | 主ファイル | 自動テスト |
|---|---|---|---|
| **C1** | `docs(planning): start Phase 03 — add phase-03-step0.md` | 本ファイル新規、master-plan §9 を 🟡、改訂履歴着手行 | smoke 影響なし (paths 外) |
| **C2** | `feat(scripts): add seed-issues.sh + mark repo as template` | `scripts/seed-issues.sh` 新規、`gh repo edit --template` 試行ログ | ローカル `bash -n` |
| **C3** | `docs(content): write Step 0 — Setup & MCP connection` | `content/step-0-setup/README.md` 本文、`VERSIONS.md` §2.5、`content/README.md` 更新 | (C4 で連携) |
| **C4** | `ci(step-gate): L2 test for Step 0 + escape hatch branch` | `.github/workflows/step-gate.yml`、`step-0-complete` branch push | step-gate.yml 緑化 |
| **C5** | `docs(planning): close Phase 03 — Step 0 published, DoD ☑` | 本ファイル DoD ☑、master-plan §9 ✅、改訂履歴 | smoke + step-gate 緑 |

---

## 5. テスト戦略 (L2 Step Gate Test 初実装)

| ID | 層 | 対象 | 方法 |
|---|---|---|---|
| T-PHASE03-001 | L2 | Step 0 README 構造 | bash assert: 必須 8 セクションのヘッダ正規表現存在 |
| T-PHASE03-002 | L2 | 内部 link 死活 | grep ベース簡易チェック (相対パスのみ、外部 URL は除外) |
| T-PHASE03-003 | L2 | seed-issues.sh 構文 | `bash -n`、可なら shellcheck |
| T-PHASE03-004 | L2 | escape hatch branch | `git ls-remote --heads origin step-0-complete` |
| T-PHASE03-Manual | (手動) | Codespaces 実機完走 | mini-triage 1 件、ユーザー本人で確認 |

`paths` trigger: `content/**`, `scripts/**`, `.github/workflows/step-gate.yml`
runner: self-hosted (smoke と同じ、Phase 11 で ubuntu-latest)

---

## 6. Phase 03 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で Phase 04 着手可能)

#### 動作確認
- [x] ユーザー Codespaces で Step 0 完走 (mini-triage 1 件、ユーザー手動) — **C6 hotfix 後 dry-run で Issue #2 に MCP 経由で `update_issue` + `add_issue_comment` 実行成功確認 (2026-04-25)、Trust thread 成立**
- [x] `seed-issues.sh` で 3 件作成成功 (冪等) — `bash -n` PASS、E1 PROCEDURE Step B body 流用
- [x] MCP 3 ツール (`list_issues` / `update_issue` / `add_issue_comment`) が承認 UI 経由で動作 — Phase 01 E1 で実機確認済
- [ ] ⚠ `step-gate.yml` main 緑 — **R03-7 (R02-6 再ヒット) によりブロック**: B 案 (ubuntu-latest 前倒し) を試行 → 'spending limit' で拒否 (run #24918629878 / learnings P1 再現) → C 案フォールバック (self-hosted へ revert)、ACI runner 復旧待ち。Phase 11 で smoke.yml と同時に ubuntu-latest 化予定 (repo public 化と同期)

#### 構造確認
- [x] Step 0 README 必須 8 セクション存在 (T-001) — ローカル grep で全 7 章 + Status badge OK
- [x] 完了確認チェックリスト 4 項目以上 — 6 項目
- [x] 画像 alt text 全英語 (mermaid 含む) — sequenceDiagram + alt comment 英語
- [x] `step-0-complete` branch push 済 (T-004) — `7dc127c` tip
- [x] `content/README.md` Step 0 行 ✅ — 公開中
- [x] `VERSIONS.md` §2.5 追記済 — list_issues / update_issue / add_issue_comment + 検証日 2026-04-24

#### 計画整合
- [x] 本ドキュメント DoD 全 ☑/⚠
- [x] master-plan §9 Phase 03 ✅
- [x] master-plan 改訂履歴更新

### 6.2 ソフトゲート (任意)
- [x] template repo 化成功 (`gh repo edit --template` PASS、`isTemplate: true` 確認、private のままで動作) — D11 クリア
- [x] Step 0 体感 ~15min 以内 (内部見積、Phase 10 で第三者検証) — 5 sub-step (A〜E) で構成
- [x] Trust thread 伏線が冒頭に明示 — `IMPORTANT` ブロックで宣言、Step 6a で回収予定

### 6.3 Phase 04 着手の最低条件
- 6.1 ハードゲート 全 ☑ または ⚠ (step-gate.yml の自動緑化のみ runner 復旧待ち、機能影響なし)
- ユーザー手動完走確認 (本 commit 後に依頼)

---

## 7. リスク (Phase 03 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| **R03-1** | MCP tool 名が rename され陳腐化 | 中/中 | VERSIONS §2.5 で 2026-04-24 時点 pin、Phase 10 で再検証 |
| **R03-2** | private repo の template 化が動かない | 中/低 | fork 第一案・template 第二案併記 |
| R03-3 | org policy で MCP/Copilot 拒否 | 低/中 | 「個人アカウントで」逃げ道、prereq P8 |
| R03-4 | `seed-issues.sh` が既存 Issue と重複 | 中/低 | 同タイトル検出 skip |
| **R03-5** | workshop / playground の取り違え (sandbox 再来) | 中/中 | Step 0 「前提」で URL red-box、`gh repo view` で現在 repo 確認 |
| R03-6 | Copilot Chat 拡張未 install | 低/高 | devcontainer pin 済、prereq に確認手順 |
| **R03-7** | step-gate.yml が R02-6 (runner offline) に再ヒット | 中/中 | smoke と同 runner、再 stuck なら ACI 再起動依頼 |
| R03-8 | mini-triage prompt が個人差で再現困難 | 中/中 | コピペ用コードブロックで一字一句明示 |
| R03-9 | "Trust thread" 概念がだれる | 低/中 | Step 0 では 2-3 文に抑え、Step 6a で本格回収 |

---

## 8. 進め方

1. **C1**: 本ドキュメント新規 + master-plan §9 🟡 + 改訂履歴 → push (CI 影響なし)
2. **C2**: `seed-issues.sh` 作成 + template 化試行 → push
3. **C3**: Step 0 本文執筆 + VERSIONS §2.5 + content/README ✅ → push
4. **C4**: `step-gate.yml` 新規 → 緑化反復 → `step-0-complete` branch push → push
5. **C5**: DoD ☑ + master-plan §9 ✅ + 改訂履歴 → push、ユーザーへ手動完走確認依頼

---

## 9. 参考リンク

- master-plan §4.1 (Step 0 範囲)、§4.5 (スキップ判定)、§4.5.3 (MCP verification block 必須化 — 本 Phase の dry-run findings から派生)、§6 (Step 0 詳細)
- `docs/planning/poc/E1-mcp/PROCEDURE.md` / `RESULT.md` (MCP tool 名・seed body、§7 dry-run regression note)
- `docs/planning/poc/learnings.md` §9 (MCP / Copilot Chat UX、本 Phase の dry-run findings)
- `docs/planning/phase-02-skeleton.md` (構造テンプレート)

---

## 10. Phase 04+ への申し送り (dry-run findings の波及)

> **位置付け**: Phase 03 dry-run (2026-04-25) で発覚した F1-F6 を Phase 04+ 計画書執筆時に必ず確認するチェックリスト。詳細は `learnings.md §9` を読むこと。

### 10.1 dry-run findings サマリ

| F# | 知見 | 反映先 (master) | Phase 04+ で参照する場所 |
|---|---|---|---|
| F1 | MCP server registration regression: `.vscode/mcp.json` 必須 | `00-master-plan §6.2 R13` / `VERSIONS §2.5.1` | 計画書 §「前提条件」 |
| F2 | MCP tools palette **default OFF** (受講者が見落とす罠) | `learnings §9.2` / `00-master-plan §4.5.3 V3` | 計画書 §「教材冒頭テンプレ」 V3 |
| F3 | 認証 **3 層モデル** (Copilot / MCP OAuth / Tool Allow) | `learnings §9.3` / `VERSIONS §2.5.3` / `00-master-plan §4.5.3 V4` | 計画書 §「教材冒頭テンプレ」 V4 + §「Trust thread 設計」 |
| F4 | gh CLI フォールバック検出パターン | `learnings §9.4` / `content/step-0-setup/README.md §3.E` | 各 Step §5 Troubleshooting |
| F5 | Copilot 前提欠落 UX (positive、選択肢提示) | `learnings §9.5` | Step 1 / Step 4 で活用余地 |
| F6 | template repo は private でも動作 | `learnings §9.6` | Phase 11 公開判断 (private 維持を継続検討可) |

### 10.2 Phase 04+ 計画書チェックリスト (D1-D6 で確立した standard 準拠)

各 Phase の詳細計画書 (`phase-NN-*.md`) 着手時に以下 4 項目を確認:

- [ ] **MCP 利用 Step か?** (Step 0/4/6 = Yes、Step 1/2/3/5 = No)
- [ ] Yes の場合: 計画書 §「前提条件」に **`00-master-plan §4.5.3` の MCP verification block 4 項目** への準拠を明記
- [ ] Yes の場合: その Step で利用する **MCP ツールの最小セット** を明示 (= V3 で ON にする対象)
- [ ] §5 Troubleshooting に **「Trust thread が出ない」行** を必ず含める (= F4 検出パターンを継承)

### 10.3 dry-run で示唆された Phase 04+ 設計余地

- **Phase 04 (Step 1 Memory)**: F5 (前提欠落 UX) を活かして「Memory が空のまま triage 依頼 → Copilot が Memory 作成を提案」のシナリオを意図的に踏ませる演習を検討
- **Phase 07 (Step 4 gh aw)**: F1-F4 全部該当。triage workflow が呼ぶ MCP ツール一式を verification block §V3 に列挙する
- **Phase 09 (Step 6 Gate)**: F1-F4 該当。Code Review 系 MCP ツール (Phase 09 で確定) を verification block §V3 に追加
- **Phase 10 (Dogfooding)**: 第三者完走テストで F2 (default OFF 罠) が再現するか確認、必要なら Step 0 README §3.C-2 にスクリーンショット追加

---

## 11. 改訂履歴

| 日付 | 変更内容 |
|---|---|
| 2026-04-25 | 初版作成 (Phase 03 着手)。D1-D14 確定、5 commits 構成、L2 Step Gate Test 初実装方針 |
| 2026-04-25 | **C2 完了**: `scripts/seed-issues.sh` 追加 (E1 body 流用、冪等)、`gh repo edit --template` 成功 (`isTemplate: true`、private のまま動作) — D11 / R03-2 解消 |
| 2026-04-25 | **C3 完了**: `content/step-0-setup/README.md` 本文公開 (必須 8 セクション、mini-triage 完走、Trust thread 冒頭明示、PAT 言及なし)、`VERSIONS.md` §2.5 新設 (list_issues/update_issue/add_issue_comment + 検証日 pin)、`content/README.md` Step 0 ✅ |
| 2026-04-25 | **C4 完了**: `step-gate.yml` 新規 (T-001..004)、`step-0-complete` escape hatch branch push。**R03-7 顕在化**: ACI runner offline で queued、B 案 (ubuntu-latest 前倒し) 試行 → 'spending limit' 拒否 (run #24918629878、learnings P1 / R02-3 現物再現) → C 案フォールバック (self-hosted revert、Phase 11 で smoke.yml と同時切替) |
| 2026-04-25 | **Phase 03 完了 (C5)**: §6.1 全 ☑ または ⚠ (step-gate.yml 自動緑化のみ runner 復旧待ち、機能影響なし)。master-plan §9 Phase 03 ✅。Step 0 公開、escape hatch branch 稼働、template repo 化成功。Phase 04 (Step 1 Memory) 着手 GO |
| 2026-04-25 | **C6 hotfix (Phase 03 dry-run 発見)**: ユーザー実機 dry-run で Step 0 §3.E の Agent が **MCP 経由ではなく `gh` CLI で代替実行** = Trust thread (承認ダイアログ 3 回) を完全スキップする UX バグを発見。原因: workshop repo に `.vscode/mcp.json` 不在 → 最近の Copilot Chat は MCP server の明示宣言を要求。`.vscode/mcp.json` 追加 (`github` server, `https://api.githubcopilot.com/mcp/`)、Step 0 README §3.C に MCP tool 可視確認手順 + WARNING、§3.E 期待挙動に CAUTION (gh フォールバック検出)、§5 Troubleshooting に該当行追加。VERSIONS §2.5 を E1 観測形 (`mcp_github_*` prefix) と短形の両表記に修正 |
| 2026-04-25 | **C6-fix2 (UX 補強)**: dry-run で `github` server は palette に出るが **チェックボックスが OFF デフォルト** + 初回利用時に **MCP server 自身の OAuth 認可ダイアログ** が出る挙動を発見。Step 0 README §3.C に「ON にする」手順と「初回 OAuth 認可は想定通り」注記を追加、§5 Troubleshooting に checkbox OFF 行を追加 (`eed8196`) |
| 2026-04-25 | **Phase 03 真クローズ**: ユーザー dry-run で Issue #2 に MCP 経由で `update_issue` (label `enhancement` 付与) + `add_issue_comment` (platform 質問) 実行成功を確認。`gh` CLI フォールバック解消、Trust thread 成立。§6.1 ハードゲート「動作確認」全 ☑ (step-gate.yml 緑化のみ Phase 11 持ち越し)。Phase 04 (Step 1 Memory) 着手 GO |
| 2026-04-25 | **§10 申し送り追加 (D5)**: dry-run findings F1-F6 を Phase 04+ への申し送りとして §10 に整理。`learnings §9` / `00-master-plan §4.5.3` への参照集約。既存 §10 改訂履歴は §11 に繰り下げ |
