# Phase 04 — Step 1 教材化 (Memory)

> **このフェーズの本質**: 学習者に「Memory が確かに効いた!」を **3 重 (Chat ログ + 物理ファイル中身 + 新規セッションの振る舞い差分)** で実感させる Phase。
> Step 1 = 「Memory に triage パターンを覚えさせる → ローカルディスク上の物理 Markdown ファイルを目で見る → 新規 chat で再現を確認 → スコープ自動判別 (Repo vs Global) を体感 → F5 演習で『前提が空だと Copilot が提案を出す』を引き出す → プライバシー観点で削除手順まで」。
> Phase 03 (Step 0) で確立した教材テンプレ (必須 8 セクション + Status badge + Trust thread 伏線) を継承しつつ、**MCP 非依存** Step として §4.5.3 V1-V4 を適用 exempt で扱う最初の Phase。

---

## 1. Phase Goal

### 1.1 主目的
keynote 60 分視聴者が、Step 0 で MCP 接続まで動かした自分の Codespaces で、**約 15 分** の heavy demo (5 sub-step + F5 演習) を完走し、「Copilot Memory がブラックボックスではなく、自分のローカルディスクに人間が読める Markdown ファイルとして書かれる」を体験する。これにより Step 2 ⭐ (Skill ⭐ CTA) への動機を「個人/ローカル/揮発な Memory を **repo/共有/versioned な Skill** に格上げしたい」という形で完成させる。

### 1.2 Phase 完了時に手元にあるもの
1. **`content/step-1-memory/README.md`** — heavy demo (5 sub-step + F5 演習) + §3.5 プライバシー独立節、必須 8 セクション準拠
2. **`docs/planning/VERSIONS.md` §2.6** — Memory tool/パス pin (検証日 2026-04-25、Insider 経路スナップショット)
3. **`content/README.md` 更新** — Step 1 行を ✅ 公開中
4. **`.github/workflows/step-gate.yml` 拡張** — `step-1-gate` job (T-101..**105**)
5. **`step-1-complete` ブランチ** — escape hatch (**repo state only と明記**)
6. **本ドキュメント** (`phase-04-step1-memory.md`) — DoD 全項目 ☑
7. master-plan §9 Phase 04 を ✅ + 改訂履歴

### 1.3 マイルストーン
master-plan §5 の M2 (Step 0-2 公開で keynote CTA カバー) の 2/3。Phase 05 (Step 2 ⭐) で M2 完成。本 Phase 単独では学習者一般公開はしない (Step 0+1 で Lite プロファイルが離脱しても CTA 到達できないため)。

---

## 2. Scope

### 2.1 IN SCOPE
| 対象 | 何を作るか |
|---|---|
| `content/step-1-memory/README.md` | heavy demo (5 sub-step + F5 演習) + §3.5 プライバシー独立節、必須 8 セクション準拠 |
| `docs/planning/VERSIONS.md` §2.6 | Memory tool 名 (`Chat: Show Memory Files`) + パス pin (Insider 経路、検証日 2026-04-25) |
| `content/README.md` | Step 1 行 🚧 → ✅ |
| `.github/workflows/step-gate.yml` | `step-1-gate` job 追加 (T-101..105) |
| `step-1-complete` branch | main 派生 push (**repo state only と明記**) |
| 本ドキュメント | Phase 04 詳細計画書 |
| master-plan §9 | Phase 04 を 🟡 → ✅ |

### 2.2 OUT OF SCOPE (Phase 05+)
- Step 2-6 本文 (Skill / Surface / Automate / Multi-engine / Gate)
- Skill 化 (`SKILL.md`、Phase 05)
- Cloud Agent / Custom Agent (Phase 06/09)
- gh aw triage workflow (Phase 07)
- 実機スクリーンショット (Phase 11)
- Step 2 README の Memory bootstrap 注記更新 (Phase 05 で実施、本 Phase では Step 1 §6 で誘導のみ)

### 2.3 設計判断 (D1-D18)

ユーザー判断 (D1-D2) と私の判断 (D3-D18):

| # | 論点 | 採用案 | 根拠 |
|---|---|---|---|
| **D1** | デモ厚さ | **heavy** = 5 sub-step + F5 演習 (約 15 分) | ユーザー判断 |
| **D2** | 削除/プライバシー位置付け | **§3.5 独立セクション** | ユーザー判断 |
| D3 | MCP 依存性 | **MCP 非依存** = master-plan §4.5.3 V1-V4 適用 **exempt**。本計画書 §10 で 4 項目チェックリストの明示マッピング | E6 (Memory は client-side ローカル機能、GitHub MCP server を呼ばない) |
| D4 | escape hatch | `step-1-complete` を main 派生で push。**branch の意味は repo state only と明記** (Memory はローカル状態なので branch には乗らない) | rubber-duck Critical 1、master-plan P3 |
| D5 | 必須 8 セクション | 学習目標 / 前提 / 手順 / 完了確認 / 詰まったら / 次の Step / 参考 + Status badge (Phase 03 D6 テンプレ継承) | Phase 03 で固定、Phase 04+ 全 Step に適用 |
| D6 | 5 sub-step 構成 | A: 植え付け (repo) → B: ファイル可視 → C: 新規 chat 再現 → D: スコープ違い (preferences) → E: F5 演習 (空 Memory → 提案を引き出す) | E6 RESULT §5.1 + phase-03-step0.md §10.3 |
| D7 | ファイル可視の主導線 | **`Chat: Show Memory Files` (コマンドパレット) を主導線**。直接パス (`~/.vscode-server*/...`) は fallback として §3.B 末尾と §5 に提示 | rubber-duck Important 4、E6 §7 |
| D8 | スコープ違い演習 | Repo (`issue-conventions.md`) + Global (`preferences.md`) の 2 ファイル両方を実機で見せる | E6 §2.2 (Copilot のスコープ自動判別が最も "賢い" を実感する瞬間) |
| **D9** | F5 演習の状態管理 | §3.E 内に **(1) reset 用 mini-step (Memory rm) → (2) F5 演習本体 → (3) restore 用 reseed (再植え付け prompt コピペ)** を 3 段で内包。これで線形読者でも前提崩れせず、Step 1 終端で Memory が空にならない | rubber-duck Critical 2 |
| D10 | Memory tool 名/パス pin | `VERSIONS.md §2.6` 新設 (検証日 2026-04-25、Insider 経路スナップショット)。`Chat: Show Memory Files` コマンド名と両スコープのパステンプレを記録 | R03-1 と同型、Stable は Phase 10 で再検証 |
| D11 | VS Code Stable 動作 | E6 §5.5 のとおり Stable は未検証。**主導線 = コマンドパレット** にすることでパス差分の影響を最小化、§5 に「Insider 検証済、Stable 動作見込み、パスは `vscode-server` (Stable) / `vscode-server-insiders` (Insider) で異なる」と注記 | rubber-duck Important 4 |
| D12 | Trust thread 伏線 | 冒頭 IMPORTANT に **Step 1 固有の文言** を入れる: 「Memory はあなたの **ローカルディスク** に物理ファイルとして書かれます (= ブラックボックスではない)。Step 6a で『**人間が最後に判断する**』へ繋がります」 | rubber-duck Important 4 (Step 0 文言の重複回避) |
| D13 | step-gate.yml 拡張 | 既存 `step-0-gate` に並ぶ形で `step-1-gate` 追加 (T-101..**105**)。**T-105 で Step 1 固有の文言を regex で gate**。paths trigger は現状の `content/**` を維持 (= **all-step gate** 運用と本計画書で明文化) | rubber-duck Important 3, 7 |
| D14 | content/README.md 動線 | Step 1 行 🚧 → ✅ (Step 2-6 はそのまま 🚧) | Phase 03 D14 と同型 |
| D15 | Commits 数 | **5 commits** (Phase 03 と同型リズム) | レビュー粒度 |
| **D16** | Step 2 への Memory bootstrap | Step 1 §6 (次の Step) に「Step 2 を始めるにあたり Memory が空でも OK。本 Step §3.A の植え付け prompt をコピペで再現可能」と明記。Step 2 README 修正は Phase 05 で実施 | rubber-duck Critical 1 (escape hatch 経由学習者ケア) |
| **D17** | Memory vs Skill 対比 | §6 (次の Step) に対比表: **Memory = 個人 / ローカル / 揮発 vs Skill = repo / 共有 / versioned**。Step 2 ⭐ CTA への自然接続 | rubber-duck Important 5 |
| D18 | prereq P7 との責務分担 | prereq P7 = 一文の事前知識 / Step 1 = 実演 + 削除手順。Step 1 §2 で P7 をリンク参照、再説明はしない | rubber-duck Optional 1 |

---

## 3. ディレクトリ構造 (本 Phase 完了時の差分のみ)

```
.github/workflows/step-gate.yml      # 拡張: step-1-gate job 追加 (T-101..105)、paths は現状維持 (all-step gate)
content/
├── README.md                        # 更新: Step 1 行 ✅
└── step-1-memory/
    └── README.md                    # 全面書き換え (placeholder → heavy demo + privacy 独立節)
docs/planning/
├── 00-master-plan.md                # 更新: §9 Phase 04 ✅、改訂履歴
├── VERSIONS.md                      # 更新: §2.6 Memory tool/パス pin (新設)
└── phase-04-step1-memory.md         # 本ドキュメント (新規)

# branches:
#   main                             (本 Phase の全 commit)
#   step-1-complete                  (新規 escape hatch、main 派生、repo state only)
```

---

## 4. 実装タスク (5 commits / 線形依存)

| C# | Commit | 主ファイル | 自動テスト |
|---|---|---|---|
| **C1** | `docs(planning): start Phase 04 — add phase-04-step1-memory.md` | 本ファイル新規、master-plan §9 Phase 04 を 🟡、改訂履歴着手行 | smoke 影響なし (paths 外) |
| **C2** | `docs(content): write Step 1 — Memory (heavy demo + privacy section)` | `content/step-1-memory/README.md` 全面書き換え (D6/D9/D12/D17 反映)、`VERSIONS.md` §2.6 新設 (D10)、`content/README.md` Step 1 ✅ | (C3 の T-101..103/T-105 で連携) |
| **C3** | `ci(step-gate): add Step 1 job (T-101..105)` | `.github/workflows/step-gate.yml` に `step-1-gate` job 追加 (D13)、T-105 regex gate を含む | step-gate.yml 緑化 |
| **C4** | `chore(branch): publish step-1-complete escape hatch` | `step-1-complete` branch を main から派生 push (D4) | T-104 緑化 |
| **C5** | `docs(planning): close Phase 04 — Step 1 published, DoD ☑` | 本ファイル DoD ☑、master-plan §9 ✅、改訂履歴 | smoke + step-gate 緑 |

---

## 5. テスト戦略 (L2 Step Gate Test)

| ID | 層 | 対象 | 方法 |
|---|---|---|---|
| T-PHASE04-101 | L2 | Step 1 README 必須 8 セクション + §3.5 privacy | bash assert: §1〜§7 ヘッダ + Status badge + `^### 3\.5\b` 正規表現存在 |
| T-PHASE04-102 | L2 | Step 1 内部 link 死活 | step-0 と同型 grep ベース、相対 path のみ (外部 URL/anchor 除外) |
| T-PHASE04-103 | L2 | Step 1 Done checklist >=4 項目 | `- [ ]` カウント >=4 |
| T-PHASE04-104 | L2 | escape hatch branch | `git ls-remote --heads origin step-1-complete` |
| **T-PHASE04-105** | L2 | Step 1 固有文言の regex gate (D13) | bash grep: `Chat: Show Memory Files` / (`Created memory file` or `Read memory`) / F5 fallback (例: `提案が出ない` or `もし.*提案`) — いずれも README 内に存在すること |
| T-PHASE04-Manual | (手動) | ユーザー実機完走 | 5 sub-step + F5 演習 (reset → 演習 → restore) を完走、Repo + Global 両 memory 物理ファイル目視、新規 chat で `Read memory` トレース確認、§3.5 削除→再生成リセット動作確認 |

`paths` trigger 設計: 現状の `content/**` を維持 = **all-step gate 運用** (本計画書で明文化、rubber-duck Important 3 への回答)。Step 2-6 job 追加時も同方針。Phase 11 で paths 細粒化を再検討。

runner: self-hosted (Phase 11 で smoke と同時に ubuntu-latest 化、R03-7 と同条件)

---

## 6. Phase 04 完了基準 (Definition of Done)

### 6.1 ハードゲート (全項目 ☑ で Phase 05 着手可能)

#### 動作確認
- [ ] ユーザー実機で 5 sub-step + F5 演習 (reset → 演習 → restore) 完走、Repo + Global 両 memory 物理ファイル目視確認、新規 chat で `Read memory [path]` トレース確認、§3.5 削除→再生成でリセット動作確認  ← **E6 = ユーザー手動確認待ち**
- [x] §3.5 プライバシー独立節のファイルパス/`rm` 手順がコピペで動作 (Stable/Insider 両パステンプレが §5 に存在)
- [ ] step-gate.yml `step-1-gate` job 緑化 ← **R03-7 持ち越し**: self-hosted runner 復旧時に自動緑化 (機能影響なし、Phase 11 で ubuntu-latest 化と同時解消予定)
- [x] T-105 regex gate 緑化 (ローカルセルフチェック PASS、CI 緑化は R03-7 復旧時)

#### 構造確認
- [x] Step 1 README 必須 8 セクション + §3.5 privacy 存在 (T-101)
- [x] Done checklist 4 項目以上 (T-103)
- [x] alt text 英語 (mermaid 含む)
- [x] `step-1-complete` branch push 済 (T-104)
- [x] `content/README.md` Step 1 行 ✅
- [x] `VERSIONS.md` §2.6 追記済 (Memory tool/パス + 検証日 2026-04-25)

#### 計画整合
- [x] 本ドキュメント DoD 全 ☑
- [x] master-plan §9 Phase 04 ✅
- [x] master-plan 改訂履歴更新

### 6.2 ソフトゲート (任意)
- [x] Step 1 体感 ~15min 以内 (heavy demo の見積、Phase 10 で第三者検証)
- [x] Trust thread 伏線が Step 1 固有文言で冒頭に明示 (Step 0 文言とは差別化、Step 6a で回収)
- [x] D17 Memory vs Skill 対比表が §6 に存在 (Step 2 CTA への自然接続)
- [x] D16 Memory bootstrap 誘導が §6 に存在 (escape hatch 経由学習者ケア)

### 6.3 Phase 05 着手の最低条件
- 6.1 ハードゲート 全 ☑ または ⚠ (step-gate.yml 自動緑化のみ runner 復旧待ち、機能影響なし)
- ユーザー手動完走確認

---

## 7. リスク (Phase 04 固有)

| # | リスク | 確率/影響 | 対処 |
|---|---|---|---|
| **R04-1** | Memory 仕様変更 (Public Preview / changelog drift) でファイルパス/トレース表記が変わる | 中/中 | VERSIONS §2.6 で 2026-04-25 時点 pin、Phase 10 で再検証、§5 に「changelog 確認」誘導 |
| **R04-2** | VS Code Stable で物理ファイルパスが Insider と異なる (`vscode-server` vs `vscode-server-insiders`) | 中/中 | **主導線をコマンドパレット (`Chat: Show Memory Files`) にする**ことで影響軽減、§3.B / §5 に両パス併記 fallback |
| R04-3 | workspace ID が学習者環境ごとに異なる | 高/低 | 教材本文ではワイルドカード `<workspace-id>` で表記、`find ~/.vscode-server*/data -path '*memory-tool*'` を §5 に提示 |
| **R04-4** | F5 演習の前提崩れ (Memory が残っている / Memory が消えたまま終わる) | 中/中 | **D9 で §3.E 内に reset → 演習 → restore の 3 段構造を埋め込み**、線形読者でも保証 |
| R04-5 | Memory 反映が瞬時に出ない (cache?) で §3.C 再現が失敗 | 低/中 | §3.C で「**新規 chat (+ ボタン)** を必ず開く」を強調、`Reload Window` を §5 に提示 |
| R04-6 | Pro 未満プランで Memory 機能が利用不可 | 低/高 | prereq P7 で既明示、§5 に「`Chat: Show Memory Files` がコマンドパレットに出ない場合 = プラン未該当」行を追加 |
| **R04-7** | step-gate.yml runner 復旧待ち (R03-7 継続) | 中/低 | Phase 11 で smoke と同時に ubuntu-latest 化、本 Phase では機能影響なしと記録 |
| R04-8 | Heavy demo (15min) が標準 30min 内に収まらない (Step 0 と合算) | 中/中 | Step 0 が 15 分、合算 30 分。E6 §5.1 の 5 step 設計で精緻に時間配分、Phase 10 で計測 |
| R04-9 | F5 演習で Copilot が Memory 作成提案を出さない (個体差) | 中/中 | §3.E に「もし提案が出ない場合は『この内容を覚えて』と明示」のフォールバック誘導を併記 (T-105 で gate) |
| **R04-10** | セッション持続性: Codespace 再作成 / 別クライアント / 後日再開で Memory が見えない | 中/中 | §5 に「**同一 Codespace / 同一クライアント前提**。見えない場合は再作成 or §3.A の再植え付け」救済。learnings §5.5 (クラウド同期未確認) を Phase 10 で再検証候補 |
| **R04-11** | escape hatch (`step-1-complete`) で Step 2 に飛ぶと Memory 状態が無く、Step 2 が動機を失う | 中/中 | **D16 で §6 に Memory bootstrap 誘導を明記**。Phase 05 で Step 2 README 側にも対応反映 |

---

## 8. 進め方 (5 commits)

1. **C1**: 本ドキュメント新規 + master-plan §9 Phase 04 を 🟡 + 改訂履歴 → push (smoke 影響なし)
2. **C2**: `content/step-1-memory/README.md` 本文執筆 + `VERSIONS.md` §2.6 新設 + `content/README.md` Step 1 ✅ → push
3. **C3**: `step-gate.yml` `step-1-gate` job 追加 (T-101..105) → push → 緑化反復
4. **C4**: `step-1-complete` branch を main から派生 push → T-104 緑化
5. **C5**: DoD ☑ + master-plan §9 ✅ + 改訂履歴 → push、ユーザーへ手動完走確認依頼

---

## 9. 参考 (内部資料)

- master-plan §4 (Phase 04 = Step 1)、§4.5 (Step 1 必須 / Lite 離脱可能)、§4.5.3 (MCP verification block — Phase 04 は **exempt**)、§9 (進捗)
- learnings §5 (Memory 5 章、★最重要発見)、§9.5 (F5 前提欠落 UX)
- E6 RESULT.md (★PASS、§2 物理ファイル、§3 Read memory トレース、§5 推奨デモ、§6 削除 UX、§7 `Chat: Show Memory Files`)
- phase-03-step0.md §10.2 (Phase 04+ 計画書チェックリスト)、§10.3 (Phase 04 設計余地として F5 演習が示唆)
- VERSIONS.md §2.5 (Phase 03 で確立した tool 名 pin パターン、§2.6 はこれを継承)
- 教材テンプレ source-of-truth: `content/step-0-setup/README.md` (必須 8 セクション + Status badge + Trust thread 伏線)
- prereq P7 (Memory が物理ファイル) ─ Step 1 §2 でリンク参照のみ (D18)

---

## 10. Phase 03 §10.2 チェックリスト適用結果 (D3 明示マッピング)

Phase 03 §10.2 が定めた Phase 04+ 計画書チェックリスト 4 項目に対する本計画書の応答:

| # | チェック項目 | Phase 04 (Step 1 Memory) の応答 |
|---|---|---|
| 1 | MCP 利用 Step か? | **No** — Step 1 は Copilot Memory のみ利用、GitHub MCP server tools (`list_issues` 等) を呼ばない |
| 2 | Yes の場合: §「前提条件」に master-plan §4.5.3 V1-V4 への準拠を明記 | **N/A** (項目 1 = No のため) |
| 3 | Yes の場合: 利用する MCP ツールの最小セットを明示 | **N/A** (項目 1 = No のため) |
| 4 | §5 Troubleshooting に「Trust thread が出ない」行を必ず含める | **読み替え適用**: Step 1 では Trust thread 自体は不出現 (MCP 経由でないため)。代替として §5 に Memory 機能未利用時 (Pro 未満 / コマンド未表示 / 反映遅延 / セッション持続性 R04-10) のトラブル行を必ず含める。Trust thread 伏線回収は Step 6a (Phase 09) に委譲 |

---

## 11. Phase 05+ への申し送り

> **位置付け**: Phase 04 (Step 1 Memory) で確立した設計パターンと、Phase 05 以降の各 Phase 計画書執筆時に必ず確認するチェックリスト。Phase 03 §10 と同型構造。詳細根拠は `learnings.md §10` を読むこと。

### 11.1 Phase 04 で確立した設計パターン (Phase 05+ で踏襲)

| # | パターン | 根拠 | Phase 05+ での適用先 |
|---|---|---|---|
| **P04-1** | **MCP 非依存 Step は §4.5.3 V1-V4 を §10 で exempt 明示マッピング** (本計画書 §10 が参照実装) | D3 / rubber-duck Important 6 | Step 1 / 2 / 3 / 5 (= Memory / Skill / Where to Run / Multi-engine が MCP 非経由なら同方式)。Step 2 は SKILL.md を `git commit` する経路で MCP 利用するか分岐で判定 |
| **P04-2** | **escape hatch branch (`step-N-complete`) は repo state only と明記**、ローカル状態 (Memory / 拡張設定など) は branch に乗らない事実を README §4 で警告し、§6 に bootstrap 動線を併記 | D4, D16 / rubber-duck Critical 1 | Step 2 以降の全 escape hatch。Step 2 = SKILL.md commit 済 repo state、bootstrap 不要 (= Memory と違って repo に乗る)。Step 3+ で再び localクライアント状態が出てきたら同型対処 |
| **P04-3** | **heavy demo (≥15min) の F5 演習は reset → 演習 → restore の 3 段構造**、線形読者でも前提崩れせず Step 終端を「次 Step に必要な状態」に固定 | D9 / rubber-duck Critical 2 | Step 4 (gh aw) / Step 6 (Gate) で前提を一旦壊して見せる演習に同方式適用 |
| **P04-4** | **§3.5 のような独立節は「ユーザーが個別関心で読み返す」用途**。プライバシー / セキュリティ / 削除手順など、フロー外で参照されるものは ## 3.x ではなく **### 3.X (= 手順節の中だが番号で独立感)** で配置 | D2 / ユーザー判断 | Step 4 でのワークフロー停止 / Step 6a での Required Check 解除手順など |
| **P04-5** | **all-step gate 運用**: `step-gate.yml` の paths trigger は `content/**` を維持、Step を 1 つ変えると全 step-N-gate job が回る = early signal 重視 | D13 / rubber-duck Important 3 | Phase 05 / 06 / 07 / 08 / 09 すべて踏襲、Phase 11 で paths 細粒化を再検討 |
| **P04-6** | **Step 固有 regex gate (T-N05 枠)** で「設計判断を CI で守る」(本 Phase の T-105 = `Chat: Show Memory Files` / `Created memory file` or `Read memory` / F5 fallback) | D13 / rubber-duck Important 7 | Step 2 = `^name:` `^description:` (frontmatter 必須キー) / `\.github/skills/` パス / `git commit` 動詞。Step 3 以降同様 |
| **P04-7** | **Trust thread 伏線は Step 固有文言で差別化** (Step 0 = Trust UI / Step 1 = Memory ローカル化 / Step 6a = 人間が最後に判断) | D12 / rubber-duck Important 4 | Step 2 = "Skill = repo に commit する = 人間レビュー対象になる" / Step 4 = "automation を gh aw で repo に commit する = 動作が版管理される" |
| **P04-8** | **VERSIONS.md §2.X 連番で tool 名/パス pin** (§2.5 = MCP / §2.6 = Memory)、検証日 + 検証クライアント + 物理パス Insider/Stable 併記をテンプレ化 | D10 / Phase 03 §2.5 継承 | Step 2 = SKILL.md 検出パス (`.github/skills/<name>/SKILL.md`) と必須/推奨 frontmatter キーを §2.7 で pin、Step 4 = gh aw spec を §2.8 で pin |
| **P04-9** | **prereq との責務分担**: prereq P7 のような事前知識の一文は prereq 側に置き、Step 本文ではリンク参照のみ (重複説明禁止) | D18 / rubber-duck Optional 1 | Step 2 = prereq P9 (Skill 機能の 1 文紹介) を新設して Step 2 §2 から参照 (Phase 05 W1 で実施) |
| **P04-10** | **content/README.md の "🪂 escape hatch" セクションは Step を公開するたびに更新** (Phase 04 hotfix C6 で Phase 03 漏れを回収済) | C6 (Phase 04 hotfix) | Phase 05 W1 で `step-2-complete` 行追加、Phase 06+ も同様に毎 Phase 更新 |

### 11.2 Phase 05+ 計画書チェックリスト (各 Phase 計画書着手時に確認)

Phase 03 §10.2 のチェックリストを Phase 04 で拡張し、以下を **8 項目** に固定:

- [ ] **MCP 利用 Step か?** (Step 0/4/6 = Yes、Step 1/2/3/5 = No / 但し Step 2 で `git commit` が MCP 経由なら Yes 寄り)
- [ ] Yes の場合: 計画書 §「前提条件」に `00-master-plan §4.5.3` の MCP verification block 4 項目への準拠を明記
- [ ] Yes の場合: その Step で利用する MCP ツールの最小セットを明示 (= V3 で ON にする対象)
- [ ] No の場合: 計画書 §10 で **§4.5.3 V1-V4 の exempt 明示マッピング** (本 Phase 04 §10 が参照実装)
- [ ] §5 Troubleshooting に **「Trust thread が出ない」行** (MCP 利用) または **「機能未利用時のトラブル行」** (MCP 非利用、本 Phase の R04-6/R04-10 が参照) を必ず含める
- [ ] **escape hatch branch の意味を明記** (repo state only / クライアントローカル状態は乗らない)、ローカル状態がある場合は §6 bootstrap 動線併記
- [ ] **Step 固有 regex gate (T-N05)** を `step-gate.yml` `step-N-gate` job に含める
- [ ] **VERSIONS.md §2.X** に該当 Step の tool 名/パス pin を新設 (検証日 + Insider/Stable 併記)

### 11.3 Phase 05 (Step 2 ⭐ Skill) への具体示唆

keynote CTA の核なので最も重要。本 Phase で確定した Step 1 → Step 2 接続点と Phase 05 計画書執筆時の留意点:

| # | 示唆 | 由来 | Phase 05 での具体実装 |
|---|---|---|---|
| **S05-1** | **Step 2 README §2 (前提) に Memory bootstrap 注記を必須化** | D16 / R04-11 | Step 1 §6 から飛んできた学習者が Memory 空で困らないよう、Step 2 §2 で「Memory が空なら Step 1 §3.A の植え付け prompt をコピペ」と明示 |
| **S05-2** | **Memory vs Skill 対比表は Step 1 §6 に既存** (D17)、Step 2 README §1 (学習目標) で「Step 1 で見た Memory を repo 資産に格上げする」と動機を明文化 | D17 | Step 2 README §1 冒頭で「個人/ローカル/揮発 → repo/共有/versioned」のフレーズを反復 (Trust thread 伏線回収の準備) |
| **S05-3** | **SKILL.md spec は E2 RESULT で確定済 (✅ PASS)**、Phase 05 で追加 PoC 不要 | E2 RESULT §3 | Phase 05 計画書 §3 (設計判断) の根拠として E2 RESULT §3.1 (frontmatter 全フィールド) と §3.2 (2 段階フィールドセット) を直接引用 |
| **S05-4** | **§4.5.3 V1-V4 適用判定**: SKILL.md を `git add` `git commit` する経路で MCP `create_or_update_file` 使うなら applicable、Codespaces 内で `git` CLI 直接打つなら exempt | P04-1 | Phase 05 計画書 §3 の D-MCP で判断、§10 で exempt or applicable のいずれかを明示マッピング |
| **S05-5** | **T-201..205 = Step 2 固有 regex gate**: `^name:` `^description:` (frontmatter 必須キー存在) / `\.github/skills/` パス言及 / `git commit` 動詞 / Memory bootstrap link (§S05-1 と連動) | P04-6 | C3 commit で `step-gate.yml` に `step-2-gate` job 追加 |
| **S05-6** | **`step-2-complete` branch は SKILL.md commit 済 repo state**、Memory bootstrap は branch に乗らないので §6 で再誘導 | P04-2 | Phase 05 W1 / C4 で main から `SKILL.md` commit 済状態として派生 push |
| **S05-7** | **content/README.md `🪂 escape hatch` セクションに `step-2-complete` 行を追加** | P04-10 | Phase 05 W1 (本 Phase ですでに `step-1-complete` まで反映済の箇所に追記) |
| **S05-8** | **prereq P9 新設**: 「Skill = `.github/skills/<name>/SKILL.md` に書く再利用可能技能、frontmatter 必須キーは `name` / `description`」(1 文) | P04-9 | Phase 05 W1 で `prerequisites.md` 更新 |

### 11.4 Phase 11 (Dogfooding) で再検証する候補

本 Phase で見込みで書いた / 環境制約で未確認の項目:

- VS Code Stable での物理ファイルパス (`vscode-server` / Insider 経路でのみ検証)
- Memory のクラウド同期挙動 (E6 §5.5 既明示)
- F5 演習で Copilot 応答が個体差で出ない場合のフォールバック実機 (R04-9)
- Codespace 再作成 / 別クライアント / 後日再開での Memory 持続性 (R04-10)
- Step 0 + Step 1 合算 30 分以内に収まるか (R04-8)

---

## 12. 改訂履歴

| 日付 | 変更内容 |
|---|---|
| 2026-04-25 | 初版作成 (Phase 04 着手)。D1-D2 はユーザー判断 (heavy demo + §3.5 privacy 独立)、D3-D18 は私の判断。rubber-duck レビューで Critical 2 件 + Important 7 件を反映 (D9/D16/D17 新設、D7/D11/D12/D13 強化、R04-10/R04-11 追加、§10 §10.2 適用マッピング新設、T-105 追加)。5 commits 構成、L2 Step Gate Test 拡張 (T-101..105)、escape hatch `step-1-complete` (repo state only) |
| 2026-04-25 | Phase 04 close (C5)。5 commits (`aec289c` C1 / `26b0140` C2 / `ebe3638` C3 / `step-1-complete` branch C4) と本 commit (C5) を完了。DoD ハードゲートのうち 構造確認 6 項目すべて ☑、計画整合 3 項目すべて ☑、ソフトゲート 4 項目すべて ☑ (D17 対比 / D16 bootstrap / Trust thread Step 1 固有 / heavy 設計済)。動作確認は ① ユーザー手動完走 (E6) と ② step-gate.yml CI 緑化 (R03-7 持ち越し、機能影響なし) のみ持ち越し、Phase 05 着手の最低条件 (6.3) は満たす。ローカルセルフチェック T-101..105 すべて PASS で commit ゲート済 |
| 2026-04-25 | Phase 04 hotfix (C6)。Phase 04 詳細レビュー中に **積み残し 1 件** を発見・修正: `content/README.md` の "🪂 escape hatch ブランチ" セクション (line 52-61) が Phase 02 当時の暫定文言 (「Phase 03 以降で順次提供」「Phase 02 ではまだ作成されていません」) のまま残存していた。Phase 03 で `step-0-complete` を push した時点で更新するべきだった漏れを Phase 04 で回収。修正後: ① 公開済 branch 一覧表 (`step-0-complete` / `step-1-complete`) を明示、② Memory bootstrap への動線を IMPORTANT で強調 (D16 を content/README.md レベルでも徹底)、③ コマンド例を `step-1-complete` に更新。template repo 同期は workshop repo 自体が `isTemplate: true` のため main push で自動最新化、追加作業不要と確認 |
