# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

## 脆弱性の報告

セキュリティ上の問題 (例: PAT / token / API key の誤コミット、教材手順による secret 漏洩リスク、CI workflow の脆弱な permissions など) を発見した場合:

1. **公開 Issue を開かないでください** — 通常の Issue tracker では機密性が確保できません
2. リポジトリオーナー (@shinyay) に **GitHub の private vulnerability reporting** 経由で報告してください
   - リポジトリの **Security** タブ → **Report a vulnerability** ボタン
3. 影響範囲 / 再現手順 / 提案する修正を記載してください

## 報告内容に含めるべき情報

- 該当ファイル / Step / コミット SHA
- 再現手順 (PoC があれば添付)
- 想定される impact (token 漏洩 / arbitrary code execution / supply chain risk 等)
- 推奨される修正案 (任意)

## 機密情報の取扱

教材中の `COPILOT_GITHUB_TOKEN` / `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` / `CODEX_API_KEY` 等は **学習者が自身の playground repo に設定する secret** です。本 repo および playground のいずれにも commit しないでください。secret scan は CI で実施されるべきですが (Phase 12+ 検討事項)、各 contributor 側でも `git diff` 確認 + gitleaks/trufflehog 等の事前 scan を推奨します。

## 学習者向け注意

教材手順の中で PAT 作成 / 削除を案内している箇所は、**最小権限 + 短期 lifetime** を強調しています。学習完了後は `https://github.com/settings/tokens` で速やかに削除してください ([Step 4 §3.B](content/step-4-automate/) 等で再掲)。

## 応答時間

報告を受領後 7 日以内に初動応答を目指します (best effort、ボランティアベースのため遅延の可能性があります)。
