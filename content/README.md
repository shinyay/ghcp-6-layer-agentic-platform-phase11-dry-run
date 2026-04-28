# 🧭 6-Layer Agentic Platform Workshop — シナリオ目次

> **シナリオ**: 「Issue Triage Skill を育てる旅」 — 1 つの Issue Triage Skill を題材に、GitHub Copilot の **6 層 Agentic Platform** を順番に積み上げて体験するセルフラーニング型ワークショップ。

> [!IMPORTANT]
> **Step 3 §3.C (Cloud Agent) の Plan 要件**: Cloud Agent (= Copilot coding agent) は **Pro+ / Business / Enterprise plan** が必要です。Copilot Pro 単体プランの方は §3.C を **screenshot + 文字証跡で代替** (= **degraded complete**) して完走できます。詳細は [Step 3 §3.C 冒頭の IMPORTANT](./step-3-surfaces/#3c-cloud-agent--issue-assignees--copilot-で-publication-boundary-を越境) を参照。Pro 単体プランの方も **[Step 4](./step-4-automate/) からは Copilot CLI engine が Actions runner 上で動く** ため full 完走可能です (= **Step 4 §3.D が初の Copilot CLI engine 由来 server-side triage 実機体験**)。

---

## 🚀 始め方

### 1. 環境確認
まず [`prerequisites.md`](./prerequisites.md) を開いて、以下が揃っているか確認してください:
- GitHub アカウント (個人 / PAT 作成権限あり)
- GitHub Copilot プラン (Pro / Pro+ / Business / Enterprise)
- GitHub Codespaces アクセス権

### 2. Codespaces を起動
リポジトリトップの **Code** ボタン → **Codespaces** タブ → **Create codespace on main** で 1 クリック起動できます。
devcontainer に `gh`, `gh aw`, `jq` が pre-install されています。

### 3. Step を順に進める
下の表のリンクを **Step 0 から順番に** 開いてください。各 Step 冒頭に「必須 / 任意」のバッジが表示されます。

---

## 📚 Step 一覧

| Step | タイトル | 必須 / 任意 | 対応 Layer | ステータス |
|---|---|---|---|---|
| [0](./step-0-setup/) | **Setup** — MCP 接続・Codespaces 起動 | 必須 | Layer 0 (MCP) | ✅ 公開中 |
| [1](./step-1-memory/) | **Memory** — Copilot Memory に triage パターンを蓄積 | 必須 | Layer 1 (Memory) | ✅ 公開中 |
| [2](./step-2-skill/) ⭐ | **Skill** — `SKILL.md` を書いて commit (= keynote CTA) | **必須 (MUST)** | Layer 2 (Customizations) | ✅ 公開中 |
| [3](./step-3-surfaces/) | **Where to Run** — 同 Skill を IDE Chat / CLI / Cloud Agent から呼ぶ | 必須 | Layer 3 (実行サーフェス) | ✅ 公開中 |
| [4](./step-4-automate/) | **Automate** — gh aw で `issues.opened` に自動起動 | 必須 | Layer 4 (gh aw) | ✅ 公開中 |
| [5](./step-5-multi-engine/) | **Multi-engine** — engine 切替 (Copilot / Claude / Codex) | **任意** | Layer 5 (Agent HQ) | ✅ 公開中 (任意) |
| [6](./step-6-gate/) | **Gate** — Required Review + Custom Agent (`.agent.md`) | 必須 (6a) + 発展題材 (6b) | Layer 6 (ゲート) | ✅ 公開中 |

---

## 🎯 学習者プロファイル別の到達経路

| あなたのゴール | 推奨パス | 想定到達 Step |
|---|---|---|
| keynote CTA だけ達成したい | 0 → 1 → 2 で離脱 OK | Step 2 完了 |
| 基本ツアーを完走したい | 0 → 1 → 2 → 3 → 4 → 6 | Step 6 (Required Review Gate 体感) |
| 発展題材まで触りたい | 0 → 1 → 2 → 3 → 4 → 5 → 6 | Step 6 (Custom Agent appendix まで) |

---

## 🪂 escape hatch ブランチ (Step ごとに公開中)

各 Step 完了状態の **repo state** を `step-N-complete` ブランチで提供しています。Step の途中で詰まったら、そのブランチに切り替えれば「次の Step を始める直前の repo 状態」に追いつけます。

| ブランチ | 等価な状態 |
|---|---|
| `step-0-complete` | Step 0 完了直後 (Phase 03 で push) |
| `step-1-complete` | Step 1 完了直後 (Phase 04 で push) |
| `step-2-complete` | Step 2 完了直後 (Phase 05 で push、`.github/skills/issue-triage/SKILL.md` commit 済 = **Local done state**。Published 状態は学習者の playground repo への push に依存) |
| `step-3-complete` | Step 3 完了直後 (Phase 06 で push、**documentation state only** = Step 3 README を読み終わった repo state のみ。**Cloud Agent 観察 (Issue Assignees → Copilot で起動した branch + draft PR) は branch では再現できません** — 各学習者が自分の playground repo で実体験する必要があります) |
| `step-4-complete` | Step 4 完了直後 (Phase 07 で push、**documentation + canonical template state** = README + `content/step-4-automate/templates/` の **canonical sample workflow (`triage-issue.md`) + expected-files checklist** のみ。**workshop repo (本 repo) には active な `gh aw` workflow を意図的に置きません** — workshop 自身のリポジトリで gh aw が動いて workshop repo 自身を triage してしまうのを避けるため。学習者は branch checkout 後、template を **自分の playground repo に展開** して再現します。`COPILOT_GITHUB_TOKEN` secret は branch には乗らないため、各学習者が自分の playground に [Step 4 §3.B](./step-4-automate/#3b-copilot_github_token-pat-を作成して-playground-repo-に登録する) で別途設定する必要があります) |
| `step-5-complete` | Step 5 完了直後 (Phase 08 で push、**documentation + canonical template state** = README + `content/step-5-multi-engine/templates/` の **engine swap unified diff patch (`triage-issue-engine-swap.md`) + 比較表テンプレート (`compare-runs.md`) + 録画 placeholder (`recordings/README.md`)** のみ。**`step-4-complete` と同型の D14 制約継承** = active gh-aw workflow を workshop repo に置かない。`ANTHROPIC_API_KEY` / `OPENAI_API_KEY` (canonical) / `CODEX_API_KEY` (accepted alternative) secret は branch には乗らないため、各学習者が自分の playground に [`prerequisites.md` P11](./prerequisites.md) で別途設定する必要があります。Step 5 は **任意 Step** のため未取得でも CTA は達成済 = 録画視聴 (後続 Phase で提供予定) で代替可能) |
| `step-6-complete` | Step 6 完了直後 (Phase 09 で push、**documentation + canonical template state** = README + `content/step-6-gate/agents/code-reviewer.agent.md` (`.agent.md` canonical sample = read/search のみ) + `content/step-6-gate/templates/pr-required-check.yml` (Appendix B 任意発展用 `pull_request` trigger sample) + 録画 placeholder (`recordings/README.md`) のみ。**workshop repo (本 repo) には branch protection rule を意図的に設定しません** = D14 制約継承 (Q4 learner_playground) — 各学習者が自分の playground repo で実体験する必要があります。Required Review Gate / Required Status Check / `.agent.md` invocation は branch には乗らない repo Settings 上の設定であり、各学習者が [Step 6 §3.B-§3.D + §3.F](./step-6-gate/) の手順で自 playground に再現します) |
| `scenario-complete` | **Phase 10 完了時点** (2026-04-26 push、SHA = `5bc6490`) の **全 7 Step + planning truth 静的品質推敲済 snapshot**。`step-6-complete` から進行した repo state に **Phase 10 静的推敲 6 commits (broken link / 用語統一 / Trust thread 連結 / prereq 整合 / planning truth status final / drift 規則確定 / rubber-duck #1 + #2 反映)** を上乗せした版です。**M4 = content-complete フルバージョン 達成**。録画 / dry-run / 実機完走 evidence は branch には乗らない (= 別 phase で達成) |
| `release-ready` | **Phase 11 完了時点** (= M5 = release-ready 達成宣言時、C6 close commit と SHA 一致) の **release-hardened snapshot**。LICENSE / CONTRIBUTING / RELEASE_NOTES / `v1.0.0` tag + GitHub Release / R03-7 解消 (ubuntu-latest 化) / public 化を含む public release 版 |

```bash
# 例: Step 3 から始めたい場合 (Step 2 完了状態の repo に追いつく)
git fetch origin step-2-complete
git checkout step-2-complete
```

> [!IMPORTANT]
> escape hatch は **repo state のみ** 復元します。Copilot Memory のような **クライアントローカル** 状態 (ローカルディスクに書かれる Memory ファイルなど) は branch には乗りません。Step 1 を飛ばして Step 2 に進む場合は [Step 1 §6 "Memory bootstrap"](./step-1-memory/#memory-bootstrap-escape-hatch-で飛んできた場合) を参照して Memory を再現してください。

> [!IMPORTANT]
> Step 2 escape hatch (`step-2-complete`) は **本 workshop repo の repo state** だけを復元します。本 workshop repo 内では Copilot Chat / `gh copilot` CLI から SKILL.md を直読みできます (= **Local invariance**)。一方 Step 3 で **Cloud Agent (= coding agent / cloud agent)** から triage を invoke するには、**学習者の playground repo の default branch にも同じ `.github/skills/issue-triage/SKILL.md` が push されている必要** があります — これが本当の **publication boundary** です (Cloud Agent / Actions / 他人の Codespaces は default branch しか見ないため)。Step 3 §2 の前提を必ず確認してください。

---

## 🆘 詰まったら

1. **Copilot Chat に質問** — このリポジトリの教材自体が Agentic です。Chat に「Step 2 で SKILL.md の YAML frontmatter がエラーになる」と聞いてください。
2. **Issue を立てる** — フィードバックは `.github/ISSUE_TEMPLATE/feedback.md` 経由で歓迎します。
3. **公式ドキュメント** — [GitHub Copilot docs](https://docs.github.com/copilot)

---

## 🔗 参考

- Workshop 全体設計: [`docs/planning/00-master-plan.md`](../docs/planning/00-master-plan.md)
- 検証実機ログ (内部用): [`docs/planning/poc/`](../docs/planning/poc/)
- バージョン pin / 学習者前提環境: [`docs/planning/VERSIONS.md`](../docs/planning/VERSIONS.md)
