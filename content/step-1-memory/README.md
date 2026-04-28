# Step 1 — Memory (Copilot Memory に triage パターンを蓄積)

> **必須 Step (MUST、Standard / Full プロファイル)** ・ 対応 Layer: **Layer 1 (Memory)** ・ 体感 ~15 分

> **このステップで何が起きるか (3 行)**
> 1. Copilot Chat に「Issue Triage の判断基準」を会話で覚えさせる ( = **植え付け** )。
> 2. 覚えた中身を **`Chat: Show Memory Files`** で開いて、ローカルディスク上の **物理 Markdown ファイル** として目で確認する。
> 3. 別の Chat セッションで同じ判断を **再現** させ、最後に Memory を空にしてから「前提が無い時 Copilot がどう振る舞うか」までを体験する。

> [!IMPORTANT]
> **Trust thread (この旅の縦糸 — Step 1 編)** — Copilot Memory はあなたの **ローカルディスク** に **人間が読める Markdown ファイル** として書かれます。クラウドのブラックボックスではありません。Step 0 で握った「Agent に何を許可するか」の続きとして、ここでは「**Agent に何を覚えさせるか / 何を覚えさせないか**」をあなたが握ります。Step 6a (Required Review Gate) で「**人間が最後に判断する**」へ繋がります。

---

## 1. 学習目標 (Learning Objectives)

このステップを終えると、あなたは:

- ✅ Copilot Chat に「リポ慣習」と「個人嗜好」を会話で覚えさせ、それぞれが **異なるスコープ** (Repo / Global) のファイルに **自動振り分け** されることを目で確認している
- ✅ 保存先の **物理 Markdown ファイル** を `Chat: Show Memory Files` で開き、中身が読めることを実感している (= 「ブラックボックスではない」)
- ✅ 新規 Chat セッションで `Read memory [path]` トレースが出ることを確認し、「Memory が確かに使われた」を 2 重 (UI 表示 + ファイル中身) で見ている
- ✅ Memory を空にしてから triage を頼むと、Copilot が **「これを覚えますか?」と提案を返してくる** UX を体験している (= F5 前提欠落 UX)
- ✅ Memory ファイルを **削除** してリセットする手順を理解している (プライバシー観点)

---

## 2. 前提 (Prerequisites)

- [Step 0](../step-0-setup/) を完了していること (= MCP 接続まで動いている、playground repo がある)
- Copilot Memory 機能が利用可能 (Pro / Pro+ / Business / Enterprise プラン) — 詳細は [`../prerequisites.md`](../prerequisites.md) **§ P7** (Memory が物理 Markdown ファイルとしてローカルに保存されることはここで既に明示済)
- VS Code Insider 版が **強く推奨** (このステップは Insider で検証済。Stable でも動作見込みだが物理ファイルパスが異なります — 詳細は §5)

> [!NOTE]
> Step 1 は **GitHub MCP server を呼びません** (Memory は Copilot Chat 拡張のクライアントローカル機能)。Step 0 で出てきた「ツール承認ダイアログ (Trust UI)」は Step 1 では出現しません。MCP 経由の操作は Step 2 (Skill) 以降と Step 4 / Step 6 で再登場します。

---

## 3. 手順 (Steps)

### 3.A 植え付け — Copilot に「リポ慣習」を覚えさせる

playground repo を Codespaces で開いた状態で **Copilot Chat** を開き、モードを **Agent** にして以下のプロンプトをそのまま貼って送ってください (一字一句コピー推奨):

```
このリポジトリでは、Issue タイトルに [bug] / [feat] / [docs] のいずれかの prefix を付ける慣例があります。今後この repo でラベル付け補助を求められたら、この慣例に従ってください。
```

期待挙動: Chat の応答冒頭に **クリック可能なリンク付きで** 次のような行が出ます。

```
Created memory file [/.../memories/repo/issue-conventions.md]
リポジトリメモリに保存しました（`/memories/repo/issue-conventions.md`）。
今後この repo でラベル付け補助を求められたら、Issue タイトルの [bug] / [feat] / [docs]
prefix に従ってラベルを判定します。prefix が無い場合は付与を提案します。
```

> [!TIP]
> 「保存しました」+ 「保存先パス (クリック可能リンク)」+ 「今後の挙動の宣言」 の **3 点セット** が出れば成功です。これが Step 1 の最初の小ピーク (= 「おっ、覚えた」) です。

---

### 3.B ファイル可視 — 物理 Markdown ファイルを目で見る

§3.A の応答に出たリンクを **クリック** して開いてもよいですが、教材的に重要なのは **「いつでも一覧できる」** ことです。コマンドパレット (`Cmd/Ctrl+Shift+P`) で次のコマンドを探してください:

```
Chat: Show Memory Files
```

実行すると、Copilot Chat が今あなたの環境に持っている全 Memory ファイルが一覧として開きます。§3.A で植え付けた `repo/issue-conventions.md` がその中にあるはずです。クリックして中身を見てみると、こんな普通の Markdown が見えます:

```markdown
# Issue title conventions (your-name/your-playground-repo)

- All issue titles must use one of these prefixes:
  - `[bug]` — bug reports
  - `[feat]` — feature requests
  - `[docs]` — documentation issues
- When asked to assist with labeling in this repo, infer the label from the title prefix and apply the matching label (`bug`, `feat`/`feature`, `docs`).
- If the title has no prefix, suggest adding one before labeling.
```

> [!IMPORTANT]
> **これが Step 1 の中ピーク (★Trust thread の核) です。** 「Copilot が何を覚えたか」は **クラウドに隠されたブラックボックスではなく、あなたのローカルディスクに人間が読める形で置かれている**。読める / 書き換えられる / 消せる、ということはあなたが Agent を **躾けている** のと同じです。

> [!NOTE]
> **直接パスを知りたい場合 (fallback)**: `Chat: Show Memory Files` がタイトルバーに出すパスをコピーするか、ターミナルで以下を実行すると見つかります:
> ```bash
> find ~/.vscode-server*/data -path '*memory-tool*' -name '*.md' 2>/dev/null
> ```
> 詳細パステンプレと Stable / Insider 差分は §5 を参照。

---

### 3.C 新規 Chat 再現 — `Read memory` トレースを確認する

Copilot Chat の **`+` (New Chat)** ボタンで **新規セッション** を必ず開いてください (同じ会話の中で続けると Memory ではなく直前の会話文脈が効いてしまうため切り分けが弱くなります)。新規 chat で以下を貼って送信:

```
新しい Issue のタイトルを提案してください: 「ログインボタンが押せない」
```

期待挙動: 応答の冒頭に **`Read memory [/.../repo/issue-conventions.md]`** トレース (クリック可能リンク) が出て、その下に prefix 付きの提案がいくつか並びます:

```
Read memory [/.../memories/repo/issue-conventions.md]

「ログインボタンが押せない」はバグ報告なので、`[bug]` プレフィックスを付けたタイトル案です:
- `[bug] ログインボタンが押せない`
- `[bug] ログインボタンをクリックしても反応しない`
- `[bug] ログイン画面でログインボタンが動作しない`
```

> [!TIP]
> **これが Step 1 の大ピーク (= 「本当に効いた!」) です。** §3.B で見たファイルが、別 chat で **ちゃんと参照され**、リンクも明示されている。Step 2 (Skill ⭐) で「これを repo 資産にして共有したい」と感じたら、Step 1 のゴールは達成です。

---

### 3.D スコープ違い — 「個人嗜好」は Global Memory に行く

同じ chat で続けて構いません (§3.C と違い、ここで観察したいのは「**書き込みが起きる瞬間** = `Created memory file [...]`」なので、新規 chat は不要)。今度は次を貼って送信:

```
コミットメッセージは Conventional Commits を使います。
```

期待挙動: 今度は応答冒頭に **`Created memory file [/.../preferences.md]`** が出ます (Repo memory ではなく **Global** スコープの `preferences.md`)。

`Chat: Show Memory Files` を再度開いて、`preferences.md` が **別のディレクトリ (Global)** に存在し、中身が次のような形になっていることを確認してください:

```markdown
# User preferences

- Commit messages: use Conventional Commits (e.g. `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`).
```

> [!NOTE]
> **Copilot がスコープを自動判別** しています。「**このリポでは** ...」のように **repo 文脈を含む発言** は Repo memory に、「コミットメッセージは ...」のような **個人/汎用嗜好** は Global memory (= **すべての repo で効く**) に振り分けられます。これは Memory が「ブラックボックスじゃない」という安心感の延長で、「**振り分けも賢い**」という発見です。

---

### 3.5 プライバシーと管理 (Privacy & Management)

> [!IMPORTANT]
> **Memory はあなたのローカルディスクに残り続けます。** 他人と画面共有したり、別の人にこの Codespace を渡す前に「何を覚えているか」を一度確認してください。

#### 確認

`Chat: Show Memory Files` で全 Memory ファイルが一覧されます。中身は普通の Markdown なので、エディタで開いてそのまま読めます。

#### 編集

Memory ファイルは **手で編集できます**。誤った前提を覚えさせてしまった場合は、エディタで該当行を直すだけで OK。次の Chat から反映されます (場合によっては VS Code を `Developer: Reload Window` で読み直しが必要)。

#### 削除 (リセット)

特定の記憶だけ消すには対象ファイルを 1 つ削除します。すべての記憶をリセットするにはディレクトリごと `rm -rf` でも構いません。

```bash
# 例: Repo memory の特定ファイルだけ削除
find ~/.vscode-server*/data -path '*memory-tool*/repo/issue-conventions.md' -delete

# 例: Global memory をすべて削除
find ~/.vscode-server*/data -path '*memory-tool/memories/preferences.md' -delete

# (もっと大胆に) 全 Memory を消したい場合
find ~/.vscode-server*/data -type d -name 'memory-tool' -exec rm -rf {} +
```

削除後、新しい Chat でもう一度同じ質問をすると、もう `Read memory` トレースは出ません (= 確実にリセットされた証拠)。

> [!TIP]
> Memory が物理ファイルである = **`git` には乗らない**、**他の Codespace に同期されない**、**他人には見えない** (※同一 Codespace を共有している場合を除く)。これがプライバシー的な強みです。

---

### 3.E F5 演習 — 「前提が空の時、Copilot は何をするか」

ここまでで Memory に 2 件 (Repo + Global) 入っている状態です。最後に「**Memory が空の状態**」で同じ triage を頼むとどうなるかを体験します。

#### (1) 演習用に Memory をリセット

§3.5 の削除コマンドで一旦すべての Memory を消してください:

```bash
find ~/.vscode-server*/data -type d -name 'memory-tool' -exec rm -rf {} +
```

VS Code を `Developer: Reload Window` で読み直し、`Chat: Show Memory Files` で **0 件** になっていることを確認してください。

#### (2) F5 演習本体 — 前提なしで triage を頼む

新規 Chat (Agent モード) で次を投げてみてください:

```
このリポジトリの open Issue を triage して、適切なラベルを付けてください。
```

期待挙動 (パターン A — 高頻度): Copilot は「**ラベリング規約をまだ知らないので、教えてください**」のような確認を返してくる、もしくは「以下のような規約で良いですか?」と **規約候補を選択肢で提示** してきます。

期待挙動 (パターン B): 個別 Issue を見て「`[bug]` っぽいので bug ラベルを付けたい」のように、その場の判断で進めようとします。

> [!TIP]
> **これが F5 (前提欠落 UX) の体験です。** 「Memory が空 = Agent が前提を持っていない」状態で、Agent は適当に進めず、**人間に確認** を入れてくる。これも Trust thread の一部です。Step 4 (gh aw) や Step 6a (Required Review Gate) で「Agent に何を握らせ、人間に何を残すか」の議論に直結します。

> [!NOTE]
> **もし提案が出ない場合 (個体差で Copilot が黙って進めるケース)**: 「**この内容を覚えてください: [bug] / [feat] / [docs] prefix で...**」と明示的に植え付けてください。F5 演習の核は「空 → 提案 or 確認 → 受け入れて Memory に書き込まれる」という感情線なので、明示植え付けでも代替できます。

#### (3) Restore — Step 2 に向けて Memory を再植え付け

F5 演習で Memory が空のまま終わると Step 2 ⭐ (Skill ⭐) を始める時に「Step 1 で何やったっけ」状態になります。Step 1 を完了する前に **§3.A の植え付け prompt をもう一度貼って** Memory に triage 規約を書き戻してください:

```
このリポジトリでは、Issue タイトルに [bug] / [feat] / [docs] のいずれかの prefix を付ける慣例があります。今後この repo でラベル付け補助を求められたら、この慣例に従ってください。
```

`Chat: Show Memory Files` で `repo/issue-conventions.md` が再生成されていることを確認したら Step 1 完了です。

---

## 4. 完了確認 (Done Checklist)

- [ ] `Chat: Show Memory Files` をコマンドパレットから実行できた
- [ ] §3.A で `Created memory file [...]` の応答を見て、ファイルを開いて中身を読んだ
- [ ] §3.C で **新規 Chat** に「タイトル提案して」と頼み、`Read memory [...]` トレースと `[bug]` prefix 付き提案を見た
- [ ] §3.D で「コミットメッセージは ...」と植え付けたら **Global** スコープの `preferences.md` に行ったことを確認した
- [ ] §3.5 の削除コマンドで Memory を空にできることを実機で確認した
- [ ] §3.E (F5 演習) で「空 Memory → Copilot が確認 or 提案を返す」を体験し、最後に Memory を再植え付けして Step 1 を終えた
- [ ] **`Chat: Show Memory Files` を最後に開いた時点で `repo/issue-conventions.md` が存在する** (= Step 2 の前提)

すべて ☑ なら、Step 1 は完了です。

> 「Step 1 完了状態」の **repo state** だけを再現したい場合は `step-1-complete` ブランチを使えます (escape hatch):
> ```bash
> git fetch origin step-1-complete
> git checkout step-1-complete
> ```
> ⚠ **重要**: Memory は **ローカルクライアント側** の状態なので branch には乗りません。escape hatch で飛んできた場合は §6 の "Memory bootstrap" を参照してください。

---

## 5. 詰まったら (Troubleshooting)

| 症状 | 原因の可能性 | 対処 |
|---|---|---|
| `Chat: Show Memory Files` がコマンドパレットに出ない | Copilot プラン未該当 (Free など) / Copilot Chat 拡張バージョン古 | [`../prerequisites.md`](../prerequisites.md) 「必須環境」でプランを確認、拡張を最新化 |
| §3.A で `Created memory file` が出ない (普通の応答だけ) | Copilot のモードが `Ask` になっている / 文章が「覚えて」と読めなかった | モードを **Agent** に切替、プロンプト末尾に「**この内容を覚えてください**」を明示追加 |
| §3.C で `Read memory` トレースが出ない | 同じ chat で続けてしまった / Memory 反映が cache でまだ効いていない | `+` で **新規 Chat** を確実に開く、それでも出ない場合は `Developer: Reload Window` |
| Memory ファイルが見つからない (`Chat: Show Memory Files` は OK だがパスを直接見たい) | VS Code Stable と Insider でパスが違う | 下の「直接パステンプレ」を参照 |
| Codespace を作り直したら Memory が消えた | Memory はローカルクライアント側の状態 (= R04-10) | 同一 Codespace + 同一クライアントを継続使用、別環境では §3.A を再実行 |
| F5 演習で Copilot が黙って triage を進めてしまう | 個体差 (R04-9) | §3.E (2) の「もし提案が出ない場合」のフォールバック誘導を実行 (= 明示「この内容を覚えて」) |
| 削除したのに古い前提がまだ効いている気がする | キャッシュが残っている | `Developer: Reload Window` を実行、もしくは VS Code を一度終了して再起動 |
| Stable で動かない / パスが違う | Stable は今回未検証 | 下の「Stable / Insider のパス差分」を参照 |

### 直接パステンプレ (fallback、`Chat: Show Memory Files` で十分なら不要)

| スコープ | Insider 経路 | Stable 経路 (見込み) |
|---|---|---|
| Global (User) | `~/.vscode-server-insiders/data/User/globalStorage/github.copilot-chat/memory-tool/memories/preferences.md` | `~/.vscode-server/data/User/globalStorage/github.copilot-chat/memory-tool/memories/preferences.md` |
| Repo (Workspace) | `~/.vscode-server-insiders/data/User/workspaceStorage/<workspace-id>/GitHub.copilot-chat/memory-tool/memories/repo/<auto-named>.md` | `~/.vscode-server/data/User/workspaceStorage/<workspace-id>/GitHub.copilot-chat/memory-tool/memories/repo/<auto-named>.md` |

`<workspace-id>` は環境ごとに異なります。`find ~/.vscode-server*/data -path '*memory-tool*' -name '*.md' 2>/dev/null` で実値を発見できます。

> [!NOTE]
> Memory 仕様は Public Preview 段階のため、changelog で挙動が変わる可能性があります。`Chat: Show Memory Files` が動かなくなったら [GitHub Copilot changelog](https://github.blog/changelog/?label=copilot) で `memory` 関連の更新を確認してください。

それでも解決しない場合は: [リポ Issue で報告](https://github.com/shinyay/ghcp-6-layer-agentic-platform/issues/new/choose) するか、Copilot Chat 自身に「Step 1 で X が起きた、原因は?」と聞いてみてください (このリポ自身が Agentic です)。

---

## 6. 次の Step

進む: **[Step 2 — Skill ⭐](../step-2-skill/)** (Memory に蓄えた triage 規約を `SKILL.md` に格上げして commit、= keynote CTA)

### Memory vs Skill — Step 2 への動機

Step 1 で植え付けた規約と、Step 2 で書く `SKILL.md` の本質的違い:

| 観点 | Memory (Step 1) | Skill (Step 2) ⭐ |
|---|---|---|
| **保管場所** | あなたのローカルディスク | repo 内 (`.github/skills/<name>/SKILL.md`) |
| **共有範囲** | 個人 (あなたの Codespace のみ) | repo の **全コラボレーター** |
| **永続性** | 揮発 (Codespace 削除や `rm` で消える) | git の commit/branch/tag で **versioned** |
| **適用範囲** | Copilot Chat のみ | Copilot Chat / `gh aw` / Cloud Agent / CLI **全サーフェス** |
| **レビュー** | (個人で完結) | PR で **人間がレビューできる** |

Step 1 の Memory は「**個人で素早く試す**」のに最強です。Step 2 はそれを「**チームの資産に格上げする**」フェーズです。

### Memory bootstrap (escape hatch で飛んできた場合)

`step-1-complete` ブランチで飛んできた / Codespace を作り直した場合、Memory は **空の状態** から始まります (Memory はローカル状態なので branch には乗らないため)。Step 2 を始める前に §3.A の植え付け prompt を 1 回貼って Memory を再現してください。それで Step 1 完了状態と等価になります。

一覧に戻る: [📚 シナリオ目次](../README.md)

---

## 7. 参考 (References)

- 内部設計根拠: [`docs/planning/00-master-plan.md`](../../docs/planning/00-master-plan.md) §4 (Phase 04) / §4.5 (Step 1 必須・Lite 離脱可能)
- 検証ログ (Memory 物理ファイル発見): [`docs/planning/poc/E6-memory/RESULT.md`](../../docs/planning/poc/E6-memory/RESULT.md)
- 学習者前提 P7 (Memory はローカル物理ファイル): [`../prerequisites.md`](../prerequisites.md)
- バージョン pin: [`docs/planning/VERSIONS.md`](../../docs/planning/VERSIONS.md) §2.6 (Memory tool / パス スナップショット)
- 公式: [Copilot Memory changelog (2026-03)](https://github.blog/changelog/2026-03-04-copilot-memory-now-on-by-default-for-pro-and-pro-users-in-public-preview/) / [GitHub Copilot docs](https://docs.github.com/copilot)
