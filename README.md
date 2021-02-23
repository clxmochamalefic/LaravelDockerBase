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

1. $ `docker-compose up -d`
2. $ `docker-compose exec php bash`
3. $ `laravel new public`

## 参考

https://qiita.com/A-Kira/items/1c55ef689c0f91420e81
