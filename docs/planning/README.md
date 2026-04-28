# Planning Documents

このディレクトリは、ワークショップ教材構築のための**計画ドキュメント**を管理します。

## 構成

| ファイル | 役割 |
|---|---|
| [`00-master-plan.md`](./00-master-plan.md) | **全体計画**(全 Phase の概要・依存・ゴール)|
| `phase-NN-*.md` | 各 Phase の詳細計画(着手時に作成)|

## ドキュメント方針

- **Master Plan が最上位の真実**。各 Phase 詳細はそれに従う
- 各 Phase 詳細計画は、**その Phase 着手時に作成**(先に全部作らない=陳腐化回避)
- Phase 完了時、Master Plan の進捗セクションを更新する
- 計画変更が発生したら Master Plan を先に更新し、関連 Phase 詳細を追従させる

## 進め方

1. Master Plan で全体合意
2. Phase N 着手前に `phase-NN-*.md` を作成
3. Phase N 実装
4. Phase N 完了レビュー → Master Plan の進捗更新
5. Phase N+1 へ

## 関連

- ワークショップの構想元: 60分 keynote プレゼンテーション(別管理)
- リポジトリ全体の README: [`/README.md`](../../README.md)
