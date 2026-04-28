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

# Triage Issue

## When to use
- 新規 issue で category label (`bug` / `enhancement` / `question` / `documentation`) が未付与のとき
- 過去に triage 済みの issue は対象外

## Workflow
1. Issue body を読む
2. 内容から最適な 1 つの category label を選ぶ (repo に存在するもののみ)
3. ラベルを付ける (もし期待ラベルが repo に無い場合は最も近い既存ラベルを採用し、コメントで substitution を説明)
4. 確認のための短いコメントを残す (テンプレ: "Categorized as <label>. <missing info があれば箇条書き>")
