
$nginx_default_conf = "\docker\nginx\.default.conf"
$nginx_conf = "\docker\nginx\default.conf"

$ini_path = @(Split-Path $script:myInvocation.MyCommand.Path -Parent).Trim()
$ini_file = ".env.default"
$ini_fullname = $ini_path + "\" + $ini_file

$parameter = @{}
Get-Content $ini_fullname | %{$parameter += ConvertFrom-StringData $_}

$laravel_project_name = $parameter.LARAVEL_PROJECT_NAME

$laravel_container_name = $laravel_project_name + "_laravel_1"

try {
  docker exec $laravel_container_name laravel new public
} catch {
  nerdctl exec $laravel_container_name laravel new public
}
