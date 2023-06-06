Param(
  [switch]$up,
  [switch]$down,
  [switch]$restart,
  [switch]$n
)

$nginx_default_conf = "docker\nginx\.default.conf"
$nginx_conf = "docker\nginx\default.conf"

# 設定読み込み
$ini_path = @(Split-Path $script:myInvocation.MyCommand.Path -Parent).Trim()
$ini_file = ".env"
$ini_fullname = $ini_path + "\" + $ini_file

$parameter = @{}
Get-Content $ini_fullname | %{$parameter += ConvertFrom-StringData $_}

$compose_project_name = $parameter.COMPOSE_PROJECT_NAME
$laravel_project_name = $parameter.LARAVEL_PROJECT_NAME

$nginx_conf_default_path  = $ini_path + "\" + $nginx_default_conf
$nginx_conf_path          = $ini_path + "\" + $nginx_conf
$laravel_container_name = $laravel_project_name + "_laravel_1"

# nginx設定のlaravelプロジェクト名を変更
(Get-Content $nginx_conf_default_path) | foreach { $_ -replace "%%%LARAVEL_PROJECT_NAME%%%",$laravel_project_name } | foreach { $_ -replace "%%%LARAVEL_CONTAINER_NAME%%%",$laravel_container_name } | Set-Content $nginx_conf_path

# docker/nerdctl サブコマンド指定
$subcommand = ""
$option = ""

if ($up) {
  $subcommand = "up"
  $option = "-d"
} elseif ($down) {
  $subcommand = "down"
} elseif (!$up -and !$down -and !$restart) {
  echo "ERROR: no subcommand"
  echo "Usage: ./docker_compose_wrapped.ps1 <-up|-down|-restart> [-n]"
  echo ""
  echo "REQUIRED ARG"
  echo "  <-up|-down|-restart>"
  echo "  choice docker-compose sub command"
  echo "    -up:      docker-compose up / nerdctl compose up"
  echo "    -down:    docker-compose down / nerdctl compose down"
  echo "    -restart: exec (docker-compose|nerdctl compose) down BEFORE up"
  echo ""
  echo "OPTIONAL ARG"
  echo "  [-n]: use 'nerdctl compose' instead 'docker-compose'"
  exit 1
}

$dcyml = ""

$command  = "docker-compose"
$command2 = "nerdctl compose"

if ($n) {
  $command  = "nerdctl compose"
  $command2 = "docker-compose"
  $dcyml = $ini_path + "/docker-compose.yml"
}

if ($restart) {
  echo "exec restart"
  try {
  echo "=== exec ${command} down ==="
    pwsh -c "${command} -p ${compose_project_name} -f ${dcyml} down"
  echo "=== exec ${command} up ==="
    pwsh -c "${command} -p ${compose_project_name} -f ${dcyml} up -d"
  } catch {
  echo "=== exec ${command2} down ==="
    pwsh -c "${command2} -p ${compose_project_name} -f ${dcyml} down"
  echo "=== exec ${command2} up ==="
    pwsh -c "${command2} -p ${compose_project_name} -f ${dcyml} up -d"
  }

  exit 0
}

try {
  echo "exec ${command} ${subcommand}"
  pwsh -c "${command} -p ${compose_project_name} -f ${dcyml} ${subcommand} ${option}"
} catch {
  echo "exec ${command2} ${subcommand}"
  pwsh -c "${command2} -p ${compose_project_name} -f ${dcyml} ${subcommand} ${option}"
}

