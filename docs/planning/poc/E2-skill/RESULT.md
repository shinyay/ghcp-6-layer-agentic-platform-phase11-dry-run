# E2 Result — SKILL.md 仕様確定

**Status**: ✅ **PASS**
**Date**: Phase 01 進行中
**Authoritative source**: `github/awesome-copilot@63d08d51` の `skills/` 配下 (公式リポジトリの参考実装)

---

## 1. 検証目的 (Phase 01 §3 E2 より)

教材で教える SKILL.md の frontmatter フィールド構成を、ハルシネーションを避けた authoritative source から確定する。

## 2. 検証手順

1. `github/awesome-copilot` リポの `skills/` ディレクトリを GitHub MCP Server 経由で取得
2. サンプル実装 `skills/acquire-codebase-knowledge/SKILL.md` の本物 frontmatter を読む
3. 教材で教える最小フィールドセットと推奨フィールドセットを決定

## 3. 確定 spec

### 3.1 frontmatter 全フィールド (実物より)

```yaml
---
name: acquire-codebase-knowledge
description: 'Use this skill when the user explicitly asks to map, document, or onboard into an existing codebase. Trigger for prompts like "map this codebase", ...'
license: MIT
compatibility: 'Cross-platform. Requires Python 3.8+ and git. Run scripts/scan.py from the target project root.'
metadata:
  version: "1.3"
  enhancements:
    - Multi-language manifest detection (25+ languages supported)
    - ...
argument-hint: 'Optional: specific area to focus on, e.g. "architecture only", "testing and concerns"'
---
```

### 3.2 教材で教える 2 段階のフィールドセット

| 段階 | フィールド | 理由 |
|---|---|---|
| **必須 (Step 2 で教える)** | `name`, `description` | これだけで Skill として trigger できる。spec 変動リスクが最も低い |
| **推奨 (Step 6 までに教える)** | `license`, `metadata.version`, `compatibility` | 組織で資産化するときに必要 |
| **発展 (出さない)** | `argument-hint`, `metadata.enhancements` | spec が固まりきっていない可能性。教材スコープ外 |

### 3.3 本文の構造慣例 (実物 acquire-codebase-knowledge より)

```markdown
# <Title (Capitalized phrase)>

<1-2 段落の概要>

## Output Contract (Required)
<完了基準を箇条書き>

## Workflow
<Phase ごとに番号付き手順>

## Gotchas
<つまずきポイントを Markdown blockquote で>

## Anti-Patterns
| ❌ Don't | ✅ Do instead |
|---|---|
| ... | ... |

## Bundled Assets
| Asset | When to load |
|---|---|
| `scripts/...` | Phase X — ... |
```

### 3.4 ディレクトリ構造慣例

```
skills/<skill-name>/
├── SKILL.md             # 必須
├── assets/              # 任意: テンプレート等
│   └── templates/
├── references/          # 任意: 参照ドキュメント
└── scripts/             # 任意: 実行可能ファイル
```

---

## 4. 教材への反映方針

- **Step 2** で学習者が書く triage SKILL.md は **frontmatter 2 フィールド (`name`, `description`) + 本文 ## When to use / ## Workflow** だけの最小形にする。
- 余計なセクションを足さないことで「Skill = description が trigger」という核心メッセージを強調する。
- `assets/` `references/` `scripts/` は教材のスコープ外 (発展課題で触れる)。

## 5. 参考にする最小 SKILL.md (Step 2 で学習者が完成させる目標形)

```markdown
---
name: triage-issue
description: 'Use this skill when a new GitHub issue is opened that needs triage. Reads the issue body, picks the best category label (bug, feature, question, docs), writes a short greeting comment that confirms the category, and notes any missing repro information. Do not trigger for issues that already have a category label.'
---

# Triage Issue

## When to use
- 新規 issue で category label (`bug` / `feature` / `question` / `docs`) が未付与のとき
- 過去に triage 済みの issue は対象外

## Workflow
1. Issue body を読む
2. 内容から最適な 1 つの category label を選ぶ
3. ラベルを付ける
4. 確認のための短いコメントを残す (テンプレ: "Categorized as <label>. <missing info があれば箇条書き>")
```

> **設計原則 P3 (Working code over prose)** の通り、これがそのまま triage シナリオの「Step 2 完成形」になる。後続 Step は同じ SKILL.md を gh aw / Cloud Agent / Custom Agent から呼び出し、振る舞いは変えない。

---

## 6. ハードゲート判定

| 判定項目 | 結果 |
|---|---|
| Authoritative source から実物 SKILL.md を取得 | ✅ |
| 必須/任意フィールドを区別できた | ✅ |
| 教材で教えるフィールドセットを 2 段階で決定 | ✅ |
| 余分な ハルシネーション フィールドを混入させていない | ✅ (`when_to_use` などは存在しないことを実物で確認) |

**Phase 02 着手の最低条件 (E2 PASS) → 達成。**

---

## 7. 学び / 注意

- Web 検索結果には `when_to_use` という frontmatter キーがハルシネーションで頻出するが、**公式リポの実物には存在しない**。`description` 自体が trigger 役を兼ねる。
- `metadata.version` は文字列 (`"1.3"` など) が慣例。日付形式 (`2026-01-20a`) は `.agent.md` で見られる慣例で混用禁物。
- `script` ベースの skill (Python script を SKILL.md から呼ぶパターン) は強力だが教材スコープ外。「Markdown だけで Skill が成立する」ことが Step 2 の意外性の源泉。

## 8. References

- `github/awesome-copilot@63d08d51:skills/acquire-codebase-knowledge/SKILL.md`
- `github/awesome-copilot@63d08d51:.schemas/` (`tools.schema.json` 等。SKILL.md 自体の JSON Schema は現時点で公開されていないため frontmatter は実物比較で確定した)
