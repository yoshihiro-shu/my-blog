---
title: "株式会社GMOペパボの経験(2024年05月~)"
date: 2024-12-08T12:00:00+09:00
weight: 1
tags: ["resume"]
categories: ["profile"]
---

{{% blocks/section color="white" %}}

## 経験したこと

### ゲーム追加のプロジェクトリード

ゲーム10タイトルの機能追加の開発およびプロジェクトのリードエンジニアを担当し、デザイナーやインフラエンジニアなど様々な人を巻き込み、プロジェクトマネジメントを行いました。

プロジェクトマネジメントする上で、課題は以下です。

- ドメイン知識が必要な領域のため、ゲーム追加に関するアーキテクチャのオンボーディングが必要がある
- ユーザーの満足度と最速でリリースできる最低限のゲームマネージャー機能の要件定義をする必要がある
- プレスリリースを伴うため、精度の高いスケジューリングを行う必要がある

そのため以下のアクションを行いました。

- システムアーキテクチャやゲームイメージなどのドメイン知識に関するオンボーディング
- 必要最低限のリリースできるゲームマネージャー要件をチーム全体で認識を合わせ、意思決定のスピードを短縮する
- タスクを最大1日以下まで細分化し見積もりを行い、デイリーで進捗確認を行い必要があればサポートをする

成果として、以下が挙げられます。

- `初期リリースにおけるゲームマネージャーの要件定義の提供項目の認識の共通化`
- `デプロイができないトラブルなどが起きたにも関わらず、当初のスケジュール通りリリースできたこと`
- `プロジェクト完了後も担当エンジニアがゲーム追加のみならず、他領域のタスクに着手可能になったこと`

### ゲームマネージャーのリアーキテクチャ

ゲームマネージャーのバックエンドの実装が複雑化していることで以下の課題があり、リアーキテクチャに取り組みました。

- 開発者によって実装方針が異なり、メンテナンス性が低く、レビューのコストが高い
- 同時並行で開発するために最適化されていない（コンフリクトが大量に発生してしまう）

根本的な課題はとして、以下が挙げられます。

- ゲームによって異なる仕様の複雑性
- 同じファイルに対して実装することにより、コンフリクトが避けられない

そのため以下のアクションを行いました。

- ゲーム設定の取得・更新RPCを共通化すること
- 新たなパッケージを作成し、複雑な仕様を抽象化すること
- 実装をゲームごとにファイルを分離すること

成果として、以下が挙げられます。

- アプリケーションの実装工数を2週間から1週間に短縮
- バックエンドとフロントエンドの開発分業が可能になり、業務委託を効率よく行えたいこと
- システムマイグレーション時に、バックエンドとフロントエンドの開発コストを大幅削減

{{% /blocks/section %}}
