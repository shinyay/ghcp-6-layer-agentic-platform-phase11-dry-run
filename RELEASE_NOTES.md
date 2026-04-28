# Release Notes

## v1.0.0 — 初版公開リリース (2026-04 / Phase 11 完了時点)

GitHub Copilot の **6 層 Agentic Platform** を 1 つの Issue Triage シナリオを通じて Step 0 → Step 6 まで段階的に体験するセルフラーニング型ワークショップの初版です。

### ✨ 含まれる教材

- **Step 0 — Setup**: Codespaces 起動 / Copilot 認証 / GitHub MCP Server 接続 (Layer 0)
- **Step 1 — Memory**: Copilot Memory に triage パターンを蓄積 (Layer 1)
- **Step 2 — Skill ⭐ keynote CTA**: `SKILL.md` を書いて publish (Layer 2)
- **Step 3 — Where to Run**: 同 Skill を IDE Chat / Copilot CLI / Cloud Agent から呼ぶ (Layer 3)
- **Step 4 — Automate**: `gh aw` で `issues.opened` をトリガに自動起動 (Layer 4)
- **Step 5 — Multi-engine** (任意): engine 切替 (Copilot / Claude / Codex) (Layer 5)
- **Step 6 — Gate**: Required Review Gate (heavy) + Custom Agent (`.agent.md` light appendix) (Layer 6)

### 🎯 学習者プロファイル

- keynote CTA だけ達成: Step 0 → 1 → 2 で離脱可
- 基本ツアー: Step 0 → 1 → 2 → 3 → 4 → 6
- 発展題材: Step 0 → 1 → 2 → 3 → 4 → 5 → 6

### 📦 同梱

- `LICENSE` (MIT)
- `CONTRIBUTING.md` (Issue / PR / 開発フロー)
- `SECURITY.md` (脆弱性報告ポリシー)
- `.devcontainer/devcontainer.json` (Codespaces で `gh`, `gh aw v0.68.3`, `jq` pre-install)
- `.github/workflows/{step-gate,smoke,pages}.yml` (`runs-on: ubuntu-latest`、CI green)
- `.github/ISSUE_TEMPLATE/{bug,feature,feedback}.md` + `config.yml`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `content/**` 全 7 Step + prerequisites
- `docs/planning/**` 設計 / 検証 / Phase ドキュメント (Phase 01〜11)

### 🔬 開発過程

11 Phase + 6+ rubber-duck review で構築:

| Phase | 内容 | Milestone |
|---|---|---|
| 01 | 現物検証 / 仕様確定 | — |
| 02 | リポジトリ骨格 / 共通基盤 | M1 |
| 03 | Step 0 (Setup) | — |
| 04 | Step 1 (Memory) | — |
| 05 | Step 2 (Skill) ⭐ | M2 (keynote CTA 達成可) |
| 06 | Step 3 (3 surfaces) | — |
| 07 | Step 4 (gh aw) | — |
| 08 | Step 5 (Multi-engine) | M3 |
| 09 | Step 6 (Gate) | M4 (content-complete) |
| 10 | シナリオ完成 (静的品質推敲) | M4 維持 |
| 11 | Dogfooding + Public Release Hardening | **M5 (release-ready)** |

### ⚠️ 既知の制約

- **Step 3 §3.C (Cloud Agent)** は **Pro+ / Business / Enterprise plan** 必須。Pro 単体プランは degraded complete (screenshot + 文字証跡で代替) で完走可能
- **Step 5 (Multi-engine)** は任意 Step。`ANTHROPIC_API_KEY` / `OPENAI_API_KEY` / `CODEX_API_KEY` を持たない学習者は Copilot baseline 1 engine のみで minimum done
- **`.agent.md` (Step 6b)** = canonical sample read/search only。Required Check への直接連携は Path A/B GA 待ち (= R11)

### 🙏 Acknowledgement

11 Phase の開発過程で実施した rubber-duck review (#1〜#3 各 Phase) と、それを実装に反映した iterative refinement パターンが本教材の品質基盤です。設計 / 検証 / 改訂履歴は `docs/planning/` 配下に全 commit trail として残しています。

### 📜 License

[MIT License](LICENSE) — 教材の再配布 / 改変 / 商用利用を許可しています。
