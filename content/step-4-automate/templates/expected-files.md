# `gh aw init` 周辺で生成されるファイル一覧 (v0.68.3 時点)

> **位置付け**: Step 4 §3.A の checklist。**生成タイミング別に 3 ブロック** に分けて整理しています (★ rubber-duck #1 I-9 反映)。
>
> v0.69+ で artifacts が追加されても、core files が揃っていれば本 Step は完走できます (drift 余地)。

---

## ブロック 1: `gh aw init` 直後に生成されるファイル

`gh aw init` を 1 回実行した直後に手元にあるべきファイル群です。

| パス | 役割 | サイズ目安 |
|---|---|---|
| `.github/workflows/copilot-setup-steps.yml` | Cloud Agent 用 setup script (gh aw scaffold 版、Step 3 の手書き版とは別物) | ~1 KB |
| `.github/agents/agentic-workflows.agent.md` | dispatcher agent (workflow から呼ばれる入口) | ~2 KB |
| `.github/aw/actions-lock.json` | gh aw が使う Actions のバージョン pin | ~3 KB |
| `.vscode/mcp.json` | playground 側で **新規生成** される MCP 設定 (workshop repo の既存版とは別物) | ~1 KB |
| `.vscode/settings.json` | gh aw 用の VS Code workspace 設定 (drift tolerant、環境により有無あり) | ~0.5 KB |
| `.gitattributes` | `*.lock.yml linguist-generated=true` 設定が追記される (既存ファイルがあれば追記、なければ新規作成) | +1 行 |

> [!NOTE]
> `.vscode/mcp.json` / `.vscode/settings.json` が既に存在する場合、`gh aw init` は対話で上書き確認をします。**playground repo は throwaway public clean を推奨** しているため、通常は衝突なく新規生成されます (Step 4 §3.A NOTE 参照)。

確認コマンド:

```bash
ls -la .github/workflows/copilot-setup-steps.yml \
       .github/agents/agentic-workflows.agent.md \
       .github/aw/actions-lock.json \
       .vscode/mcp.json \
       .gitattributes
```

---

## ブロック 2: 学習者が **自分で書く** ファイル

Step 4 §3.C で **学習者がエディタで作成** する workflow ソース。

| パス | 役割 | サイズ目安 |
|---|---|---|
| `.github/workflows/triage-issue.md` | triage workflow 本体 (`on: issues.opened` + `workflow_dispatch.inputs.issue_number` + `safe-outputs.add-labels` + `add-comment` + prompt body) | ~50 行 |

canonical sample: [`./triage-issue.md`](./triage-issue.md) を **playground repo の `.github/workflows/triage-issue.md` にコピー** してください。

---

## ブロック 3: `gh aw compile` で生成されるファイル

学習者が `triage-issue.md` を書き終えた後、`gh aw compile` を実行すると以下が生成されます。

| パス | 役割 | サイズ目安 |
|---|---|---|
| `.github/workflows/triage-issue.lock.yml` | `gh aw compile` が `triage-issue.md` から生成する **GitHub Actions runner が実行する形式** の YAML | ~63 KB |

確認コマンド:

```bash
# triage-issue.md + .lock.yml ペアが揃っているか
ls -la .github/workflows/triage-issue.md .github/workflows/triage-issue.lock.yml
```

---

## 補足

- **編集対象は `triage-issue.md` の方**: `.lock.yml` を直接編集すると次回 `gh aw compile` で上書きされます。
- **`.lock.yml` も commit する**: GitHub Actions runner は `.yml` / `.yaml` ファイルしか workflow として認識しないため、`.lock.yml` を commit しないと workflow が動きません。
- **`.lock.yml` の diff は GitHub UI で折りたたまれる**: `.gitattributes` の `*.lock.yml linguist-generated=true` 設定により自動的に折りたたまれます (Step 4 README §2 V3' verification 項目)。

---

## 今後の drift 監視 (Phase 11 で再検証)

`gh aw` v0.69+ で追加 / 変更される可能性のある項目:

- `.github/workflows/copilot-setup-steps.yml` のスケルトン構成
- `safe-outputs` キー (現在 = `add-labels` / `add-comment` / `create-issue` / `create-pull-request`)
- Copilot CLI engine の elapsed time (現在 = 約 3 分、E3 RESULT §8.4)
- `actions-lock.json` のバージョン pin
- `.vscode/mcp.json` / `.vscode/settings.json` の有無 / 内容

→ 詳細は [`docs/planning/00-master-plan.md §6 R6`](../../../docs/planning/00-master-plan.md) を参照。
