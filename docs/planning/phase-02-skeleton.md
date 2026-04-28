# Phase 02 — リポジトリ骨格 / 共通基盤

> **このフェーズの本質**: 「Codespaces を 1 クリックで開けば、空のシナリオ筐体が即起動する」状態を作る。Phase 03+ で各 Step 教材本文を流し込む**空き箱**を整備する Phase。
> Step 教材の**本文は書かない** (それは Phase 03-09)。

---

## 1. Phase Goal

### 1.1 主目的
Phase 03+ (Step 0/1/2/.../6 の教材執筆 Phase) が「**書く以外の準備**」に時間を取られないよう、骨格・共通基盤・自動化・ナビゲーションを先に確定させる。

### 1.2 Phase 完了時に手元にあるもの
1. **動く `.devcontainer/`** — `gh`, `gh aw v0.68.3`, `jq` 等が pre-install された Codespaces 環境
2. **`content/` ツリー** — Step 0/1/2/3/4/5/6a/6b の placeholder README + `prerequisites.md` + ナビゲーション `README.md`
3. **L1 Smoke Test** (`.github/workflows/smoke.yml`) — devcontainer build + 必須ツール存在検証が CI で走る
4. **更新された root `README.md`** — Status バッジ更新、Quick Start (Codespaces ボタン) + `content/` リンク
5. **Issue / PR template の骨格** (Phase 11 で本格整備)
6. **本ドキュメント** (`phase-02-skeleton.md`) — DoD 全項目 ☑

### 1.3 マイルストーン M1 達成
master-plan §5 のマイルストーン **M1**:
> Phase 02 完了 → 空のシナリオが起動可能 (社内デモ可)

---

## 2. Scope

### 2.1 IN SCOPE (作る)
| 対象 | 何を作るか |
|---|---|
| `.devcontainer/` | base = `mcr.microsoft.com/devcontainers/universal:2`、postCreate で `gh aw v0.68.3` install |
| `content/` ツリー | 8 Step ディレクトリ (0/1/2/3/4/5/6a/6b) + placeholder README + `prerequisites.md` + ナビ `README.md` |
| L1 Smoke CI | `.github/workflows/smoke.yml` (PR + push to main + schedule weekly) |
| Issue / PR template | フィードバック用の最小テンプレート (Phase 11 で本格整備) |
| root README | Status badge 更新 + Quick Start + content link |
| 本ドキュメント | Phase 02 詳細計画書 (本ファイル) |
| master-plan §9 | Phase 02 進捗を 🟡 (着手) → ✅ (完了) に更新 |

### 2.2 OUT OF SCOPE (Phase 03+ で扱う)
- **各 Step の教材本文** (Step 0 = Phase 03 / Step 1 = Phase 04 / ... )
- 実 SKILL.md / .agent.md / triage.aw.md (Phase 05 / 09 / 07)
- L2 Step Gate Test / L3 E2E Test (Phase 03+ / Phase 07 完了後)
- escape hatch ブランチ (`step-N-complete`) → 各 Step 教材化 Phase で同時に切る (P3 設計原則)
- Codespaces Prebuild 有効化 (Phase 11 公開準備)
- branch protection で smoke.yml を Required 化 (Phase 11)
- LICENSE ファイル本体 (Phase 11)
- keynote サイト (`site/`) は変更しない (Phase 11)
- WorkIQ MCP / Datadog 等 Microsoft+GitHub 外ツール (master-plan 設計原則 P5)
- 多言語化 (教材は日本語のみで Phase 02 完了)

### 2.3 設計判断 (本 Phase で確定)

| # | 論点 | 採用案 | 根拠 |
|---|---|---|---|
| D1 | 教材ディレクトリ名 | **`content/`** | 中立的、Phase 11 で改名容易 |
| D2 | Step 6 命名 | **`step-6a-required-check/`, `step-6b-custom-agent/`** | master-plan §4.5 と整合、6a 必須 / 6b 発展題材 |
| D3 | devcontainer base | **`mcr.microsoft.com/devcontainers/universal:2`** | gh / jq / node / python pre-install 済、設計原則 P4 (1 クリック) を尊重 |
| D4 | gh aw インストール | **postCreate.sh で `GH_AW_VERSION=v0.68.3` を ENV 固定** | VERSIONS.md §1 の pin を尊重、Technical Preview 仕様変動に備える (R6 対処) |
| D5 | smoke.yml runner | **暫定: `[self-hosted, Linux, X64]` / Phase 11 で `ubuntu-latest` 化** | 本リポは現在 PRIVATE で GitHub-hosted runner が spending limit でブロックされる (learnings P1 / R02-3 顕在化)。pages.yml と同じ self-hosted ACI runner を共用。Phase 11 で repo を public 化するタイミングで `ubuntu-latest` に切替 |
| D6 | smoke.yml 構成 | **1 ジョブ: postCreate.sh 直接実行 → gh aw version pin assert** | self-hosted で動かすため `devcontainers/ci@v0.3` (Docker 必要) を避け、postCreate.sh を runner 上で直接実行。Phase 11 で ubuntu-latest 化と同時に `devcontainers/ci` 採用検討 |
| D7 | 教材言語 | **日本語のみ** | keynote 聴講者前提 |
| D8 | 各 Step README placeholder | **「Coming in Phase XX」+ Step 概要 1 段落 + master-plan §3 へのリンク** | Phase 03+ 着手時の埋める箇所を明示 |
| D9 | escape hatch ブランチ | **Phase 02 では切らない、各 Step 教材化 Phase で切る** | 教材本文がない状態では「完了状態」が定義できない |
| D10 | commit 戦略 | **意味のある単位で 5 commits** | Phase 02 内部の進捗を追えるように |

---

## 3. ディレクトリ構造 (本 Phase 完了時の到達形)

```
.
├── .devcontainer/                       ← 新規 (本 Phase)
│   ├── devcontainer.json
│   └── postCreate.sh
├── .github/
│   ├── ISSUE_TEMPLATE/                  ← 新規
│   │   └── feedback.md
│   ├── PULL_REQUEST_TEMPLATE.md         ← 新規
│   └── workflows/
│       ├── pages.yml                    (既存・変更なし、self-hosted)
│       └── smoke.yml                    ← 新規 (ubuntu-latest)
├── content/                             ← 新規 (学習者向け)
│   ├── README.md                        (シナリオ全体像 + Step ナビ)
│   ├── prerequisites.md                 (VERSIONS.md §6 を学習者向けに整形)
│   ├── step-0-setup/README.md           ← placeholder (Phase 03 で本文)
│   ├── step-1-memory/README.md          ← placeholder (Phase 04)
│   ├── step-2-skill/README.md           ← placeholder (Phase 05) ⭐ keynote CTA
│   ├── step-3-surfaces/README.md        ← placeholder (Phase 06)
│   ├── step-4-automate/README.md        ← placeholder (Phase 07)
│   ├── step-5-multi-engine/README.md    ← placeholder (Phase 08, 任意)
│   ├── step-6a-required-check/README.md ← placeholder (Phase 09, 必須)
│   └── step-6b-custom-agent/README.md   ← placeholder (Phase 09, 発展)
├── docs/
│   └── planning/
│       ├── 00-master-plan.md            (§9 進捗を更新)
│       ├── phase-01-spec-validation.md  (変更なし)
│       ├── phase-02-skeleton.md         ← 本ファイル
│       ├── VERSIONS.md                  (変更なし、§1 が postCreate の pin 元)
│       ├── test-plan-template.md        (変更なし、smoke.yml が L1 の最初の実装)
│       └── poc/                         (変更なし)
├── scripts/                             (既存・変更なし)
├── site/                                (既存・変更なし、keynote 専用)
└── README.md                            (Status バッジ更新 + Quick Start + content link)
```

---

## 4. 実装タスク (12 タスク / 5 commits / 依存順)

| # | タスク | commit |
|---|---|---|
| 1 | 本ファイル `phase-02-skeleton.md` 作成 | **C1: `8a7260d`** 詳細計画書 |
| 2 | `content/` ツリー作成 (8 step ディレクトリ + placeholder README + prereq + nav) | **C2: `046d9c3`** content scaffolding |
| 3 | `.devcontainer/{devcontainer.json,postCreate.sh}` + `.github/workflows/smoke.yml` (初版) | C3a: `474bda9` |
| 4 | smoke.yml self-hosted 化 (private repo の spending limit 対応、D5/D6/R02-3 修正) | C3b: `7a4083b` |
| 5 | smoke.yml に gh CLI bootstrap 追加 (self-hosted runner 側に gh 不在) | **C3c: `eec8e4b`** L1 Smoke 緑 ✅ run 24899384621 (7s) |
| 6 | root `README.md` 更新 + Issue/PR template | **C4: `aab2687`** README + templates |
| 7 | master-plan §9 進捗 ✅ + 改訂履歴 + 本ファイル §6 DoD ☑ + 改訂履歴 | **C5** Phase 02 完了処理 |

---

## 5. テスト戦略 (L1 Smoke の実装)

`test-plan-template.md` §1 に準拠して `smoke.yml` を実装:

| ID | 層 | 対象 | 方法 | トリガ | 状態 |
|---|---|---|---|---|---|
| T-PHASE02-001 | L1 | postCreate.sh end-to-end | self-hosted runner 上で gh CLI を bootstrap (v2.80.0 を workspace 内 .bin/ に配置) → `bash .devcontainer/postCreate.sh` を実行 | PR / push to main (paths 制限) / schedule weekly (Mon 00:00 UTC) / workflow_dispatch | ✅ 緑 (run 24899384621, 7s, [aab2687](https://github.com/shinyay/ghcp-6-layer-agentic-platform/actions/workflows/smoke.yml)) |
| T-PHASE02-002 | L1 | gh aw version pin assertion | postCreate 完了後に `gh aw version` の出力が `v0.68.3` (`VERSIONS.md §1` の pin) と一致するか正規表現で照合 | 上と同じ run 内 | ✅ 緑 |

**Phase 02 で実装しない**: L2 Step Gate (Phase 03+) / L3 E2E (Phase 07 完了後)

**Phase 11 で再構成予定** (D5/D6 と整合):
- runner: `[self-hosted, Linux, X64]` → `ubuntu-latest` (repo public 化と同時)
- 構成: postCreate.sh 直接実行 → `devcontainers/ci@v0.3` で真の devcontainer build へ昇格

---

## 6. Phase 02 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で Phase 03 着手可能)

#### 動作確認
- ☑ `.devcontainer/devcontainer.json` が存在 (`474bda9`)
- ☑ Codespaces で build が完走する (実機検証 2026-04-25: Rebuild 後 `gh aw version` が `v0.68.3` を返却。C6 hotfix `eaea388` で SAML 403 解消)
- ☑ smoke.yml が main 上で緑 (run [24899384621](https://github.com/shinyay/ghcp-6-layer-agentic-platform/actions/runs/24899384621), 7s)
- ☑ `gh aw version` v0.68.3 pin が CI で assert されている

#### 構造確認
- ☑ `content/README.md` に Step 0/1/2/3/4/5/6a/6b の全リンクが揃い、各 placeholder README が存在 (`046d9c3`)
- ☑ `content/prerequisites.md` が VERSIONS.md §6 P1-P7 を学習者向けに転載済 (`046d9c3`)
- ☑ root `README.md` の Status バッジが Phase 02 表記に更新済 + L1 Smoke バッジ追加 (`aab2687`)
- ☑ root `README.md` → `content/README.md` の動線リンクが存在 (Quick Start §)
- ☑ Codespaces 1-click ボタン (`codespaces.new/...?quickstart=1`) が root README に配置 (`aab2687`)

#### 計画整合
- ☑ `docs/planning/phase-02-skeleton.md` が存在し、本 DoD のすべてが ☑ または ⚠ (本ファイル / C5 で更新)
- ☑ master-plan §9 進捗表で Phase 02 が ✅ 完了 + 完了日記入 (C5 で更新)
- ☑ master-plan 改訂履歴に Phase 02 完了行追加 (C5 で更新)

### 6.2 ソフトゲート (任意)
- ☑ Issue template (`.github/ISSUE_TEMPLATE/feedback.md`) 存在 (`aab2687`)
- ☑ PR template (`.github/PULL_REQUEST_TEMPLATE.md`) 存在 (`aab2687`)
- ☑ smoke.yml が schedule トリガ (weekly Mon 00:00 UTC) でも動く設定 (`474bda9`)

### 6.3 Phase 03 着手の最低条件
§6.1 のうち「動作確認 3 項目」+「content/README.md 動線」が動いていれば、Phase 03 (Step 0 教材化) を**並行着手可能**。

---

## 7. リスク (Phase 02 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| R02-1 | devcontainer build が遅く Codespaces 初期体験が悪化 | 中/中 | universal:2 採用 (pre-install 多い)。Phase 11 で Prebuild 有効化 |
| R02-2 | gh aw install スクリプトがバージョン変動で壊れる | 中/中 | `GH_AW_VERSION=v0.68.3` を ENV で固定 (master-plan R6 対処の一環) |
| R02-3 | private repo のため GitHub-hosted runner が spending limit で blocked | **顕在化済 (高/中)** | self-hosted ACI runner (pages.yml と共用) で smoke.yml を実行。Phase 11 で repo を public 化 + `ubuntu-latest` 化 |
| R02-4 | content/ への変更が pages.yml の build 対象を巻き込む | 低/中 | pages.yml は `site/**` のみ対象。smoke.yml も `.devcontainer/**` + 自身に paths 制限 |
| R02-5 | Step 6a/6b の URL slug 変更で Phase 09 着手時に migration 発生 | 低/低 | Phase 02 で 6a/6b 命名で**確定**、Phase 09 で踏襲 |
| R02-6 | self-hosted runner がダウン / 容量逼迫で smoke が動かない | 低/中 | ACI runner は ghrunner-aci-03 (resource group ghrunner-rg)、Phase 11 で ubuntu-latest に切替し依存解消 |
| R02-7 | Codespaces 自動 GH_TOKEN が `github` org の SAML SSO 認可を持たず、`gh extension install github/gh-aw` が release API で HTTP 403 (`Resource protected by organization SAML enforcement`) | **解消済 (高/高)** | postCreate.sh の install 行を `GH_TOKEN= GITHUB_TOKEN=` prefix で unauthenticated 化 (public repo asset)。**smoke.yml では発生しない** (workflow token は user PAT と異なり SAML 制約なし)。**C6 `eaea388` で修正、ユーザー Rebuild 後 `gh aw version` = v0.68.3 を実機確認 (2026-04-25)** |

---

## 8. 進め方

1. **C1**: 本ファイル commit (Phase 02 着手宣言)
2. **C2**: `content/` ツリー scaffolding commit
3. **C3**: `.devcontainer/` + `smoke.yml` commit → main で smoke が緑になるまで反復
4. **C4**: root README + Issue/PR template commit
5. **C5**: master-plan 進捗 ✅ + 本ファイル DoD ☑ commit (Phase 02 完了宣言)

各 commit は Conventional Commits (`feat:` / `docs:` / `chore:` / `ci:`) で記述する。

---

## 9. 参考リンク

- master-plan: [`./00-master-plan.md`](./00-master-plan.md) §4 / §4.5 / §5 / §6 / §9
- Phase 01 完了報告: [`./phase-01-spec-validation.md`](./phase-01-spec-validation.md) §6 ハードゲート
- 学習者前提環境: [`./VERSIONS.md`](./VERSIONS.md) §6 P1-P7
- 実機検証で得た秘伝の前提: [`./poc/learnings.md`](./poc/learnings.md)
- L1/L2/L3 テスト戦略原典: [`./test-plan-template.md`](./test-plan-template.md)

---

## 10. 改訂履歴

| 日付 | 変更内容 |
|---|---|
| 2026-04-25 | 初版作成 (Phase 02 着手) |
| 2026-04-25 | **Phase 02 完全クローズ**: ユーザー Codespaces Rebuild 後 `gh aw version` = v0.68.3 を実機確認、§6.1 動作確認 #2 を ☑ 化、R02-7 を「解消済」へ更新。Phase 02 ハードゲート 100% ☑ 達成、Phase 03 着手 GO (真) |
| 2026-04-25 | **R02-6 顕在化**: SAML hotfix `eaea388` の smoke 再実行が self-hosted runner `ghrunner-aci-03-ghcp6` offline により 38min+ queued。機能的影響なし (同 postCreate.sh をユーザー Codespaces 実機で end-to-end 検証済)。Phase 11 で `ubuntu-latest` 化により恒久解消、それまでは ACI runner 再起動を都度対応。Phase 03 着手は計画通り進行 (B 案採択) |
