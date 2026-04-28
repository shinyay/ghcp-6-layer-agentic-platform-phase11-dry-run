# Phase 11 ユーザー実機作業 引き継ぎサマリ (C6-prep-5)

> **対象**: shinyay (本人) / Phase 11 残作業 = CLI 範囲外 = 実機 owner 必須項目
> **CLI 完了範囲 (本ドキュメント時点)**: C1 (`eb36271`) + C2 (`2fbf312`) + C4 (`ec1b7fa`) + C5 (`ead279a`) + C6-prep 全 5 (本ファイル含む)

---

## 📋 残タスク (実機 owner 必須)

### A. C3 = Dogfooding 1 take 通し (軸 1、所要 ~3〜4 時間)

#### A.1 事前 (sync gate、★ RD#2-B3)

> C3 開始前に必ず実施。手順詳細は `docs/planning/phase-11-dogfooding-release.md` §10.4 「playground sync gate」セクション。

```bash
# 1. 本家 C5 HEAD SHA を確認 (現在 = ead279a)
cd /home/shinyay/work/github/ghcp-6-layer-agentic-platform
git log --oneline -1

# 2. playground を recreate (推奨方式)
gh repo delete shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run --yes
gh repo create shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run \
  --template shinyay/ghcp-6-layer-agentic-platform \
  --public --description "Dogfooding playground for Phase 11"

# 3. 本家 C5 HEAD と playground 新 HEAD を §10.4 に記録
```

#### A.2 dogfooding 実施

1. playground repo を Codespaces で起動 (`https://codespaces.new/shinyay/ghcp-6-layer-agentic-platform-phase11-dry-run?quickstart=1`)
2. `content/README.md` の Step 0 から **連続 1 take 通し完走** (途中で blocking が出たら fix → restart policy 適用)
3. 各 Step 完了時に E10/E11 marker を §10.4 RESULT block の 6 evidence rows に記入

#### A.3 dogfooding 完了後

- VERSIONS engine stanza + prereq P1〜P12 chip の確証反映 (発見 drift があれば本家 repo に commit)
- C3 commit message = `phase11(dogfooding): C3 = 1 take 通し完走 + E10 1 + E11 5 = 6 evidence rows 全回収`

### B. post-C3 regression gate (★ RD#2-I1)

C3 commit 直後 / C6 close 前に以下を再実行 (PASS evidence を §10.4 に記録):

```bash
# B.1 broken-link 検査
# (Phase 10 で使用した検査スクリプト or 手動 grep)

# B.2 external URL HTTP status check (本家 public 化後の self-link 解消確認)
# /tmp/urls.txt と同等の 29 URLs を curl -I で再 check (404 = 0 期待)

# B.3 a11y 検査 (image alt / heading hierarchy)

# B.4 9 jobs CI 緑 evidence
gh run list -R shinyay/ghcp-6-layer-agentic-platform --workflow=step-gate.yml --limit 1
gh run view <run-id> --json jobs -q '.jobs[] | {name, conclusion}'
# step-gate ×7 + smoke + pages = 計 9 jobs 全 success 確認

# B.5 secret scan #2 (本家 + playground、gitleaks 推奨)
gitleaks detect --source . --redact --no-banner
cd ../playground && gitleaks detect --source . --redact --no-banner
```

### C. C6 = close + M5 達成宣言 (★ 実機 owner 必須、最終 commit)

#### C.1 secrets 設定 (CI 緑化のため、必要に応じて)

```bash
gh secret set ANTHROPIC_API_KEY -R shinyay/ghcp-6-layer-agentic-platform
gh secret set OPENAI_API_KEY -R shinyay/ghcp-6-layer-agentic-platform
# 他、Step 5 multi-engine で必要な key
```

#### C.2 C6 close commit

`docs/planning/phase-11-dogfooding-release.md` §4.2 C6 acceptance を全 ☑ にする commit:

- DoD §6.1 全 PASS 確証
- §10.4 RESULT block 確定 (6 evidence rows + sync gate SHA + secret scan #2 + 9 jobs CI 緑)
- master-plan §5 M5 達成宣言 + §9 Phase 11 ✅ + §改訂履歴 entry (文案 = `docs/release-drafts/m5-statement.md`)
- `content/README.md` escape hatch 表 `release-ready` row は既存

#### C.3 tag + GitHub Release + public 化 (★ 順序厳守、§10.4 参照)

```bash
# 1. release-ready branch push (SHA = C6 commit と一致)
git checkout -b release-ready
git push -u origin release-ready
git checkout main

# 2. tag v1.0.0 発行
git tag -a v1.0.0 -m "v1.0.0 — Initial Public Release (M5 = release-ready)"
git push origin v1.0.0

# 3. GitHub Release publish (文案 = docs/release-drafts/v1.0.0-release.md)
gh release create v1.0.0 \
  --notes-file docs/release-drafts/v1.0.0-release.md \
  --title "v1.0.0 — Initial Public Release"

# 4. ★ 最後の operation = repo public 化
gh repo edit shinyay/ghcp-6-layer-agentic-platform \
  --visibility public \
  --accept-visibility-change-consequences

# 5. repo description / topics / homepage 設定
gh repo edit shinyay/ghcp-6-layer-agentic-platform \
  --description "GitHub Copilot 6-layer × 7-step agentic platform workshop. Codespaces ready, OSS-licensed (MIT)." \
  --homepage "https://github.com/shinyay/ghcp-6-layer-agentic-platform" \
  --add-topic "github-copilot" --add-topic "workshop" --add-topic "codespaces" \
  --add-topic "agentic-ai" --add-topic "education" --add-topic "mcp"
```

### D. RD#3 (post-close review、必須)

C6 close 後に rubber-duck #3 (8 観点 post-close review) を実施。Blocking 出た場合のみ任意 C7 patch 発動。Important/Suggestion は Phase 12+ に持ち越し可。

---

## 🎁 CLI 完了済成果物 (引き継ぎ用 reference)

| 成果物 | path | 用途 |
|---|---|---|
| Phase 11 計画書 v1.2 | `docs/planning/phase-11-dogfooding-release.md` | C3〜C6 の手順 SoT |
| GitHub Release 文案 v1.0.0 | `docs/release-drafts/v1.0.0-release.md` | C6.C.3 で `gh release create --notes-file` に渡す |
| M5 達成宣言文案 | `docs/release-drafts/m5-statement.md` | C6.C.2 で master-plan §5 / §9 / §改訂履歴 に貼り付け |
| public 用 community files | LICENSE / CONTRIBUTING.md / SECURITY.md / RELEASE_NOTES.md / .github/ISSUE_TEMPLATE/ | C5 で commit 済、public 化と同時に GitHub UI で community standards 100% に到達 |

---

## ⚠️ Phase 12+ 持ち越し (RD#3 後 or release 後対応)

| ID | 内容 | 理由 |
|---|---|---|
| S12-recording | 録画 (各 Step walkthrough video) | 2026-04-26 ユーザー判断 baked-in、Phase 11 scope 外 |
| S12-3rd-party-dogfood | 第三者 dogfooding | 自分以外の学習者 1〜2 名で完走 |
| S12-i18n | 多言語化 (EN translation) | 現状 JP only、需要次第 |
| S12-CoC | CODE_OF_CONDUCT.md | 第三者 contributor 増加時 |
| S12-phase3-evidence | phase3-dry-run#8 evidence URL public 化 or 移送 | 現在 private、学習者から不可視 |
| RD#2-S1 | root README Quick Start に Pro+/API key plan 境界注記 | 軽微、Phase 12 で対応可 |
| RD#2-I3/I4/I6/I7 | CoC 不在明記 / Cloud Agent path evidence / pages.yml hard gate / playground secrets 別管理 | C3 acceptance + Phase 12+ で対応 |
