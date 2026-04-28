# Contributing to 6-Layer Agentic Platform Workshop

このリポジトリは GitHub Copilot の 6 層 Agentic Platform を学ぶセルフラーニング型ワークショップです。学習者からのフィードバック / Issue / PR を歓迎します。

## 🐛 バグ報告

教材中の誤り、リンク切れ、手順の不整合などを発見した場合:

1. [Issues タブ](https://github.com/shinyay/ghcp-6-layer-agentic-platform/issues) を開く
2. **Bug report** テンプレートを選択
3. 該当 Step / セクション / 期待した挙動 / 実際の挙動 / 環境情報を記載

機密情報 (PAT / token / 個人 secret 等) を含むセキュリティ問題は通常 Issue ではなく [`SECURITY.md`](SECURITY.md) の手順に従ってください。

## 💡 機能リクエスト

新しい Step / 新しい layer / 新しい dogfooding シナリオの提案など:

1. [Issues タブ](https://github.com/shinyay/ghcp-6-layer-agentic-platform/issues) を開く
2. **Feature request** テンプレートを選択
3. 動機 / 想定 user story / 既存 Step との関係を記載

## 🔀 Pull Request

軽微な修正 (typo / 用語統一 / link 修正) は直接 PR を歓迎します。設計変更を伴う PR は事前に Issue で議論してください。

### PR チェックリスト

- [ ] `content/**` を編集した場合、関連する `docs/planning/` 側の SoT (master-plan / VERSIONS / 該当 Phase doc) と矛盾しない
- [ ] 用語規約に従う = `Required Review Gate` (= Step 6a) と `Required Status Check` (= Branch protection setting) を混同しない
- [ ] broken link / typo を導入していない (該当 Step README + ハイパーリンクを目視確認)
- [ ] secrets / PAT / token / API key を含まない (= 公開 OK な変更のみ)

### コミットメッセージ規約

`<phase>(<scope>): <subject>` 形式を推奨 (例: `phase11(release): C5 = CONTRIBUTING + RELEASE_NOTES + workflow ubuntu-latest`)。Phase に紐付かない汎用修正は `chore:` / `docs:` / `fix:` で開始してください。

## 🛠️ 開発フロー

1. Fork → Clone
2. Codespaces で起動 (devcontainer に `gh`, `gh aw`, `jq` が pre-install)
3. ブランチを切る (`git checkout -b fix/<short-description>`)
4. 編集 + commit + push
5. PR を出す (本 repo の `main` 宛)

## 📐 ドキュメント方針

- **SoT 階層**: `docs/planning/00-master-plan.md` > `docs/planning/VERSIONS.md` > `content/prerequisites.md` > `content/**/README.md` > 各 Phase doc
- **歴史 Phase docs (`docs/planning/phase-03〜10-*.md`)** は close-time SoT snapshot として凍結。最新 SoT は上記階層に集約
- **学習者向け文書** (`content/**`) はユーザーフェイシング tone、**設計 / 検証文書** (`docs/planning/**`) は内部 SoT tone

## 📜 行動規範

すべてのコントリビューターは [Contributor Covenant](https://www.contributor-covenant.org/) に準じた行動規範に従うことが期待されます。専用の `CODE_OF_CONDUCT.md` ファイルは現時点では未作成 (Phase 12+ 検討事項)。リスペクトある建設的な議論をお願いします。

## 📝 ライセンス

PR を提出することで、あなたの contribution が本 repo の [MIT License](LICENSE) の下で配布されることに同意したものとみなします。
