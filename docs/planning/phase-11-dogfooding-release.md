# Phase 11 詳細計画書 — Dogfooding + Public Release Hardening (M5 達成 Phase)

> **位置付け**: Phase 10 (シナリオ完成 = 静的品質推敲) §11 で Phase 11 へ移送した **M5 軸 1 (録画) / M5 軸 2 (実機完走 evidence E10/E11) / M5 軸 3 (public release hardening)** のうち、**ユーザー判断 (2026-04-26) で軸 1 (録画) を Phase 12+ へさらに移送**し、Phase 11 = **軸 2 dogfooding (本人実機完走 + E10/E11 marker 回収) + 軸 3 release hardening の 2 軸で M5 = release-ready 達成** に再定義。
> **本ファイルは Phase 06 / 07 / 08 / 09 / 10 SoT と同型構造** (§1 Goal → §2 Scope → §3 Dir → §4 Commits → §5 Test → §6 DoD → §7 Risks → §8 進め方 → §9 Refs → §10 dogfooding + drift 取扱規則 → §11 申し送り → §12 履歴)。
> **特殊性**: Phase 11 は **本人 (= 著者) が学習者と同じ初期状態の fresh playground repo (`shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run`) を新規作成し、全 7 Step (Step 0〜6) を 1 take 通しで完走することで E10 / E11-Setup/Minimum/Full/Degraded/Workflow-Advanced 全 5 marker を回収する**「動的検証 Phase」。Phase 10 が "リファクタ Phase" だったのに対し、Phase 11 は "実機検証 + OSS 公開準備 Phase"。
> **commit 構成**: **6 commits + escape hatch branch `release-ready`** (★ v1.2 で実施順序を再定義 = 2026-04-28 ユーザー判断 baked-in)。
> **commit 番号と実施順序**: `C1 plan publish` → `C2 playground 新規作成 + 初期化` → **`C4 cosmetic + release hardening Part 1` (LICENSE + README minimal 公開トーン化、CLI 先行)** → **`C5 release hardening Part 2 + RD#2 remediation` (CONTRIBUTING + RELEASE_NOTES + workflow ubuntu-latest 化、CLI 先行)** → **`C3 dogfooding 1 take + blocking 修正 + dogfooding 依存項目反映` (実機 owner)** → **`C6 close + M5 達成宣言` (実機 owner、tag `v1.0.0` + GitHub Release + public 化)**。**commit 番号 C1-C7 は維持**しつつ、**実施順序を C4/C5 先行 → C3 → C6** に再定義 (= dogfooding = ユーザー実機作業 = 自分が前提なため最終局面に集約、CLI 先行で release hardening を完成可能)。dogfooding 依存項目 (= VERSIONS engine stanza / prereq P1〜P12 chip 確認) は **C4 acceptance から C3 acceptance に move** (詳細 §3.2 + §4.2)。Phase 10 同型 6 commits + escape hatch、C5/C6 分離で close commit 肥大化防止 + post-close polish 用 任意 C7 hook 用意。
> **rubber-duck**: C1 直後 (#1 = 計画レビュー) + C5 着手前 (#2 = 8 観点 final review) + C6 close 後 (#3 = post-close review、Phase 10 で確立した型) の **計 3 回** + post-C2/C3/C4 lightweight self-checkpoint 3 回。

---

## 1. Phase Goal

### 1.1 主目的

**「自分で書いたシナリオを自分で実機で走らせて、本当に学習者が完走できるかを検証する」+「OSS として公開できる完成度に整える」** の 2 軸を 1 Phase で達成する。

中核軸:

- **軸 2: Dogfooding (本人実機完走 evidence)**
  - **新規 fresh playground repo** `shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run` を template から作成
  - 学習者と同じ初期状態 (空 repo + Codespaces 起動 + secret 未設定 + Required Review Gate 未設定 等) から開始
  - **全 7 Step (Step 0 → Step 6) を 1 take 通し**で `content/step-{0..6}/README.md` の手順そのままに完走
  - 各 Step で観測される現象が README の記述と一致するか検証 (Trust thread Layer 1→6 の連結が学習者の目で本当に体感できるか)
  - **E10 = 著者による完走 evidence** + **E11-Setup/Minimum/Full/Degraded/Workflow-Advanced 全 5 段階パス完走 evidence** を marker として回収 (E11-* の正確な family vs variants の解像度は §1.2 で確定 = RD#3-I5 解消)
  - dogfooding で **必ず discovery が出る** (Phase 03 dry-run + Phase 05 E7/E7' で 21 件 critical findings 出た先例)。**discovery 取扱規則** = Phase 10 §10.1 で確立した **drift 5 質問 (完走/copy-paste/gate / 事実-SoT-evidence 矛盾 / broken link / safety boundary / M5 evidence 誤誘導)** を流用、blocking は Phase 11 内で即修正、cosmetic は §10.3 持ち越し台帳 (Phase 10 P10-2 = 8 列構造) に積んで Phase 12+ へ送る

- **軸 3: Public Release Hardening (OSS 公開準備)** — **canonical 作業順 (§2.1 / §4.2 / §6.1 / P11-4 で同順序を踏襲)**:
  1. **LICENSE 確定** (種別 = MIT、§1.5 確定、RD#1 で再確認)
  2. **README 公開トーン化** = 現状の `planning-heavy` (= 進行 Phase の中の途上感が出る表現) を `user-facing` (= OSS として初見学習者が違和感なく読める表現) に refine
  3. **CONTRIBUTING.md** 新規作成 (Issue / PR テンプレ / コードレビュー方針 / DCO or sign-off / コードオブコンダクト言及)
  4. **RELEASE_NOTES.md** 新規作成 (`RELEASE_NOTES.md` に固定、`CHANGELOG.md` 統合は §6.2 ソフトゲート / Phase 12+ 任意)
  5. **git tag `v1.0.0` + GitHub Release** 発行 (§1.5 確定、tag = v1.0.0)
  6. **R03-7 = self-hosted runner CI 緑化**: `runs-on: self-hosted` → `runs-on: ubuntu-latest` 化 + 必要 secrets を workshop repo Settings に設定し、step-{0..6}-gate / L1 smoke を **GitHub Actions 上で本物の緑** にする (= Phase 11 close 必須、部分解消は不可、§7.1 R11-4 参照)
  7. **external link rot hardening** (Phase 10 RD#2-S2 持ち越し) = `curl -I` 一括検査 + 404 link 修正
  8. **i18n / accessibility hardening** (Phase 10 RD#2-S2 持ち越し) = alt text / heading hierarchy / lang attr 検査
  9. **org policy / 公開 repo 設定** = repo description / topics / homepage URL / issue template / pages publish / branch protection (本家 main の Required Status Check で step-{0..6}-gate を必須化するか判断、§1.5 = Phase 12+ 持ち越し確定)
  10. **§10.3 持ち越し台帳列拡張** (Phase 10 RD#2-S3 持ち越し) = `owner` / `target commit` / `evidence required` 列を 8 列 → 11 列に拡張

中核メッセージ:
- **Phase 11 は「本人確認 + OSS 公開準備」の 2 軸を一気通貫で達成し、M5 = release-ready を宣言する Phase**
- **録画 (旧 M5 軸 1) は Phase 12+ へ完全移送** (ユーザー判断 2026-04-26 確定)
- **dogfooding で discovery が出ることは前提** (Phase 03/05 で実証)、**discovery が Phase 05 E7 reframe 級 = 10+ critical findings ならば Phase 12 split criteria gate 発動** (§2 で詳述)

### 1.2 Phase 完了時に手元にあるもの

- **新規 playground repo** `shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run`
  - template 適用 + Codespaces 起動成功 + 全 7 Step 完走 evidence (E10) + branch `dogfooding-complete` (任意) push 済
  - 各 Step 完走時の screenshot / コミット / PR / Issue が evidence URL として `phase-11-dogfooding-release.md §10.4` に記録

- **回収済み marker** (= **E10 = 1 marker** + **E11 = 5 variant markers** = §10.4 RESULT block 6 evidence rows):
  - **E10** (1 marker) = 著者による全 7 Step 通し完走 evidence (master-plan §6 R3 / R5 で言及していた marker)
  - **E11-Setup** (variant 1) = Codespaces 起動 + Step 0 環境チェック ①〜⑫ 全 PASS evidence
  - **E11-Minimum** (variant 2) = Step 1〜3 (Memory + Skill + Surfaces) 完走 evidence (=学習者必須 path 完走)
  - **E11-Full** (variant 3) = Step 4 (Automate) + Step 5 (Multi-engine) + Step 6 (Gate) 完走 evidence (= 任意発展含む全 path 完走)
  - **E11-Degraded** (variant 4) = Pro plan degraded complete path 完走 evidence (Step 3 Path C / Step 5 任意 skip / Step 6b 任意 skip = M2 keynote CTA を Pro plan で達成)
  - **E11-Workflow-Advanced** (variant 5) = Step 4 §3 Appendix workflow 任意発展 evidence (Step 4 任意発展 + Step 6b appendix workflow integration)
  - **family vs variants 解像度** (RD#3-I5 解消): E10 = 1 marker (単一) / E11 = 5 variant markers (= 5 段階パス) として固定。RESULT block (§10.4) は **計 6 evidence rows** (E10 1 + E11 5)

- **修正済み 7 Step README + planning truth** (dogfooding discovery 反映):
  - blocking discovery 全件 Phase 11 内で fix commit (本家 repo `shinyay/ghcp-6-layer-agentic-platform`)
  - cosmetic discovery は §10.3 持ち越し台帳 (11 列構造) に積んで Phase 12+ 送り

- **Public Release Hardening 完了**:
  - `LICENSE` (MIT) / `CONTRIBUTING.md` (新規) / `README.md` 公開トーン化 / `RELEASE_NOTES.md` v1.0.0 / git tag `v1.0.0` + GitHub Release 発行
  - `R03-7` 解消 = self-hosted runner offline → ubuntu-latest 化 + secrets 設定で GitHub Actions が緑
  - external URL HTTP status check 完了 (404 link 0 件) + i18n / accessibility 整備
  - org policy / repo Settings (description / topics / branch protection) 確定

- `phase-11-dogfooding-release.md` (本ファイル) DoD 全 ☑、§10.4 RESULT block (E10 1 marker + E11 5 variant markers = 6 evidence rows × 11 列構造、blocking 修正済 commit 一覧 + cosmetic 持ち越し台帳)

- master-plan §9 Phase 11 ✅ + §5 milestone block の **M5 = release-ready 達成宣言** + §改訂履歴 + Phase 11 close commit (= C6) で `release-ready` branch push (D14 継承、SHA = C6 一致)

- **Phase 12+ 申し送り §11**: P11-1〜N 設計パターン + S12-* (録画 / 第三者 dogfooding / 多言語化 / accessibility expansion / org-level deployment 等)

### 1.3 マイルストーン

master-plan §5 の **M5 = "release-ready" を Phase 11 完了時点で達成宣言**する。

Phase 11 完了時点での milestone 状態:
- **M4 = content-complete** = ✅ 維持 (Phase 09 で達成、Phase 10 で品質確定、Phase 11 でも維持)
- **M5 = release-ready** = ✅ 達成宣言 (Phase 11、2 軸構成 = dogfooding + release hardening、録画なし)
  - **M5 軸 2**: dogfooding evidence (E10 + E11-Setup/Minimum/Full/Degraded/Workflow-Advanced)
  - **M5 軸 3**: public release hardening (LICENSE / CONTRIBUTING / README 公開トーン化 / リリース note + tag / R03-7 解消 / i18n + accessibility / org policy)
  - **(旧 M5 軸 1 = 録画 = Phase 12+ へ移送、M5 達成宣言から除外)**
- **M5+ (Phase 12+)** = 録画完備 + 第三者 dogfooding + 多言語化 + 各種 hardening expansion (任意)

### 1.4 "Dogfooding + Release Hardening" を 1 Phase に統合する整合性

> **論点**: 軸 2 (dogfooding) と軸 3 (release hardening) を 1 Phase に統合する vs 分離する (Phase 11 = dogfooding / Phase 12 = release hardening) の判断根拠は?

**回答 (= 1 Phase 統合判断)**:
- **dogfooding で blocking discovery が出た場合の hardening 範囲が決まる**: 例えば Step 5 で engine 説明に致命的な誤りが見つかれば README 公開トーン化の表現も連動修正する必要がある。dogfooding と hardening を分離すると Phase 12 で再度 README 全部読み直しが発生する (= 二度手間)
- **commit 履歴の clean さ**: dogfooding の blocking 修正 (C3) と hardening の表現統一 (C4-C5) は同じ Phase 11 内で連動 commit すれば `git log` で「Phase 11 = release-ready 化作業」として一括把握可能
- **rubber-duck #2 のスコープ**: 「dogfooding evidence 完備 + release hardening 完備 + 統合整合性」の 3 軸で 8 観点 review が成立。分離すると Phase 11 RD#2 と Phase 12 RD#2 で重複 observation が発生
- **Phase 12 split criteria gate** (§2 で詳述): ただし dogfooding discovery が **10+ critical findings 級** に膨らんだ場合のみ Phase 12 = release hardening 分離を発動 (= overload safety net)

### 1.5 ユーザー判断 baked-in 確定値 (RD#1 で再確認のみ、本 §1 で確定済)

| 項目 | 確定値 | 根拠 |
|---|---|---|
| LICENSE 種別 | **MIT** | workshop / OSS 教材として最も permissive、依存 SDK = MIT 互換、商用利用 / 改変 / 配布 / private 利用すべて許可、GitHub OSS 標準 |
| 公開 repo タイミング | **C6 close commit 時点で public 化** | M5 = release-ready 達成宣言と同時に公開、release note v1.0.0 を tag 発行 (LICENSE は C4 で commit 済 = README badge dead link 防止) |
| 初回 release tag | **`v1.0.0`** | M5 = release-ready 初公開版として v1.0.0 を採用 (pre-1.0 = `v0.x` ではない、release-ready 達成 = semver 1.0 メジャー宣言)。C5 RELEASE_NOTES + C6 GitHub Release + README badge / release link で同 tag を参照 |
| org policy 設定 | **個人 repo 配下のまま release** | workshop org 移管は Phase 12+ 任意発展、release-ready 達成は個人 repo で十分 |
| Phase 12 split criteria N | **release hardening が 5+ commits or 15+ files なら発動** | Phase 11 で C4 + C5 の 2 commits 以内 / 15 files 以内なら 1 Phase 内、それ以上なら Phase 12 split |
| dogfooding discovery 級判定 | **10+ critical findings なら Phase 12 split 発動** | Phase 03 21 件級 / Phase 05 21 件級は split、5 件以下なら 1 Phase 内 |
| Required Status Check 必須化 | **Phase 12 へ持ち越し** | 本家 main に Required Status Check を強制すると workshop repo そのものが学習者の dogfooding と運用が対立、release hardening バランス的に Phase 12 任意発展 |

---

## 2. Scope

### 2.1 IN SCOPE

| 対象 | 推敲 / 修正方針 |
|---|---|
| **Playground repo `phase11-dry-run` 新規作成 (C2)** | template `shinyay/ghcp-6-layer-agentic-platform` から fresh repo 作成 + Codespaces 起動成功確認 + 初期 commit のみ |
| **Step 0 = Setup dogfooding (C3)** | 環境チェック ①〜⑫ 全 PASS + MCP verification block + Trust thread Layer 0/MCP プロローグ完走 → E11-Setup marker 回収 |
| **Step 1 = Memory dogfooding (C3)** | Memory ファイル投入 + Trust thread Layer 1 連結確認 + R12 削除手順検証 → E11-Minimum 一部回収 |
| **Step 2 = Skill dogfooding (C3)** | M2 keynote CTA = SKILL.md 投入 + Local invariance / Publication boundary 検証 + Trust thread Layer 2 連結 → E11-Minimum 一部回収 |
| **Step 3 = Surfaces dogfooding (C3)** | 3 surfaces (Suggest / Edits / Agent / Cloud Agent) + Path A/B/C 分岐 + E7' Cloud Agent Issue Assignees トリガ → E11-Minimum 完了 |
| **Step 4 = Automate dogfooding (C3)** | gh aw heavy demo 6 sub-step + canonical templates (`triage-issue.md` / `safe-outputs`) + R9 PAT 秘伝 + §3 Appendix workflow 任意発展 → E11-Full 一部回収 + E11-Workflow-Advanced 回収 |
| **Step 5 = Multi-engine dogfooding (C3)** | engine stanza 両形 + COPILOT_GITHUB_TOKEN baseline + 3 engine head-to-head (任意) + 4 状態 done + 任意 Step 救済 path → E11-Full 一部回収 + E11-Degraded (Pro plan skip path) 回収 |
| **Step 6 = Gate dogfooding (C3)** | Step 6a Required Review Gate UI 5 sub-step + plan/permission completion matrix 5 path + Step 6b Custom Agent + §3 Appendix workflow 任意発展 → E11-Full 完了 + E10 通し完走完了 |
| **§10.3 cosmetic 持ち越し台帳 3 項目処理 (Phase 10 持ち越し、C4)** | L01 (section header style 不統一 = badges vs blockquote) / L02 (Step 6 §3.F sample wording drift) / L03 (歴史 docs 凍結方針 → master-plan §4 Phase 11 行 + 本 §1 で転記) を全件処理 (修正 or 受容明示) |
| **(canonical 順序 1) LICENSE 確定 (C4)** | `LICENSE` ファイル新規作成 = MIT (§1.5 確定)、`README.md` badge + footer 反映、`copyright (c) 2025-2026 shinyay` + 著者表記 |
| **(canonical 順序 2) README 公開トーン化 (C4)** | `README.md` (root) + `content/README.md` (scenario entrypoint) を planning-heavy → user-facing にリファクタ。Phase 進行中の途上感を消し、初見学習者が違和感なく読める tone に統一 |
| **(canonical 順序 3) CONTRIBUTING.md 新規作成 (C5)** | Issue 報告方針 / PR テンプレ / コードレビュー方針 / DCO or sign-off / コードオブコンダクト (Contributor Covenant 言及) / branch 命名規約 / commit message 規約 (本 repo の trailer 規約継承) |
| **(canonical 順序 4) RELEASE_NOTES.md 新規作成 (C5)** | `RELEASE_NOTES.md` 新規作成 (= `RELEASE_NOTES.md` に固定、`CHANGELOG.md` 統合は §6.2 ソフトゲート / Phase 12+ 任意)、Phase 03〜11 までの主要 milestone を release note 形式で記録、M5 達成宣言 = Phase 11 close commit と一致 |
| **(canonical 順序 5) git tag `v1.0.0` + GitHub Release (C6)** | tag = `v1.0.0` (§1.5 確定) を C6 で発行、GitHub Release 作成 (release note ベース = §10.4 RESULT block + master-plan §改訂履歴) |
| **(canonical 順序 6) R03-7 self-hosted runner CI 緑化 (C5)** | `.github/workflows/{step-gate,smoke,pages}.yml` の `runs-on:` を `self-hosted` → `ubuntu-latest` 化 (= **計 9 workflow runs** = step-gate ×7 jobs + smoke + pages の 2 jobs)、必要 secrets を Settings に設定、step-{0..6}-gate / L1 smoke が GitHub Actions 上で **本物の緑**に (= 部分解消は不可、§7.1 R11-4 参照)。**`copilot-setup-steps.yml` は現状不在のため Phase 11 scope から除外** (= 2026-04-28 ユーザー判断 baked-in、Phase 12+ で Cloud Agent setup workflow を新規作成する場合に追加検討) |
| **(canonical 順序 7) external link rot hardening (C5、Phase 10 RD#2-S2 持ち越し)** | `curl -I` 一括 external URL 検査 (404 / redirect / auth-required 分類) + 404 link 修正 |
| **(canonical 順序 8) i18n / accessibility hardening (C5、Phase 10 RD#2-S2 持ち越し)** | heading hierarchy + alt text 検査 + 言語切替の lang attr 確認 |
| **(canonical 順序 9) org policy / repo Settings (C5)** | repo description / topics (`copilot` / `workshop` / `agentic-ai` / `github-actions` 等) / homepage URL / issue template (Phase 09 stub があれば確定化) / pages publish (Step 0 §3.D-2 / docs site 化、任意) |
| **(canonical 順序 10) §10.3 持ち越し台帳列拡張 (Phase 10 RD#2-S3 持ち越し、C5)** | 8 列 → 11 列に拡張 (`owner` / `target commit` / `evidence required` 追加)、Phase 10 持ち越し L01/L02/L03 + Phase 11 dogfooding cosmetic discovery を全件 11 列で記録 |
| **master-plan §4 Phase 11 行更新 + §6 R 表 status final + §改訂履歴** | M5 達成宣言 + 歴史 docs 凍結方針の Phase 11 側適用 + Phase 12+ 申し送り |
| **rubber-duck 3 回 (#1 計画 / #2 close 直前 / #3 post-close)** | Phase 10 で確立した型を継承、各 finding を計画書本体 / commits に反映 |
| **P11-1〜N 設計パターン抽出 + Phase 12+ 申し送り §11** | dogfooding 動的検証 Phase 固有のパターン (例: discovery 即修正 cycle / E11 5 段階 marker 構造 / playground repo lifecycle / release hardening 順序 / Phase 11→12 split 発動判断 / OSS 公開ワンポイント等) |

### 2.2 OUT OF SCOPE (= Phase 12+ 移送)

| 対象 | 移送先 | 理由 |
|---|---|---|
| **録画 (recordings)** | Phase 12+ | ユーザー判断 (2026-04-26) で完全に Phase 12+ へ移送、Phase 11 では touch しない |
| **第三者 dogfooding** | Phase 12+ | Phase 11 = 著者本人の dogfooding (E10) のみ、第三者 dogfooding は public release 後に Issue / Discussion 経由で収集 |
| **多言語化 (i18n full)** | Phase 12+ | Phase 11 = lang attr / 文字化け / RTL 対応の最低限のみ、英語版 README 等のフル翻訳は Phase 12+ |
| **org-level deployment** | Phase 12+ | Phase 11 = 個人 repo 配下で release (§1.5 確定)、workshop org 移管は Phase 12+ 任意発展 |
| **本家 main branch protection 適用** | Phase 12+ | Phase 11 = workshop repo 自体の main に Required Status Check を強制すると著者の dogfooding 運用と対立、Phase 12+ 任意発展 (§1.5 確定) |
| **既存歴史 phase-03〜10 docs の本文修正** | しない (Phase 10 §2.2 凍結方針継承) | 各 phase doc は close-time SoT snapshot として保存、Phase 11 では touch しない (master-plan §4 Phase 11 行 + 本 §1 で凍結方針の Phase 11 側適用を明記するのみ) |
| **RD#3-I4 = Phase 12 split criteria N の placeholder 確定 → 本 §1.5 で確定済 (5+ commits or 15+ files / 10+ critical findings)** | (Phase 11 内で確定) | Phase 10 から持ち越した RD#3-I4 を本 §1.5 で確定したため、Phase 12+ 移送ではなく Phase 11 で消化 |
| **RD#3-I5 = E10/E11 marker family vs variants 解像度 → 本 §1.2 で確定 (E10 = 単一 / E11 = 5 variants)** | (Phase 11 内で確定) | Phase 10 から持ち越した RD#3-I5 を本 §1.2 で確定したため、Phase 12+ 移送ではなく Phase 11 で消化 |

### 2.3 Phase 12 split criteria gate (Phase 10 §11.2 から継承 + 本 §1.5 で確定)

> **Phase 11 計画書執筆時点 (本 C1 commit) で、以下のいずれかが該当すれば Phase 12 = Public Release Hardening を新設し、M5 達成宣言を Phase 12 に分離する**:
>
> - **release hardening が 5+ commits or 15+ files** を超える (例: README 公開トーン化大規模 + CONTRIBUTING 新規 + LICENSE 確定 + リリース note + tag automation + org policy 設定 + i18n フル翻訳 + accessibility 全 Step 検査 が 6+ commits 必要)
> - **dogfooding で 10+ critical findings** が出る (Phase 05 E7 reframe 級 = 21 件 / Phase 03 = 18 件級)
> - rubber-duck #1 (Phase 11) で「2 軸一括は overload」と判定された
>
> **該当しない場合は Phase 11 で M5 = release-ready 達成宣言** (現行 1 Phase プラン継続)。
>
> **Phase 12 分割案** (該当時のみ採用):
> - **Phase 11**: Dogfooding + E10/E11 marker 回収 + blocking discovery 修正 (M5 軸 2 のみ)
> - **Phase 12**: Public release hardening + LICENSE / CONTRIBUTING / リリース note / final tag + i18n / accessibility (M5 軸 3 のみ)
> - M5 達成宣言は Phase 12 close commit で行う (master-plan §5 milestone block + §11.5 を Phase 12 で更新)
>
> **Phase 11 RD#1 で本 gate を必ず判定** (= 本 §2.3 を読んで「split 発動 / 不発動」を Blocking finding として明記)。

### 2.4 ユーザー判断 baked-in (再確認、§1.5 確定値、2026-04-26 + 2026-04-28)

| 項目 | 確定値 |
|---|---|
| 録画 (recordings) | **完全に Phase 12+ へ移送** (Phase 11 では touch しない) |
| Phase 11 軸構成 | **2 軸**: 軸 2 dogfooding + 軸 3 release hardening |
| M5 達成宣言条件 | **2 軸完了で release-ready 宣言** (録画なしで OSS 公開可能版) |
| 新規 playground repo | **`shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run`** (新規作成、template から fresh) |
| dogfooding 取り回し | **全 7 Step (Step 0〜6) を 1 take 通し** (連続実機完走、Trust thread 連結性検証最大化) |
| LICENSE | **MIT** (§1.5 確定) |
| 公開 repo タイミング | **C6 close で public 化** + tag 発行 (§1.5 確定) |
| 初回 release tag | **`v1.0.0`** (§1.5 確定、M5 = release-ready 初公開) |
| Phase 12 split criteria | **5+ commits or 15+ files / 10+ critical findings で発動** (§1.5 + §2.3 確定) |
| Required Status Check 必須化 | **Phase 12+ 持ち越し** (§1.5 確定) |

---

## 3. ディレクトリ / ファイル

### 3.1 新規作成

| Path | 役割 | commit |
|---|---|---|
| `docs/planning/phase-11-dogfooding-release.md` | 本ファイル | C1 |
| `LICENSE` | MIT ライセンス | C4 |
| `CONTRIBUTING.md` | 貢献ガイド | C5 |
| `RELEASE_NOTES.md` | リリース note (`RELEASE_NOTES.md` に固定、`CHANGELOG.md` 統合は Phase 12+ 任意) | C5 |
| (任意) `.github/ISSUE_TEMPLATE/*.md` | Issue テンプレ確定化 | C5 |

### 3.2 更新 (本家 repo `shinyay/ghcp-6-layer-agentic-platform`)

| Path | 更新内容 | commit |
|---|---|---|
| `README.md` (root) | LICENSE badge + 公開トーン化 + 著者表記 | C4 |
| `content/README.md` | 公開トーン化 + Phase 11 完了表記 + escape hatch 表に `release-ready` row 追加 | C4 + C6 |
| `content/step-{0..6}/README.md` | dogfooding discovery 反映 (blocking 修正 + cosmetic 一部反映) | C3 + C4 |
| `docs/planning/00-master-plan.md` | §4 Phase 11 行 ✅ + §5 M5 達成宣言 + §6 R 表 status final + 歴史 docs 凍結方針 Phase 11 側適用 1 行 + §改訂履歴 | C4 + C6 |
| `docs/planning/VERSIONS.md` | dogfooding で確証された engine stanza 仕様 / secret naming / .lock.yml 出力差分の **実機 verify 済** 表記化 | **C3** (= 旧 C4 から移送、2026-04-28 ユーザー判断 baked-in) |
| `content/prerequisites.md` | dogfooding で確認した P1〜P12 過不足 (chip 実物存在確認) | **C3** (= 旧 C4 から移送、2026-04-28 ユーザー判断 baked-in) |
| `.github/workflows/{step-gate,smoke,pages}.yml` | `runs-on: [self-hosted, Linux, X64]` → `runs-on: ubuntu-latest`、R03-7 解消 (= 計 9 workflow runs。`copilot-setup-steps.yml` は現状不在のため Phase 11 scope 除外、2026-04-28 ユーザー判断 baked-in) | C5 |
| `LICENSE` (新規) | MIT、§1.5 確定 | C4 |
| `CONTRIBUTING.md` (新規) | Issue / PR / 開発フロー / DCO / レビュー方針 | C5 |
| `RELEASE_NOTES.md` (新規) | v1.0.0 初版、Phase 03〜11 milestone | C5 |
| `.github/ISSUE_TEMPLATE/{bug,feature,config}.md` (新規追加、`feedback.md` は既存維持) | bug 報告 / feature リクエスト / 振り分け config | C5 |
| `phase-11-dogfooding-release.md` (本ファイル) | DoD 全 ☑ + §10.4 RESULT block + §11 P11-1〜N + §12 改訂履歴 | C2〜C6 |

### 3.3 新規 playground repo (`shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run`)

| Path | 役割 | commit (playground 側) |
|---|---|---|
| (template 適用後の全ファイル) | template から fresh、初期 commit のみ | playground C1 |
| `.github/skills/issue-triage/SKILL.md` | Step 2 dogfooding で投入 | playground C2 (任意) |
| `.github/agents/code-reviewer.agent.md` | Step 6 dogfooding で投入 | playground C3 (任意) |
| `.github/workflows/triage-issue.md` (gh aw) | Step 4 dogfooding で投入 | playground C4 (任意) |
| (Step 5 multi-engine 用) `.github/workflows/multi-engine.lock.yml` 等 | Step 5 dogfooding で投入 | playground C5 (任意) |
| `dogfooding-complete` branch (任意) | Phase 11 完了時に push、E10 evidence | playground C6 (任意) |

> playground side commits は本家 repo の `phase-11-dogfooding-release.md §10.4` に evidence URL として記録。playground は Phase 11 close 後 archive (Phase 03 dry-run と同型処理、または public 維持で第三者 dogfooding 用 = §1.5 で再判断)。

### 3.4 削除 / 移動

なし (Phase 10 §2.2 凍結方針継承、歴史 docs は touch しない)。

---

## 4. Commits 構成

### 4.1 概要

**6 commits + escape hatch branch `release-ready`** (Phase 09/10 同型継承)。各 commit は **明確な単一目的** + **rubber-duck or self-checkpoint との位置関係** で配置。

> **C1 = 2 sub-commits 構造** (RD#1 反映を監査 trail として明示、Phase 10 と同型):
> - **C1-draft**: `phase-11-dogfooding-release.md` v1 publish (RD#1 入力用 draft)
> - **RD#1** (計画書全体レビュー)
> - **C1-final**: RD#1 findings 反映済 v1.1 publish (= 本ファイルの確定形、§12 改訂履歴 v1.1 entry 記録)

> **実行順序 (= 2026-04-28 ユーザー判断 baked-in、計画書 v1.2 改訂)**:
> C1 → C2 → **C4 → C5 → (C3 = ユーザー実機 dogfooding) → C6** の順で実行する。
> **理由**: C3 = dogfooding 1 take 通しは Codespaces UI / Copilot surface 各種実体験検証が必須で CLI agent では実行不可、本人実機作業のため。一方 C4 (LICENSE + README 公開トーン化) と C5 (CONTRIBUTING + RELEASE_NOTES + workflow ubuntu-latest 化 + link/a11y check + repo settings) は dogfooding 結果に依存しないため CLI 単独で先行可能。
> **依存関係**: C3 は C2 (playground 必須) に依存、C4/C5 は C2 に依存 (C3 不要)、C6 は C3 + C5 完了に依存 (M5 達成宣言には dogfooding evidence 6 rows + release hardening 完備の両方が必要)。
> **dogfooding 依存項目の移送**: 旧 C4 acceptance に含まれていた「VERSIONS dogfooding 確証反映 (engine stanza / secret naming / .lock.yml 実機 verify)」と「prereq P1〜P12 dogfooding 確認反映 (chip 実物存在確認)」は **C3 acceptance に move** (= dogfooding 結果ありきのため、CLI 先行 C4 では実施不可)。

| commit | branch | 目的 | rubber-duck / checkpoint |
|---|---|---|---|
| **C1-draft** | main | `phase-11-dogfooding-release.md` v1 publish (本ファイル draft、~700 行、RD#1 入力用) | C1-draft 直後に **rubber-duck #1** (計画書全体レビュー) |
| **C1-final** | main | RD#1 findings (Blocking + Important + 採用 Suggestion) 反映済 v1.1 publish | — (post-C1-final mini checkpoint Q1〜Q4 のみ) |
| **C2** | main + playground main | playground repo `phase11-dry-run` 新規作成 + 初期化 + Codespaces 起動可能性確認 + template 差分 0 確認 + 本ファイル §10.4 RESULT block 雛形追加 | post-C2 mini checkpoint (Q1: playground template 適用差分 / Q2: Codespaces 起動 / Q3: secrets 初期状態 / Q4: whitelist) |
| **C4** | main | **軸 1 cosmetic + 軸 3 release hardening Part 1** (canonical 順序 1〜2) = LICENSE 確定 (MIT) + README **minimal** 公開トーン化 (root + content/、= WIP 削除 + Maintainers section 縮約 + Audience 完成形表記) + master-plan §4 Phase 11 行更新 + Phase 10 §10.3 L01/L02/L03 全件処理 + 計画書 §4 commit 順序改訂 (v1.2)。**dogfooding 依存項目 (VERSIONS / prereq) は C3 へ move** | post-C4 mini checkpoint (Q1: LICENSE valid / Q2: README tone consistent / Q3: planning truth final / Q4: whitelist) |
| **C5** | main | **軸 3 release hardening Part 2 + RD#2 remediation** (canonical 順序 3〜4 + 6〜10) = CONTRIBUTING 新規 + RELEASE_NOTES 新規 + R03-7 ubuntu-latest 化 (= 9 workflow runs 部分解消不可、§7.1 R11-4) + external link rot + i18n / accessibility + org policy + §10.3 列拡張 (8 → 11) + RD#2 findings remediation | C5 着手前に **rubber-duck #2** (8 観点 final review)、post-C5 mini checkpoint (Q1: CI green / Q2: hardening 完備 / Q3: 統合整合性 / Q4: whitelist) |
| **C3** | main + playground main + playground branches | **dogfooding 1 take 通し (Step 0 → Step 6)** + discovery 即時 blocking 修正 + E10 (1 marker) + E11 (5 variant markers) = 6 evidence rows 全回収 + §10.3 cosmetic 持ち越し台帳 (11 列) 投入 + VERSIONS / prereq dogfooding 確証反映 (= 旧 C4 から移送)。**fallback**: 単一 commit でレビュー不能なら C3a (dogfooding evidence 回収) / C3b (blocking discovery 修正 + RESULT block 更新) に分割可能 (= §4.2 C3 末尾参照) | post-C3 mini checkpoint (Q1: 全 6 evidence rows 回収 / Q2: blocking 全件 fix / Q3: Trust thread Layer 1→6 体感 / Q4: whitelist) |
| **C6** | main + `release-ready` branch | **close commit + M5 達成宣言** (canonical 順序 5) = DoD §6.1 全 ☑ + §10.4 RESULT block 確定 + master-plan §5 M5 達成宣言 + §9 Phase 11 ✅ + §改訂履歴 + **public 化前 secret safety gate PASS** + git tag `v1.0.0` (§1.5 確定) 発行 + GitHub Release 作成 + repo public 化 (= 最後の operation) + `release-ready` branch push (SHA = C6 commit 一致) | C6 close 後に **rubber-duck #3 (post-close review、実施必須)**、Blocking finding が出た場合のみ任意 C7 patch 発動 (= 実施は必須、C7 commit は条件付き) |
| **(条件付き) C7** | main | post-close polish (RD#3 Blocking findings 反映時のみ、Phase 10 同型) | — |

### 4.2 各 commit の Acceptance criteria

#### C1 = 計画書 v1 publish (= C1-draft + RD#1 + C1-final の 2 sub-commits)

**C1-draft acceptance**:
- [ ] `docs/planning/phase-11-dogfooding-release.md` v1 (~700 行) publish (RD#1 入力用 draft)
- [ ] §1.5 で LICENSE / 公開タイミング / 初回 release tag / org policy / Phase 12 split criteria N / dogfooding discovery 級判定 / Required Status Check 必須化判断 全 7 項目 確定
- [ ] §1.2 で E10 = 1 marker / E11 = 5 variant markers (= 6 evidence rows) 解像度確定 (RD#3-I5 解消)
- [ ] §2.3 Phase 12 split criteria gate 明文化
- [ ] §2.4 ユーザー判断 baked-in 10 項目記録
- [ ] §10.1〜§10.4 dogfooding + drift 取扱規則 + RESULT block 雛形 完備
- [ ] §11 Phase 12+ 申し送り雛形 完備

**C1-draft 後に RD#1 (計画書全体レビュー) を実施**

**C1-final acceptance**:
- [ ] RD#1 findings (Blocking + Important + 採用 Suggestion) を本ファイル本体に全反映
- [ ] §12 改訂履歴に v1.1 entry 記録 (= C1-final commit、RD#1 反映明細 + 受容 Suggestion 一覧 + 不採用 Suggestion 理由)
- [ ] 不採用 Suggestion は §12 で受容理由明記

#### C2 = playground 新規作成

- [ ] `gh repo create shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run --template shinyay/ghcp-6-layer-agentic-platform --public` 成功
  - **playground = `--public` 例外**: 本家 repo の C6 close まで private 維持方針 (§1.5) の例外として、playground は C2 から `--public` で作成。理由 = Codespaces / Issue Assignees / Cloud Agent 検証で public 前提機能を使うため。**ただし C2 作成直後と C6 前に playground 側でも secret scan 実施 (§6.1 ハードゲート参照)**
- [ ] **template 適用差分検証**: playground 初期 commit tree と本家 main template source SHA の差分 0 を確認
  - 比較対象 SHA を §10.4 RESULT block に記録 (本家 main HEAD SHA + playground initial commit SHA)
  - 差分があれば **許容差分** (= GitHub template metadata、`README.md` の `Use this template` button text 等) と **blocking 差分** (= workflow / SKILL / docs 等の本体差分) に分類
  - blocking 差分があれば本家 repo 側を template 用に固定化 commit
- [ ] Codespaces 起動可能性確認 (= playground repo に対し owner として Codespaces 作成可能、devcontainer 設定が壊れていない) — **詳細な Step 0 §3.A 環境チェック ①〜⑫ は C3 = dogfooding で実施**、C2 では `gh repo view` + `.devcontainer/` の存在確認のみ
- [ ] secrets 未設定 / Required Review Gate 未設定 / branch protection 未設定 = 学習者 fresh 状態確認
- [ ] **playground 側 secret scan 初回**: `git status --ignored --short` で untracked / ignored secret-like files 0 件、`gitleaks detect --source . --redact` (or 同等) PASS
- [ ] 本ファイル §10.4 RESULT block 雛形に playground repo URL + initial commit SHA + 本家 main HEAD SHA + 差分検証結果記録
- [ ] post-C2 mini checkpoint (Q1〜Q4) PASS

#### C3 = dogfooding 1 take 通し

- [ ] **Step 0 完走** = 環境チェック ①〜⑫ 全 PASS + MCP verification + Trust thread Layer 0/MCP プロローグ → **E11-Setup marker URL 記録** (variant 1)
- [ ] **Step 1 完走** = Memory ファイル投入 + Trust thread Layer 1 + R12 削除手順 → E11-Minimum 一部
- [ ] **Step 2 完走** = SKILL.md 投入 + Local invariance / Publication boundary 検証 + Trust thread Layer 2 → E11-Minimum 一部
- [ ] **Step 3 完走** = 3 surfaces + Path A/B/C + Cloud Agent Issue Assignees → **E11-Minimum marker URL 記録** (variant 2)
- [ ] **Step 4 完走** = gh aw heavy demo + canonical templates + R9 PAT + §3 Appendix workflow 任意発展 → E11-Full 一部 + **E11-Workflow-Advanced marker URL 記録** (variant 5)
- [ ] **Step 5 完走** = engine stanza + COPILOT_GITHUB_TOKEN + 3 engine head-to-head (任意) + 4 状態 done + 任意 Step 救済 path → E11-Full 一部 + **E11-Degraded marker URL 記録** (variant 4)
- [ ] **Step 6 完走** = Step 6a Required Review Gate UI + plan/permission 5 path + Step 6b Custom Agent + §3 Appendix workflow → **E11-Full marker URL 記録 (variant 3) + E10 marker URL 記録 (= 全 7 Step 通し完走)**
- [ ] §10.4 RESULT block に **6 evidence rows 全件記録** (E10 1 + E11 5)
- [ ] discovery 全件 §10.3 持ち越し台帳に投入 (blocking / cosmetic 分類)
- [ ] blocking discovery 全件 fix commit (本家 repo、C3 内 sub-commits or C4 へ持ち越し判断)
- [ ] **VERSIONS dogfooding 確証反映** (engine stanza / secret naming / .lock.yml 実機 verify 済表記化、`docs/planning/VERSIONS.md`、= 旧 C4 から移送、2026-04-28 ユーザー判断 baked-in)
- [ ] **prereq P1〜P12 dogfooding 確認反映** (chip 実物存在確認、`content/prerequisites.md`、= 旧 C4 から移送、2026-04-28 ユーザー判断 baked-in)
- [ ] **blocking discovery 発生時の restart policy** (§10.4 末尾):
  1. 本家 repo に fix commit
  2. playground に fix を sync (= playground 側でも該当 file 更新 commit)
  3. 当該 Step が手順前提を壊す場合は Step 0 から restart (= E10 取り直し)
  4. restart しない場合は §10.4 RESULT block に「継続理由」と「影響範囲なし evidence」を記録
  5. E10 は最終的に blocking fix 適用後の連続完走のみを採用 (= 途中までの evidence は E11-* variant に格下げ可能)
- [ ] §2.3 Phase 12 split criteria gate 判定 (= 10+ critical findings 出たら split 発動 GO/NO-GO、結果を §10.4 に記録)
- [ ] post-C3 mini checkpoint (Q1〜Q4) PASS

**C3 fallback (= C3 が単一 commit でレビュー不能と post-C3 mini checkpoint Q3 で判定された場合)**:
- C3a = dogfooding evidence 回収 (Step 0 → Step 6 + 6 evidence rows 全記録)
- C3b = blocking discovery 修正 + RESULT block 更新 + §10.3 持ち越し台帳投入
- ただし Phase 12 split criteria の `5+ commits` 判定には C3a/C3b 分割理由を §10.4 RESULT に記録 (= 範囲膨張による split ではない、レビュー粒度による分割と明記)

#### C4 = cosmetic + release hardening Part 1 (canonical 順序 1〜2)

- [ ] **(canonical 順序 1)** `LICENSE` 新規作成 (MIT、§1.5 確定) + `README.md` (root) badge + footer 反映
- [ ] **(canonical 順序 2)** `README.md` (root) + `content/README.md` **minimal** 公開トーン化 (= WIP 削除 + Maintainers section 縮約 + Audience 完成形表記、planning-heavy → user-facing)
- [ ] master-plan §4 Phase 11 行更新 + §5 M5 達成宣言準備 + §6 R 表 status final + 歴史 docs 凍結方針 Phase 11 側適用 1 行
- [ ] 計画書 (`phase-11-dogfooding-release.md`) §4 commit 構造改訂 (v1.2 = 2026-04-28 ユーザー判断 baked-in: copilot-setup-steps.yml scope 除外 + 順序 C4→C5→C3→C6 + dogfooding 依存項目 C3 移送 + R03-7 対象を 9 workflow runs に修正)
- [ ] Phase 10 §10.3 持ち越し L01 (section header style) / L02 (Step 6 §3.F sample) / L03 (歴史 docs 凍結方針) 全件処理 (修正 or 受容明示)
- [ ] post-C4 mini checkpoint (Q1〜Q4) PASS

> **dogfooding 依存項目は C3 へ移送** (2026-04-28 ユーザー判断 baked-in):
> 旧 acceptance に含まれていた「VERSIONS dogfooding 確証反映 (engine stanza / secret naming / .lock.yml 実機 verify 済表記化)」と「prereq P1〜P12 dogfooding 確認反映 (chip 実物存在確認)」は **C3 acceptance に move 済**。CLI 先行 C4 では実機 dogfooding 結果がないため実施不可。

#### C5 = release hardening Part 2 + RD#2 remediation (canonical 順序 3〜4 + 6〜10)

- [ ] **RD#2 (8 観点 final review) を C5 着手前に実施**、findings を C5 commit 内で全反映
- [ ] **(canonical 順序 3)** `CONTRIBUTING.md` 新規作成 (Issue / PR / レビュー / DCO / コードオブコンダクト / branch / commit message)
- [ ] **(canonical 順序 4)** `RELEASE_NOTES.md` 新規作成 + Phase 03〜11 milestone 記録 (`CHANGELOG.md` 統合は §6.2 ソフトゲート)
- [ ] **(canonical 順序 6)** `.github/workflows/{step-gate,smoke,pages}.yml` の `runs-on: [self-hosted, Linux, X64]` → `ubuntu-latest` 化 (= **計 9 workflow runs** = step-gate ×7 jobs + smoke + pages の 2 jobs)、必要 secrets 設定、step-{0..6}-gate / L1 smoke が GitHub Actions 上で **本物の緑** = R03-7 解消 (= **部分解消は不可、§7.1 R11-4 参照**、self-hosted 維持が 1 つでも残る場合は C6 close 不可 → Phase 12 split or C7 blocking patch 発動)。**`copilot-setup-steps.yml` は現状不在のため Phase 11 scope から除外** (= 2026-04-28 ユーザー判断 baked-in)
- [ ] **(canonical 順序 7)** external URL HTTP status check (`curl -I` 一括) 完了、404 link 0 件
- [ ] **(canonical 順序 8)** heading hierarchy / alt text / lang attr 検査完了 (i18n / accessibility 最低限)
- [ ] **(canonical 順序 9)** org policy / repo Settings 確定 (description / topics / homepage URL / issue template / pages publish 任意)
- [ ] **(canonical 順序 10)** §10.3 持ち越し台帳列拡張 (8 → 11、`owner` / `target commit` / `evidence required` 追加)
- [ ] post-C5 mini checkpoint (Q1〜Q4) PASS

#### C6 = close + M5 達成宣言 (canonical 順序 5)

- [ ] **post-C3 regression gate (★ RD#2-I1 反映)**: C3 dogfooding 完了後 / C6 close 前に以下を再実行し、PASS evidence を §10.4 に記録:
  - broken-link 0 件 (whitelist 適用後、本家 + content/**)
  - external URL HTTP status check (29 URLs、本家 public 化後の self-link 解消確認、404 = 0)
  - a11y 検査 (image alt / heading hierarchy)
  - 9 jobs CI 緑 (step-gate ×7 + smoke + pages、`gh run view --json jobs` で job conclusion 確証 = RD#2-I5)
  - secret scan #2 (本家 + playground、gitleaks 推奨 = RD#2-S3)
- [ ] DoD §6.1 全 ☑
- [ ] §10.4 RESULT block 確定 (E10 1 + E11 5 = 6 evidence rows + blocking 修正済 commit + cosmetic 持ち越し 11 列台帳)
- [ ] master-plan §5 M5 達成宣言 + §9 Phase 11 ✅ + §改訂履歴 entry
- [ ] **public 化前 secret safety gate PASS** (§6.1 ハードゲート参照、本家 repo + playground repo 両方):
  - `git status --ignored --short` で untracked / ignored secret-like files 0
  - `gitleaks detect --source . --redact` (or 同等の history scan tool) PASS
  - `git log -p --all` 対象で high-confidence secret 0 (PAT / JWT / base64 key pattern / `COPILOT_GITHUB_TOKEN` raw value / API key)
  - `.env*` / `*.pem` / `id_rsa` / `*.key` / `secrets.yml` 等が repo / playground に存在しない
  - playground repo も同じ scan を実施 (`cd playground && gitleaks detect ...`)
- [ ] **(canonical 順序 5)** git tag `v1.0.0` (§1.5 確定) 発行 + GitHub Release 作成 (release note は §10.4 RESULT block + master-plan §改訂履歴 ベース)
- [ ] **repo public 化** (`gh repo edit --visibility public --accept-visibility-change-consequences`) — **必ず最後の operation** (= secret scan PASS 後、tag 発行後、release-ready branch push 後)
- [ ] `release-ready` branch push (SHA = C6 commit 一致)
- [ ] `content/README.md` escape hatch 表に `release-ready` row 追加 (Phase 09 同型 + Phase 10 `scenario-complete` と並列)
- [ ] **C6 close 後に rubber-duck #3 (post-close review、8 観点) 実施 (= 必須)**、Blocking 出た場合のみ任意 C7 patch を発動 (= RD#3 実施は必須、C7 commit は条件付き、Important/Suggestion 反映は Phase 12+ 可)

### 4.3 各 commit の commit message 規約

- title (1 行目): `phase11(<軸>): <要約>` 例 `phase11(dogfooding): C3 = 1 take 通し完走 + E10 1 + E11 5 = 6 evidence rows 全回収`
- body: rubber-duck finding 反映明細 + 受容理由 + 自己検査結果
- trailer: `Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>` 必須

---

## 5. テスト戦略

### 5.1 静的検査 (Phase 10 流用)

- **broken-link self-check** (Phase 10 §10.1 + RD#2-B5 whitelist 規則継承) = 各 commit 後に実行、whitelist 適用後 unresolved local link 0 件
- **用語統一 grep** (Step 0〜6 全 README + planning truth) = "Required Check" / "Trust thread Layer" / engine canonical / 4 状態 done / verification block 名 / `.agent.md` 用語 等の drift 検査
- **anchor target 存在確認** = README cross-link の `#anchor` が target heading に実在
- **`gh aw lint`** (Step 4 templates) = `triage-issue.md` / `safe-outputs` の syntax 検査

### 5.2 動的検査 (Phase 11 固有)

- **playground repo dogfooding** = 全 7 Step 1 take 通し完走 (= E10 evidence)
- **E11-Setup/Minimum/Full/Degraded/Workflow-Advanced 全 5 marker 回収** = playground repo 上の screenshot / commit URL / PR URL / Issue URL を §10.4 RESULT block に記録
- **CI 緑化検証** = `runs-on: ubuntu-latest` 化後、`gh run list --workflow=step-gate.yml` で 全 7 step-{0..6}-gate + L1 smoke が GitHub Actions 上で緑 (= R03-7 解消)
- **external URL HTTP status check** = `curl -I` 一括 + 404 / redirect / auth-required 分類

### 5.3 Phase 11 固有 test ID

| ID | 内容 | gate |
|---|---|---|
| T-PHASE11-001 | broken-link 0 件 (whitelist 適用後) | C6 close gate |
| T-PHASE11-002 | 用語統一 grep 0 drift | C6 close gate |
| T-PHASE11-003 | anchor target 存在確認 全 PASS | C6 close gate |
| T-PHASE11-004 | E10 1 marker + E11 5 variant markers = 6 evidence rows URL §10.4 記録済 | C6 close gate |
| T-PHASE11-005 | step-{0..6}-gate / L1 smoke + smoke + pages が GitHub Actions 上で全緑 (R03-7 解消、部分解消不可、計 9 workflow runs。`copilot-setup-steps.yml` は scope 除外 = 2026-04-28 ユーザー判断 baked-in) | C5/C6 close gate |
| T-PHASE11-006 | LICENSE / CONTRIBUTING / RELEASE_NOTES / git tag `v1.0.0` / GitHub Release / repo public 化 全完了 | C6 close gate |
| T-PHASE11-007 | external URL HTTP status check 完了 (404 link 0 件) | C5/C6 close gate |
| T-PHASE11-008 | §10.3 持ち越し台帳 11 列拡張 + Phase 10 L01/L02/L03 全件処理 | C4/C6 close gate |
| T-PHASE11-009 | rubber-duck #1 + #2 + #3 全 3 回実施完了 + Blocking 全件反映 + Important 反映 or 受容理由明記 + Suggestion 採否判断記録 (= #3 実施は必須、C7 commit は条件付き) | C6 close gate |
| T-PHASE11-010 | `release-ready` branch push (SHA = C6 一致) | C6 close gate |
| T-PHASE11-011 | public 化前 secret safety gate 全 PASS (本家 + playground、§6.1 ハードゲート参照) | C6 close gate |

---

## 6. DoD (Definition of Done)

### 6.1 ハードゲート (全件 ☑ で Phase 11 完了 = M5 達成宣言)

- [ ] T-PHASE11-001〜010 全件 PASS
- [ ] **軸 2 = dogfooding**: playground `phase11-dry-run` で全 7 Step 1 take 完走 + E10 (1 marker) + E11-Setup/Minimum/Full/Degraded/Workflow-Advanced (5 variant markers) = **6 evidence rows 全件回収**
- [ ] **軸 2**: dogfooding discovery を blocking / cosmetic 分類完了 + blocking 全件 Phase 11 内修正
- [ ] **軸 3 (canonical 順序 1)**: LICENSE (MIT) 確定 + `README.md` badge + footer 反映
- [ ] **軸 3 (canonical 順序 2)**: README 公開トーン化 (root + content/) 完了
- [ ] **軸 3 (canonical 順序 3)**: CONTRIBUTING.md 新規作成完了
- [ ] **軸 3 (canonical 順序 4)**: RELEASE_NOTES.md 新規作成 + Phase 03〜11 milestone 記録
- [ ] **軸 3 (canonical 順序 5)**: git tag `v1.0.0` 発行 + GitHub Release 作成
- [ ] **軸 3 (canonical 順序 6)**: R03-7 解消 (ubuntu-latest 化 + secrets 設定 = step-{0..6}-gate / L1 smoke が GitHub Actions 上で **本物の緑、部分解消は不可、計 9 workflow runs**。`copilot-setup-steps.yml` は scope 除外 = 2026-04-28 ユーザー判断 baked-in)
- [ ] **軸 3 (canonical 順序 7)**: external URL HTTP status check 完了 (404 link 0 件)
- [ ] **軸 3 (canonical 順序 8)**: heading hierarchy / alt text / lang attr 検査完了 (i18n / accessibility 最低限)
- [ ] **軸 3 (canonical 順序 9)**: org policy / repo Settings 確定 (description / topics / homepage URL / issue template)
- [ ] **軸 3 (canonical 順序 10)**: §10.3 持ち越し台帳列拡張 (8 → 11) + Phase 11 dogfooding cosmetic discovery 全件記録
- [ ] **public 化前 secret safety gate PASS** (本家 repo + playground repo 両方):
  - `git status --ignored --short` で untracked / ignored secret-like files 0 件
  - `gitleaks detect --source . --redact` (or `trufflehog filesystem .` / `git secrets --scan-history` 等の同等 scanner) PASS
  - `git log -p --all` 対象で high-confidence secret 0 件 (PAT pattern `ghp_*` / `github_pat_*` / JWT pattern / base64 key pattern / `COPILOT_GITHUB_TOKEN` raw value / API key)
  - `.env*` / `*.pem` / `id_rsa` / `*.key` / `secrets.yml` / `credentials.json` 等が repo / playground に存在しない (`find . -name '.env*' -not -path './.git/*'` で 0 件)
  - **playground repo も同じ scan を実施** (= playground `--public` 例外の安全網)
- [ ] Phase 10 §10.3 持ち越し台帳 L01/L02/L03 全件処理 (修正 or 受容明示)
- [ ] **rubber-duck 実施 (#1 計画 / #2 close 直前 / #3 post-close 全 3 回必須)**、Blocking 全件反映、Important 反映 or 受容理由明記、Suggestion 採否判断記録
- [ ] **repo public 化** (`gh repo edit --visibility public --accept-visibility-change-consequences`、= 必ず最後の operation) + GitHub Release 作成
- [ ] `release-ready` branch push (D14 継承、C6 close commit SHA 一致)
- [ ] master-plan §5 M5 達成宣言 + §9 Phase 11 ✅ + §改訂履歴 + 歴史 docs 凍結方針 Phase 11 側適用 1 行 (= L03 解消)
- [ ] §2.3 Phase 12 split criteria gate 判定明文化 (発動 / 不発動どちらでも理由記録)

### 6.2 ソフトゲート (任意)

- [ ] playground repo に `dogfooding-complete` branch push (任意、Phase 03 dry-run と同型処理選択時)
- [ ] playground repo を public 維持で第三者 dogfooding 用に提供 (vs Phase 11 close 後 archive、§1.5 で再判断 → §11.2 Phase 12+ 着手チェックリスト)
- [ ] Pages publish (Step 0 §3.D-2 / docs site 化、任意発展)
- [ ] workshop org 移管検討 (Phase 12+ 任意発展)
- [ ] `CHANGELOG.md` を `RELEASE_NOTES.md` から分離 + 統合 (Phase 12+ 任意、Phase 11 では `RELEASE_NOTES.md` のみ)
- [ ] P11-1〜N 設計パターン抽出 (Phase 12+ 申し送り用)

### 6.3 Phase 11 close 形式

C6 commit message + master-plan §改訂履歴 entry に **以下 5 要素** を含める:
1. M5 達成宣言 (= 録画なしの 2 軸完了で release-ready)
2. E10 1 marker + E11 5 variant markers = 6 evidence rows URL リスト
3. release hardening canonical 順序 1〜10 完了項目 (LICENSE / README / CONTRIBUTING / RELEASE_NOTES / tag `v1.0.0` / R03-7 解消 / external link rot / i18n / accessibility / org policy)
4. dogfooding discovery 件数 (blocking / cosmetic 内訳) + Phase 12 split criteria gate 判定結果
5. P11-1〜N 設計パターン (= Phase 12+ で参照される受入 hook)

---

## 7. リスク

### 7.1 Phase 11 固有リスク (R11-*)

| ID | リスク | 確率/影響 | 対策 |
|---|---|---|---|
| **R11-1** | dogfooding で **Phase 05 E7 reframe 級 (10+ critical findings)** 出る → Phase 12 split 発動 → release hardening が Phase 12 持ち越し → M5 達成宣言が 1 Phase ずれる | 中/高 | §2.3 split criteria gate を C3 中盤で判定、超過時は Phase 12 立て直し (= release hardening を Phase 12 へ移送)、Phase 11 RD#2 でも再判定 |
| **R11-2** | **playground repo template 適用差分** = template から fresh 作成時に template 側で update された差分が学習者初期状態と乖離 | 中/中 | C2 で template 適用直後に `git log` + `git diff` で差分確認、差分があれば本家 repo 側を template 用に固定化 |
| **R11-3** | **Codespaces 起動失敗** (template repo の devcontainer 設定が壊れている / Codespaces capacity 不足) | 低/高 | C2 で 3 リトライ + 起動失敗時は Phase 11 一時 hold + Codespaces capacity 解消待ち |
| **R11-4** | **R03-7 ubuntu-latest 化で workflow が落ちる** (self-hosted 専用ツール依存 / secrets 不足 / runner 環境差) | 中/中 | C5 で 1 workflow ずつ ubuntu-latest 化 + 落ちたら secrets / `apt-get install` / `permissions:` 段階的調整。**部分解消は不可** = step-{0..6}-gate / L1 smoke の **全 9 workflow runs が ubuntu-latest 緑** でなければ C6 close 不可 (= Phase 12 split or C7 blocking patch 発動)。R03-7 対象 workflow = `step-gate.yml` (×7 jobs) + `smoke.yml` + `pages.yml` (= 計 9 workflow runs) を §10.4 RESULT block に明示記録。**`copilot-setup-steps.yml` は現状不在のため Phase 11 scope から除外** (= 2026-04-28 ユーザー判断 baked-in、Phase 12+ で Cloud Agent setup workflow を新規作成する場合に追加検討) |
| **R11-5** | **public 化 + tag 発行で誤って secret 漏洩** (uncommitted secret / .env / API key / PAT 含むファイルが public 化時点で公開) | 低/極高 | **C6 直前に public 化前 secret safety gate を実施 (§6.1 ハードゲート)**: (a) `gitleaks detect --source . --redact` (or `trufflehog filesystem .`) で history scan PASS、(b) `git status --ignored --short` で untracked / ignored secret-like files 0、(c) `find . -name '.env*' -o -name '*.pem' -o -name '*.key'` で 0 件、(d) PAT pattern (`ghp_*` / `github_pat_*`) / JWT / base64 key の grep PASS、(e) playground repo も同じ scan を実施。**`gh repo edit --visibility public --accept-visibility-change-consequences` を C6 内最後の operation として実施** (= secret scan PASS 後 + tag 発行後 + release-ready branch push 後) |
| **R11-6** | **dogfooding で Trust thread Layer 1→6 連結が学習者の目で繋がらない** = README 上は連結文があるが実機では読み飛ばされる UI / 順序問題 | 中/中 | C3 dogfooding 中に Trust thread 連結を体感ベースでチェック、感じない箇所があれば §10.3 cosmetic として記録 + Phase 12+ 申し送り |
| **R11-7** | **release hardening 範囲膨張** = README 公開トーン化が想定以上に広範 (= 既存 Phase 進行中表現が大量に残っている) → 5+ commits 超過 → Phase 12 split 発動 | 中/中 | C4 着手前に `grep -ri 'Phase \(0[3-9]\|1[01]\)' README.md content/README.md` で残存数を見積もり、20+ 件なら C4/C5 を 3 commits に分割 (= split 不要、Phase 11 内で C4a/C4b/C5 構成に変更) |

### 7.2 Phase 10 から継承するリスク (再掲)

- **R03-7** (self-hosted runner CI 緑化) = Phase 11 C5 で解消
- **R10-* family** (Phase 10 で定義された静的推敲リスク) = Phase 11 dogfooding で動的に再検証

### 7.3 リスク発動時の手順

1. discovery を §10.3 持ち越し台帳 (11 列) に投入
2. 5 質問判定で blocking / cosmetic 分類
3. blocking → 即修正 commit (本家 repo + 必要に応じて playground sync、§10.4 restart policy 参照)
4. cosmetic → Phase 12+ 申し送り
5. **Phase 12 split criteria gate 判定** (= §2.3 連動、以下 3 条件のいずれか YES で発動):
   - **dogfooding critical findings >= 10** (= R11-1 発動)
   - **release hardening 見積もり / 実績が 5+ commits or 15+ files** (= R11-7 発動、C4 着手前 + C5 着手前 + post-C5 mini checkpoint で 3 回判定)
   - **rubber-duck #1 / #2 が「2 軸一括は overload」と判定** (= RD#1/RD#2 Blocking finding)
6. **いずれか YES の場合**:
   - Phase 11 = dogfooding close に縮退 (= 軸 2 のみ完了で close)
   - release hardening (canonical 順序 1〜10) は Phase 12 = Public Release Hardening に移送
   - C6 / M5 達成宣言は行わない、または Phase 12 close commit に移動 (master-plan §5 milestone block + §11.5 を Phase 12 で更新)
   - §10.4 RESULT block に split 発動理由 (どの条件が trigger したか) + 移送項目一覧を明記
7. **全条件 NO の場合**: 現行 1 Phase プラン継続 (= §2.3 不発動を §10.4 に明記)

---

## 8. 進め方 (commit 順 + rubber-duck/checkpoint タイミング)

```
[C1-draft commit publish] (= phase-11-dogfooding-release.md v1 draft)
   ↓
RD#1 (計画書全体レビュー)
   ↓ findings 反映
[C1-final commit publish] (= phase-11-dogfooding-release.md v1.1、§12 改訂履歴 v1.1 entry)
   ↓
[C2 commit] playground 新規作成 + template 差分 0 確認 + secret scan #1
   ↓
post-C2 mini checkpoint (Q1〜Q4)
   ↓
[C3 commit (= 単一 or C3a/C3b fallback)] dogfooding 1 take 通し + restart policy
   ↓
post-C3 mini checkpoint (Q1〜Q4) + Phase 12 split criteria gate 判定 (1st)
   ↓
[C4 commit] cosmetic + release hardening Part 1 (canonical 順序 1〜2)
   ↓
post-C4 mini checkpoint (Q1〜Q4) + Phase 12 split criteria gate 判定 (2nd)
   ↓
RD#2 (8 観点 final review)
   ↓ findings 反映
[C5 commit] release hardening Part 2 + RD#2 remediation (canonical 順序 3〜4 + 6〜10)
   ↓
post-C5 mini checkpoint (Q1〜Q4) + Phase 12 split criteria gate 判定 (3rd、final)
   ↓
public 化前 secret safety gate (本家 + playground 両方)
   ↓
[C6 commit] close + M5 達成宣言 + tag v1.0.0 + GitHub Release + release-ready branch + repo public 化 (最後の operation)
   ↓
RD#3 (post-close review、実施必須)
   ↓ Blocking finding ありの場合のみ反映 (任意 C7)
[(条件付き) C7 commit] post-close polish
```

### 8.1 mini checkpoint 共通 4 質問 (post-C2/C3/C4/C5)

- **Q1**: 当該 commit の主目的は達成されたか? (= acceptance criteria PASS)
- **Q2**: 副作用 / regression がないか? (= 既存 step-{0..6}-gate / L1 smoke が緑のまま、broken-link 0 件)
- **Q3**: 次 commit への引き継ぎは整理されているか? (= discovery 持ち越し / rubber-duck input 準備)
- **Q4**: broken-link whitelist / false positive 検査 (Phase 10 RD#2-I6 で追加された質問、継承)

### 8.2 rubber-duck timing 詳細

- **#1 (C1 直後)**: 計画書全体レビュー = §1〜§12 全項目で Blocking / Important / Suggestion 抽出、Phase 12 split criteria gate 判定の妥当性、§1.5 ユーザー判断 6 項目の妥当性、§1.2 E10/E11 marker 解像度の妥当性、P10-1〜9 設計パターン受入 hook (= P11-* 抽出方針)
- **#2 (C5 着手前)**: 8 観点 final review = Phase 10 で確立した型 (= dogfooding evidence 完備 / release hardening 完備 / 統合整合性 / Phase 12 split 判定 / RD#2 自己整合 / Phase 12+ 申し送り完備 / broken-link whitelist / master-plan §5/§9/§改訂履歴整合)
- **#3 (C6 close 後)**: post-close review = Phase 10 で確立した型 = close 状態整合性 / 用語統一 / 歴史 docs 凍結 / 持ち越し台帳受入 / Phase 12+ 申し送り / broken-link whitelist / master-plan §5/§9/改訂履歴 / Phase 11 self-consistency。Blocking 出たら任意 C7 patch 発動

---

## 9. 参照 / 依存

- Phase 10 SoT: `docs/planning/phase-10-scenario-finish.md` (静的品質推敲、P10-1〜9 設計パターン、§10.3 持ち越し台帳 L01/L02/L03)
- Phase 09 SoT: `docs/planning/phase-09-step6-gate.md` (Step 6 = Gate、P09-1〜8 設計パターン、M4 達成宣言)
- master-plan: `docs/planning/00-master-plan.md` (§4 Phase 11 行 / §5 M5 milestone block / §6 R 表 / §9 進捗 / §改訂履歴)
- VERSIONS: `docs/planning/VERSIONS.md` (engine stanza / secret naming / .lock.yml 仕様、Phase 11 dogfooding で実機 verify 反映)
- prerequisites: `content/prerequisites.md` (P1〜P12、Phase 11 dogfooding で実物 chip 存在確認)
- 全 7 Step README: `content/step-{0..6}/README.md` (Phase 11 dogfooding の検証対象)
- PoC 履歴: `docs/planning/poc/{E1-mcp,E7-cli-skill}/RESULT.md` + `docs/planning/poc/learnings.md` (Phase 03/05 dry-run findings = Phase 11 dogfooding の参考事例)

---

## 10. Dogfooding + drift 取扱規則

### 10.1 drift 取扱規則 (Phase 10 §10.1 から継承 + 動的検証拡張)

discovery が出たら以下 5 質問で blocking / cosmetic 判定:

1. **学習者完走を阻害するか?** (= copy-paste 失敗 / 環境差で詰まる / Trust thread 切れる)
2. **事実-SoT-evidence の矛盾はあるか?** (= README 記述と実機挙動のズレ / planning truth との不整合)
3. **broken link / 404 / 引用先消失か?** (= 後続 Phase で必ず詰まる)
4. **safety boundary 越境のリスクか?** (= secret 漏洩 / Trust thread 越境 / public 化前後で危険度変化)
5. **M5 evidence 誤誘導か?** (= dogfooding evidence URL の取り違え / E10/E11 marker の取り違え)

→ 1 つでも YES = **blocking** = Phase 11 内で即修正 commit
→ 全て NO = **cosmetic** = §10.3 持ち越し台帳 (11 列) に投入 = Phase 12+ 申し送り

### 10.2 broken-link whitelist 規則 (Phase 10 RD#2-B5 から継承)

unresolved local link が以下に該当すれば false positive として除外:
- inline code (` `` ` で囲まれた link 風 string)
- image placeholder (`./recordings/*.mp4` 等の Phase 12+ 提供予定 placeholder)
- 歴史 docs 内 close-time relative path (phase-{03..10}-*.md 内)
- §10.3 持ち越し台帳の自己引用 (本ファイル内 §10.3 への link)

### 10.3 cosmetic 持ち越し台帳 (11 列、Phase 10 RD#2-S3 から継承拡張)

| ID | 種別 | 場所 (file:line) | 現状 | 推奨修正 | 理由 (5 質問判定) | 重要度 | target commit hint | **owner** | **target commit** | **evidence required** |
|---|---|---|---|---|---|---|---|---|---|---|
| (Phase 10 持ち越し L01) | section header style 不統一 | content/step-{0..6}/README.md 各所 | badges vs blockquote 混在 | blockquote 統一 | 全 NO = cosmetic | 低 | `release-hardening` | shinyay | C4 (Phase 11) | grep diff |
| (Phase 10 持ち越し L02) | Step 6 §3.F sample wording drift | content/step-6-gate/README.md §3.F | sample 表記揺れ | canonical 用語統一 | 全 NO = cosmetic | 低 | `release-hardening` | shinyay | C4 (Phase 11) | grep diff |
| (Phase 10 持ち越し L03) | 歴史 docs 凍結方針 | docs/planning/00-master-plan.md §4 Phase 11 行 + 本ファイル §1 | C6 master-plan §改訂履歴 1 段落明記済 | §4 Phase 11 行 + 本 §1 に転記 | 全 NO = cosmetic (但し receivership 整合のため receipt 必須) | 中 | `phase11-plan-start` | shinyay | C1 (本 commit) | master-plan §4 + 本 §1 反映確認 |
| (Phase 11 dogfooding cosmetic) | (= C3 dogfooding 中に発見) | (= playground side or 本家 README) | (= 観測現象) | (= 推奨表現) | (= 5 質問判定) | (= 重要度) | (= commit hint) | (= owner) | (= target) | (= evidence) |

### 10.4 RESULT block (C6 close commit で確定)

#### playground sync gate (C5 後 / C3 開始前、★ RD#2-B3 反映)

> **手順**: C5 commit 完了直後 (= C5 HEAD SHA 確定後) に、playground repo `shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run` を C5 HEAD 相当に sync する。手段は以下のいずれか:
>
> 1. **recreate 方式 (推奨)**: playground repo を delete → 同名で再 `gh repo create --template <本家>` して fresh state にする (template 適用差分 0 を維持)
> 2. **merge 方式**: 本家 main を playground の upstream として fetch + merge / cherry-pick (差分が小さい場合)
>
> sync 完了後、本家 C5 HEAD SHA と playground sync 後 HEAD SHA を以下に記録し、dogfooding の起点とする。これにより stale C2 snapshot で dogfooding を始めるリスクを排除する (RD#2-B3)。

| 項目 | SHA / URL | 備考 |
|---|---|---|
| 本家 C5 HEAD SHA (dogfooding 起点) | (C5 commit 直後に記入) | C5-10 = `phase11(release): C5 = ...` |
| playground sync 後 HEAD SHA | (sync 直後に記入) | recreate 方式なら新 initial commit SHA |
| sync 方式 | (recreate / merge どちらか) | recreate 推奨 (RD#2-B3) |
| dogfooding start timestamp | (C3 開始時刻) | 本家 C5 HEAD と playground HEAD が乖離していないことを確認した直後 |

#### dogfooding evidence URL (E10 1 marker + E11 5 variant markers = 6 evidence rows)

| Marker | URL | playground side commit / PR / Issue | 取得日時 | 備考 |
|---|---|---|---|---|
| **E10** = 全 7 Step 通し完走 (1 marker) | (C3 完了時に記入) | (= playground main HEAD) | (= C3 commit timestamp) | E10 = 1 marker (単一、RD#3-I5 解消)、blocking fix 適用後の連続完走のみ採用 |
| **E11-Setup** = Codespaces + Step 0 完走 (variant 1) | (C3 中に記入) | playground (Step 0 完了時) | (= C3 中) | E11 = 5 variant markers の variant 1 |
| **E11-Minimum** = Step 1〜3 完走 (variant 2) | (C3 中に記入) | playground (Step 3 完了時) | (= C3 中) | variant 2 |
| **E11-Full** = Step 4〜6 完走 (variant 3) | (C3 完了時に記入) | playground (Step 6 完了時) | (= C3 完了時) | variant 3 |
| **E11-Degraded** = Pro plan skip path 完走 (variant 4) | (C3 中に記入) | playground (Step 5 任意 skip / Step 6b 任意 skip) | (= C3 中) | variant 4 |
| **E11-Workflow-Advanced** = §3 Appendix 任意発展完走 (variant 5) | (C3 中に記入) | playground (Step 4 §3 Appendix + Step 6b appendix) | (= C3 中) | variant 5 |

#### template 適用差分検証 (C2 evidence)

| 比較対象 | SHA | 差分 |
|---|---|---|
| 本家 main HEAD (template source) | `eb36271` (= C1 commit) | — |
| playground initial commit | `40154ca` ([repo](https://github.com/shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run/commit/40154ca)) | **0** = 許容差分 / blocking 差分なし (= 全 61 tracked files で `diff -q` 0 件、`git ls-files` 完全一致) |

> **C2 verification (2026-04-28)**: `gh repo create --template ... --public` 直後に local clone + 本家との full content diff を実施し、playground initial commit が本家 `eb36271` の完全 mirror であることを確認。GitHub template metadata (= `Use this template` button text 等) は GitHub 側 UI metadata のみで、tracked file には差分なし。

#### C2 secret scan #1 結果 (playground、2026-04-28)

| 検査項目 | 結果 |
|---|---|
| `git status --ignored --short` secret-like files | 0 件 |
| `find . -name '.env*' -o -name '*.pem' -o -name 'id_rsa*' -o -name '*.key' -o -name 'secrets.yml' -o -name 'credentials.json'` | 0 件 |
| PAT pattern grep (`ghp_*` / `github_pat_*`) | 0 件 |
| JWT pattern grep (`eyJ*.eyJ*`) | 0 件 |
| `COPILOT_GITHUB_TOKEN` raw value grep | 0 件 |
| `gh secret list -R ...phase11-dry-run` | `no secrets found` (= 学習者 fresh 状態確認) |
| `gh api repos/.../branches/main/protection` | `Branch not protected` (= 学習者 fresh 状態確認) |

#### post-C2 mini checkpoint (Q1〜Q4、2026-04-28)

| 質問 | 結果 | 根拠 |
|---|---|---|
| **Q1**: 当該 commit の主目的は達成されたか? (= acceptance criteria PASS) | **PASS** | playground repo `shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run` 新規作成完了 (`40154ca`)、template 適用差分 0、secret scan #1 全 PASS、学習者 fresh 状態 (secrets 0 / branch protection 未設定) 確認済 |
| **Q2**: 副作用 / regression がないか? | **PASS** | 本家 repo `eb36271` への影響なし (= playground は別 repo として独立、本家側の変更は本 §10.4 RESULT block 追記のみ)。.devcontainer/devcontainer.json 存在確認 → C3 で Codespaces 起動可能 |
| **Q3**: 次 commit (C3) への引き継ぎは整理されているか? | **PASS** | C3 = dogfooding 1 take 通し (Step 0 → 6) に必要な playground URL + initial SHA + 本家 SHA を §10.4 に記録、C3 acceptance に restart policy + 6 evidence rows 回収項目あり |
| **Q4**: broken-link whitelist / false positive 検査 | **N/A** | 本 commit はファイル新規追記のみ、既存 broken-link 影響なし。次 commit C3 着手前に再確認 |

#### blocking 修正済 commit (本家 repo + playground sync)

| commit SHA (本家) | playground sync SHA | title | 修正対象 | 5 質問判定 | restart 有無 |
|---|---|---|---|---|---|
| (C3 内 sub-commits or C4 へ持ち越し) | (= playground 側 sync commit) | (= 修正内容) | (= 修正対象 file) | (= YES の質問番号) | (= Step 0 restart Y/N、N の場合は継続理由) |

#### dogfooding restart policy 適用記録 (= §4.2 C3 acceptance に対応)

> blocking discovery が Step N で出た場合の対応:
> 1. 本家 repo に fix commit
> 2. playground に fix を sync (= playground 側でも該当 file 更新 commit)
> 3. 当該 Step が手順前提を壊す場合 (例: Step 0 環境チェックが NG だった、Step 1 Memory 投入手順が誤っていた等) は **Step 0 から restart** (= E10 取り直し)
> 4. restart しない場合は本ブロックに「継続理由」と「影響範囲なし evidence」を記録
> 5. **E10 は最終的に blocking fix 適用後の連続完走のみを採用** (= 途中までの evidence は E11-* variant に格下げ可能、または E11 variant の補足記録扱い)

| Step | discovery 内容 | restart 判断 | 継続理由 / 影響範囲 evidence |
|---|---|---|---|
| (C3 中に記入) | (= 観測現象) | (= Y / N) | (= N の場合のみ記入) |

#### Phase 12 split criteria gate 判定結果

| 判定タイミング | 判定基準 | 結果 (発動 / 不発動) | 理由 |
|---|---|---|---|
| post-C3 (1st) | dogfooding critical findings | (= 発動 / 不発動) | (= 件数 + 内訳) |
| post-C4 (2nd) | release hardening commits / files 見積もり | (= 発動 / 不発動) | (= 見積もり値) |
| post-C5 (3rd, final) | release hardening 実績 + RD#2 overload 判定 | (= 発動 / 不発動) | (= 実績値 + RD#2 結果) |

#### release hardening canonical 順序 1〜10 完了項目

| 順序 | 項目 | 完了 commit | 確認 evidence |
|---|---|---|---|
| 1 | LICENSE (MIT) | C4 | LICENSE file SHA |
| 2 | README 公開トーン化 | C4 | grep diff (Phase 表現除去) |
| 3 | CONTRIBUTING | C5 | CONTRIBUTING.md SHA |
| 4 | RELEASE_NOTES | C5 | RELEASE_NOTES.md SHA |
| 5 | git tag `v1.0.0` + GitHub Release | C6 | gh release list / `gh release view v1.0.0` |
| 6 | R03-7 解消 (ubuntu-latest 化、部分解消不可) | C5 | gh run list で全 9 workflow runs 緑 (step-{0..6}-gate ×7 + smoke + pages、`copilot-setup-steps.yml` は scope 除外) |
| 7 | external link rot (404 link 0 件) | C5 | curl -I 結果 |
| 8 | i18n / accessibility (heading hierarchy / alt text / lang attr) | C5 | 検査結果 |
| 9 | org policy / repo Settings | C5 | gh repo view |
| 10 | §10.3 持ち越し台帳 11 列拡張 | C5 | §10.3 表 |

#### public 化前 secret safety gate 結果 (本家 repo + playground repo)

| 検査項目 | 本家 repo 結果 | playground repo 結果 |
|---|---|---|
| `gitleaks detect --source . --redact` (or 同等) | (PASS / FAIL + 件数) | (PASS / FAIL + 件数) |
| `git status --ignored --short` secret-like files | (0 / N 件) | (0 / N 件) |
| `find . -name '.env*' -o -name '*.pem' -o -name '*.key'` | (0 / N 件) | (0 / N 件) |
| PAT pattern grep (`ghp_*` / `github_pat_*`) | (0 / N 件) | (0 / N 件) |
| JWT / base64 key / `COPILOT_GITHUB_TOKEN` raw value grep | (0 / N 件) | (0 / N 件) |

#### repo public 化 + tag 発行 + release-ready branch push (C6 最後の operation 順序)

| Step | operation | 確認 |
|---|---|---|
| 1 | secret safety gate 全 PASS | (上記表) |
| 2 | `git tag v1.0.0` + `git push origin v1.0.0` | gh release list |
| 3 | `gh release create v1.0.0 ...` | gh release view v1.0.0 |
| 4 | `git push origin main:release-ready` | git ls-remote |
| 5 | `gh repo edit --visibility public --accept-visibility-change-consequences` (= 最後の operation) | gh repo view --json visibility |

---

## 11. Phase 12+ 申し送り

### 11.1 P11-1〜N 設計パターン (= Phase 12+ で再利用される hook、本 §10.3 / §11 で記録)

| ID | パターン名 | 内容 |
|---|---|---|
| **P11-1** | Discovery 即修正 cycle | dogfooding で discovery が出たら 5 質問判定 → blocking 即 fix commit (本家) / cosmetic 11 列台帳投入 (= Phase 11 内 close 性維持) |
| **P11-2** | E11 5 段階 marker 構造 (Setup / Minimum / Full / Degraded / Workflow-Advanced) | Phase 12+ で第三者 dogfooding 提供時に同 5 marker でパス分類可能 |
| **P11-3** | Playground repo lifecycle | template fresh 作成 → dogfooding → archive (vs public 維持で第三者 dogfooding 用)、Phase 12+ 第三者 dogfooding は新規 playground を都度作成 |
| **P11-4** | Release hardening canonical 順序 (1: LICENSE → 2: README 公開トーン化 → 3: CONTRIBUTING → 4: RELEASE_NOTES → 5: git tag + GitHub Release → 6: R03-7 ubuntu-latest 緑化 → 7: external link rot → 8: i18n / accessibility → 9: org policy / repo Settings → 10: §10.3 11 列拡張) | Phase 12+ で hardening 拡張時に同順序を踏襲。本 §1.1 / §2.1 / §4.2 C4-C5 / §6.1 / §10.4 で同順序参照 |
| **P11-5** | Phase 11→12 split 発動判断 (5+ commits or 15+ files / 10+ critical findings) | Phase 12+ split 判断時にも同基準で運用 |
| **P11-6** | OSS 公開ワンポイント (secret 漏洩確認 / `gh repo edit --visibility public` を最後 operation / tag 発行 + GitHub Release 作成 + release-ready branch push の順序) | Phase 12+ 任意 release タイミング (例: v1.1.0 / v2.0.0) でも同手順 |
| **P11-7** | §10.3 11 列拡張 (owner / target commit / evidence required 追加) | Phase 12+ で持ち越し台帳がさらに膨らんだ場合の追跡性確保 |
| **P11-8** | Required Status Check 必須化判断保留 (= 著者 dogfooding 運用と branch protection の対立を避ける) | Phase 12+ で workshop org 移管時に再判断 |
| **P11-9** | rubber-duck 3 回 (#1 計画 / #2 close 直前 / #3 post-close) + post-commit mini checkpoint 4 質問 (Q1〜Q4) | Phase 12+ も同型継承 |

### 11.2 Phase 12+ 着手チェックリスト

> Phase 12 計画書執筆時に **以下を §1 / §2 で必ず確認**:

- [ ] **録画 (recordings)**: Phase 11 で Phase 12+ 移送した M5 軸 1 を Phase 12 = 録画 + 公開準備として再起動するか / 別 Phase に分離するか判断
- [ ] **第三者 dogfooding**: GitHub Issue / Discussion 経由で第三者 dogfooding を募集する仕組み確定 (template / フィードバックフォーム / 受入 SLA)
- [ ] **多言語化 (i18n full)**: 英語版 README / 全 7 Step 翻訳の対応範囲確定 (= 1 言語追加 / 2 言語追加 / N 言語)
- [ ] **org-level deployment**: workshop org 移管 + branch protection + Required Status Check 必須化判断
- [ ] **accessibility expansion**: WCAG 2.1 AA 準拠 / screen reader 対応 / キーボード操作対応の対応範囲確定
- [ ] **release hardening expansion**: v2.0.0 / メジャーアップデート時の release プロセス確定 (semver / breaking change 規約 / migration guide)
- [ ] **Phase 11 P11-1〜9 設計パターン全 9 項目**を Phase 12 計画書 §1.1 / §8 / §10.3 に転記
- [ ] **歴史 docs 凍結方針の Phase 12 側適用** = master-plan §4 Phase 12 行 + phase-12 計画書 §1 冒頭で明記
- [ ] **external URL HTTP status check** を Phase 12 でも継続 (link rot は時間で進行する)

### 11.3 Phase 11 で達成しない事項 (= Phase 12+ 移送、再掲)

- 録画 (M5 軸 1)
- 第三者 dogfooding
- 多言語化 (i18n full)
- org-level deployment / workshop org 移管
- 本家 main branch protection 適用 / Required Status Check 必須化
- accessibility expansion (WCAG 2.1 AA 準拠フル)
- 既存歴史 phase-03〜10 docs の本文修正 (Phase 10 §2.2 凍結方針継承)

### 11.4 Phase 11 で発生したリスク (= Phase 12+ で継続観察)

- **R11-1** (dogfooding 10+ findings → Phase 12 split): Phase 11 close 時点での発生有無 + Phase 12 split 採択 / 不採択を §10.4 RESULT に記録
- **R11-7** (release hardening 範囲膨張): Phase 11 close 時点での膨張度合いを §10.4 RESULT に記録、Phase 12+ で継続観察 (= release が膨らむほど v2.0.0 タイミングで再発リスク)
- **R10-* / R03-7 family**: Phase 11 で解消した分は ✅ 記録、未解消があれば Phase 12+ 持ち越し

### 11.5 M5 達成宣言の品質規約

**M5 = release-ready の達成条件** (Phase 11 close commit = C6 で宣言):

- **軸 2 = dogfooding**: E10 1 marker + E11 5 variant markers = 6 evidence rows URL 完備 + blocking discovery 全件 Phase 11 内修正 + Trust thread Layer 1→6 体感確認済
- **軸 3 = release hardening**: canonical 順序 1〜10 全項目完了 (LICENSE / README 公開トーン化 / CONTRIBUTING / RELEASE_NOTES / git tag `v1.0.0` + GitHub Release / R03-7 解消 (部分解消不可) / external link rot / i18n / accessibility / org policy / §10.3 11 列拡張)
- **public 化前 secret safety gate** PASS (本家 + playground 両方)
- **(録画 = M5 軸 1 から除外、Phase 12+ 移送)**

**達成宣言の場所**:
- master-plan §5 milestone block (M5 = release-ready ✅ + 達成宣言文)
- master-plan §改訂履歴 (Phase 11 完了 entry に M5 達成明記)
- phase-11-dogfooding-release.md §10.4 RESULT block (E10/E11 6 evidence rows + canonical 順序 1〜10 完了項目 + secret safety gate 結果 + Phase 12 split criteria gate 判定結果)
- C6 commit message (上記 5 要素を含む)
- GitHub Release v1.0.0 release note

---

## 12. 改訂履歴

| 日付 | 変更 | コミット |
|---|---|---|
| 2026-04-28 | C1-draft: Phase 11 着手、本ドキュメント v1 新規 (RD#1 入力用 draft)。**ユーザー判断 (2026-04-26 + 2026-04-28) baked-in**: 録画 = Phase 12+ へ完全移送、Phase 11 = 2 軸 (dogfooding + release hardening)、playground = `phase11-dry-run` 新規、dogfooding = 全 7 Step 1 take 通し、LICENSE = MIT、公開タイミング = C6 close で public 化、初回 release tag = `v1.0.0`、Phase 12 split criteria = 5+ commits or 15+ files / 10+ critical findings、E10 = 1 marker / E11 = 5 variant markers (= 6 evidence rows)、Required Status Check 必須化 = Phase 12+ 持ち越し。 | C1-draft |
| 2026-04-28 | C1-final: **RD#1 (計画書全体レビュー) findings 反映済 v1.1**。**Blocking 4 件全反映**: B1 = C1-draft / C1-final 2 sub-commits 構造化 (= 監査 trail) / B2 = public 化前 secret safety gate を §6.1 ハードゲート + C6 acceptance + R11-5 + T-PHASE11-011 に追加 (gitleaks/trufflehog + untracked + .env scan + playground 両方) / B3 = R11-4 「部分解消許容」を削除し step-{0..6}-gate / L1 smoke + smoke + pages + copilot-setup-steps の全 10 workflow runs ubuntu-latest 緑 = C6 close 必須に厳格化 / B4 = §7.3 リスク発動時手順を Phase 12 split criteria gate 3 条件 (10+ critical findings / 5+ commits or 15+ files / RD overload 判定) に拡張接続。**Important 7 件全反映**: I1 = §1.5 heading を「ユーザー判断 baked-in 確定値」に + line 28 暫定表現削除 / I2 = §1.5 + §2.4 に初回 release tag = `v1.0.0` を 7 項目目として追加 / I3 = release hardening 順序を canonical 10 項目 (P11-4) として §1.1 / §2.1 / §4.2 C4-C5 / §6.1 / §10.4 で同順序統一 / I4 = E10 = 1 marker + E11 = 5 variant markers (= 6 evidence rows) に表現統一 / I5 = §10.4 末尾と §4.2 C3 acceptance に restart policy 明記 (Step N で blocking 出たら本家 fix → playground sync → Step 0 restart 判断 → E10 は最終連続完走のみ採用) / I6 = §4.2 C2 acceptance に template 適用差分 0 確認 + SHA 比較 + 許容/blocking 差分分類追加 / I7 = §4.2 C2 acceptance に playground = `--public` 例外明記 + playground 側 secret scan 義務化。**Suggestion 3 件全採用**: S1 = `RELEASE_NOTES.md` 固定 + `CHANGELOG.md` 統合は §6.2 ソフトゲート / Phase 12+ 任意 / S2 = RD#3 実施必須化 + C7 commit は条件付き (Blocking findings ありの場合のみ) / S3 = C3 fallback C3a (evidence 回収) / C3b (blocking 修正) を §4.2 C3 acceptance 末尾に明記。 | C1-final (`eb36271`) |
| 2026-04-28 | **C2: playground repo `shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run` 新規作成 + 初期化完了**。template `shinyay/ghcp-6-layer-agentic-platform` から `gh repo create --template --public` で fresh 作成 (initial commit `40154ca`)、本家 main `eb36271` と全 61 tracked files content diff = 0 (= I6 acceptance PASS)、secret scan #1 全 PASS (untracked 0 / .env-pattern 0 / PAT-pattern 0 / JWT-pattern 0 / `COPILOT_GITHUB_TOKEN` raw 0)、`gh secret list` = none / branch protection = 未設定 / `.devcontainer/devcontainer.json` 存在確認済 (= C3 で Codespaces 起動可能)、§10.4 RESULT block の C2 evidence (template 差分検証 + secret scan #1 結果 + post-C2 mini checkpoint Q1〜Q4) 確定記入。**Codespaces 起動成功は C3 = dogfooding Step 0 §3.A 環境チェック ①〜⑫ で実施** (= C2/C3 境界明確化)。 | C2 (`2fbf312`) |
| 2026-04-28 | **v1.2 = CLI 先行進行のための計画書改訂 (本セッションユーザー判断 3 件 baked-in)**。**判断 1**: `copilot-setup-steps.yml` は現状不在のため Phase 11 scope から除外 (= R03-7 解消対象を 10 → **9 jobs** = step-gate ×7 + smoke + pages に修正、§2.1 / §4.2 C5 acceptance / §5.3 T-PHASE11-005 / §7.1 R11-4 / §10.4 順序 6 / §6.1 ハードゲートに反映)。Phase 12+ で Cloud Agent setup workflow を新規作成する場合に追加検討。**判断 2**: commit 実施順序を **C1→C2→C4→C5→C3→C6** に変更 (= dogfooding = ユーザー実機作業 = 自分が前提なため最終局面に集約、CLI 先行で C4/C5 release hardening を完成可能。§4.1 概要表 + 実行順序注記 + 依存関係注記更新、commit 番号 C1-C7 自体は維持)。**判断 3**: dogfooding 依存項目 = `docs/planning/VERSIONS.md` engine stanza / secret naming / .lock.yml verify と `content/prerequisites.md` P1〜P12 chip 確認を **C4 acceptance から C3 acceptance に move** (= CLI 先行 C4 では実機 dogfooding 結果がないため実施不可、§3.2 + §4.2 で反映)。**判断 4**: README 公開トーン化 = **minimal** (= WIP 削除 + Maintainers section 縮約 + Audience 完成形表記、§4.2 C4 acceptance に明記)。 | C4 (= `ec1b7fa`、本 commit に集約済) |
| 2026-04-28 | **C4 publish (`ec1b7fa`)**: LICENSE (MIT) 新規作成 + README.md (root) minimal 公開トーン化 (LICENSE badge gist URL → ローカル file / Status badge WIP→v1.0.0 release-ready / WARNING block 削除 / Planning & Progress→For Maintainers 縮約 / Eventual Audience→Audience) + Phase 10 §10.3 持ち越し L01 (Step 0/1 README badges → blockquote 統一) + L02 (Step 6 §3.F sample = R11 末尾追加で agent file と完全一致) + L03 (master-plan §4 Phase 11 行に凍結方針 1 行追加) + master-plan §4 Phase 11 行 v1.2 仕様書き換え + §9 Phase 11 進捗 ⏳→🟡 + §改訂履歴 entry + 計画書 v1.2 改訂 (本 entry 含む)。post-C4 mini checkpoint Q1〜Q4 PASS。 | C4 (`ec1b7fa`) |
| 2026-04-28 | **RD#2 (= rubber-duck #2 final review、8 観点) 実施結果**: 3 Blocking + 7 Important + 4 Suggestion。**Blocking 3 件 = C5-1 で remediation 必須**: B1 = `content/README.md` の Phase 10 完了 / Phase 11 持ち越し warning が release tone と矛盾 → 削除 + escape hatch 表 `scenario-complete` row の M5 未達 wording を簡素化 + `release-ready` row 追加 / B2 = 計画書 line 6 commit 構成が v1.2 順序 (`C1→C2→C4→C5→C3→C6`) と矛盾 → 修正 / B3 = playground sync gate = C5 後 / C3 開始前に playground を C5 HEAD 相当に sync (recreate or merge/cherry-pick) しないと dogfooding evidence が stale C2 snapshot になる → §4.2 C2 / C3 / §10.4 に sync gate + dogfooding start SHA 記録義務追加。**Important 7 件**: I1 = post-C3 regression gate (broken-link / external URL / a11y / 9-gate CI / secret scan 再実行) を C6 acceptance に明記 / I2 = `SECURITY.md` 新規作成 (脆弱性報告先) / I3 = `CODE_OF_CONDUCT.md` 作成 or CONTRIBUTING から CoC リンク不在の明記 (broken link 防止) / I4 = `copilot-setup-steps.yml` 不在で Cloud Agent path が成立する evidence を C3 で取得 (失敗時は C3 blocking discovery) / I5 = "9 workflow runs" 表現を "9 jobs" or "step-gate 7 jobs + smoke 1 job + pages workflow" に修正 (`gh run view --json jobs` で job conclusion まで evidence) / I6 = `pages.yml` を hard gate にするなら C5-7 repo settings に Pages enable evidence を含める or R03-7 から pages deploy green を外す / I7 = playground side secrets/settings 別管理を C3 acceptance で `gh repo view` 証跡化。**Suggestion 4 件**: S1 = root README Quick Start に Pro+ / API key plan 境界の短い注記追加 / S2 = `smoke.yml` の self-hosted 前提 comment / job name も ubuntu-latest 前提に更新 / S3 = secret scanner コマンドを 1 つ固定 (`gitleaks detect --source . --redact --no-banner` 推奨) / S4 = `resume` untracked file は中身確認 + 削除 or .gitignore (本セッション = Copilot CLI status file = .gitignore 対象、commit 含めず)。 | RD#2 (C5-1 で remediation) |
