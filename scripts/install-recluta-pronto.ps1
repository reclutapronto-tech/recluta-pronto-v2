[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$InstallRoot = 'D:\ReclutaProntoOS-V2',
    [switch]$Start
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Require-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) { throw "No se encontró '$Name'. Instala Docker Desktop/WSL2 y vuelve a ejecutar." }
}
Write-Host 'Recluta Pronto OS V2 - instalación local' -ForegroundColor Cyan
Write-Host "Destino: $InstallRoot"
Require-Command 'docker'
$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) { throw "El motor Docker no está disponible. Inicia Docker Desktop antes de continuar.`n$dockerInfo" }
if (Get-Command wsl.exe -ErrorAction SilentlyContinue) { Write-Host 'WSL detectado. Se conserva la configuración existente.' } else { Write-Warning 'WSL no está disponible; los servicios que dependan de WSL2 no podrán iniciarse.' }
$repoRoot = Split-Path -Parent $PSScriptRoot
$compose = Join-Path $repoRoot 'compose.yaml'
if (-not (Test-Path -LiteralPath $compose)) { throw "No se encontró compose.yaml en $repoRoot." }
$directories = @('mariadb', 'redis-cache', 'redis-queue', 'frappe-sites', 'evolution', 'docling', 'n8n', 'backups')
foreach ($relative in $directories) {
    $path = Join-Path $InstallRoot $relative
    if (-not (Test-Path -LiteralPath $path) -and $PSCmdlet.ShouldProcess($path, 'Crear directorio')) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
}
$envPath = Join-Path $InstallRoot '.env'
$envExample = Join-Path $repoRoot '.env.example'
if (-not (Test-Path -LiteralPath $envPath)) {
    if ($PSCmdlet.ShouldProcess($envPath, 'Copiar plantilla .env.example')) { Copy-Item -LiteralPath $envExample -Destination $envPath }
    Write-Warning "Se creó $envPath. Completa secretos localmente; nunca los publiques."
} else { Write-Host 'Se conserva el .env existente.' }
Push-Location $repoRoot
try {
    docker compose --env-file $envPath -f $compose config --quiet
    if ($LASTEXITCODE -ne 0) { throw 'La configuración de Docker Compose no es válida.' }
    if ($Start) {
        docker compose --env-file $envPath -f $compose up -d
        if ($LASTEXITCODE -ne 0) { throw 'Docker Compose no pudo iniciar los servicios.' }
    } else { Write-Host 'Validación completada. Usa -Start para iniciar los servicios.' }
} finally { Pop-Location }
Write-Host 'Instalación/verificación finalizada.' -ForegroundColor Green
