# Test Plan Template (後続 Phase で使用)

> **Purpose**: Phase 02 以降の各 Phase で「テスト戦略」セクションを書くときの雛形。Phase 01 §7 の 3 層テスト戦略 (L1 Smoke / L2 Step Gate / L3 E2E) に準拠する。

---

## 1. このフェーズで実装するテスト

| ID | 層 | 対象 | 種類 | 自動 / 手動 |
|---|---|---|---|---|
| T-PHASE-001 | L1 Smoke | (例: devcontainer build) | (例: GH Actions matrix) | 自動 |
| T-PHASE-002 | L2 Step Gate | (例: Step 2 完了時 repo 状態) | (例: bash assertions) | 自動 |
| T-PHASE-003 | L3 E2E | (例: Issue → triage 完走) | (例: schedule trigger + gh CLI 検証) | 自動 |

## 2. 各テストの定義 (テンプレート)

### T-PHASE-XXX

- **目的**: 何を担保するか (1 文)
- **入力**: 前提となる repo / branch 状態
- **手順**: 番号付きステップ (実行可能)
- **期待結果**: PASS と判定するための具体的観測
- **失敗時**: ロールバック / 再実行 / 教材文章修正のどれか

## 3. CI 統合方針

- すべての L1 / L2 テストは GitHub Actions で `on: pull_request` 実行
- L3 (E2E) は `on: schedule` (週 1 cron) または `on: workflow_dispatch`
- 教材リポ自身に branch protection を Phase 11 で設定し、L1 + L2 を Required Check に

## 4. テストデータ

- seed Issue / sample SKILL.md / fixture commit など、テストで使う固定データの保管場所を明示
- 保管先候補: `tests/fixtures/`

## 5. 教材体験との整合

- 学習者が **手で** やる操作のうち、CI で **再現可能な部分** をテスト化する
- 学習者ごとに環境が違う部分 (Cloud Agent / Memory) は **テストしない** (代わりに録画 / FAQ)

## 6. このフェーズの "Acceptance Test" (Phase 完了基準)

- [ ] 上記テストが全て PASS
- [ ] PASS が `main` にマージされた状態で確認できた
- [ ] ロールバック手順が記述されている
- [ ] 学習者向け文章 (Step.md 等) と CI assertion が一致している
