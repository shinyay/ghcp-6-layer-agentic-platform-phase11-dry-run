# Template: `triage-issue.md` engine swap (unified diff patch 形式)

> **使い方**: 本ファイルは **diff patch 形式の canonical sample**。Step 4 で書いた `triage-issue.md` の `engine` stanza のみを書き換える差分を示します。frontmatter 全体を置き換えるのではなく、**`engine:` 行だけを追加 / 書き換え** て Step 4 の `on:` / `permissions:` / `safe-outputs:` ガードレールは維持してください (R08-8 / R08-9)。
>
> **適用先**: playground repo の `.github/workflows/triage-issue.md` (または engine 別コピー `triage-issue-{copilot,claude,codex}.md`)

---

## A. Copilot baseline (engine 明示化)

Step 4 の `triage-issue.md` は `engine` 暗黙 (= `copilot`)。本 Step §3.B で **明示** に切り替える。動作不変 (R08-9 backward compat)。

```diff
 ---
 on:
   issues:
     types: [opened]
   workflow_dispatch:
     inputs:
       issue_number:
         required: true
         type: string
 permissions:
   contents: read
   issues: read
+engine: copilot
 safe-outputs:
   add-labels:
     allowed: [bug, enhancement, question, documentation]
     target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
   add-comment:
     target: "${{ github.event.issue.number || github.event.inputs.issue_number }}"
 ---
 (prompt body は Step 4 のまま、engine 非依存で再利用)
```

**期待 secret**: `COPILOT_GITHUB_TOKEN` (Step 4 P10 から継承)

---

## B. Claude engine 切替 (§3.C)

```diff
-engine: copilot
+engine: claude
```

**両形 OR でサポート** (Phase 08 R08-1 = canonical syntax 未確定):

```yaml
# (B-1) scalar 形 (model 暗黙、簡素)
engine: claude

# (B-2) object 形 (model / version 明示時の canonical 候補)
engine:
  id: claude
  # model: claude-3-5-sonnet-20241022   # ← Phase 11 で世代切替を再検証
```

**期待 secret**: `ANTHROPIC_API_KEY` (P11 に従い playground repo に登録済)

`gh aw compile` を実行 → `unknown engine` / schema error が出たら scalar ⇄ object を切り替えて再試行 → なお fail なら §3.F 録画 fallback。

---

## C. Codex engine 切替 (§3.D)

```diff
-engine: copilot
+engine: codex
```

**両形 OR**:

```yaml
# (C-1) scalar 形
engine: codex

# (C-2) object 形
engine:
  id: codex
  # model: gpt-5-codex   # ← Phase 11 で世代切替を再検証
```

**期待 secret**: `OPENAI_API_KEY` (canonical) または `CODEX_API_KEY` (accepted alternative、gh-aw 側で優先される実装の場合あり)

---

## D. compile-before-commit 順序 (Step 4 P07-* 継承)

各 engine 切替後、**必ず以下の順序**を厳守:

1. `triage-issue-<engine>.md` を edit (engine 行のみ書き換え)
2. `gh aw compile` 実行 → エラーなしを確認
3. `git add triage-issue-<engine>.md triage-issue-<engine>.lock.yml`
4. `git commit -m "step 5: <engine> engine swap"`
5. `git push`
6. Issue 作成 / `workflow_dispatch` で invoke
7. Actions log を観測 → README §3.E 比較表に記入

---

## E. Trust thread invariant (verification target)

3 engine 全部の `.lock.yml` で以下が **engine 横断で維持されている** かを `diff` で確認:

```bash
diff triage-issue-copilot.lock.yml triage-issue-claude.lock.yml | grep -E "safe_outputs|permissions:|add-labels|add-comment"
```

維持されているべき invariant:
- `safe_outputs` job boundary (agentic job ≠ writer job)
- `permissions: contents: read` のみ (agentic 側に write 無し)
- `add-labels.allowed: [bug, enhancement, question, documentation]` 不変

→ 全 engine で維持 → **`confirmed`**、いずれか崩れる → **`partially confirmed`** (Step 5 README §3.E)

---

## 参考

- Step 5 README §3.B / §3.C / §3.D: [`../README.md`](../README.md)
- Step 4 canonical `triage-issue.md`: [`../../step-4-automate/templates/triage-issue.md`](../../step-4-automate/templates/triage-issue.md)
- engine canonical samples / engine x secret マトリクス: [VERSIONS.md §4.2](../../../docs/planning/VERSIONS.md)
- engine 別 secrets 登録: [VERSIONS.md §9](../../../docs/planning/VERSIONS.md)
- リスク: [phase-08-step5-multi-engine.md §7 (R08-1〜R08-9)](../../../docs/planning/phase-08-step5-multi-engine.md)
