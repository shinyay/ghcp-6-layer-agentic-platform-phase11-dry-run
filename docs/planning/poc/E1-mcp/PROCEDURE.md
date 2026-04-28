# E1 Procedure — GitHub MCP Server 接続検証 (手動)

> **対象**: ユーザー手動実行 (Codespaces + VS Code Copilot Chat 必須)
> **throwaway repo**: https://github.com/shinyay/test-ghcp-workshop-validation
> **完了時に書くべき**: 同ディレクトリの `RESULT.md`

---

## 0. 前提

- VS Code 最新、GitHub Copilot extension 最新
- `gh auth status` で認証済み
- throwaway repo を Codespaces で開ける状態

## 1. 検証手順

### Step A. throwaway repo を Codespaces で開く

1. https://github.com/shinyay/test-ghcp-workshop-validation を開く
2. `Code` → `Codespaces` → `Create codespace on main`

### Step B. seed Issue を作成 (Codespaces ターミナルで)

```bash
gh issue create --title "App crashes on startup" \
  --body "When I run \`npm start\`, the process exits with code 1 and no log."
gh issue create --title "Add dark mode" \
  --body "Please add a dark mode toggle to settings."
gh issue create --title "How do I configure auth?" \
  --body "I cannot find docs on JWT setup."
```

3 件作成できたか確認:
```bash
gh issue list
```

### Step C. Copilot Chat から MCP 経由で Issue を取得

VS Code の Copilot Chat を開き、以下を入力:

```
@workspace List the open issues in this repository using the GitHub MCP server.
```

**期待される動作**:
- Chat が GitHub MCP Server の `list_issues` ツールを呼び出す (ツール承認ダイアログが出る)
- 3 件の Issue タイトルが返ってくる

### Step D. ツール呼び出しの確認

Copilot Chat 上で以下を確認:
- ツール呼び出しが UI に表示されたか (ツール名 / 引数 / 結果)
- Approve / Deny の選択肢が現れたか (Trust thread の伏線)

### Step E. (任意) WorkIQ MCP の存在を確認

MCP のツールパレット (歯車アイコンなど) で `workiq` 系のツールが列挙されているかを確認 (見えない場合は教材で「紹介のみ」とする)。

## 2. 記録すべき内容 (RESULT.md に書く)

- ツール呼び出しダイアログのスクリーンショット (`docs/planning/poc/E1-mcp/screenshots/` 配下に)
- 実際に呼ばれた MCP tool 名
- レスポンス時間の体感 (秒)
- ツール承認の UX が教材で説明可能か (Trust thread として使える形か)

## 3. PASS 基準 (Phase 01 §3 E1)

- [ ] Codespaces から `https://api.githubcopilot.com/mcp/` 経由で Issue 取得成功
- [ ] tool 呼び出しダイアログを確認できた

## 4. FAIL 時の対応

| 症状 | 対応 |
|---|---|
| MCP server が表示されない | Codespaces を再作成、Copilot extension のバージョン確認 |
| 認証エラー | `gh auth status` 再確認、Codespaces secrets を確認 |
| ツール承認 UI が出ない | 設定で `chat.tools.autoApprove` が true になっていないか確認 (false 推奨) |
| 持続的に再現不能 | Master Plan §6 R1 を発動: Step 0 を「MCP の概念紹介のみ + 録画」に縮退 |
