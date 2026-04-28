# Step 6 (Gate) — Recordings (placeholder, Phase 11 以降で提供予定)

> このディレクトリは **Phase 11 以降で録画コンテンツを収録する placeholder** です。本 Phase 09 (= Step 6 publish) では README から link 切れにならないように file 自体だけを設置しています (D09-13 / Suggestion 18 = Phase 08 `step-5-multi-engine/recordings/README.md` 同型 D08-10 継承)。Phase 10 = シナリオ完成 = 静的品質推敲のみ のためコンテンツ追加対象外、Phase 11 dry-run + recording で実コンテンツ化 (ユーザー判断 2026-04-26)。

## 収録予定コンテンツ (Phase 11 以降で確定)

| # | 内容 | 補完する README セクション | 想定尺 |
|---|---|---|---|
| 1 | Branch protection rule 作成 → Required Reviewer に Copilot 追加 | §3.B / §3.C | ~3 分 |
| 2 | 実 PR で Required Review Gate (`not satisfied` → `satisfied`) を観察 | §3.D / §3.D.full | ~3 分 |
| 3 | Degraded path 説明 (org policy / Free + Private で `Disabled by policy` を踏んだ場合の screenshot) | §3.A / §4 / §5.1 | ~2 分 |
| 4 | `.agent.md` を `@code-reviewer` で invoke する Local 体験 | §3.F | ~2 分 |

## 対応 E11 marker

- 録画版で完走できる E11 marker = E11-Setup + E11-Minimum + (任意 E11-Full) + Step 6b complete
- E11-Workflow-Advanced (= §3 Appendix B) は **録画対象外** (= 任意発展)
- E11-Degraded は **録画 #3** で代替パス可視化

## 持ち越し方針 (Phase 11 以降)

- **Phase 11**: 上記 4 録画を実際に収録、`recordings/01-branch-protection.mp4` 等として配置 (S11-5 / S11-6 = 旧 S10-5 / S10-6)
- **Phase 11 以降**: UI drift watch (master-plan §6 R5 / R09-1) に応じて録画再撮 (`docs/planning/VERSIONS.md §10` の canonical labels が変わったら再収録)

> Phase 09 close 時点 (M4 = content-complete) では本 file 1 つで link 健全性を担保する。Phase 10 = シナリオ完成 = 静的品質推敲のみ では本 placeholder のコンテンツは更新しない。Phase 11 で録画を配置することで M5 (= 公開リリース版) 軸 1 に該当 (M5 は 3 軸一括達成、§11.5 参照)。
