# LaravelDockerBase with PHP8.0

## 構成

- php
    - PHP8.0
- nginx
    - stable
- db
    - mysql:5.7
- php-my-admin
    - stable

## `git clone` した後にやること

(Terminalで実行してください / 最初の `$` はプロンプトを意味します、 `$` のコピペは不要です)

1. `.env.default` から `.env` をコピーして作成
2. `.env` 内で定義されている `COMPOSE_PROJECT_NAME=DEFAULT` の `DEFAULT` を任意の名前に変更
3. $ `docker-compose -p <.envで定義したCOMPOSE_PROJECT_NAME=DEFAULTの値> up -d`
4. $ `docker exec -it <laravelのコンテナのname> bash`
5. $ `laravel new public`
6. $ `chmod 777 ./public/storage/ -R`

## 参考

https://qiita.com/A-Kira/items/1c55ef689c0f91420e81
