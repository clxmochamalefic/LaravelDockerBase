Param(
  [switch]$up,    # docker-compose up
  [switch]$down,  # docker-compose down
)

$nginx_default_conf = "\docker\nginx\.default.conf"
$nginx_conf = "\docker\nginx\default.conf"

# 設定読み込み
$ini_path = @(Split-Path $script:myInvocation.MyCommand.Path -Parent).Trim()
$ini_file = ".env.default"
$ini_fullname = $ini_path + "\" + $ini_file

$parameter = @{}
Get-Content $ini_fullname | %{$parameter += ConvertFrom-StringData $_}

$compose_project_name = $parameter.COMPOSE_PROJECT_NAME
$laravel_project_name = $parameter.LARAVEL_PROJECT_NAME

$nginx_conf_default_path  = $ini_path + "\" + $nginx_default_conf
$nginx_conf_path          = $ini_path + "\" + $nginx_conf

# laravelプロジェクト名を変更
if ($laravel_project_name -ne "public") {
  (Get-Content $nginx_conf_default_path) | foreach { $_ -replace "root /var/www/public/public","root /var/www/" + laravel_project_name + "/public" } | Set-Content $nginx_conf_path
}

# docker/nerdctl サブコマンド指定
$subcommand = ""

if ($up) {
  $subcommand = "up"
} elseif ($down) {
  $subcommand = "down"
} else {
  echo "no subcommand / Usage: ./docker_compose_wrapped.ps1 <-up|-down>"
  exit 1
}

try {
  docker-compose -p $compose_project_name $subcommand -d
} catch {
  $dcyml = $ini_path + "/docker-compose.yml"
  nerdctl compose -p $compose_project_name -f $dcyml $subcommand
}
