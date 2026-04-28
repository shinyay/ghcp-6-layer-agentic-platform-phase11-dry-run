# Step 3 — Where to Run (3 surfaces で同じ Skill を呼ぶ)

> **必須 Step (MUST、Standard / Full プロファイル)** ・ 対応 Layer: **Layer 3 (実行サーフェス)** ・ 体感 ~18 分

> **このステップで何が起きるか (3 行)**
> 1. Step 2 で書いた **同じ `SKILL.md`** を、**3 つの surface** = (A) IDE Chat / (B) Copilot CLI / (C) Cloud Agent から呼んで、**読む state (= source of truth)** が surface ごとに違うことを観察する。
> 2. **Cloud Agent (= Copilot coding agent)** に Issue を assign し、**publication boundary を越境** (= `git push` した default branch をリモート Agent が読む = skill の **propagation**) する瞬間を体験する。
> 3. `suggestedActors` GraphQL で **同じ Issue に複数 engine を assign 可能** な世界観 (Multi-engine teaser) を確認し、6 観点 × 3 surface の比較表で「どの surface を、いつ使うか」を持ち帰る。

> [!IMPORTANT]
> **Trust thread (この旅の縦糸 — Step 3 編)** — Cloud Agent は **default で外部 API を叩こうとして firewall でブロック** され、その代わりに **workflow ファイルを PR で提案** します。これは「**Agent が外に出ていくときには、人間の review (= PR) を必ず通す**」という Zero-trust 設計です。さらに Cloud Agent の commit は **Verified Signed Commits** として届き、誰が (= Agent が) コードを書いたかが暗号的に検証可能です。これは Step 6a (Required Review Gate) の「**人間が最後に判断する**」へ直結します。

---

## 1. 学習目標 (Learning Objectives)

このステップを終えると、以下を **自分の言葉で説明** できるようになります:

- **Skill = file 1 つ、surface = 3 つ**: Step 2 で書いた `.github/skills/issue-triage/SKILL.md` が、**書き換え無しで** IDE Chat / Copilot CLI / Cloud Agent の 3 surface から呼ばれる。
- **Local invariance (Step 2 で確認済) は publication 後も維持される**: `git push` した後でも、IDE Chat と CLI は **`file:///` の workspace ファイルを直読み** し続ける。push は **Local の挙動を変えない**。
- **Publication boundary** = Cloud Agent / 他の人 / GitHub Actions が「Skill を見える」ようになる境界。**default branch に push されている** ことが Cloud Agent invoke の前提。
- **Cloud Agent の正規トリガ** = **Issue Assignees に Copilot を追加する** (Web UI 推奨)。Issue 本文に書く `@copilot` は本文の文字列であって、それだけでは Cloud Agent は起動しません。
- **3 surface の "読む state"**: IDE Chat = workspace file (uncommitted も読む) / CLI = current branch state / Cloud Agent = **default branch の published state のみ**。
- **Multi-engine の世界観**: 同じ Issue に **Copilot 以外の bot** (Claude / Codex などのコーディング Agent) も assign できる枠組みがあり、Step 5 で head-to-head 比較する伏線。

---

## 2. 前提 (Prerequisites)

- [Step 2 ⭐](../step-2-skill/) を完了していること、または `step-2-complete` ブランチで飛んできていること (Local done + **Published done** §4.2 を満たしていること)。
- 自分の **playground repo の default branch** に `.github/skills/issue-triage/SKILL.md` が **push 済** であること。検証コマンド:
  ```bash
  gh api repos/<owner>/<repo>/contents/.github/skills/issue-triage/SKILL.md --jq .name
  ```
  `SKILL.md` が表示されれば ready です (404 になる場合は Step 2 §4.2 に戻って push してください)。
- playground repo は **public + GitHub Actions 有効 + clean repo 推奨** (= 既存の `.github/copilot-instructions.md` / auto-label workflow / 独自 workflow が無い状態)。
- **Cloud Agent (= Copilot coding agent) が有効化されている** こと:
  - Plan = **Copilot Pro+ / Business / Enterprise** のいずれか (Copilot Pro 単体では §3.C の実機実行は不可、IMPORTANT box を §3.C で参照)
  - repo Settings → Copilot → Coding agent が **Enabled**
  - Issue 右サイドバー Assignees の検索窓に `Copilot` と入力して候補に出ること (= 起動可能 sign)
- `gh` CLI が認証済 (`gh auth status` で OK)、`gh copilot --version` で **v1.0.36+** を確認 (Step 2 §2 と同じ)。

> [!NOTE]
> **Memory bootstrap (escape hatch で飛んできた場合)** — `step-2-complete` ブランチで飛んできた / Codespace を作り直した場合、Memory は **空** から始まります。Step 3 は **Memory に依存しない** ので Memory が空でも問題なく完走できます。Memory も再現したい場合は [Step 1 §3.A](../step-1-memory/#3a-植え付け--copilot-にリポ慣習を覚えさせる) の植え付け prompt を 1 回貼ってください。

> [!NOTE]
> Step 3 は **GitHub MCP server を呼びません** (Skill は Step 2 で commit 済、Step 3 は invoke のみ)。Step 0 の MCP 経由ツール承認ダイアログは Step 3 では出現しません (= Step 4 / Step 6 で再登場)。Trust thread の体験は §3.C の **Cloud Agent firewall default deny → workflow PR 提案 → Verified commit** という形で観測します。

---

## 3. 手順 (Steps)

5 つの sub-step (A → B → C → D → E) で進めます。**§3.A → §3.B で Local invariant が published 後も維持されること** を確認し、**§3.C で publication boundary を越境** (Cloud Agent invoke) します。

### 3.A IDE Chat — `file:///` のまま (= Local invariant が published 後も維持)

> **目的**: Step 2 §3.D で見た「VS Code Chat は uncommitted の workspace ファイルを `file:///` で直読み」が、**push 後も変わらない** ことを確認する。

VS Code で **新規 Chat session** を開き (右側パネルの "+" ボタン)、以下を投げます:

```
このリポジトリの open issue を 1 件 triage して。
```

応答を見ると、再び以下のようなトレースが付きます:

```
スキル [issue-triage](file:///workspaces/<your-repo>/.github/skills/issue-triage/SKILL.md) の読み取り
```

> [!IMPORTANT]
> **観察ポイント**: **`file:///` のままです**。default branch に push 済であっても、IDE Chat は **workspace の file** を読みます (= GitHub raw URL ではない)。これが Step 2 で見た **Local invariance** が **published 後も維持される** 証拠です。`git push` は Local の動作を変えません。**変わるのは「他の場所 (Cloud / 他人 / Actions) から見えるかどうか」だけ** です。

§3.E の比較表 IDE Chat 行に、観察した **トレース文字列 (日本語、`file:///` link)** を 1 行書き写してください。

### 3.B Copilot CLI — `gh copilot` で `/skills list` + 自然言語/明示 invoke

> **目的**: 同じ `SKILL.md` が **CLI surface でも** invoke されることを確認し、トレース表記が IDE Chat (日本語 / `file:///`) と **異なる (英語 / 関数記法)** ことを比較する。

Codespaces ターミナルで:

```bash
gh copilot
```

interactive プロンプトが出たら:

```
/skills list
/skills info issue-triage
```

`name` / `description` / path がそのまま表示されます。

そのまま自然言語で同じ prompt を投げます (= **自動 invoke**):

```
このリポジトリの open issue を 1 件 triage して。
```

または、明示的に Skill を指定したい場合 (= **明示 invoke**):

```
Use the /issue-triage skill to triage the latest open issue.
```

トレースは `skill(issue-triage)` のような **英語 + 関数記法** です (Chat の日本語トレースとは表記が違う = surface ごとの個体差)。

> [!NOTE]
> CLI は **current branch の state** を読みます (= ローカル checkout している branch の workspace)。IDE Chat と同様、**uncommitted な変更も即座に反映** されます (= Local invariant)。

§3.E の比較表 CLI 行に、観察した **トレース文字列 (英語、関数記法)** を 1 行書き写してください。

### 3.C Cloud Agent — Issue Assignees → Copilot で publication boundary を越境

> **目的**: **`git push` した default branch の SKILL.md** を、リモートの **Cloud Agent** が読んで動くことを観察する。これが Step 3 のクライマックス = **publication boundary 越境** の体験。

> [!IMPORTANT]
> **Pro plan の方へ** — Cloud Agent (= Copilot coding agent) は **Pro+ / Business / Enterprise plan** で使えます。Copilot Pro 単体プランの方は本 sub-step を実機実行できないため、**screenshot + 文字証跡で代替** してください:
> - 動作証跡 1: [E4 RESULT §3-§5](../../docs/planning/poc/E4-cloud-skill/RESULT.md) (Cloud Agent が SKILL.md を発見・利用、PR を作成、firewall default deny)
> - 動作証跡 2: E7' verification — playground PR ([shinyay/ghcp-6-layer-agentic-platform-phase3-dry-run#8](https://github.com/shinyay/ghcp-6-layer-agentic-platform-phase3-dry-run/pull/8)) — Issue Assignees → Copilot で起動して `copilot/...` branch + draft PR が生成された実機証跡
> - Pro plan 学習者の **完走パス (degraded complete)** = §3.A + §3.B + §3.D + §3.E の 4 sub-step を完走 (§3.C は読み物として消化)。**Step 4 §3.X で初めて Cloud Agent を実機体験** することになります (Step 4 README §2 で再掲予定)。

#### Step 1: Issue を作成する

playground repo に Issue を作成します。**Issue body はテンプレ通りに書く** ことが極めて重要です (= F21 / Cloud Agent の default mode 対策):

> [!IMPORTANT]
> **必須テンプレ (コピペ可能)**:
> ```
> Use the issue-triage skill to triage this issue.
>
> The pagination on the search results page does not advance past page 2;
> clicking "Next" reloads page 2.
> ```
>
> **冒頭の 1 行 = `Use the issue-triage skill to triage this issue.`** が決定的に重要です (slash 無し / `triage` 動詞 / `skill` 名詞)。これが無いと、Cloud Agent は **default で code-fix mode** に解釈し、triage skill ではなく「コードを直そう」と動き始めてしまいます。

**Good vs Bad Issue body 対比**:

| | body 例 | Cloud Agent の解釈 |
|---|---|---|
| ✅ Good | `Use the issue-triage skill to triage this issue.\n\n<状況描写 2-3 行>` | **triage mode** = SKILL.md の Workflow に従って category 判定 / label 付与 / コメント投稿 |
| ❌ Bad | `Fix the pagination bug` (単独) | **code-fix mode** = ソースコードを直接修正しようとする (= 本来 Step 3 の体験ではない) |

#### Step 2: Issue Assignees に Copilot を追加する (= 正規トリガ)

Issue 画面の **右サイドバー → Assignees** をクリックして、検索窓に `Copilot` と入力して候補を選択します。

> [!IMPORTANT]
> **これが Cloud Agent の正規トリガです**。Issue body の中に `@copilot` と書いても、それは本文中の文字列にすぎず Cloud Agent は起動しません。**Assignees への追加こそが起動 signal** です。
>
> CLI 経由 (`gh issue edit <num> --add-assignee Copilot`) は環境によっては `Bot does not have access to the repository` で失敗するため、**Web UI 経由を main path** とします (CLI 経路は §5 Troubleshooting で TIP 扱い)。

#### Step 3: Cloud Agent の起動 + branch + draft PR を観察する

Assign してから **数十秒〜数分** 待ちます。すると以下が自動生成されます:

1. `copilot/<auto-named>` branch (例: `copilot/fix-search-results-pagination`)
2. その branch から default branch への **draft PR**

PR 画面に "Copilot" の eye 👁️ アイコン + Initial plan commit が現れたら、**publication boundary を越境した瞬間** です。

> [!NOTE]
> **「branch + draft PR が生成された時点で §3.C は完了 (= Cloud crossed minimum)」** とします。これは GitHub Actions minutes の quota が切れていても (Initial plan commit 直後に finished_failure になっても) 達成可能です。実際 E7' verification の PR #8 がその実機証跡です。

#### Step 4 (任意 — Pro+ で quota 余裕がある人向け): full triage を観察する

quota が十分にある場合、Cloud Agent は SKILL.md の Workflow に従って次を実行します (= **Cloud triage observed (full)**):

- (d) PR title が triage 内容を反映 (例: `[issue-triage] Search pagination bug — labeled as bug`)
- (e) PR body に **`Initial plan` セクション** + **`Tasks` checklist** + 進行状況の更新
- (f) PR body に **`Used skill: issue-triage`** のような skill 参照
- (g) **firewall default deny** = Cloud Agent が外部 API (例: `npm registry`) を呼ぼうとした際にブロックされ、**workflow ファイル (`.github/workflows/copilot-setup-steps.yml`) を PR で提案** する Trust thread (詳細は [E4 RESULT §4-§5](../../docs/planning/poc/E4-cloud-skill/RESULT.md))
- (h) commit が **Verified Signed Commits** として届く (= 署名検証済、E4 §7)

これらは「Cloud Agent も人間の review boundary に従う」という Zero-trust 設計の実例です (= Trust thread 縦糸を Step 6a へ繋ぐ伏線)。

### 3.D Multi-engine teaser — `suggestedActors` で世界観を覗く

> **目的**: Cloud Agent invoke の枠組みは **Copilot だけのものではない** (= 同じ "Issue に bot を assign" の API で、他の engine も assign できる枠組み) ことを確認する。**実 invoke はしない**。

Codespaces ターミナルで:

```bash
gh api graphql -f query='
{
  repository(owner: "<your-owner>", name: "<your-repo>") {
    suggestedActors(capabilities: [CAN_BE_ASSIGNED], first: 20) {
      nodes {
        login
        ... on Bot { id }
        ... on User { id }
      }
    }
  }
}'
```

期待される出力例:

```
{ "login": "Copilot", ... }
{ "login": "anthropic-code-agent", ... }   ← bonus
{ "login": "openai-code-agent", ... }      ← bonus
... (人間ユーザーも含まれる)
```

> [!NOTE]
> **観察の不変条件は "Copilot が出ること" だけ** です。`anthropic-code-agent` (Claude Code) や `openai-code-agent` (Codex) は plan / org / repo の rollout 状況に依存して **見えないこともある** (= bonus 扱い)。Copilot 以外の actor が 1 つも見えなくても §3.D は完了です。

> [!IMPORTANT]
> **§3.D での実 invoke は意図的にしません**。「同じ枠組みで複数 engine を head-to-head 比較する」体験は **Step 5 (Multi-engine)** の責務です。Step 3 は **actor discoverability** (= "そういう枠組みがある" の発見) に絞ります。

### 3.E 比較表 — 6 観点 × 3 surface

§3.A / §3.B / §3.C で観察した結果を **以下の表に書き写し** てください。これが Step 3 の **持ち帰り資料** です:

| # | 観点 | IDE Chat | Copilot CLI | Cloud Agent |
|---|---|---|---|---|
| ① | **実行場所** | あなたの IDE プロセス内 | あなたの shell プロセス内 | GitHub の Actions runner |
| ② | **publication 要件** | 不要 (uncommitted で動く) | 不要 (uncommitted で動く) | **必須** (default branch に push 済) |
| ③ | **観測トレース** | `スキル [...] (file:///...) の読み取り` (日本語) | `skill(issue-triage)` (英語、関数記法) | PR body の `Initial plan` + `Tasks` + (full なら `Used skill`) |
| ④ | **レイテンシ** | 即時 (~秒) | 即時 (~秒) | 数十秒〜数分 (Actions 起動コスト) |
| ⑤ | **読む state (= source of truth)** | workspace file (uncommitted も) | current branch state | **default branch の published state のみ** |
| ⑥ | **適用シーン** | 個人の試行錯誤、その場の質問 | スクリプト化、shell 連携 | チームへの自動化、Issue 起点の triage |

> [!IMPORTANT]
> **覚えておくべき 1 つの真実**: **「どの state を読むか」が surface ごとに違う**。Local 2 surface (Chat / CLI) は **workspace** を、Cloud Agent は **default branch の publication** を読みます。Step 2 で握った "**Authoring vs Publishing**" が、Step 3 では **3 surface の振る舞い差** として現れます。

---

## 4. 完了確認 (Done Checklist) — 3 段階

### 4.1 Local crossed (§3.A + §3.B 完了)

- [ ] §3.A で **新規 Chat session** を開き、`スキル [issue-triage](file:///...) の読み取り` トレースが **push 後も `file:///` のまま** であることを確認した
- [ ] §3.B で `gh copilot` interactive → `/skills list` に `issue-triage` が表示され、自動 invoke + 明示 invoke (`Use the /issue-triage skill ...`) の両方で動いた
- [ ] §3.B のトレース表記が `skill(issue-triage)` (英語、関数記法) で、§3.A の日本語表記と **異なる** ことを観察した
- [ ] §3.E の比較表 ③ 観測トレース欄に Chat / CLI 行を書き写した

### 4.2 Cloud crossed (minimum) (§3.C 前半 — Standard / Full プロファイル必須、Pro plan は screenshot 代替)

- [ ] playground repo の Issue body に **`Use the issue-triage skill to triage this issue.`** (slash 無し) を冒頭に書いて Issue を作成した
- [ ] Issue 右サイドバー Assignees → **Copilot** を追加した (= 正規トリガ、Web UI 経由)
- [ ] 数十秒〜数分後、`copilot/<auto-named>` branch が自動生成され、その branch から default branch への **draft PR** が現れた (= **publication boundary 越境を観察**)
- [ ] §3.E 比較表 ② publication 要件 = 「必須」に Cloud Agent 行を書き写した

### 4.3 Cloud triage observed (full) (任意 — quota 余裕がある Pro+ 学習者向け)

- [ ] PR body に **`Initial plan` + `Tasks` checklist** が現れた
- [ ] PR body に **`Used skill: issue-triage`** などの skill 参照が現れた
- [ ] firewall default deny → workflow file PR 提案の Trust thread を観察した (E4 §4 と同型)
- [ ] commit が **Verified Signed Commits** として届くことを確認した

### Step 3 complete (Standard / Full プロファイル) — Local crossed + **Cloud crossed (minimum)** + §3.D + §3.E まで完走で達成です。 🎉
### Step 3 degraded complete (Pro plan) — Local crossed + (§3.C を screenshot/文字証跡で代替) + §3.D + §3.E で達成扱い。Step 4 §3.X で初の Cloud Agent 実機体験になります。

> 「Step 3 完了状態」の **repo state** だけを再現したい場合は `step-3-complete` ブランチを使えます (escape hatch):
> ```bash
> git fetch origin step-3-complete
> git checkout step-3-complete
> ```
> ⚠ **重要**: このブランチは **本 workshop repo の documentation state のみ** を復元します (= Step 3 README を読み終わった repo state)。**Cloud Agent 観察 (Assignees → Copilot で起動した branch + draft PR の現物) は branch では再現できません** — 各学習者が自分の playground repo で実体験する必要があります。

---

## 5. 詰まったら (Troubleshooting)

| 症状 | 原因の可能性 | 対処 |
|---|---|---|
| §3.A で `スキル [issue-triage] の読み取り` が出ない | (a) **新規 Chat session** ではない (b) frontmatter YAML パース失敗 (c) Skill の description trigger が緩い | (a) 右側パネル "+" で新規 session を開く (b) Step 2 §5 の YAML 構文 4 落とし穴を再確認 (c) description 冒頭に「Use this skill when ...」を明示 |
| §3.B で `/skills list` に `issue-triage` が出ない | (a) repo の最新 main を CLI が掴んでいない (b) path typo | `/skills reload` → それでも出なければ `ls .github/skills/issue-triage/SKILL.md` で path 確認 (Step 2 §5 と同型) |
| Issue Assignees の picker に **Copilot が出ない** | (a) repo Settings → Copilot → Coding agent が disabled (b) plan が Pro 単体 | (a) repo Settings から有効化 (b) Pro plan は §3.C IMPORTANT 通り screenshot 代替で degraded complete |
| Issue を作って数分待っても `copilot/...` branch が出ない | (a) Assign が picker から完了していない (b) Actions が disabled (c) Actions minutes quota 切れ | (a) Issue 右サイドの Assignees に "Copilot" の avatar が出ているか確認 (b) repo Settings → Actions → 有効化 (c) Org / 個人の Actions 利用枠を Settings → Billing で確認 |
| `gh issue edit <num> --add-assignee Copilot` が `Bot does not have access to the repository` で fail | env-dependent な制限 (org policy / token scope) | **Web UI 経由で assign してください**。CLI 経由は環境依存で安定しない (= main path は Web UI) |
| Issue body に `@copilot` と書いただけで何も起きない | これは **本文中の文字列** であって、Cloud Agent への signal ではない | Issue **Assignees** (右サイドバー) に Copilot を追加する。本文の mention は無関係 |
| Cloud Agent が **triage** ではなく **コード修正** を始めた | Issue body が code-fix 風に解釈された (default mode = code-fix) | Issue body 冒頭を **`Use the issue-triage skill to triage this issue.`** (slash 無し / `triage` 動詞 / `skill` 名詞) に書き換えて再 assign。Good/Bad 対比を §3.C 参照 |
| Cloud Agent が `Initial plan` commit 後すぐ `copilot_work_finished_failure` で止まる | GitHub Actions minutes の quota 切れ | **Cloud crossed (minimum) は達成済** (branch + draft PR まで生成 = publication boundary 越境を観察済) として §3.C を完了扱いにして問題なし。full triage の観察は次回 quota 復帰時にどうぞ |
| Cloud Agent の Issue body テンプレで **slash 付き** `/issue-triage` を使ったら動かなかった | slash 構文は CLI (= `gh copilot` interactive) の文化であって、Cloud Agent の Issue body では未保証 | **slash 無し** の `Use the issue-triage skill to triage this issue.` を使う (= E7' で実証された invoke 文言) |
| §3.D の `suggestedActors` で `Copilot` 以外の bot が出ない | plan / org / repo の rollout 状況による | **Copilot 以外は bonus** = 出なくても §3.D は完了。Step 5 (Multi-engine) で改めて触れます |
| `gh api graphql` が `field 'suggestedActors' doesn't exist` で fail | GraphQL schema が新しくなったか、scope 不足 | `gh auth refresh -h github.com -s repo` で scope 追加。それでも fail なら GitHub Status を確認 |
| Cloud Agent を **self-hosted runner** で動かしたいが、毎回 GitHub-hosted runner に dispatch される (managed quota を消費する) | repo が `.github/workflows/copilot-setup-steps.yml` を持っていない、または job 名 / `runs-on` が不一致 | 同 path に **job 名 `copilot-setup-steps` (固定 magic name)** + `runs-on: [<your-runner-labels>]` の YAML を追加。これだけで Cloud Agent はその `runs-on` を採用する。検証: `gh api repos/.../actions/runs/<id>/jobs --jq '.jobs[].runner_name'` |
| Self-hosted runner で起動したが `agent firewall is enabled ... exit 1` で即 fail | Cloud Agent の **firewall ガード**が有効 (vanilla self-hosted では明示 OFF が必要) | repo Settings → Copilot → Coding agent → **"Enable firewall" を OFF**。これは security trade-off (allowlist 制限が外れる) の正規動作。詳細: <https://gh.io/cca-self-hosted-disable-firewall> |
| 2 回目以降の run で `fatal: refusing to merge unrelated histories` (`Previous HEAD position was ... Initial commit`) | self-hosted runner が **永続 (non-ephemeral)** モードで `_work` がジョブ間で共有されている (Copilot agent の追加 `git pull` が前回 state と衝突) | runner を **ephemeral mode** で再登録 (`./config.sh --ephemeral ...`)。コンテナホスト側 (ACI / k8s 等) の restart policy で 1 ジョブ完了 → exit → 自動再 register → fresh `_work` の循環にする。長期運用は **ARC (Actions Runner Controller)** がより堅実 |
| Self-hosted runner 上の Cloud Agent が `remote: Repository not found` (`fatal: repository '...' not found`) で fail | repo が **private** で、vanilla self-hosted runner に渡される `GITHUB_TOKEN` が `Contents: read` を持たないため checkout で 404 (GitHub の private repo 認証失敗の挙動) | (a) repo を **一時的に public** にして検証 (= 実際に動く実証はこれで取れる) (b) 本番運用は **ARC on AKS** に移行 (ARC は internal token issuance に対応していて private repo + Cloud Agent が完走できる) |

それでも解決しない場合は: [リポ Issue で報告](https://github.com/shinyay/ghcp-6-layer-agentic-platform/issues/new/choose) するか、Copilot Chat 自身に「Step 3 で X が起きた、原因は?」と聞いてみてください (このリポ自身が Agentic です)。

---

## 6. 次の Step

進む: **[Step 4 — Automate](../step-4-automate/)** (`gh aw` で Issue opened を gate にして、triage workflow を **自動起動** する = **イベント駆動 triage**)

### Step 4 への動機 — 手動起動から自動起動 (イベント駆動 triage) へ

Step 3 で見たのは:

- Cloud Agent invoke は **手動で Assignees → Copilot を追加** することで起動する。
- これは「**人間が起動を判断する**」という意味で安全だが、**毎回手動** はスケールしない。

Step 4 で見るのは:

- **`gh aw` (GitHub Agentic Workflows)** で「Issue opened」イベントを gate にして、**triage workflow を自動起動** する仕組みを書く (= **イベント駆動 triage**、Cloud Agent UI 経由ではなく **Actions runner 上の Copilot CLI engine** が `COPILOT_GITHUB_TOKEN` PAT 経由で server-side triage を実行する形式)。
- 自動化されても **エージェントへ書き込み権限を直接渡さない** という Trust thread は変わらない = Step 3 で見た Cloud Agent firewall default deny と同じ思想の **別表現** として、`gh aw` strict mode + `safe-outputs` がエージェントの書き込み経路を制御する (Step 3 §3.C で観察した Trust thread の継続)。

> [!NOTE]
> **Pro plan 学習者の方** へ — Step 3 §3.C を screenshot 代替 (degraded complete) で完走した方は、Step 4 §3.D が **初の Copilot CLI engine 由来 server-side triage 実機体験** の場になります。Step 4 README §2 でも再掲します。

一覧に戻る: [📚 シナリオ目次](../README.md)

---

## 7. 参考 (References)

- 内部設計根拠: [`docs/planning/00-master-plan.md`](../../docs/planning/00-master-plan.md) §4 (Phase 06) / §4.5 (Step 3 必須)
- 検証ログ (Cloud Agent + SKILL): [`docs/planning/poc/E4-cloud-skill/RESULT.md`](../../docs/planning/poc/E4-cloud-skill/RESULT.md) — §3 動作 / §4 firewall default deny / §5 workflow PR 提案 / §7 Verified Signed Commits
- 検証ログ (E7 walkthrough F1-F21 / E7' Cloud Agent verification): [`docs/planning/poc/E7-cli-skill/RESULT.md`](../../docs/planning/poc/E7-cli-skill/RESULT.md)
- 学習者前提 P9 (Cloud Agent): [`../prerequisites.md`](../prerequisites.md)
- バージョン pin: [`docs/planning/VERSIONS.md`](../../docs/planning/VERSIONS.md) §2.7 (SKILL.md spec) + §2.8 (Cloud Agent surface pin = 起動方法 / Plan / Actions minutes / default mode / firewall / suggestedActors)
- 公式: [GitHub Copilot docs — Coding agent](https://docs.github.com/copilot) / [GitHub Copilot CLI](https://docs.github.com/copilot/github-copilot-in-the-cli) / `suggestedActors` GraphQL ([API docs](https://docs.github.com/graphql))
