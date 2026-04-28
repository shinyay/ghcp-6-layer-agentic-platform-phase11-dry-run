# 📋 学習者前提環境 (Prerequisites)

> **このページの目的**: ワークショップを始める前に、以下を満たしているか確認してください。
> **所要時間**: 5–10 分

---

## ✅ 必須環境

| 項目 | 要件 | 確認方法 |
|---|---|---|
| **GitHub アカウント** | 個人アカウント (PAT 作成権限あり) | https://github.com/settings/profile を開けること |
| **GitHub Copilot プラン** | **Pro / Pro+ / Business / Enterprise** のいずれか | 下の §「環境チェック」スクリプト参照 |
| **GitHub Codespaces アクセス権** | 個人 60 時間 / 月 (Free 枠) で完走可能 | https://github.com/codespaces で codespace を作成できること |
| **Web ブラウザ (モダン版)** | OAuth フロー / PR・Issue UI / Settings UI 操作 | Chrome / Edge / Firefox / Safari いずれの最新版でも OK |
| **VS Code (Web 版 / Desktop 版どちらか)** | Copilot Chat 拡張同梱版 (Codespaces なら自動) | Codespaces 起動時に自動セットアップされます |

---

## ✨ 推奨環境 (なくても可だが体験向上)

| 項目 | 用途 |
|---|---|
| **VS Code Insider** | Step 1 (Memory) の物理ファイル可視化機能の検証は Insider で実施しました。安定版でも動作見込みです |
| **Anthropic / OpenAI API key** | **Step 5 (Multi-engine)** をフル体験する場合のみ必要。Step 5 は任意化されているため、無くても完走できます。**Q5 = Pro plan 縛り廃止 = API key 条件のみ追加** で、Step 4 で登録した `COPILOT_GITHUB_TOKEN` + Copilot license baseline は継承 (Phase 08 P11 参照) |

---

## 🔐 ワークショップ開始前に必ず知っておくべき「秘伝の前提」

ワークショップを途中で詰まらせないために、以下を事前に把握しておいてください。詳細は各 Step で再度説明します。

| # | 前提 | なぜ重要か |
|---|---|---|
| **P1** | **検証用リポジトリ (throwaway repo) は public で作成してください** | private repo は GitHub Actions の分数を消費し、個人 spending limit (デフォルト $0) でブロックされる場合があります |
| **P2** | **Step 4 で使う PAT は「Resource owner = 個人 / Repository access = Public Repositories (read-only) / Permissions → Copilot Requests = Read-only」で作成** | この 3 条件を全て満たさないと PAT 作成 UI に `Copilot Requests` permission が出てきません。**詳細手順 (UI ラベル全文 + sanity check) は Step 4 §3.B 参照** |
| **P3** | **PAT 作成後はすぐ `curl` で sanity check** | `Bad credentials` エラーの原因の大半は PAT のコピーミス (末尾 whitespace 等) です。**copy-paste 可能スニペットは下の §環境チェック ⑦ 参照** (Step 4 §3.B でも再掲) |
| **P4** | **Cloud Agent への Issue assign は Web UI が main path** | Issue 右サイドバー Assignees → `Copilot` を選択 (= 正規トリガ、E7' で確証)。CLI (`gh issue edit <N> --add-assignee Copilot`) は環境により `Bot does not have access` で fail することがあるため TIP 扱い。Issue 本文の `@copilot` mention だけでは起動しません (詳細は **P9** 参照) |
| **P5** | **Cloud Agent サンドボックスは default で外部接続を blocking** | これは**学びの一部**です。教材ではデフォルトのまま進めます |
| **P6** | **Copilot Code Review reviewer 要請は UI / リポ設定のみ** | CLI からの `gh pr edit --add-reviewer copilot` は現時点で動作しません |
| **P7** | **Copilot Memory は VS Code クライアント側のディスクに物理 Markdown ファイルとして保存される** | プライバシー的にはローカル保管です。削除はファイルを `rm` するだけです |
| **P8** | **Skill は `.github/skills/<name>/SKILL.md` の Markdown ファイル** | YAML frontmatter の必須キーは `name` と `description` の 2 つだけ。**ローカルの VS Code Chat / `gh copilot` CLI は workspace ファイルを直接読む** ので uncommitted な状態でも即 invoke できます (= Local invariance)。`git commit + push` は **Cloud Agent / 他の人の Codespaces / GitHub Actions に skill を伝播 (propagation) させる** publication step です。Copilot CLI なら `/skills list` で一覧確認できます |
| **P9** | **Cloud Agent (= Copilot coding agent) は Pro+ / Business / Enterprise plan + Settings 有効化 + Issue Assignees → Copilot 起動** | (a) Plan = Copilot **Pro+ / Business / Enterprise** (Pro 単体は不可、Step 3 §3.C は screenshot 代替で degraded complete) (b) repo Settings → Copilot → **Coding agent → Enabled** (c) **正規トリガ = Issue 右サイドバー Assignees に `Copilot` を追加** (Web UI 推奨、E7' で確証 = F19) (d) GitHub **Actions minutes を消費** する (quota 切れの場合 Initial plan commit 後すぐ finish_failure になり得る = F20) (e) **default で code-fix mode** に解釈するため、Issue body 冒頭に `Use the issue-triage skill to triage this issue.` (slash 無し) を明示すること (= F21) (f) サンドボックスは default で外部接続を blocking、workflow file PR で迂回提案する (= R10、Trust thread の核) |
| **P10** | **`COPILOT_GITHUB_TOKEN` secret は playground repo (workshop repo ではない) に設定する** | Step 4 で gh aw workflow が Copilot CLI engine を呼ぶ際の auth secret。**設定先 repo を必ず確認**: `gh repo view --json nameWithOwner --jq .nameWithOwner` で playground であることを確認してから登録。**登録経路は 4 つ**: ① **UI method** (Settings → Secrets and variables → Actions → New repository secret、Codespaces で確実) ② **`gh aw secrets set COPILOT_GITHUB_TOKEN --value "$COPILOT_PAT"`** (gh-aw docs 主導線) ③ `gh aw secrets bootstrap` (対話式 + existing secrets check) ④ fallback `gh secret set COPILOT_GITHUB_TOKEN -R <owner>/<playground>`。詳細は Step 4 §3.B 参照 |
| **P11** | **Step 5 (Multi-engine、任意) 追加 secret = `ANTHROPIC_API_KEY` (Claude engine 用) / `OPENAI_API_KEY` (Codex engine 用、`CODEX_API_KEY` accepted alternative)** | Step 5 で `gh aw` workflow の `engine` stanza を `claude` / `codex` に切り替えて実機 invoke する場合のみ必要。**Q5 確定**: Pro plan 縛りは廃止、本 Step は **API key 有無のみで分岐** (Plan 縛り廃止)。ただし **Copilot baseline (`COPILOT_GITHUB_TOKEN` + Copilot license) は Step 4 から継承** (= Step 5 §3.B `engine: copilot` 再走に必須)。**設定先 repo は P10 と同じ playground repo**: `gh repo view --json nameWithOwner --jq .nameWithOwner` で確認。**登録経路は 4 つ** (P10 と並列構造): ① **UI method** (Settings → Secrets and variables → Actions → New repository secret、Codespaces で確実) ② **`gh aw secrets set ANTHROPIC_API_KEY --value "$ANTHROPIC_KEY"`** / **`gh aw secrets set OPENAI_API_KEY --value "$OPENAI_KEY"`** (gh-aw docs 主導線) ③ `gh aw secrets bootstrap` (existing secrets check) ④ fallback `gh secret set ANTHROPIC_API_KEY -R <owner>/<playground>`。**API key cost (利用量に応じて Anthropic Console / OpenAI Platform で請求)** に注意 = §2 推奨環境表のとおり、未取得でも CTA は達成済 (Step 5 任意 + 録画代替パス 後続 Phase で提供予定)。詳細は Step 5 §3.A 参照 |
| **P12** | **Step 6 (Gate、Required Review) は GitHub plan と Copilot plan を分けて確認** | Step 6a (Required Review Gate) は **2 種類の plan boundary** を独立に満たす必要があります (混同しがち、Important 12)。**5 項目分解**: (a) **GitHub plan = Branch protection / Repository rulesets が利用可能** (= Free でも Public repo なら OK、Private repo は Pro / Team / Enterprise 以降。playground repo が public なら問題なし) (b) **GitHub repo permission = Admin** (Settings → Branches を開ける = ruleset 編集可能) (c) **Copilot plan = Copilot Code Review が利用可能** (= Copilot **Pro / Pro+ / Business / Enterprise** いずれでも OK、**Step 3 §3.C の Cloud Agent と異なり Pro 単体でも利用可能**、F19 と区別) (d) **org policy 影響なし** (組織アカウント配下なら GitHub Copilot policy で `Copilot Code Review` が disabled でないこと、§環境チェック ⑪ で確認) (e) **playground repo 推奨** (workshop repo に branch protection を設定しないこと、D14 制約継承 = Q4 learner_playground)。**(c)/(d) のいずれかが NG なら degraded path** (Plan/permission completion matrix の Free / Degraded / Workflow-Advanced parsing、Step 6 README §3.A 参照)。詳細は Step 6 §3.A 参照 |

---

## 🔍 環境チェック (Codespaces 起動後すぐ実行)

Codespaces のターミナルで以下を順に実行してください。すべて成功するはずです。

```bash
# 1. GitHub CLI のバージョン (2.x 以降)
gh --version

# 2. Copilot プラン確認 (個人 = "individual", 組織 = "business" / "enterprise")
gh api /user/copilot --jq '.copilot_plan'

# 3. gh aw (Agentic Workflows) の存在確認 — Step 4 で使います
gh aw version  # v0.68.3 が pre-install されています

# 4. jq の存在確認 — 各 Step の sanity check に使います
jq --version

# 5. (Step 2 で必要) Copilot CLI extension — `.github/skills/<name>/SKILL.md` を CLI から invoke するため
gh copilot --version  # v1.0.36 以降を推奨 (Codespaces で auto pre-install されない場合あり)

# 6. (Step 3 §3.C で必要) Cloud Agent 有効化と Assignees picker 確認 — playground repo で実施
#   (a) ブラウザで playground repo の Settings → Copilot → Coding agent が "Enabled" であること
#   (b) playground repo の Issues → New issue 画面 右サイドバー "Assignees" picker に `Copilot` が出ること
#   (c) Plan = Copilot Pro+ / Business / Enterprise (Pro 単体の場合 §3.C は degraded complete で代替)
#   ※ コマンド一発の確認手段はないため Web UI で目視確認してください

# 7. (Step 4 §3.B で必要) PAT 作成後の sanity check (copy-paste 可能形、$COPILOT_PAT は作成した PAT 値に置換)
COPILOT_PAT="github_pat_xxxxxxxxxxxx"  # ← 自分の PAT 値に置き換えて実行
curl -sH "Authorization: Bearer $COPILOT_PAT" https://api.github.com/user | jq .login
#   → 自分の GitHub username が表示されれば PAT は valid (copy ミスなし)

# 8. (Step 4 §3.B で必要) playground repo に COPILOT_GITHUB_TOKEN 登録済か確認 (P10)
gh repo view --json nameWithOwner --jq .nameWithOwner   # ← まず playground repo にいるか確認
gh secret list -R <your-org>/<your-playground-repo> | grep COPILOT_GITHUB_TOKEN
#   → COPILOT_GITHUB_TOKEN  Updated YYYY-MM-DD と表示されれば OK

# 9. (Step 5 §3.C / §3.D で必要、任意) playground repo に ANTHROPIC_API_KEY / OPENAI_API_KEY 登録済か確認 (P11)
#    Step 5 は任意 Step。API key 不所持なら本セクションは skip 可、録画視聴で代替 (後続 Phase で提供予定)
gh secret list -R <your-org>/<your-playground-repo> | grep -E "ANTHROPIC_API_KEY|OPENAI_API_KEY|CODEX_API_KEY"
#   → 該当 engine 用の secret 行が表示されれば OK (claude → ANTHROPIC_API_KEY、codex → OPENAI_API_KEY canonical)

# 10. (Step 5 §3.A で確認) gh aw が認識する engine 別 secret 一覧
gh aw secrets list  # ← engine 別の登録済 secret を表示 (P11 の登録経路③ と並列)
#   → COPILOT_GITHUB_TOKEN / ANTHROPIC_API_KEY / OPENAI_API_KEY が確認できる

# 11. (Step 6 §3.A で必要) playground repo Settings UI で Branch protection / Required Review が編集可能か (P12 (a)(b))
#   (a) ブラウザで playground repo の Settings → Branches (or Settings → Rules → Rulesets) を開けること
#       → Add branch protection rule / New ruleset ボタンが見えれば OK = Repo Admin 権限あり
#   (b) Settings → Code & automation → Copilot (organization 配下なら Organization 設定) で
#       "Copilot Code Review" 関連 setting が visible (= grayed-out / "disabled by policy" でない)
#   ※ コマンド一発の確認手段はないため Web UI で目視確認 (UI verification block 4 項目 = U1-U4)

# 12. (Step 6 §3.D で必要) playground repo に test-用 PR が立てられるか (Required Review 動作確認用)
gh repo view --json nameWithOwner,visibility --jq '.nameWithOwner + " (" + .visibility + ")"'
#   → 自分の playground repo が表示されれば OK (private/public いずれでも、P12 (a) を満たすこと)
#   ※ workshop repo (本リポジトリ) には branch protection を設定しないでください (D14 制約 = Q4 learner_playground)
```

> **エラーが出たら**: `gh auth login` で認証していない可能性があります。Codespaces なら自動で認証されますが、ローカル VS Code で開いている場合は実行してください。

---

## 🆘 トラブルシューティング

| 症状 | 対処 |
|---|---|
| `gh api /user/copilot` が 404 | あなたの GitHub アカウントに Copilot プランが付与されていません。https://github.com/settings/copilot で確認してください |
| `Codespace creation failed` | 個人の Codespaces 残り時間を確認: https://github.com/settings/billing/summary |
| `gh aw: command not found` | Codespaces を再 build してください (Command Palette → `Codespaces: Rebuild Container`) |
| `gh copilot: command not found` | `gh extension install github/gh-copilot` で extension を導入してください (Codespaces なら通常 pre-installed) |
| `gh aw version` が v0.68.3 と異なる | Codespaces を再 build。`v0.69+` 等で動かない場合は Step 4 README §5 参照 (gh aw v0.68.3 pin 中、`docs/planning/VERSIONS.md §1` R6 / Master Plan §6 R6) |

---

## 🚀 環境チェックが全て通ったら

[`README.md`](./README.md) に戻って **Step 0** から始めてください。
