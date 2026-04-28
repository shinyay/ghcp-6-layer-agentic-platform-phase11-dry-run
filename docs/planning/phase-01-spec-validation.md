# Phase 01 — 現物検証 / 仕様確定

> **このフェーズの本質**: 教材で書く全ての仕様文(「ファイル X を作ってください」「コマンド Y を実行してください」)を、**実機で動作確認した根拠とセット**にする。後続 Phase の "情報源の真実度" を担保する。

---

## 1. Phase Goal

### 1.1 主目的
教材を書く前に、**動かしながら確認すべき不確定事項をゼロ**にする。後続 Phase で「教材を書いていたら spec が違っていた」を起こさない。

### 1.2 Phase 完了時に手元にあるもの
1. **6 つの検証実験(E1〜E6)の結果レポート**(PASS/FAIL + 証跡)
2. **動く Proof of Concept (PoC) 一式**(各実験の最小再現コード/設定)
3. **Pin したバージョン一覧**(MCP / gh aw / Skills 形式 / 等)
4. **更新された Master Plan**(リスク再評価、Out of Scope 調整)
5. **後続 Phase 用の "テスト計画テンプレート"**

---

## 2. Scope

### 2.1 IN SCOPE(検証する)
| 対象 | 何を確定するか |
|---|---|
| **GitHub MCP Server** | Codespaces での接続方式(Remote MCP vs Docker)、auth フロー、triage に必要な toolset |
| **Copilot Memory** | 学習結果の観測方法(panel? prompt?)、Pro プランでの挙動 |
| **Skills (SKILL.md)** | 現行 spec の必須/任意フィールド、frontmatter 構造、invocation 方法 |
| **Cloud Agent + Skill** | Cloud Agent が SKILL.md を読み取る/使う条件、Issue assign からの動作 |
| **gh aw** | workflow Markdown 形式、`safe-outputs` の add-labels/add-comment スキーマ、`engine` 切替、`gh aw compile` 出力 |
| **Custom Agent (.agent.md)** | spec、Required Check への組み込み方式(直接 or Actions ラッパー)|

### 2.2 OUT OF SCOPE(やらない)
- 性能/レイテンシ計測
- セキュリティ監査
- 全エンジン(Claude / Codex / Gemini)の網羅検証 — Copilot のみ必須、他は時間が許せば
- 実際の triage ロジック設計(Phase 05 で実施)
- 教材文面の執筆(Phase 03 以降)
- WorkIQ MCP の実機検証 — Layer 0 で言及するのみ、シナリオ本編で使わない方針
- 多言語化 / アクセシビリティ

### 2.3 不確定事項(Phase 内で議論し決定する)
- Pin するバージョンの "粒度"(タグ vs commit SHA vs ブランチ名)
- PoC 配置場所(`docs/planning/poc/` vs 別 branch vs 別 repo)
- 失敗実験の扱い(諦める vs ワークアラウンド調査 vs Phase 延長)

---

## 3. 検証実験(Experiments)

### 共通ルール
- 各実験は**独立した PoC ディレクトリ**を作り再現可能にする(`docs/planning/poc/EXX-*/`)
- 各実験完了時に **`docs/planning/poc/EXX-*/RESULT.md`** を残す(目的・手順・結果・証跡へのリンク)
- "PASS" 判定基準を実験開始**前**に書く(後付けで甘くしない)
- "FAIL" の場合は必ず**次の選択**を1つ決める:
  - (a) ワークアラウンドで継続
  - (b) 教材から該当 Step を削除
  - (c) Phase 延長して再検証

---

### E1 — GitHub MCP Server 接続検証

**Goal**: Codespaces から GitHub MCP Server に**PAT なし**で接続し、Issue の read/label/comment が動くこと

**前提準備**:
- 検証用の throwaway リポジトリを作成(GitHub UI で手動 or CLI)
- Issue 5件をシード(triage 対象として)

**手順**:
1. Codespaces を起動
2. VS Code の MCP 設定で **Remote MCP** (`https://api.githubcopilot.com/mcp/`) を追加
3. Copilot Chat に `@github` 経由で `list open issues` と依頼
4. 同じく `add label "bug" to issue #1` と依頼
5. 同じく `add comment "test" to issue #1` と依頼
6. Local Docker 方式(`docker run -i --rm ghcr.io/github/github-mcp-server:latest`)も同様に試す

**PASS 基準**:
- ☐ Remote MCP 方式で 3〜5 が成功
- ☐ Docker 方式も 3〜5 が成功(代替手段の確認のため)
- ☐ Codespaces 内で OAuth フローが完結(ブラウザ画面が出る/出ない問題なし)

**FAIL 時の選択**:
- Remote MCP NG → Docker 方式に切替(教材は Docker 前提に)
- 両方 NG → Phase 延長、GitHub サポート/Issue で確認

**Artifacts**:
- `poc/E1-mcp/RESULT.md`
- VS Code `settings.json` の MCP 設定スニペット
- 実際の Chat ログ(成功例)
- スクリーンショット

---

### E2 — SKILL.md 仕様確定

**Goal**: 教材で配布する `SKILL.md` テンプレの根拠となる **現行 spec** を確定

**前提準備**:
- `awesome-copilot` リポジトリ から最新 SKILL.md サンプル 3 件を取得
- 公式 docs の Skills 関連ページを参照(URL を記録)

**手順**:
1. 公式 docs と awesome-copilot の SKILL.md を比較し、frontmatter フィールドを表化
2. 必須フィールド / 推奨フィールド / 任意フィールドを分類
3. 最小有効 SKILL.md(triage 用ではなく "hello world" 用)を作成
4. throwaway リポに commit
5. Copilot Chat / CLI から skill を呼ぶ(invocation の語彙を確認)
6. Cloud Agent 経由でも呼べるかを確認(別実験 E4 と連携)

**PASS 基準**:
- ☐ frontmatter の必須フィールドが 3 ソース(docs / awesome-copilot 2件)で一致
- ☐ 最小 SKILL.md が VS Code Chat から呼べる(`@workspace` / skill 名 / 自然言語のいずれか)
- ☐ Pin する spec バージョン(参照 commit SHA or リリース番号)が決定
- ☐ frontmatter の **不安定 / 変動リスクが高い**フィールドが特定(教材で使わない判断材料に)

**FAIL 時の選択**:
- spec が3ソースで割れる → 公式 docs 優先で pin、awesome-copilot は "サンプルとして紹介" 扱い
- 最小 SKILL.md が呼べない → invocation 方式を変更(IDE 限定にするか、CLI 限定にするか)

**Artifacts**:
- `poc/E2-skill/RESULT.md`
- `poc/E2-skill/sample-hello-skill/SKILL.md`(動作確認済み最小版)
- frontmatter 比較表(docs / awesome-copilot × 3)
- 採用 spec を pin した参照 URL/SHA

---

### E3 — gh aw 動作検証(Markdown → 自動 triage)

**Goal**: gh aw で **issues.opened トリガ → ラベル付与 + コメント投稿** が動くこと

**前提準備**:
- E1 完了済み(MCP / GitHub の操作確認済み)
- gh aw CLI を Codespaces にインストール

**手順**:
1. `gh extension install github/gh-aw` 実行
2. `.github/workflows/triage.aw.md` を最小版で作成(下記参照)
3. `gh aw compile` を実行
4. 生成された `.lock.yml` を git にコミット(または compile を CI に組み込む)
5. push
6. テスト Issue を新規作成
7. 5 分以内にラベルとコメントが付くか観察
8. `engine: copilot` で動作確認後、`engine: claude` に変更してリトライ(API key があれば)

**最小版 triage.aw.md(検証用、未確定)**:
```markdown
---
on:
  issues:
    types: [opened]
permissions:
  issues: read
  contents: read
tools:
  github:
    toolsets: [issues, labels]
safe-outputs:
  add-labels:
    allowed: [bug, enhancement, docs, question, needs-info]
  add-comment: {}
engine: copilot
---

新しく開かれた Issue を分類し、適切なラベルを 1 つ付けてください。
不明な場合は `needs-info` を付けてください。
```

**PASS 基準**:
- ☐ `gh aw compile` がエラーなく完了
- ☐ `.lock.yml` が生成され、Actions が成功
- ☐ Issue にラベルとコメントが自動で付く(5 分以内)
- ☐ `safe-outputs` で `allowed` リストに**ない**ラベルを Agent が選んでも、ブロックされる(ガードレール検証)
- ☐ engine 切替の手順が明確化(成功 or "API key 必要" の確認)

**FAIL 時の選択**:
- compile NG → gh aw のバージョン違いか syntax 違いを再調査、ドキュメント側を優先
- 5 分待っても動かない → Actions ログ調査、permissions 不足の可能性
- engine 切替不可 → Phase 08 で Step 5 を**録画提供のみ**に確定

**Artifacts**:
- `poc/E3-gh-aw/RESULT.md`
- `poc/E3-gh-aw/triage.aw.md`(動作確認済み)
- `poc/E3-gh-aw/triage.lock.yml`
- Actions 実行ログのリンク
- ガードレール検証の証跡(allowed 外ラベル試行)

---

### E4 — Cloud Agent + SKILL.md 連携

**Goal**: SKILL.md がリポにある状態で Issue を Cloud Agent に assign すると、Agent が SKILL.md を**実際に参照する**ことを確認

**前提準備**:
- E1, E2 完了済み
- E2 の SKILL.md を triage 用に書き換え(最小版)

**手順**:
1. throwaway リポに `triage` skill (SKILL.md) を push
2. テスト Issue を作成
3. Issue を `@copilot` (Cloud Agent) に assign
4. Cloud Agent の作業ログ / 出力を観察
5. 出力が SKILL.md の指示(ラベル名、コメント文体など)に従っているかチェック
6. SKILL.md を変更して再 assign し、出力が変わるかも確認(因果関係の検証)

**PASS 基準**:
- ☐ Cloud Agent の出力に SKILL.md の指示が反映されている
- ☐ SKILL.md 変更で出力が変わる(キャッシュではないことの確認)
- ☐ Cloud Agent が SKILL.md を読んだ証跡(ログや言及)が確認できる
- ☐ Cloud Agent が triage を実行できる(ラベル付与 / コメント投稿が成功)

**FAIL 時の選択**:
- Cloud Agent が SKILL.md を無視する → Step 3 のシナリオ再設計(IDE/CLI のみで "write once" を見せる)
- 出力に反映されない → invocation の "明示性" を上げる(SKILL 名を Issue 内で明示する等)

**Artifacts**:
- `poc/E4-cloud-skill/RESULT.md`
- 検証用 Issue のリンク
- Cloud Agent 出力のスクリーンショット
- SKILL.md 変更前後の比較

---

### E5 — Custom Agent (.agent.md) を Required Check に

**Goal**: `.github/agents/*.agent.md` を **PR の Required Check** として動作させる方法を確定

**前提準備**:
- throwaway リポ で main ブランチ保護を ON
- Copilot Code Review の Ruleset 設定権限あり

**手順**:
1. **Path A(直接型)**: `.github/agents/triage-review.agent.md` を作成し、Branch Protection の Required Check 候補に出るか確認
2. **Path B(Actions ラッパー型)**: `.github/agents/triage-review.agent.md` + それを呼ぶ `.github/workflows/triage-review.yml` を作成し、Actions ジョブを Required Check に登録
3. 両 Path で:
   - Draft PR を作成(triage 結果)
   - Custom Agent が走るか確認
   - 失敗ケースを意図的に作り、merge ブロックされるか確認
4. **Path C(Copilot Code Review のみ)**: Settings → Rulesets で "Automatically request Copilot code review" を有効化、Custom Agent は使わない

**PASS 基準**:
- ☐ Path A / B / C のうち**少なくとも 1 つ**が動く
- ☐ Required Check の失敗で merge がブロックされる
- ☐ 教材で説明可能な手順(UI クリック数 5〜10 以内)

**FAIL 時の選択**:
- Path A 不可 → Path B(ラッパー方式)を主軸に
- Path B も不可 → Path C(Copilot Code Review のみ)に縮退、Step 6 を 6a のみに簡素化

**Artifacts**:
- `poc/E5-required-check/RESULT.md`
- `poc/E5-required-check/triage-review.agent.md`
- `poc/E5-required-check/triage-review.yml`(Path B の場合)
- Branch Protection / Ruleset 設定のスクリーンショット
- merge ブロックされた PR のスクリーンショット

---

### E6 — Copilot Memory 観測方法

**Goal**: Memory が学習した内容を **学習者に "見える形"** にする方法を確定

**前提準備**:
- E1 完了済み
- Copilot Pro/Pro+ アカウント

**手順**:
1. throwaway リポで Copilot Chat を開き、5〜6 回 triage 関連の質問をする
   - 「このリポでは "feature" でなく "enhancement" を使う」と教える
   - 「P0 = 本番障害」と教える
2. しばらく待つ(Memory 反映のタイムラグ?)
3. **観測方法 A**: Settings → Copilot → Memory パネルを確認
4. **観測方法 B**: 新規 Chat セッションで「このリポの triage の慣習を教えて」と質問
5. **観測方法 C**: 別の Issue について triage させて、過去の指示が反映されているか確認

**PASS 基準**:
- ☐ A / B / C のうち**少なくとも 1 つ**で学習結果が確認できる
- ☐ Step 1 の教材で "学習を実感させる" 手順が書ける
- ☐ Memory off → on 切替方法が分かる(プライバシー懸念への配慮)

**FAIL 時の選択**:
- 全部 NG → Step 1 を「Memory はバックグラウンドで学んでいる」と概念紹介のみにし、デモを諦める
- 観測手段が学習者にとって複雑 → Step 1 の手順をシンプル化

**Artifacts**:
- `poc/E6-memory/RESULT.md`
- 各観測方法のスクリーンショット / Chat ログ
- 採用する観測方法の決定根拠

---

## 4. 副次タスク(検証以外)

### T1 — Pin バージョン台帳の作成
- `docs/planning/poc/VERSIONS.md` を作成
- 確定したバージョン(MCP server image tag、gh aw CLI version、Skills spec source 等)を全部リスト

### T2 — 既存 README.md(プロジェクトルート)の更新
- 「このリポは workshop 教材を構築中である」旨を明記
- 完成までは Work in Progress であることを宣言

### T3 — Master Plan 進捗・リスク再評価
- E1〜E6 の結果を踏まえ Master Plan の `9. 進捗` と `6. リスク` を更新

### T4 — 後続 Phase 用 "テスト計画テンプレート" 作成
- 後続 Phase で書く educational content に対する**自動テスト**の枠組みを定義
- 詳細は §5 参照

---

## 5. テスト戦略 — 後続 Phase でのテストの位置付け

### 5.1 Phase 01 でのテスト = "検証実験"
本 Phase の "テスト" は §3 の E1〜E6(現物検証実験)である。これらは PoC 動作確認であって、CI で繰り返し実行する性質ではない。

### 5.2 後続 Phase で必要となるテスト
教材は**動く repo**として配布されるため、内容が壊れていないことを継続的に確認する必要がある。Phase 02 以降で以下の3層のテストを構築する:

| 層 | テスト名 | 内容 | Phase で実装 |
|---|---|---|---|
| **L1** | **Smoke Test**(devcontainer) | Codespaces で `.devcontainer` がエラーなく build し、必須ツールが入っていることを確認 | Phase 02 |
| **L2** | **Step Gate Test** | 各 Step 完了時の repo 状態を検証(必要ファイル存在、構文 valid 等) | Phase 03〜09 |
| **L3** | **E2E Scenario Test** | テスト Issue を作成 → 自動 triage → 期待ラベル/コメントが付くまで観測(週次 schedule で実行) | Phase 07 完了後 |

### 5.3 テストツールの選定方針(Phase 01 で決定する)
- **L1**: GitHub Actions + devcontainer の `prebuild` 機能を活用
- **L2**: 簡易 shell スクリプト + `yamllint` / `markdownlint` 等
- **L3**: Actions の `schedule` トリガで `gh issue create` → 結果検証 → `gh issue close`

### 5.4 Phase 01 で作成するテスト計画テンプレート
`docs/planning/test-plan-template.md` を作成し、後続 Phase が従うフォーマットを定義する:
- テスト名 / 対象 Step / 種別(L1/L2/L3) / 入力 / 期待出力 / 失敗時の挙動

---

## 6. このフェーズの評価基準(次フェーズへ進む前に必ず確認)

### 6.1 ハードゲート(全項目 ☑ で Phase 02 着手可能)

#### 検証完了
- ☑ E1〜E6 の全実験が**完了**(PASS or FAIL の決着がついている) — E1/E2/E3/E4/E6 ✅ PASS、E5 🟡 CONDITIONAL PASS (Path C)
- ☑ FAIL 案件はすべて **次の選択(a/b/c)が決定済み** — E5 → Path C 採用、Path A/B は Phase 09 で発展題材化
- ☑ 各 PoC ディレクトリに `RESULT.md` が存在し、再現可能な手順が記載されている

#### 仕様確定
- ☑ `VERSIONS.md` (`docs/planning/VERSIONS.md`) に以下が pin 済み:
  - ☑ GitHub MCP Server (`https://api.githubcopilot.com/mcp/`、§1)
  - ☑ gh aw CLI バージョン (`v0.68.3`、§1)
  - ☑ Skills SKILL.md spec の参照 commit SHA (`github/awesome-copilot@63d08d51`、§2)
  - ☑ Custom Agent (.agent.md) の参照 commit SHA (`github/awesome-copilot@63d08d51`、§3)
- ☑ 教材の "前提環境" が文書化されている — VERSIONS.md §6 学習者前提環境(必須/推奨 + 秘伝の前提 P1-P7)

#### リスク再評価
- ☑ Master Plan の `6. リスク` が E1〜E6 結果を踏まえ更新済み (R1-R8 再評価、`(↓)` `(★)` 凡例追加)
- ☑ 新規発覚リスクが追記され、対処 Phase が決まっている — R9 (Phase 07) / R10 (Phase 06) / R11 (Phase 09) / R12 (Phase 04)
- ☑ 影響を受ける Phase 構成(分割/統合/削除)が反映済み — Phase 09 を 6a (主軸) / 6b (発展) に分割

#### 後続準備
- ☑ Step 0〜6 のうち、**スキップ判定**が決定済み — Master Plan §4.5 (Step 5 任意化 / Step 6b 発展題材化、Lite/Standard/Full プロファイル別経路)
- ☑ `test-plan-template.md` が作成され、後続 Phase が利用可能

### 6.2 ソフトゲート(あれば望ましい、必須ではない)
- ☑ E1〜E6 で得た「教材で使えそうな小ネタ / 失敗例」が `learnings.md` にメモされている (`docs/planning/poc/learnings.md`)
- ☐ 検証中に GitHub 公式 Issue / Discussion を立てた場合、リンクを残している
- ☐ 不明点を public にして反応待ちのものがある場合、Phase 02 で再確認するメモが残っている

### 6.3 Phase 02 着手の最低条件(これだけは絶対)
すべてのソフトゲートを満たさなくても、**以下が達成されていれば Phase 02 へ進める**:
1. E1, E2, E3 が **PASS**(Step 0–4 のコア技術が動くと確認できている)
2. `VERSIONS.md` のうち MCP / gh aw / Skills が pin されている
3. Master Plan の進捗が更新されている

E4, E5, E6 が FAIL でも、Phase 02 は走らせつつ Phase 06/09/04 の詳細計画作成時に再検討する選択肢が残せる。

---

## 7. Deliverables(成果物 — 実機配置)

```
docs/planning/
├── 00-master-plan.md                        ← 更新済 (リスク R1-R12 / Step 6 縮退 / §4.5 スキップ判定)
├── phase-01-spec-validation.md              ← このファイル
├── VERSIONS.md                              ← Pin 台帳 (§6 学習者前提環境を含む)
├── test-plan-template.md                    ← 後続 Phase で使う
└── poc/
    ├── learnings.md                         ← 副次的な学び (内部 KB)
    ├── E1-mcp/
    │   ├── PROCEDURE.md
    │   └── RESULT.md  (✅ PASS)
    ├── E2-skill/
    │   └── RESULT.md  (✅ PASS)
    ├── E3-gh-aw/
    │   ├── PROCEDURE.md
    │   └── RESULT.md  (✅ PASS, end-to-end 完走)
    ├── E4-cloud-skill/
    │   ├── PROCEDURE.md
    │   └── RESULT.md  (✅ PASS + 🎁 firewall ボーナス発見)
    ├── E5-required-check/
    │   ├── PROCEDURE.md
    │   └── RESULT.md  (🟡 CONDITIONAL PASS — Path C 採用)
    └── E6-memory/
        ├── PROCEDURE.md
        └── RESULT.md  (✅ PASS — 理想ケース)
```

> [!NOTE]
> §7 当初計画では `VERSIONS.md` を `poc/` 配下に置く想定だったが、**実機配置は `docs/planning/VERSIONS.md`** とした (Phase 02+ から横断参照される一次資料のため、トップレベルが妥当)。
> また `poc/E*/triage.aw.md` `triage-review.agent.md` 等の個別 artifact は throwaway repo (`shinyay/test-ghcp-workshop-validation`) 側に配置済みのため、本リポでは `RESULT.md` から URL/commit SHA でリンクする方式を採用。

加えて、プロジェクトルートの `README.md` を WIP 表示に更新済み。

---

## 8. リスク(Phase 01 固有)

| # | リスク | 確率 | 影響 | 対処 |
|---|---|---|---|---|
| PR1 | 検証中に GitHub 機能が更新されて手順が変わる | 中 | 中 | 各実験で参照 URL/SHA を必ず記録、再現性担保 |
| PR2 | throwaway リポが GitHub の Spam 検出に引っかかる | 低 | 中 | 1 個に絞り、test-* というプレフィックスを付ける |
| PR3 | Cloud Agent / Code Review の Premium Request 枠を消費し過ぎる | 中 | 低 | 各実験は最小回数(各 3 回まで)に制限 |
| PR4 | E5(Required Check)が想定以上に複雑で時間を吸う | 中 | 中 | 30 分 timebox、超過したら Path C(縮退案)に切替 |
| PR5 | Memory(E6)が観測不能で結論が出ない | 中 | 低 | "Step 1 を概念紹介のみ" として落としどころを用意 |
| PR6 | 検証中に重大な spec の不整合が発覚し、Master Plan の前提が崩れる | 低 | 高 | Master Plan の改訂を Phase 01 内で完了、Phase 02 着手前に user 確認 |

---

## 9. 進め方 / 実行順序

```
T2 (README WIP 更新)
   ↓
E1 (MCP) ──┬→ E2 (Skill) ──┬→ E4 (Cloud + Skill)
           │                │
           └→ E3 (gh aw) ───┘
                            ↓
                          E5 (Required Check)

(並行可) E6 (Memory) ──── 独立して実施可能

  最後に → T1 (VERSIONS.md) → T3 (Master Plan 更新) → T4 (test-plan-template)
```

- **E1 → E2 → E3** が直列(後続が前提に依存)
- **E4** は E1+E2 完了後
- **E5** は E3+E4 完了後が望ましい(triage の流れ全体を試したいので)
- **E6** は完全独立、いつでも実行可

---

## 10. ユーザー確認事項(Phase 01 着手前)

実装開始前に以下の判断を確認したい:

1. **throwaway リポジトリの作り方**: 既存個人アカウントに `test-ghcp-workshop-validation` のような名前で作って良い? それとも組織? `private` か `public` か?
2. **PoC コードのコミット方針**: PoC は本リポの `docs/planning/poc/` に置く前提で良い? 別リポやブランチを希望する場合は教えて欲しい
3. **API key を要する実験(E3 の engine 切替, E4 の Cloud Agent)**: 利用可能な API key の確認(Anthropic / OpenAI 等)。なければ "Copilot のみ" で進める
4. **Premium Request 消費**: Phase 01 は最大何回 Cloud Agent を起動して良いか上限を決めたい(デフォルト 10 回程度を提案)
5. **タイムボックス**: Phase 01 全体に "n 日" の上限を設けるか? 設けないか?(計画では時間見積もりはしないルールだが、検証実験は際限なくなりがちなので timebox 提案)

---

## 11. 改訂履歴

| 日付 | 変更内容 |
|---|---|
| 2026-04-24 | 初版作成 |
| 2026-04-25 | **Phase 01 完了** (全実験 E1-E6 PASS、E5 のみ Conditional PASS=Path C)。クロージング作業 (A-E) 実施: 副次タスク T1 (VERSIONS.md = §6 前提環境追加で完成), T3 (Master Plan §6 リスク R9-R12 追記 + Step 6 縮退反映 + §4.5 スキップ判定), T4 (test-plan-template.md 既作成); ソフトゲート `learnings.md` 作成。Phase 02 着手 GO |
