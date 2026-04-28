# Template: 3 engine head-to-head 比較表

> **使い方**: 本テンプレートを playground repo にコピーして engine x 5 軸で埋めます。**観測場所別 4 グループ** で構成 (Phase 08 D08-14)。
>
> **記入方針**: API key 不所持で本 Step を録画 fallback (§3.F) で完走する場合も、**Group 1 + Group 3 は録画から書き写し可能** (リファレンス品質を保証)。Group 2 + Group 4 は省略可。

---

## メタデータ (記入)

| 項目 | 値 |
|---|---|
| 実施日 | YYYY-MM-DD |
| Issue 題名 | (3 engine 共通の入力 Issue) |
| Issue body 抜粋 | |
| `gh aw version` | v0.68.3 |
| playground repo | `<owner>/<repo>` |

---

## Group 1: Observed in this run (1 invocation 完結で観測)

各 engine 1 invocation で取得できる観測値。

| engine | latency (run 全体 elapsed) | label 結果 | comment 文体 (要約 1 行) | run status |
|---|---|---|---|---|
| **copilot** | (例: ~3m) | (例: bug) | (例: 簡潔・引用部あり) | success / fail |
| **claude** | | | | |
| **codex** | | | | |

**観測 source**: GitHub Actions の workflow run page (`Actions → triage-issue-<engine>.lock.yml → run id → Summary`)。

---

## Group 2: Post-run / optional (各 console の billing/usage visibility)

API key 不所持時は省略可。本 Step の **5 軸比較の "cost" 軸** はこの Group 2 で観測 (workshop 中は省略しても full done 可)。

| engine | console URL | observed cost (1 invocation) | observed tokens (input / output) |
|---|---|---|---|
| copilot | (Premium Request usage、Settings → Billing) | — | — |
| claude | https://console.anthropic.com/ → Usage | $X.XX | input ~ / output ~ |
| codex | https://platform.openai.com/usage | $X.XX | input ~ / output ~ |

---

## Group 3: Design invariant to inspect (= verification target)

3 engine 全部の `.lock.yml` を `diff` で並べて以下を inspect:

```bash
diff triage-issue-copilot.lock.yml triage-issue-claude.lock.yml | grep -E "safe_outputs|permissions:|add-labels|add-comment"
diff triage-issue-copilot.lock.yml triage-issue-codex.lock.yml  | grep -E "safe_outputs|permissions:|add-labels|add-comment"
```

| invariant | copilot | claude | codex | 全 engine 維持? |
|---|---|---|---|---|
| `safe_outputs` job boundary (agentic job ≠ writer job) | (Yes) | | | (Yes / Partial / No) |
| `permissions: contents: read` のみ (agentic 側 write 無し) | (Yes) | | | |
| `add-labels.allowed` allowlist 不変 (`[bug, enhancement, question, documentation]`) | (Yes) | | | |

**昇格判断**:
- 全 Yes & 全 engine が PASS → **`confirmed` (engine 横断 invariant 確証)**
- いずれか Partial / No、または Group 1 で Safe-output fail が 1 engine ある → **`partially confirmed` (条件付確証)**

→ この昇格判断結果を **Phase 08 README §6 完了確認 / phase-08-step5-multi-engine.md §6.1 / §10.3 RESULT block** に反映。

---

## Group 4: Troubleshooting-only (error mode 例)

エラーがなければ全行を `—` にする。Step 5 README §4 fallback decision tree との対応:

| engine | error mode 観測有無 | 対応分岐 (§4 decision tree) |
|---|---|---|
| copilot | (例: なし) | — |
| claude | (例: Compile-fail = `unknown engine`、object 形に切替で解消) | (a) syntax 切替で recovery |
| codex | | |

---

## 観察ノート (Free form、任意)

- (例: claude は引用が多めで comment が長い、codex は簡潔だが label 選択は同じ etc)
- (例: 全 engine とも `safe_outputs` job 経由で書き戻し、Trust thread invariant 維持)

---

## 参考

- Step 5 README §3.E (4 group 詳細): [`../README.md`](../README.md)
- engine 切替 patch: [`./triage-issue-engine-swap.md`](./triage-issue-engine-swap.md)
- E3 RESULT (Copilot baseline reference data): [E3 RESULT §8.2 / §8.4](../../../docs/planning/poc/E3-gh-aw/RESULT.md)
