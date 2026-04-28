# E6 Procedure — Copilot Memory 観測方法検証 (手動)

> **対象**: ユーザー手動。E1〜E5 と独立に実行可能。

---

## 1. 目的

Step 1 で学習者が「Memory が記憶した」ことを **可視化** できる UX を見つける。これが取れないと Step 1 が抽象的な座学になり感情曲線の最初のピークが立たない。

## 2. 前提

- Copilot Pro / Pro+ プラン (Memory が default-on / public preview, 2026-03 changelog)
- VS Code 最新 + Copilot extension 最新
- throwaway repo を Codespaces で開いた状態

## 3. 検証手順

### Step A. Memory パネルの所在確認

VS Code で:
1. Copilot Chat を開く
2. ⚙️ または `…` メニューから **Memory** / **Preferences** / **Profile** 等の表示があるか
3. コマンドパレット (Cmd/Ctrl+Shift+P) で `Copilot: Memory` を検索

候補名:
- `Copilot: Show Memory`
- `Copilot: Manage Memory`
- `Copilot: View Conventions`

### Step B. 記憶生成のトリガ

Copilot Chat で以下を順に入力:

```
このリポジトリでは、Issue タイトルに [bug] / [feat] / [docs] のいずれかの prefix を付ける慣例があります。今後この repo でラベル付け補助を求められたら、この慣例に従ってください。
```

```
コミットメッセージは Conventional Commits を使います。
```

### Step C. 記憶反映確認

Step B の後、別 Chat (新規) で:

```
新しい Issue のタイトルを提案してください: 「ログインボタンが押せない」
```

期待: `[bug] ログインボタンが押せない` のように prefix を付けた提案が返ってくる。

### Step D. Memory パネルでの可視確認

Step A で見つけた Memory UI を開いて、以下を保存した記憶として表示しているか確認:
- prefix 慣例
- Conventional Commits

### Step E. 削除可能性

UI で個別の記憶を削除できるかを確認 (Trust thread の延長線で「学習者がコントロールできる」体験は重要)。

## 4. 記録 (RESULT.md)

- Memory UI のスクリーンショット (見つかった場合)
- 見つからなかった場合のコマンドパレット検索結果スクリーンショット
- Step C でメモリが反映された証拠 (Chat ログ抜粋)
- 削除 UI の有無

## 5. PASS 基準 (Phase 01 §3 E6)

| 観測 | 評価 |
|---|---|
| ✅ Memory パネルが存在し、生成された記憶を表示する | Step 1 を「Memory に何が入ったか見せる」設計で書ける ─ 理想 |
| △ パネルは無いが Chat 上で記憶反映を確認できる | Step 1 を「Chat の振る舞いの差分で Memory を体感する」設計に変更 |
| ❌ 何も観測できない | Step 1 を「概念紹介 + 公式 changelog 引用 + 録画」に縮退 (Master Plan §6 R2) |

## 6. 学習者の感情曲線への影響

- ✅ なら Step 1 の "見えた!" 体験が成立 → Step 2 (Skill) への動機 "見える資産にしたい" に自然に繋がる
- △ でも体感はあるので OK
- ❌ なら Step 1 を圧縮し、Step 2 を早く出す方が教材として強い

## 7. 関連 changelog

- 2026-03-04: Copilot Memory now on by default for Pro and Pro+ users (public preview)
  - https://github.blog/changelog/2026-03-04-copilot-memory-now-on-by-default-for-pro-and-pro-users-in-public-preview/
