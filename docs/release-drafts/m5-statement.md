# C6 で master-plan に貼り付ける M5 達成宣言 文案 (C6-prep-3)

> **使い方**: C6 close commit 時に master-plan §5 milestone block / §9 進捗 / §改訂履歴 / §11.5 (もしあれば) に貼り付け。`<C6 SHA>` は C6 commit 直後に置換。

---

## 案 1: §5 milestone block 追加 (M4 完了 entry の直後に追記)

### M5 = release-ready 達成 (`<C6 SHA>`、`<YYYY-MM-DD>`)

Phase 11 = Dogfooding + Public Release Hardening 完了により、**本教材は OSS として公開可能な release-ready 状態に到達**した。具体的には以下を満たす:

| 達成軸 | evidence |
|---|---|
| 軸 1 = Dogfooding | 本人実機 1 take 通し完走、E10 (全 7 Step 連続完走) 1 marker + E11 (Setup/Minimum/Full/Degraded/Workflow-Advanced) 5 variant markers = 計 6 evidence rows 回収済 (詳細 `docs/planning/phase-11-dogfooding-release.md` §10.4) |
| 軸 3 = Public Release Hardening | LICENSE (MIT) + README minimal 公開トーン化 + CONTRIBUTING + SECURITY + RELEASE_NOTES + ISSUE_TEMPLATE + workflow ubuntu-latest 化 (R03-7 解消、計 9 jobs 緑) + tag `v1.0.0` + GitHub Release + repo public 化 |
| 静的品質 | broken-link 0 件 (whitelist 適用後) + external URL HTTP status check PASS + a11y 検査 PASS + secret scan #2 (本家 + playground) PASS |
| review プロセス | rubber-duck #1 (計画レビュー) + #2 (8 観点 final review、3B + 7I + 4S 全反映) + #3 (post-close review、必須) 完了 |

**録画は Phase 12+ に完全移送** (2026-04-26 ユーザー判断)。本 release は録画なしで OSS 公開可能版として hand-off 可能。

`release-ready` branch SHA = `<C6 SHA>` (C6 commit と一致)。

---

## 案 2: §9 進捗テーブル更新

| Phase | 状態 | 備考 |
|---|---|---|
| 11 | ✅ 完了 (`<C6 SHA>`) | M5 = release-ready 達成、tag `v1.0.0` 発行、GitHub Release publish、public 化済 |

---

## 案 3: §改訂履歴 entry

```
| <YYYY-MM-DD> | **Phase 11 (Dogfooding + Public Release Hardening) 完了 = M5 達成 (`<C6 SHA>`)**: 軸 1 dogfooding (E10 1 + E11 5 = 6 evidence rows 回収) + 軸 3 release hardening (LICENSE / README / CONTRIBUTING / SECURITY / RELEASE_NOTES / ISSUE_TEMPLATE / workflow ubuntu-latest 化 = R03-7 解消 / tag v1.0.0 / GitHub Release / public 化) 全完了。RD#1 + RD#2 (3B + 7I + 4S) + RD#3 全 finding 反映 or 受容明記。録画 = Phase 12+ 完全移送 (2026-04-26 ユーザー判断 baked-in)。`release-ready` branch push 完了 (SHA = C6 一致)。歴史 phase docs (phase-03〜09-*.md) は close-time SoT snapshot として凍結方針継承 (L03)。Phase 12 split criteria gate = 不発動 (release hardening が想定範囲内、N commits < threshold)。 | M5 達成 |
```

---

## 案 4: §11.5 (M5 達成宣言ブロック、もし§11セクションがある場合)

> Phase 11 close commit `<C6 SHA>` (`<YYYY-MM-DD>`) をもって本教材は M5 = release-ready に到達。OSS 公開可能版としての全ハードゲート (DoD §6.1) PASS、tag `v1.0.0` 発行、GitHub Release publish、repo public 化、`release-ready` branch push 完了。録画提供は Phase 12+ に分離。
