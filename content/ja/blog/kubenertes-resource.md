---
title: "Kubernetesリソースメモ"
date: 2023-01-18T12:00:00+09:00
weight: 1
tags: ["Kubernetes"]
categories: ["infra"]
---

{{% blocks/section color="white" %}}

## 背景

以外と忘れがちなリソースについて、まとめました。

## 対象としている人

Kubernetesを学習途中の人、またこれからKubernetesを学習しようとしている人

# リソース

## Pod

PodはKubernetesにデプロイ出来る最小単位

- コンテナやボリュームの集まり

## Deployment

- 新しいReplicaSetを作成したり、既存のDeploymentを削除して新しいDeploymentで全てのリソースを適用することができる

## ReplicaSet

- どんな時でも指定された数のPodのレプリカが稼働することを保証する
- `spec.template`をハッシュ値で管理しているため、ロールアップ・ダウンによる変更に即座に対応できる。

## Ingress

- IngressはHTTPやHTTPSの外部アクセスを制御するオブジェクト
- Load Balancerの役割をしている。

## Service

- 動的にIPAddressが変更されるPodへの接続を解決してくれる抽象的なオブジェクト
- Podの集合で実行されているアプリケーションをネットワークサービスとして公開する抽象的な方法

役割
- Pod,Nodeの存在を抽象化し、Podとの通信に単一のエンドポイントを提供する

## Volumeについて

コンテナのデータは一時的なもので、Pod/コンテナが削除されるか、コンテナがクラッシュした場合コンテナのデータは消えてしまう。
そこでVolumeを使う
- メリット
  - Volumeはデータの永続化をしてくれる。 永続化したいデータは指定したVolumeに保存することで削除やクラッシュした際でもデータが残る。
  - また、Volumeは別の目的でも使用される。それはPod内でのコンテナ間のデータ共有だ。
  - Pod内のコンテナはVolumeを通してデータを共有することが出来る。

### 種類

- emptyDir
  - Podがノードに割り当てられたときに最初に作成され、そのPodがそのノードで実行されている限り存在する
  - 名前が示すようにemptyDirボリュームは最初は空
  - Podが削除された際に対象のVolumeのデータも削除される。 よってPod内のコンテナ間のデータ共有のみで使用
- hostPath
  - データが永続化されている(Podが削除されてもデータは消されない)
  - Kubernetesが実行されているサーバーにデータが置いてある

## ConfigMap
- 機密性のないデータをキーと値のペアで保存するために使用されるAPIオブジェクト

## Secret
- Secretとは、パスワードやトークン、キーなどの少量の機密データを含むオブジェクト
- PodがSecretを使う方法は3種類がある。
  - ボリューム内のファイルとして、Podの単一または複数のコンテナにマウントする
  - コンテナの環境変数として利用する
  - Podを生成するためにkubeletがイメージをpullするときに使用する

## HorizontalPodAutoscaler
- Deployment、ReplicaSetまたはStatefulSetといったレプリケーションコントローラ内のPodの数を、観測されたCPU使用率（もしくはベータサポートの、アプリケーションによって提供されるその他のメトリクス）に基づいて自動的にスケールさせる
- podの負荷に応じて自動的にpodの数を増減させる

## PodDisruptionBudget
- Podの最小の有効状態や最大の無効状態の数を指定する
- Podの管理対象はLabelSelectorで指定する
- フィールドのメモ
    - spec.maxUnavailable : Eviction実行時にPodを無効状態にしていい最大数を指定する。絶対値か百分率で指定する。
    - spec.minAvailable : Eviction実行時にPodを有効状態にしておく最小数を指定す る。絶対値か百分率で指定する。
    - spec.selector : このBudgetを適用する対象のPodを選択するLabelSelectorを指定

## CronJob
- CronJobはJobをcronのように定期実行するためのKubernetesのWorkloadリソース
  - 時間ベースのスケジュールでJobを作成するKubernetesオブジェクト
- concurrencyPolicy Jobの並行実行についてのポリシーを指定できる
  - Allow
    - 並行なJobの実行を許可するポリシー
  - Forbid
    - 前回のJobがまだ実行中で完了してない場合、スケジュールされたJobはスキップされる
  - Replace
    - 前回のJobがまだ実行中で完了してない場合、前回のJobをキャンセルし新しくスケジュールされるJobに置き換える

## Job
- 一つ以上のPodを作成することである特定数のPodが正常終了するまでリトライしながら処理を実行するKubernetesのWorkloadリソース
  - Podの実行が失敗したり削除された場合はJobは新たにPodを起動する
  - 平行に複数のPodを起動することも可能
  - 指定された数が正常に終了した際にJobが完了
  - Jobを削除するとそのJobによって作成されたPodも削除される

## Namespace

- 同一の物理クラスター上で複数の仮想クラスターの動作をサポートする
  - `kubectl api-resources --namespaced=true`でどのリソースが適応なのか確認できる

# おまけ

Manifestについて簡単なメモです。

## Manifest

Podを作成するにはKubernetesのManifestファイルを作成する必要がある。

### 共通部分のメモ

- apiVersion
  - apiVersion はオブジェクトのSchemaのVersionを指定する
- kind
  - kind は作成するObject名を指定する。指定については対象のObjectのKindを参照する。
- metadata
  - MetadataのnameでResourceの名前を指定する。
- spec
  - オブジェクトの期待する状態を定義する
  - name はPod内でのコンテナ名を指定する。このnameはPod内でユニークである必要がある
  - image はイメージ名を指定する

{{% /blocks/section %}}
