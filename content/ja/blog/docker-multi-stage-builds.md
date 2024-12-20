---
title: "[検証]DockerのMulti-stage builds"
date: 2023-03-18T12:00:00+09:00
weight: 1
tags: ["Go", "Docker", "dockerfile"]
categories: ["infra"]
---

{{% blocks/section color="white" %}}

## 背景

DockerImageのMulti-stage buildsをするとサイズがどのくらい落ちるか気になったので、検証しました。

## 対象としている人

- Docker学習中の人
- Docker Imageを実装している人

## 実験結果

一目瞭然ですね。
まさかの約370MBの違いもありました。

Goのベースイメージを採用したDockerImage
[golang:1.19]()をベースイメージとして使っています。
![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2083780/1d9bebbb-bb78-5145-1a7b-150fa1899955.png)

Multi-stage buildsを採用したDockerImage
[scratch](https://hub.docker.com/_/scratch)をベースイメージとして使っています。
![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2083780/c0f9912f-5208-06f9-b60b-5ccae2d97e99.png)

## それぞれのDockerImage

Goのベースイメージを採用したDockerImage

```Dockerfile
FROM golang:1.19
WORKDIR /usr/src/app
COPY . ./
RUN go mod download && go mod verify
EXPOSE 8000
CMD ["go", "run", "./cmd/main.go"]
```

Multi-stage buildsを採用したDockerImage

```Dockerfile
# syntax=docker/dockerfile:1
FROM golang:1.19 as builder
WORKDIR /usr/src/app
COPY ./backend/go.mod ./backend/go.sum ./
RUN go mod download && go mod verify
COPY ./backend .
RUN CGO_ENABLED=0 go build -o binary ./cmd/main.go
FROM scratch
WORKDIR /usr/src/app
# scratch doesn't have timezone.
COPY --from=builder /usr/share/zoneinfo/Asia/Tokyo /usr/share/zoneinfo/Asia/Tokyo
COPY --from=builder /usr/src/app/binary /usr/src/app/binary
COPY ./backend/configs.yaml .
EXPOSE 8080
CMD ["./binary"]
```

{{% /blocks/section %}}