# LaravelDockerBase with PHP8.0

## 構成

- php
  - php:8.0-fpm
- nginx
  - stable
- db
  - mariadb:10.11
- redis
  - redis:7.0.11
- php-my-admin
  - stable

## `git clone` した後にやること

(Terminalで実行してください / 最初の `$` はプロンプトを意味します、 `$` のコピペは不要です)

### docker-composeで複数コンテナを起動

#### ラッパーコマンドを実行

##### dockerの場合

```pwsh
./docker_compose_wrapped.ps1 -up
```

##### nerdctlの場合

```pwsh
./docker_compose_wrapped.ps1 -up -n
```

#### `docker` / `docker-desktop`

1. `.env.default` から `.env` をコピーして作成
2. `.env` 内で定義されている `COMPOSE_PROJECT_NAME=DEFAULT` の `DEFAULT` を任意の名前に変更
3. $ `docker-compose -p <.envで定義したCOMPOSE_PROJECT_NAME=DEFAULTの値> up -d`
4. $ `docker exec -it <laravelのコンテナのname> bash`
5. $ `laravel new public`
6. $ `chmod 777 ./public/storage/ -R`

#### `nerdctl`

##### `docker-compose` コマンド部分

以下のコマンドに変更する

```sh
nerdctl compose -p <.envで定義したCOMPOSE_PROJECT_NAMEの値> -f <docker-compose.ymlのpath> up -d
```

### laravelのプロジェクトを配置

#### 既存laravelプロジェクトが存在する場合

`/server/` 配下にlaravelプロジェクトを配置してください

※この時、配置したプロジェクトのディレクトリ名は `.env` 内の `LARAVEL_PROJECT_NAME` の値と同じにする必要があります

#### 新規laravelプロジェクトを作成する場合

こちらもラッパーを作成してありますのでご利用ください

```pwsh
./make_laravel.ps1
```

## 参考

<https://qiita.com/A-Kira/items/1c55ef689c0f91420e81>
