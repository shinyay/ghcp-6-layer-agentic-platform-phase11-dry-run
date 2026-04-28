# E3 Result — gh aw 実機検証

> ✅ **Reused as source-of-truth for Phase 07 §3 教材化** (Phase 07 C2a で確定、2026-04-26)
>
> Step 4 README §3 の根拠として以下の節を明示参照:
> - **§8.2** = all PASS proof (workflow run completed / label / comment / Copilot 由来 reasoning)
> - **§8.4** = ~3 分 elapsed proof (pre_activation / activation / **agent 1m20s** / detection / safe_outputs / conclusion)
> - **§3** = strict mode proof (`permissions: issues: write` を入れると `gh aw compile` が fail、`safe-outputs` 必須化の根拠)
> - **§5** + **§8.3** = PAT "秘伝の手順" proof (Resource owner = 個人 / Repository access = Public / Copilot Requests = Read-only + sanity check 必須)
>
> ★ §6 PROCEDURE の label allowlist `[bug, feature, question, docs]` は **PoC 時の仮 vocabulary**。教材では `[bug, enhancement, question, documentation]` に統一 (Step 2/3 + GitHub default labels と整合、Phase 07 D23)。
>
> 新規 PoC (E9/E10 等) は不要 = 本 RESULT で end-to-end PASS 済を再活用。E9 = ユーザー実機完走 marker (E9-Standard = Pro+ プロファイル / E9-Pro = Pro 単体プロファイル) としてのみ Plan §5 で使用。
>
> ---
>
> ✅ **Reused (extended) for Phase 08 §3.B = Step 5 Copilot baseline 再走** (Phase 08 C2a で確定、2026-04-26)
>
> Step 5 README §3.B (= `engine: copilot` baseline 再走、3 engine head-to-head の起点) の根拠として以下を明示参照:
> - **§8.2** + **§8.4** = Copilot engine baseline の workflow run completed / ~3 分 elapsed (Step 5 §3.E 5 軸比較表 Group 1 = "Observed in this run" の latency baseline)
> - **§3** = strict mode + safe-outputs ガードレール (Phase 08 Trust thread invariant の **verification target** = 全 engine で safe_outputs job boundary が維持されるかを Phase 08 C5 で `confirmed` 昇格判断)
>
> Step 5 §3.C (Claude engine) / §3.D (Codex engine) の **実機 evidence は Phase 08 C2b dogfooding discovery で本 RESULT §8.x または phase-08-step5-multi-engine.md §10.3 RESULT block に accumulate** 予定。本 PoC を engine 切替で再実行することで E10 = ユーザー実機完走 marker (E10-Standard 3 engine / E10-Minimum 1 engine / E10-Fallback) を埋める。
>
> Phase 08 R08-1 (engine stanza spec drift = R6 sub-risk) は本 PoC の workflow を流用して `.lock.yml` 出力差分 / canonical syntax (scalar vs object) / engine x secret マトリクスを **C2c (truth migration 後段) で確定値記入**。

---

**Status**: ✅ **PASS** (end-to-end workflow run completed 2026-04-25)
**Date**: 2026-04-24
**Throwaway repo**: https://github.com/shinyay/test-ghcp-workshop-validation
**gh aw version**: `v0.68.3`

---

## 1. 検証結果サマリ

| 検証項目 | 結果 | 詳細 |
|---|---|---|
| `install-gh-aw.sh` でインストール | ✅ | `~/.local/share/gh/extensions/gh-aw/` に v0.68.3 配置 |
| `gh aw version` 動作 | ✅ | `v0.68.3` 表示 |
| `gh aw init` で repo 初期化 | ✅ | 5+1 ファイル生成(spec 訂正は §2) |
| `triage-issue.md` を `gh aw compile` | ✅(2 回目) | strict mode で 1 度失敗 → 重要発見(§3) |
| `.lock.yml` 自動生成 | ✅ | 62.7 KB |
| commit & push | ✅ | commit `1d6f287` |
| `issues: opened` で workflow 自動 trigger | ✅ | run id 24872495654 起動 |
| workflow 完走 | ❌ | 2 つの prerequisite で block(§4 / §5) |
| `add-labels` / `add-comment` 反映 | ⏳ | PAT 設定後に再実行で確定 |

---

## 2. PROCEDURE 訂正(spec 確定の差分)

VERSIONS.md / PROCEDURE で当初想定していた構成と、**実機 `gh aw init` (v0.68.3) が生成したもの** に差分あり:

| ファイル | 当初想定パス | **実際のパス** |
|---|---|---|
| MCP config | `.github/mcp.json` | **`.vscode/mcp.json`** |
| dispatcher agent | `.github/agents/agentic-workflows.agent.md` | 同じ ✅ |
| `.gitattributes` | あり | あり ✅ |
| `.vscode/settings.json` | あり | あり ✅ |
| copilot setup | `.github/workflows/copilot-setup-steps.yml` | 同じ ✅ |
| `.github/aw/actions-lock.json` | (記述なし) | **追加で生成された** |

→ **教材で `mcp.json` の場所を `.vscode/` と明示すべき**(VERSIONS.md 修正候補)

### 2.1 dispatcher agent の frontmatter

```yaml
---
description: GitHub Agentic Workflows (gh-aw) - ...
disable-model-invocation: true
---
```

**`name` フィールドが無い**。E2 で確定した `.agent.md` 仕様(`CSharpExpert.agent.md` は `name` あり)とは異なる。
→ **`.agent.md` で `name` は任意の可能性が高い**。教材では「`description` のみ必須」と教える方が安全。

### 2.2 `disable-model-invocation: true` の存在

**agent が他 agent を invoke しないこと** を宣言する frontmatter キー(Trust thread 関連)。教材スコープ外でも一言触れる価値あり。

---

## 3. 重要発見 #1 — strict mode が `issues: write` を禁止

最初の `gh aw compile` が以下のエラーで失敗:

```
strict mode: write permission 'issues: write' is not allowed for security reasons.
Use 'safe-outputs.create-issue', 'safe-outputs.create-pull-request',
'safe-outputs.add-comment', or 'safe-outputs.update-issue' to perform write operations safely.
```

**意味**: gh aw は **default で strict mode**。workflow `permissions:` で書き込み権限を直接付与することを禁止し、**必ず `safe-outputs` 経由で GitHub に書く** ことを強制する。

**教材的価値(★高)**:
- これは **Trust thread の Layer 4 における核心メッセージそのもの**
- Step 4 で学習者にあえて失敗を体験させる教材ステップを入れられる(「`issues: write` を入れて失敗 → strict mode の保護を体感 → `safe-outputs` 必須を理解」)
- keynote で語る「ガードレール」の最強の現物デモ

**修正方法**: `permissions:` から `issues: write` を削除し、`contents: read` のみで OK。書き込みは全て `safe-outputs` 経由。

---

## 4. 重要発見 #2 — private repo の Actions 分数 / spending limit

最初の workflow run が:
```
The job was not started because recent account payments have failed
or your spending limit needs to be increased.
```

→ private repo は GitHub-hosted runner の分数を消費。throwaway 教材としては障壁。

**取った対応**: `gh repo edit --visibility public --accept-visibility-change-consequences` で repo を public に。public repo の Actions は無料無制限。

**教材的価値**: Workshop の「環境準備」で **「throwaway repo は public で作る」** を明示するだけで回避可能。Master Plan §4 Phase 02 の設定タスクに追加候補。

---

## 5. 重要発見 #3 — Copilot engine は `COPILOT_GITHUB_TOKEN` secret 必須

repo を public 化後、再 run すると:

```
Error: None of the following secrets are set: COPILOT_GITHUB_TOKEN
The GitHub Copilot CLI engine requires either COPILOT_GITHUB_TOKEN secret to be configured.
```

`gh aw secrets bootstrap` で対話式に解決可能だが、**fine-grained PAT を手動作成する必要がある**:
- 場所: https://github.com/settings/personal-access-tokens/new
- Resource owner: 個人アカウント
- Repository access: **Public repositories** (← これにしないと Copilot Requests 権限が表示されない)
- Permissions → **Copilot Requests: Read-only**
- 作成後 `gh aw secrets bootstrap` の対話で token を貼る

**教材的価値(★最重要)**:
- これは **Workshop Step 4 の冒頭に prerequisite として明示しないと全員詰む**
- Master Plan §4 Phase 06 (Step 4 教材化) に**必須**入れる
- 学習者の心理的障壁を下げるため、PAT 作成手順を正確なスクショ付きで示す

---

## 6. 残タスク(Phase 01 完了に向けて)

ユーザー側で 1 度実施 → これで E3 を完全 PASS にできる:

```bash
# 1. https://github.com/settings/personal-access-tokens/new で fine-grained PAT 作成
#    Resource owner: 個人  / Repository access: Public repositories
#    Permissions: Copilot Requests = Read-only

# 2. シェルから:
cd /home/shinyay/work/github/test-ghcp-workshop-validation
gh aw secrets bootstrap   # 対話で PAT を貼る

# 3. workflow を再 trigger
gh issue create --title "Verify triage works end-to-end" \
  --body "After PAT setup, this issue should be auto-triaged."

# 4. 結果確認
sleep 90
gh run list --limit 3
gh issue view <new_issue_number>   # ラベルとコメントを確認
```

完了したら本ファイルの §1 表の最後 2 行を ✅ に更新し、Status を `✅ PASS` に変更。

---

## 7. ハードゲート判定

| 判定項目 | 結果 |
|---|---|
| インストール手順を実機で確認 | ✅ |
| workflow `.md` 仕様が実機で機能 | ✅ |
| `safe-outputs` の add-labels / add-comment が正しく compile | ✅ |
| triage シナリオが gh aw の枠で記述可能 | ✅(strict mode 制約も spec 範囲内) |
| **実機 `gh aw run` で workflow 完走** | ⏳ PAT 設定で完走見込み |

**Phase 02 着手の最低条件 (E3 PASS) → spec / compile / trigger まで OK。完走確認は PAT 設定後に追記。**

---

## 8. References

- gh aw version: `v0.68.3`
- workflow run (failed, COPILOT_GITHUB_TOKEN 未設定): https://github.com/shinyay/test-ghcp-workshop-validation/actions/runs/24872495654
- safe-outputs reference: https://github.github.com/gh-aw/reference/safe-outputs/
- engines reference: https://github.github.com/gh-aw/reference/engines/#github-copilot-default
- PAT auth reference: https://github.github.com/gh-aw/reference/auth/#copilot_github_token

---

## 8. 完走確認 (2026-04-25)

### 8.1 実施内容

1. fine-grained PAT を作成 (Resource owner: shinyay, Repository access: Public repositories, Account permissions → Copilot Requests: Read-only)
2. `gh secret set COPILOT_GITHUB_TOKEN -R shinyay/test-ghcp-workshop-validation`
3. 検証用 Issue 作成 (#13 "Verify triage works after PAT fix")
4. `Triage Issue (validation)` workflow が自動 trigger され完走

### 8.2 結果(全 PASS 基準達成)

| 期待 | 実測 | 証跡 |
|---|---|---|
| workflow run completed | ✅ Run `24896562859` success | `gh run view 24896562859 -R shinyay/test-ghcp-workshop-validation` |
| Issue にラベル自動付与 | ✅ `question` | Issue #13 |
| Issue にコメント自動投稿 | ✅ `github-actions` bot から triage 結果コメント | Issue #13 |
| Copilot 由来の reasoning が含まれる | ✅ "categorized as a **question** — it looks like a verification/validation test..." | コメント本文 |

### 8.3 失敗からの学び(教材化必須)

1 度目の試行は PAT の copy ミス("Bad credentials")で失敗。教材では:
- PAT 作成後 **すぐに `curl -H "Authorization: Bearer <token>" https://api.github.com/user` で sanity check** させる手順を入れる
- copy 後に whitespace が混じる事故が頻発する想定 → 教材冒頭の prerequisite チェックスニペットに含める

### 8.4 ジョブ別 elapsed (教材で時間感覚を伝える材料)

| Job | 時間 |
|---|---|
| pre_activation | 10s |
| activation | 18s |
| **agent (Copilot CLI 推論)** | **1m20s** |
| detection | 51s |
| safe_outputs (label/comment 反映) | 9s |
| conclusion | 12s |
| **合計** | **約 3 分** |

→ Step 4 デモで「Issue を立ててから triage 完了まで 3 分」と説明可能。

