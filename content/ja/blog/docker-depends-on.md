---
title: "Dockerのdepends onについて"
date: 2023-01-17T12:00:00+09:00
weight: 1
tags: ["Docker", "docker-compose"]
categories: ["infra"]
---

{{% blocks/section color="white" %}}

## 背景

Dockerの`depends_on`について、簡単に学んだことをまとめました。

## 対象としている人

Dockerについて、一通り学習したことがある人

## depends_on

サービス間の依存関係を指定できる

```docker-compose.yaml
services:
  service_a:
    image: busybox
  service_b:
    image: busybox
    # `service_b` を `service_a` に依存させる
    depends_on:
      - service_a
```

service_b を service_a に依存させることができます

- docker-compose up: service_a → service_b の順に起動する
- docker-compose run: （ docker-compose up と同じ）
- docker-compose stop: service_b → service_a の順に停止する

## 指定パターン

- Short syntax （リスト）
  - 依存先のサービス名を単純に記述するだけ

```docker-compose.yaml
depends_on:
  - service_a
```

- Long syntax （オブジェクト）
  - 依存関係にあるサービスをオブジェクト形式で記述するもの
  - この方法では依存先に加えて「条件」を指定することができます

```docker-compose.yaml
depends_on:
  service_a:
    condition: service_started
```

条件の指定には condition を使用
condition にデフォルト値は無いため、 long syntax を選ぶ場合は必ず指定する必要があり

- service_started
  - 依存先のサービスが起動したら起動する
    - 依存先のサービスが「起動したこと」を条件とします
- service_healthy
  - 依存先のサービスが起動して、なおかつ、 healthcheck が通ったら起動する
    - 依存先のサービスが起動してなおかつ healthcheck が通ることを条件とする
- service_completed_successfully
  - 依存先のサービスが正常終了したら起動する
    - 依存先のサービスが正常に終了したことを条件

{{% /blocks/section %}}
