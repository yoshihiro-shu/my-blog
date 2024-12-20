---
title: "これだけは知っておきたいDNS"
date: 2023-07-30T12:00:00+09:00
weight: 1
tags: ["dns", "infra", "network"]
categories: ["infra"]
---

{{% blocks/section color="white" %}}

## はじめに

DNSについて、最低限知っておきたいポイントを整理しました。誰かのお役に立てれば幸いです。

## 登場人物

## DNSを動かすために必要なこと

- 自分のドメイン名をインターネットでつけるようにする
　- 権威サーバーを動かすことで自分のドメイン名をインターネットで使えるようにする
- インターネットで使われているドメイン名を自分が使えるようにする
  - フルリゾルバー、スタブリゾルバー、特にフルリゾルバーを動かすことでインターネットで使われているドメインを自分で使えるようにする
- DNSを動かし続け、可用性を高める
  - 問題なく動作していることを確認すること、外部攻撃に備え動かし続ける必要がある

## DNS設計

### ユースケース

- 運用しているサービスやサーバーが少ない場合
サブドメインを作成せず、階層構造を持たないフラットな管理をする。

- 部門別のシステムをサブドメインを作成し、システム部門が全体の管理する場合
1つのゾーンで運用する

- 他部門が独自サブドメインを使ってサービスサイトを運用し、そのサブドメインもその部門が管理する場合
サブドメインを作成し、ゾーンの管理をその部門委任する

## 権威サーバーの可用性
### プライマリサーバーとセカンダリサーバーの設置

**役割**
プライマリサーバーがセカンダリサーバーからのゾーン転送の要求を受け、要求されたゾーンデータを送る

**考慮すること**

プライマリサーバーをセカンダリサーバーへのゾーン転送のコピー元としてだけ使う。
- 利用者からの問い合わせは受け付けないように構成する
プライマリサーバーのIPアドレスをプライベートにすることで、サイバー攻撃のリスクを減らすことができる

### ゾーン転送の仕組み
- AXFR
全てのゾーン情報を転送する
- IXFR
前回のゾーン転送情報をジャーナルファイルに記録しておき、ゾーン転送時にはジャーナルファイルを参照して差分情報のみを転送する

## 権威サーバーが応答する情報

- リソースレコードの表記フォーマット
    - TTLとクラスは省略できる
    - 同じドメイン名に複数のリソースレコードを設定する場合、二行目以降はドメイン名を省略できる

```jsx
<name> <TTL> <class> <type> <data>
```

## フルリゾルバー

**役割**

利用者の機器で動作するスタブリゾルバーから名前解決要求を受け付け、名前解決を行い結果を返す

**考慮すること**
- ネット上に設置された権威サーバー群に問い合わせを送るため、一般的にグローバルIPを割り当てる
- 利用者のネットワークからアクセスしやすい場所に設置することが望ましい

## 代表的に攻撃手法
### DNSリフレクター攻撃
DNSを利用したDoS攻撃の一つ

送信元IPアドレスを偽った問い合わせをフルリゾルバーや権威サーバーに送ることでそれらのサーバーが応答を攻撃対象に送りサービス不能の状態に陥らせる

**対策**

RRL(Response Rate Limiting)の導入
- ある宛先に対する同じ内容の応答が所定の頻度を超えた場合に、応答を送らない用にするなどの制限を発動させる
### ランダムサブドメイン攻撃

権威サーバーやフルリゾルバーに対するDDoS攻撃手法の一つ

問い合わせのドメイン名にランダムなサブドメインを付加することでフルリゾルバーのキャッシュ機能を無効化し、攻撃対象となる権威サーバーに問い合わせを集中させることにより、権威サーバーやフルリゾルバーをサービス不能の状態に陥らせる

**対策**
- 必要なアクセス制限がされておらず、外部から不正使用可能な状態になっているオープンリゾルバーをなくす
- 顧客側に設置された欠陥をもつホームルーターなどの機器を悪用されないようにするためにISP側でIP53Bを実施する
- フルリゾルバーにおいて、フィルタリングや問い合わせレートによる制限
- 監視の強化と攻撃検知する仕組みを導入

## 参考
[DNSがよくわかる教科書](https://amzn.to/3rQsYck)

{{% /blocks/section %}}
