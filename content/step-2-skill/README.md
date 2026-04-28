# Step 2 — Skill ⭐ (`SKILL.md` を書いて publish) — keynote CTA

> **必須 Step (MUST = keynote CTA)** ・ 対応 Layer: **Layer 2 (Customizations)** ・ 体感 ~20 分

> **このステップで何が起きるか (3 行)**
> 1. `.github/skills/issue-triage/SKILL.md` を **YAML frontmatter (`name` + `description`、folded scalar `>-` 形式) + 本文 (When to use / Workflow)** だけの最小構成で書く。
> 2. **書いた瞬間 (= まだ commit していない状態)** から Copilot Chat (IDE) と Copilot CLI が **同じ workspace ファイル** を即座に読んで invoke する (= Local invariance) を体感する。
> 3. `git add / commit / push` で **publish** する。これは Local 体感を変えるためではなく、**Cloud Agent / 他の人 / GitHub Actions に伝播 (propagation) させる** ための publication step。Cloud surface 越境の体験は Step 3 に譲る。

> [!IMPORTANT]
> **Trust thread (この旅の縦糸 — Step 2 編)** — Step 1 の Memory は「あなたのローカルディスク」に書かれましたが、Step 2 の Skill は **repo にチェックインでき、PR で人間がレビューできる** ものになります。Step 0 で「Agent に何を許可するか」、Step 1 で「Agent に何を覚えさせるか」を握ったのと同じ流れで、Step 2 では「**Agent にどう振る舞わせるかを、文書化してチームでレビューできる形に publish する**」を握ります。これは Step 6a (Required Review Gate) の「**人間が最後に判断する**」へ直結します。

---

## 1. 学習目標 (Learning Objectives)

このステップを終えると、以下を **自分の言葉で説明** できるようになります:

- **Skill とは何か**: `.github/skills/<name>/SKILL.md` の Markdown ファイル 1 枚。`name` と `description` を frontmatter に書くだけで、Copilot が **`description` の文面を trigger** にして自動 invoke する。
- **Authoring と Publishing の違い**:
  - **Authoring** = ファイルを書いて保存する。これだけで **VS Code Chat と `gh copilot` CLI は uncommitted の workspace ファイルを即座に認識して invoke** します (= Local invariance)。
  - **Publishing** = `git commit + push`。これは **Cloud Agent / 他の人の Codespaces / GitHub Actions に skill を伝播 (propagation) させる** ための publication step です。Local の体感を変えるためのものではありません。
- **Skill = surface 非依存資産**: 同じ `SKILL.md` を Copilot Chat (IDE) と Copilot CLI の **両方から** invoke できる。Step 3 で 3 surface (CLI / Cloud / IDE) に拡張する伏線。
- **Memory との違い**: Memory は個人 / 揮発 / クライアント側 / Chat 限定だったのに対し、Skill は **共有 (publish 後) / 永続 / repo 側 / 全 surface 対応**。詳細対比表は §6 を参照。
- **`description` = trigger**: Copilot は description を読んで「今この prompt にこの skill を当てるべきか?」を自分で判断する。これが「Skill を 1 度書けば、毎回明示しなくても自動 invoke される」の正体。

> [!NOTE]
> **重要な気づき (E7 検証で判明)**: 「Skill ファイルを書いた = ローカルで効く」「commit した = Cloud / 他人にも届く」の **2 段階** で考えてください。一般に誤解されがちな「commit しないと Copilot に見えない」は **誤り** です。Local Chat / CLI は workspace ファイルを直接読みます。git history は **publication boundary** であって activation boundary ではありません。

---

## 2. 前提 (Prerequisites)

- [Step 1](../step-1-memory/) を完了していること、または `step-1-complete` ブランチで飛んできていること。
- [`prerequisites.md`](../prerequisites.md) §環境チェックを完走していること。特に **P8 (Skill = `.github/skills/<name>/SKILL.md`)** の 1 行解説に目を通しておくと §3 がスムーズ。
- Codespaces で `git` と **`gh copilot`** (Copilot CLI extension、**v1.0.36 で動作確認済**) が動くこと。`gh copilot --version` で確認してください。Codespaces で auto pre-install されない場合は `gh extension install github/gh-copilot` で導入します。

> [!NOTE]
> Step 2 は **GitHub MCP server を呼びません** (Skill ファイルは `git` で直接 commit します)。Step 0 の MCP 経由ツール承認ダイアログは Step 2 では出現しません (= Step 4 / Step 6 で再登場)。Trust thread の体験は Step 2 では「**`SKILL.md` を repo に publish して、PR で同僚がレビューできる形に固定する**」という形で観測します。

> [!NOTE]
> **Memory bootstrap (escape hatch で飛んできた場合)** — `step-1-complete` ブランチで飛んできた / Codespace を作り直した場合、Memory は **空** から始まります (Memory はクライアントローカル状態で branch には乗らないため)。Step 2 は **Memory に依存しない** ので Memory が空でも問題なく完走できます。Memory も再現したい場合は [Step 1 §3.A](../step-1-memory/#3a-植え付け--copilot-にリポ慣習を覚えさせる) の植え付け prompt を 1 回貼ってください。

---

## 3. 手順 (Steps)

5 つの sub-step (A → B → C → D → E) で進めます。**§3.C で `Local 即効` を体感**し、**§3.D で publish** します。「commit してから初めて効く」ではなく「**書いた瞬間からローカルで効く / commit はチームへ届けるための publication**」が Step 2 のコアメッセージです。

### 3.A 雛形作成 — `.github/skills/issue-triage/` を作る

Codespaces のターミナルで以下を実行します:

```bash
mkdir -p .github/skills/issue-triage
touch .github/skills/issue-triage/SKILL.md
code .github/skills/issue-triage/SKILL.md   # VS Code でファイルを開く
```

> [!TIP]
> ディレクトリ名 `.github/skills/` (複数形) と `issue-triage` (`<noun>-<verb>` の順) はこの教材の慣例です。public な慣例も同様で、Copilot CLI の `/skills list` (後述 §3.E) はこのパスを認識します。typo (`.github/skill/` 単数形など) すると `/skills list` に出てきません。

### 3.B frontmatter — `name` と `description` を書く (folded scalar `>-` 必須)

`SKILL.md` の冒頭に以下を貼ってください。**必須は `name` と `description` の 2 フィールドだけ** ですが、`description` は **YAML folded scalar (`>-`) で複数行** にしてください (理由は下のボックス):

```yaml
---
name: issue-triage
description: >-
  Use this skill when a new GitHub issue is opened that needs triage.
  Reads the issue body, picks the best category label from the repository's
  existing label set (typically bug, enhancement, question, documentation),
  writes a short greeting comment that confirms the category, and notes any
  missing repro information. If none of the expected labels exist on the
  repository, pick the closest available label and explain the substitution
  in the comment. Do not trigger for issues that already have a category label.
---
```

> [!IMPORTANT]
> **YAML 構文の 4 つの落とし穴 (E7 で全部踏みました)** — どれを外しても `gh copilot` の `/skills list` から消えます。
> 1. **`---` は列 0 (行頭) に置く**: 行頭スペースが入るとパースされません。VS Code で `Ctrl-Shift-P` → "Format Document" で揃えるのが安全。
> 2. **`description: >-` を使う**: `>-` は YAML "folded scalar with strip chomping" — **複数行を半角 space で連結して 1 つの文字列として渡す** という意味。`description:` の **直下** から **2-space indent** で本文を書きます。
> 3. **行末に物理改行 (CR/LF) を持ち込まない**: 別の場所からコピペすると改行コードが混ざることがあります。`cat -A SKILL.md` で `^M` が見えたら NG (`dos2unix` で除去)。
> 4. **`description:` の後に直接長文を書かない**: `description: 'Use this skill ...'` 形式 (1 行 quoted) も可ですが、長文だと 100 字を超えてエディタが折り返し → コピー時に物理改行が入ってパース失敗、というのが E7 で頻発した。**`>-` + 複数行で書く方が圧倒的に安全**です。

> [!NOTE]
> **canonical template が repo にあります**: 上の YAML をそのまま手で書き写す代わりに、`docs/planning/poc/E7-cli-skill/templates/SKILL.md` を **`gh api` でダウンロード** することもできます (private repo で `raw.githubusercontent.com` が 404 になる対策、§5 troubleshooting 参照)。
> ```bash
> gh api repos/shinyay/ghcp-6-layer-agentic-platform/contents/docs/planning/poc/E7-cli-skill/templates/SKILL.md \
>   -H "Accept: application/vnd.github.raw" \
>   > .github/skills/issue-triage/SKILL.md
> ```

> [!NOTE]
> **命名のメモ**: 検証段階の参考実装 ([E2 RESULT §5](../../docs/planning/poc/E2-skill/RESULT.md#5-参考にする最小-skillmd-step-2-で学習者が完成させる目標形)) では `name: triage-issue` と書かれていますが、本教材では **`issue-triage`** (`<noun>-<verb>` = 対象オブジェクト先行) で統一しています。同じ Skill を別名で呼ぶこともできますが、`/skills list` で表示される名前は `name:` の値です。

> [!TIP]
> **description が trigger です** (= 学習者が一番驚くポイント)。Copilot は description を読んで「今この prompt にこの skill を当てるべきか?」を自分で判断します。「Use this skill when ...」のように **明示的な発火条件文** を書くのが鉄則。あとから自分の repo の triage 規約に合わせて 1 文だけカスタマイズしてみてください (例: 「Do not trigger for issues with `wontfix` label」を末尾に足す)。

> [!NOTE]
> `license` / `metadata.version` / `compatibility` / `user-invocable` といった任意 frontmatter は **Step 6 (Gate) で再登場** します。今は `name` + `description` の 2 つだけに集中してください ([VERSIONS.md §2.7](../../docs/planning/VERSIONS.md) で全フィールド一覧)。

### 3.C 本文 — `## When to use` と `## Workflow` を書く + ★ Local 即効体感

frontmatter の **下に** 以下の 2 セクションを追記してください:

```markdown
# Triage Issue

## When to use
- 新規 issue で category label (`bug` / `enhancement` / `question` / `documentation`) が未付与のとき
- 過去に triage 済みの issue は対象外

## Workflow
1. Issue body を読む
2. 内容から最適な 1 つの category label を選ぶ (repo に存在するもののみ)
3. ラベルを付ける (もし期待ラベルが repo に無い場合は最も近い既存ラベルを採用し、コメントで substitution を説明)
4. 確認のための短いコメントを残す (テンプレ: "Categorized as <label>. <missing info があれば箇条書き>")
```

> [!NOTE]
> **なぜ `bug` / `enhancement` / `question` / `documentation` の 4 つか?** これらは GitHub が新規 repo に **デフォルトで作成する label セット** です。多くの playground repo に存在するので、教材として deterministic に動きます。あなた自身の repo に合わせるときは、実際に存在する label に書き換えてください。

ここまで書けたら **保存** してください。**ただしまだ commit しません**。

#### ★ Local 即効体感 (= authoring だけで Local Chat が即読む)

ここで一度、Copilot Chat (IDE 内) で **新規 Chat** (`+` ボタン) を開いて、自分の **playground repo** (= Step 0 / Step 1 で使った issue 練習用 repo) を VS Code で開いた状態で以下を聞いてみてください:

> このリポジトリの open issue を 1 件 triage して。

応答冒頭付近に **`スキル [issue-triage](file:///...) の読み取り`** のようなクリック可能なトレースが出るはずです (VS Code Chat の場合、日本語表記。CLI の場合は `skill(issue-triage)` のような英語表記)。**まだ commit していないのに Skill が認識・invoke されている** = これが **Local invariance** です。

> [!IMPORTANT]
> **これが Step 2 の最初の Aha! ポイントです。**
> - 「Skill ファイルを書いた = まだ何も起きていない」と思い込みがち
> - しかし VS Code Chat / `gh copilot` CLI は **workspace ファイルを直接読む** ので、`---` を 1 行書いた瞬間から認識される
> - つまり **個人の試行錯誤に commit/push は不要** = ペアプロ感覚で `description` を何度も書き直して、即座に Copilot 応答の差分を観察できる
> - これが「**git history は activation boundary ではない**」の意味

> [!NOTE]
> **ラベル選択の挙動 (F18 sidebar)**: もしあなたの playground repo に `bug` / `enhancement` / `question` / `documentation` のうち **存在しない label** があった場合、agent はエラーを出さず **最も近い既存 label に "adapt"** してコメントで理由を述べます (例: `feature` 不在 → `enhancement` を選択)。E7 でこの挙動を実機で観察済みです。`description` の "If none of the expected labels exist on the repository, pick the closest available label and explain the substitution" の部分が効いています。

#### git で publish する (= Cloud / 他人へ伝播させる publication step)

Local 動作が確認できたら、次は **publish** します。これは Local 体感を変えるためではなく、**Cloud Agent / 他の人の Codespaces / GitHub Actions** に skill を届けるためのステップです:

```bash
git add .github/skills/issue-triage/SKILL.md
git commit -m "feat(skill): add issue-triage skill"
git push origin main
```

> [!TIP]
> push 先は **default branch (= 通常 `main`)** にしてください。feature branch では Cloud Agent / 他人の Codespaces から拾われません (= R05-2 の典型原因)。

> [!IMPORTANT]
> **publish しても Local の挙動は変わりません**: §3.C で `Read skill` トレースが既に出ていたとおり、Local Chat は依然 `file:///` 経由で workspace ファイルを読みます。「commit したから初めて効いた」ような変化は **Local では起きません**。**publish の本当の効果は Step 3 で Cloud Agent を assign したときに見えます** (= "publication boundary を越境")。

### 3.D 同じ Chat で再確認 (= Local invariant の確認)

`+` で **新規 Chat** を開いて、§3.C で試したのと **同じ prompt** を聞いてください:

> このリポジトリの open issue を 1 件 triage して。

応答は §3.C で見たのと **ほぼ同じ** はずです — `スキル [issue-triage] の読み取り` トレースが出て、issue に対応する label を付け、コメントを残します。

> [!IMPORTANT]
> **これが Step 2 の二つ目の Aha!: Local invariant** です。
> - commit 前 (§3.C) と commit 後 (§3.D) で **Local Chat の挙動は変わらない**
> - = git history は **Local の activation boundary ではない**
> - publish の効果は **Cloud surface (= Step 3 の Cloud Agent demo) で初めて可視化される**

> [!NOTE]
> もし `スキル [...] の読み取り` トレースが出ない場合は §5 のフォールバックを参照してください。個体差で Copilot が黙って Skill を使うケースもあります。その場合は明示的に「**`issue-triage` skill を使って triage して**」と書くと確実に invoke されます。

### 3.E CLI invoke (= 第 2 surface で同じ Skill を呼ぶ)

今度は **Copilot CLI** から同じ Skill を呼んでみます。Codespaces ターミナルで:

```bash
gh copilot
```

> [!TIP]
> `gh copilot` は対話 TUI を起動します。**`tee` などのパイプを噛ませると TUI が起動しません** (TTY 検出失敗のため)。ログを取りたい場合は `script -q -c "gh copilot" /tmp/copilot.log` で PTY を確保してください (ANSI 除去は §5 troubleshooting 参照)。

interactive モードに入ったら、まず Skill が認識されているか確認します:

```
/skills list
```

`issue-triage` が一覧に出てくれば OK です (出ない場合は `/skills reload` で repo を再スキャン)。詳細を見たいときは:

```
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

CLI 側でも description で書いた triage 規約通りの応答が返ってきます。トレースは `skill(issue-triage)` のような英語表記です (Chat の日本語と表記が違う = surface ごとの個体差)。

> [!TIP]
> **Step 2 の山頂はここです。** Chat (IDE) と CLI で **同じ `SKILL.md` が同じ trigger で同じ振る舞い** をする。これが「**Skill = surface 非依存の再利用資産**」の意味です。Step 3 ではこれをさらに **Cloud Agent (= 第 3 surface)** に展開し、「Cloud は publish しないと届かない」という publication boundary を体験します。

> [!NOTE]
> `gh copilot` を初めて起動したときは VS Code セッションの GitHub 認証を継承します。ブラウザで認証ダイアログが出たら許可してください (= Step 0 で扱った Trust 階層 Layer 1 と同じ仕組み)。

---

## 4. 完了確認 (Done Checklist) — 2 段階

### 4.1 Local done (authoring まで完了 — Step 2 のコア体感)

- [ ] `.github/skills/issue-triage/SKILL.md` を **frontmatter (folded scalar `>-`) + 本文** で記述した
- [ ] §3.C で **uncommitted のまま** VS Code Chat の新規 Chat に "issue を triage して" と聞いて `スキル [issue-triage](file:///...) の読み取り` トレースが出た (= Local Chat は file:// で読んでいる)
- [ ] §3.E で `gh copilot` interactive → `/skills list` に `issue-triage` が表示され、`/issue-triage` skill 経由で triage が動いた
- [ ] (任意) §3.D で commit 後にも Local Chat の挙動が **変わっていない** ことを確認した (= Local invariant)

### 4.2 Published done (publication まで完了 — Step 3 の前提を整える)

- [ ] `git commit + push origin main` で **default branch** に publish 済 (リポ Web UI で `.github/skills/issue-triage/SKILL.md` が見える)
- [ ] **(Step 3 の前提)** 自分の **playground repo の default branch** にも `.github/skills/issue-triage/SKILL.md` を push 済 (workshop repo のこの branch だけでは Step 3 の Cloud Agent invoke が effective に動かないため)

### Local done すべて ☑ なら、**keynote CTA の Aha! は達成** です。 🎉
### Published done も ☑ なら、Step 3 (Cloud Agent propagation) の準備完了です。

> 「Step 2 完了状態」の **repo state** だけを再現したい場合は `step-2-complete` ブランチを使えます (escape hatch):
> ```bash
> git fetch origin step-2-complete
> git checkout step-2-complete
> ```
> ⚠ **重要**: このブランチは **本 workshop repo の Local done state** を復元します。Step 3 で Cloud Agent から triage を invoke するには、**学習者の playground repo の default branch にも同じ `.github/skills/issue-triage/SKILL.md` が push されている必要** があります (= Published done) (R05-7 / Step 3 §2 で再掲予定)。

---

## 5. 詰まったら (Troubleshooting)

| 症状 | 原因の可能性 | 対処 |
|---|---|---|
| §3.C で `スキル [issue-triage] の読み取り` が出ない | (a) frontmatter YAML がパース失敗 (b) description の trigger 文が緩い (c) Copilot プラン未該当 | (a) `cat -A SKILL.md` で `^M` 改行 / 行頭スペース確認 → 修正 (b) 「Use this skill when ...」を冒頭に明示 (c) [`prerequisites.md`](../prerequisites.md) でプラン確認 |
| YAML パース失敗 (skill が認識されない) | **列 0 違反** / **2-space indent 違反** / **`>-` 不使用で 1 行に長文** / **物理改行 (CR/LF) 混入** | §3.B IMPORTANT ボックスの 4 落とし穴をチェック。`cat -A SKILL.md` で末尾 `$` のみ (`^M$` は NG)、`---` が必ず列 0、`description: >-` の直下 2-space indent。困ったら canonical template を `gh api` で取得 (§3.B NOTE) |
| `gh api` で template 取得時 **404** | private repo で `raw.githubusercontent.com` は anonymous 404 になる | `gh api repos/<owner>/<repo>/contents/<path> -H "Accept: application/vnd.github.raw"` の認証込み API を使う (`raw.githubusercontent.com` はやめる) |
| §3.E で `/skills list` に `issue-triage` が出ない | (a) repo の最新 main を CLI が掴んでいない (b) path が typo (`.github/skill/` など) | `/skills reload` で再スキャン → それでも出ない場合は `ls .github/skills/issue-triage/SKILL.md` でファイル存在 + path 綴り (`skills` が複数形) を確認 |
| `gh copilot` を起動しても **TUI が出ない / プロンプトが返らない** | `tee` などのパイプ経由で起動 → TTY 検出失敗 | `script -q -c "gh copilot" /tmp/copilot.log` で起動 (PTY 確保)。ログ後処理は `sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g; s/\x1b][^\x07]*\x07//g; s/\r//g' /tmp/copilot.log` で ANSI 除去 |
| `gh copilot: command not found` / version が `< v1.0.36` | Copilot CLI extension 未 install / 古い | `gh extension install github/gh-copilot` を実行、`gh copilot --version` で `v1.0.36+` を確認 |
| `/skills info issue-triage` で `not found` | Skill 名 (`name:` の値) と CLI で指定した名前が違う | `/skills list` で表示される正確な名前を確認、frontmatter の `name:` 行を再確認 |
| Chat / CLI で Skill は読まれているが triage の動きが期待通りでない | description の Workflow 記述が曖昧 | §3.B の description を「具体的な category label 名」「使う動詞 (label を付ける / コメントする)」を含む形に強化 |
| Chat / CLI が Skill を黙って使う (トレースが出ない) | UI 表示の個体差 (R04-9 と同型) | 明示的に「**`issue-triage` skill を使って triage して**」と書く、CLI なら `Use the /issue-triage skill ...` 形式を使う |
| commit/push したのに **Cloud Agent が反応しない** | (a) Issue body の `@copilot` mention だけでは Cloud Agent は起動しない (b) Issue Assignees に Copilot を追加していない (c) repo / org で Copilot cloud agent が無効 | (a)(b) Issue 右サイドバー Assignees → Copilot を選択。CLI なら `gh issue edit <num> --add-assignee Copilot` (※ 一部環境で fail、Web UI 推奨) (c) repo Settings → Copilot で coding agent / cloud agent を有効化。Plan 要件あり (Pro+/Business/Enterprise) — **詳細は Step 3 で再掲** |
| `git push origin main` が拒否される | branch protection で push 不可 (組織 repo の場合) | feature branch で push → PR を作って main にマージ。本教材は個人 playground 想定なので main 直 push を許容している前提 |

> [!NOTE]
> Skill 仕様は安定してきていますが、`description` の trigger 仕様や frontmatter の任意キーは将来変動する可能性があります (詳細は [VERSIONS.md §2.7](../../docs/planning/VERSIONS.md))。動作がおかしくなったら [GitHub Copilot changelog](https://github.blog/changelog/?label=copilot) で `skill` 関連の更新を確認してください。

それでも解決しない場合は: [リポ Issue で報告](https://github.com/shinyay/ghcp-6-layer-agentic-platform/issues/new/choose) するか、Copilot Chat 自身に「Step 2 で X が起きた、原因は?」と聞いてみてください (このリポ自身が Agentic です)。

---

## 6. 次の Step

進む: **[Step 3 — Where to Run](../step-3-surfaces/)** (publish した同じ Skill を 3 つの surface = CLI / Cloud Agent / IDE Chat から呼んで特性差 + **publication boundary** を体験)

### Step 3 への動機 — Local invariance vs Publication boundary

Step 2 で見たのは:

- **Local invariance**: VS Code Chat / `gh copilot` CLI は workspace ファイルを直接読む。commit/push の前後で Local の体感は変わらない。
- **Authoring が Local 動作に十分**: 個人の試行錯誤フェーズで `description` を何度も書き直し、即座に応答差を観察できる。

Step 3 で見るのは:

- **Publication boundary**: Cloud Agent (= Issue Assignees → Copilot で起動) / 他の人の Codespaces / GitHub Actions は **default branch の最新 commit に push された** SKILL.md を読む。
- **publication boundary を越境する瞬間**: push 前 = Cloud から見えない / push 後 = Cloud Agent が assign で起動して同じ skill を invoke する。これが「**publish の本当の効果**」です。

> [!IMPORTANT]
> **Step 3 を始める前の必須前提**: 自分の **playground repo の default branch** に Step 2 で書いた `.github/skills/issue-triage/SKILL.md` が push されていること。本 workshop repo の `step-2-complete` branch は **Local done state** を復元するだけで、Cloud Agent が triage する対象は学習者の playground repo です。`§4.2 Published done` のチェックリストを必ず完了してください。

### Skill vs Surface — reference 表

Step 2 で書いた `SKILL.md` と、Step 3 で扱う **surface** の本質的違い:

| 観点 | Skill (Step 2、本ステップで完了) | Surface (Step 3) |
|---|---|---|
| **何を表すか** | **何を** やるか の定義 (description = trigger / Workflow = 手順) | **どこで** 実行するか の選択肢 (IDE Chat / CLI / Cloud Agent) |
| **数** | repo に **複数** 置ける (1 skill = 1 file) | プラットフォームが提供する **固定セット** (= 3 surface) |
| **可搬性** | **surface 非依存** (Step 2 で Chat + CLI 2 surface で実証) | surface ごとに UX / 実行環境 / **publication 要件** が異なる |
| **編集者** | あなた (repo collaborator) | プラットフォーム提供 (= GitHub) |
| **Authoring vs Publishing** | authoring (file 書き) で Local Chat / CLI には即届く / publishing (commit/push) で Cloud / 他人に届く | surface ごとに publication 要件が違う (Local Chat = authoring で十分 / Cloud = publish + assign 必須) |

### keynote 視聴者向けメモ — ここで離脱しても OK

ここまで来たら **keynote CTA は達成済み** です。残り時間で:
- **Step 3 を覗く** = surface 差 + publication boundary を体験 (~10 min 追加)
- **自分の repo に SKILL.md を書く** = 自分の triage 規約を反映 (~時間自由)

のどちらでも OK。Step 3 以降は「**同じ Skill を、どう自動化 / どこで走らせ / どうゲートをかけるか**」というプラットフォーム広がりの体験です。

一覧に戻る: [📚 シナリオ目次](../README.md)

---

## 7. 参考 (References)

- 内部設計根拠: [`docs/planning/00-master-plan.md`](../../docs/planning/00-master-plan.md) §4 (Phase 05) / §4.5 (Step 2 必須・⭐ keynote CTA)
- 検証ログ (SKILL.md 仕様確定): [`docs/planning/poc/E2-skill/RESULT.md`](../../docs/planning/poc/E2-skill/RESULT.md)
- 検証ログ (Copilot CLI / `/skills list/info/reload` 確証 + E7 実機完走 F1-F21): [`docs/planning/poc/E7-cli-skill/RESULT.md`](../../docs/planning/poc/E7-cli-skill/RESULT.md)
- canonical SKILL.md template (folded scalar 版): [`docs/planning/poc/E7-cli-skill/templates/SKILL.md`](../../docs/planning/poc/E7-cli-skill/templates/SKILL.md)
- 学習者前提 P8 (Skill = `.github/skills/<name>/SKILL.md`): [`../prerequisites.md`](../prerequisites.md)
- バージョン pin: [`docs/planning/VERSIONS.md`](../../docs/planning/VERSIONS.md) §2.7 (SKILL.md spec / path / YAML 構文 / surface 別トレース表記スナップショット)
- 公式: [GitHub Copilot docs — Skills](https://docs.github.com/copilot) / [`github/awesome-copilot`](https://github.com/github/awesome-copilot) `skills/` (参考実装の本家)
