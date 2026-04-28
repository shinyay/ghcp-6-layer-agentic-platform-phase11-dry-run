# Step 5 Recordings (Phase 11 以降で提供予定)

> **状態**: **録画提供前の placeholder file** (Phase 08 C2b で配置、broken link 防止。Phase 10 = シナリオ完成 = 静的品質推敲のみ のためコンテンツ追加対象外、Phase 11 dry-run + recording で実コンテンツ化)。
>
> **目的**: API key 不所持の学習者が Step 5 を **録画視聴で代替完走** できるようにする (Step 5 README §3.F = Step 5 fallback complete パス)。

---

## 提供予定コンテンツ (Phase 11 以降で作成)

- `engine-claude-walkthrough.{mp4,webm}` — Claude engine 切替の実機 walkthrough (§3.C 相当、~5-7 分)
- `engine-codex-walkthrough.{mp4,webm}` — Codex engine 切替の実機 walkthrough (§3.D 相当、~5-7 分)
- `compare-runs-readout.md` — 3 engine head-to-head の §3.E 比較表記入例 (録画から書き写し可能なリファレンス)

---

## 録画提供前の代替手段

録画提供前に Step 5 を fallback 完走する場合は以下で代替:

1. **§3.A** = playground repo で実機実行 (engine 別 secret 登録確認まで)
2. **§3.B** (Copilot baseline) = playground repo で実機実行 (Step 4 §3 と同型、API key 不要)
3. **§3.C / §3.D** = 本 placeholder の代わりに、**Step 5 README §3.E Group 1 + Group 3 の構造を Step 5 README 本文 + テンプレート [`../templates/compare-runs.md`](../templates/compare-runs.md) を読み込んで概念理解** で代替 (= 録画なしの構造的代替)
4. **§3.E 比較表** = Group 1 / Group 3 を Step 5 README §3.E のサンプル値で書き写し、Group 2 / Group 4 は省略

→ これで **Step 5 fallback complete** 達成可能 (Phase 08 D08-7 done state 4 状態の 4 番目)。

---

## 申し送り

- 録画作成は **S11-1〜S11-4 (旧 S10-1〜S10-4 / Phase 11 申し送り)** として `phase-08-step5-multi-engine.md §11.5` + `phase-10-scenario-finish.md §11.3` に登録済 (Phase 10 = シナリオ完成 = 静的品質推敲のみ により Phase 11 へ移送、ユーザー判断 2026-04-26)
- 本 placeholder は **Phase 11 の recording commit** で `recordings/` 配下の実コンテンツに置き換える

---

[← Step 5 README に戻る](../README.md)
