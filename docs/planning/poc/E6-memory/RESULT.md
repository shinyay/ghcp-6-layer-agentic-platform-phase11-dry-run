# E6 Result — Copilot Memory 観測方法検証

**Status**: ✅ **PASS** (理想ケース達成 — Memory パネル/ファイル可視化 + Chat 反映 + スコープ自動判別)
**実施日**: 2026-04-25
**実施者**: ユーザー (shinyay) 手動実行
**throwaway repo**: https://github.com/shinyay/test-ghcp-workshop-validation
**環境**: VS Code Insider + GitHub Copilot Chat (Pro+)

---

## 1. 結果サマリ

| Phase 01 §3 E6 PASS 基準 | 結果 |
|---|---|
| 観測方法 A (Memory UI / パネル) | ✅ コマンドパレット → `Chat: Show Memory Files` で発見 |
| 観測方法 B (新規 Chat で振る舞い変化) | ✅ 新規セッションで `[bug]` prefix 付き提案を生成 |
| 観測方法 C (記憶を別 Issue でも適用) | ✅ "Read memory [file path]" トレースを Chat 上で表示 |
| Step 1 教材で "学習を実感させる" 手順が書ける | ✅ ファイル直接閲覧 + Chat トレースで二重に可視化 |
| Memory off / on 切替/削除 の手段 | ⚠️ 公式 UI 未確認だが、ファイル直接削除でリセット可能(後述) |

→ **理想ケース ✅** ─ Step 1 を「Memory に何が入ったか見せる」設計で書ける。

---

## 2. ★最重要発見 — Memory は **物理的な Markdown ファイル**

これは教材設計を大幅に強化する発見:

### 2.1 ストレージ構造(2 つのスコープ)

| スコープ | パス | 自動命名された例 | サイズ |
|---|---|---|---|
| **Global (User)** | `~/.vscode-server-insiders/data/User/globalStorage/github.copilot-chat/memory-tool/memories/` | `preferences.md` | 129 B |
| **Repo (Workspace)** | `~/.vscode-server-insiders/data/User/workspaceStorage/<workspace-id>/GitHub.copilot-chat/memory-tool/memories/repo/` | `issue-conventions.md` | 437 B |

### 2.2 スコープは Copilot が自動判別

同じ "記憶して" 系の入力でも、内容で自動的に振り分け:

| ユーザー入力 | 自動判定 | 保存先 |
|---|---|---|
| "このリポジトリでは Issue タイトルに [bug]/[feat]/[docs] の prefix を付ける" | **Repo** スコープ | `repo/issue-conventions.md` |
| "コミットメッセージは Conventional Commits を使います" | **Global (User)** スコープ | `preferences.md` |

→ Copilot は文脈から「このリポ限定の慣習」 vs 「ユーザー個人の嗜好」を判別して書き分けている。

### 2.3 ファイル中身は **読める Markdown**

実例 1 (`repo/issue-conventions.md`):
```markdown
# Issue title conventions (shinyay/test-ghcp-workshop-validation)

- All issue titles must use one of these prefixes:
  - `[bug]` — bug reports
  - `[feat]` — feature requests
  - `[docs]` — documentation issues
- When asked to assist with labeling in this repo, infer the label from the title prefix and apply the matching label (`bug`, `feat`/`feature`, `docs`).
- If the title has no prefix, suggest adding one before labeling.
```

実例 2 (`preferences.md`):
```markdown
# User preferences

- Commit messages: use Conventional Commits (e.g. `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`).
```

→ Trust thread (★) の最強教材: 「Copilot が何を覚えたか」がブラックボックスでなく、**人間が読める形でディスクに置かれている**。

---

## 3. ★重要発見 — Chat に **"Read memory [file]" のトレース表示**

新規 Chat セッションで「ログインボタンが押せない」のタイトル提案を求めたところ:

```
Read memory [/home/.../memory-tool/memories/repo/issue-conventions.md]

「ログインボタンが押せない」はバグ報告なので、`[bug]` プレフィックスを付けたタイトル案です:
- `[bug] ログインボタンが押せない`
- `[bug] ログインボタンをクリックしても反応しない`
- `[bug] ログイン画面でログインボタンが動作しない`
```

→ **どの memory ファイルを参照したか** がチャット内に明示される(クリック可能なリンク付き)。
→ 学習者が「Memory が確かに使われた」と一目で分かる UX が用意されている。

---

## 4. ★重要発見 — Memory 作成時にも明示的フィードバック

記憶を植え付ける入力に対し、Copilot は応答内で:

```
Created memory file [.../memories/repo/issue-conventions.md]
リポジトリメモリに保存しました（`/memories/repo/issue-conventions.md`）。
今後 shinyay/test-ghcp-workshop-validation でラベル付け補助を求められたら、
Issue タイトルの [bug] / [feat] / [docs] prefix に従ってラベルを判定します。
prefix が無い場合は付与を提案します。
```

→ 「保存しました」+「保存先パス(クリック可能リンク)」+「今後の挙動の宣言」 の **3 点セット**。
→ Trust thread の Step 1 で「学習者が Copilot に何を頼んだか / 何を覚えたか / どう使われるか」が完結する。

---

## 5. 教材設計への反映 (Step 1)

### 5.1 推奨デモシナリオ (5 分)

1. **植え付け**: Chat で「このリポでは [bug]/[feat]/[docs] prefix を付ける」と発話
   - → "Created memory file" 表示を見せる
2. **ファイル可視**: クリックで `repo/issue-conventions.md` を開いて中身を表示
   - → 「ブラックボックスじゃない」を強調(★Trust thread)
3. **新規 Chat で再現**: `+` で新規セッション → 「タイトル提案して: 〜」
   - → "Read memory [...]" トレース + `[bug]` prefix 付き提案を見せる
4. **スコープの違い**: 「コミットメッセージは Conventional Commits」と発話
   - → 今度は `preferences.md` (global) に保存される様子
   - → "リポ慣習 vs 個人嗜好" を Copilot が自動判別する説明
5. **編集/削除**: ファイルを直接編集してから新規 Chat → 振る舞いが変わることを見せる(オプション)

### 5.2 Step 1 の感情曲線

| 局面 | 受講者の感情 |
|---|---|
| 植え付け時の「保存しました」表示 | "おっ、覚えた" (小ピーク) |
| ファイルを開いて中身を見る | "ブラックボックスじゃないんだ" ★(中ピーク・Trust thread の核) |
| 新規 Chat で prefix 付き提案 | "本当に効いた!" (大ピーク・Step 2 への動機形成) |

→ 当初の懸念だった「Step 1 が抽象的な座学になる」リスクは完全に消えた。

---

## 6. 削除/管理 UX

- 公式の Memory パネル UI(専用エディタなど)は今回未確認
- **ファイル直接削除** で記憶リセットが可能(`rm ~/.../memories/repo/issue-conventions.md`)
- 教材では「ファイルを開いて編集 / 削除する = 自分の Copilot を躾けている」というメンタルモデルで紹介する

---

## 7. 技術的な観察事実

- Memory tool の起動コマンド: **`Chat: Show Memory Files`** (コマンドパレット)
- 初期状態は "no memory found" 表示
- 記憶植え付け時に Chat 応答の冒頭に **`Created memory file [link]`**
- 記憶参照時に Chat 応答の冒頭に **`Read memory [link]`**
- ストレージはユーザーローカル(同期 = 不明、要 Phase 02 で確認)
- workspace ID は `2413842ddc815e4ce37260503d8aeba0`(throwaway repo を VS Code Insider で開いたインスタンス)

### 過去の Memory 構造との比較

`find ~/.vscode-server-insiders/data -path "*copilot*memor*"` で発見:

- 古い別 workspace では base64 ID 形式のサブディレクトリ(`YzVhNzAwMDAtOTg4MC...`)に `*-plan.md` などが置かれていた → **chat-session 単位** だった可能性
- 今回の repo (新形式) は `repo/` ディレクトリ配下で **意味ある名前(`issue-conventions.md`)** のフラットな配置

→ Memory 仕様は最近整理された(教材で「2026 で UX が向上した」と触れられる)。

---

## 8. Phase 02 着手判定への影響

| 実験 | 状態 | Phase 02 着手最低条件 |
|---|---|---|
| E1 | ✅ PASS | ✅ 必須 → クリア |
| E2 | ✅ PASS | — |
| E3 | ✅ PASS | 推奨 → クリア |
| E4 | ✅ PASS | 任意 → クリア |
| E5 | 🟡 CONDITIONAL PASS (Path C) | 任意 |
| **E6** | ✅ **PASS (理想ケース)** | 任意 → クリア(Step 1 教材化が一番強い形で書ける) |

→ **Phase 01 完全 PASS。Phase 02 (Step 0 教材化) 着手 GO。**

