[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$InstallRoot = 'D:\ReclutaProntoOS-V2',
    [switch]$Start
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Require-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "No se encontrÃ³ '$Name'. Instala Docker Desktop/WSL2 y vuelve a ejecutar."
    }
}

Write-Host "Recluta Pronto OS V2 - instalaciÃ³n local" -ForegroundColor Cyan
Write-Host "Destino: $InstallRoot"

Require-Command 'docker'
$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "El motor Docker no estÃ¡ disponible. Inicia Docker Desktop antes de continuar.`n$dockerInfo"
}
if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    $wslVersion = (wsl.exe --status 2>&1 | Out-String)
    Write-Host "WSL detectado. Se conserva la configuraciÃ³n existente."
} else {
    Write-Warning 'WSL no estÃ¡ disponible; los servicios que dependan de WSL2 no podrÃ¡n iniciarse.'
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$composeCandidates = @('compose.yaml', 'compose.yml', 'docker-compose.yaml', 'docker-compose.yml') |
    ForEach-Object { Join-Path $repoRoot [CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$InstallRoot = 'D:\ReclutaProntoOS-V2',
    [switch]$Start
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Require-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "No se encontrÃ³ '$Name'. Instala Docker Desktop/WSL2 y vuelve a ejecutar."
    }
}

Write-Host "Recluta Pronto OS V2 - instalaciÃ³n local" -ForegroundColor Cyan
Write-Host "Destino: $InstallRoot"

Require-Command 'docker'
$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "El motor Docker no estÃ¡ disponible. Inicia Docker Desktop antes de continuar.`n$dockerInfo"
}
if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    $wslVersion = (wsl.exe --status 2>&1 | Out-String)
    Write-Host "WSL detectado. Se conserva la configuraciÃ³n existente."
} else {
    Write-Warning 'WSL no estÃ¡ disponible; los servicios que dependan de WSL2 no podrÃ¡n iniciarse.'
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$compose = Join-Path $repoRoot 'compose.yaml'
if (-not (Test-Path -LiteralPath $compose)) {
    throw "No se encontrÃ³ compose.yaml en $repoRoot. Ejecuta el instalador desde el repositorio completo."
}

# Solo crea directorios y archivos auxiliares; nunca elimina ni sobreescribe datos existentes.
$directories = @('mariadb', 'redis-cache', 'redis-queue', 'frappe-sites', 'evolution', 'docling', 'n8n', 'backups')
foreach ($relative in $directories) {
    $path = Join-Path $InstallRoot $relative
    if (-not (Test-Path -LiteralPath $path)) {
        if ($PSCmdlet.ShouldProcess($path, 'Crear directorio')) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
    }
}

$envPath = Join-Path $InstallRoot '.env'
$envExample = Join-Path $repoRoot '.env.example'
if (-not (Test-Path -LiteralPath $envPath)) {
    if (Test-Path -LiteralPath $envExample) {
        if ($PSCmdlet.ShouldProcess($envPath, 'Copiar plantilla .env.example')) { Copy-Item -LiteralPath $envExample -Destination $envPath }
    } else {
        if ($PSCmdlet.ShouldProcess($envPath, 'Crear archivo .env vacÃ­o')) { New-Item -ItemType File -Path $envPath -Force | Out-Null }
    }
    Write-Warning "Se creÃ³ $envPath. Completa secretos localmente; nunca los publiques."
} else {
    Write-Host "Se conserva el .env existente."
}

Push-Location $repoRoot
try {
    docker compose -f $compose config --quiet
    if ($LASTEXITCODE -ne 0) { throw 'La configuraciÃ³n de Docker Compose no es vÃ¡lida.' }
    if ($Start) {
        Write-Host 'Iniciando servicios definidos en Docker Compose...'
        docker compose -f $compose --env-file $envPath up -d
        if ($LASTEXITCODE -ne 0) { throw 'Docker Compose no pudo iniciar los servicios.' }
    } else {
        Write-Host 'ValidaciÃ³n completada. Usa -Start para iniciar los servicios.'
    }
} finally { Pop-Location }

Write-Host 'InstalaciÃ³n/verificaciÃ³n finalizada.' -ForegroundColor Green



 }
$compose = $composeCandidates | Where-Object { Test-Path -LiteralPath [CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$InstallRoot = 'D:\ReclutaProntoOS-V2',
    [switch]$Start
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Require-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "No se encontrÃ³ '$Name'. Instala Docker Desktop/WSL2 y vuelve a ejecutar."
    }
}

Write-Host "Recluta Pronto OS V2 - instalaciÃ³n local" -ForegroundColor Cyan
Write-Host "Destino: $InstallRoot"

Require-Command 'docker'
$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "El motor Docker no estÃ¡ disponible. Inicia Docker Desktop antes de continuar.`n$dockerInfo"
}
if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    $wslVersion = (wsl.exe --status 2>&1 | Out-String)
    Write-Host "WSL detectado. Se conserva la configuraciÃ³n existente."
} else {
    Write-Warning 'WSL no estÃ¡ disponible; los servicios que dependan de WSL2 no podrÃ¡n iniciarse.'
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$compose = Join-Path $repoRoot 'compose.yaml'
if (-not (Test-Path -LiteralPath $compose)) {
    throw "No se encontrÃ³ compose.yaml en $repoRoot. Ejecuta el instalador desde el repositorio completo."
}

# Solo crea directorios y archivos auxiliares; nunca elimina ni sobreescribe datos existentes.
$directories = @('mariadb', 'redis-cache', 'redis-queue', 'frappe-sites', 'evolution', 'docling', 'n8n', 'backups')
foreach ($relative in $directories) {
    $path = Join-Path $InstallRoot $relative
    if (-not (Test-Path -LiteralPath $path)) {
        if ($PSCmdlet.ShouldProcess($path, 'Crear directorio')) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
    }
}

$envPath = Join-Path $InstallRoot '.env'
$envExample = Join-Path $repoRoot '.env.example'
if (-not (Test-Path -LiteralPath $envPath)) {
    if (Test-Path -LiteralPath $envExample) {
        if ($PSCmdlet.ShouldProcess($envPath, 'Copiar plantilla .env.example')) { Copy-Item -LiteralPath $envExample -Destination $envPath }
    } else {
        if ($PSCmdlet.ShouldProcess($envPath, 'Crear archivo .env vacÃ­o')) { New-Item -ItemType File -Path $envPath -Force | Out-Null }
    }
    Write-Warning "Se creÃ³ $envPath. Completa secretos localmente; nunca los publiques."
} else {
    Write-Host "Se conserva el .env existente."
}

Push-Location $repoRoot
try {
    docker compose -f $compose config --quiet
    if ($LASTEXITCODE -ne 0) { throw 'La configuraciÃ³n de Docker Compose no es vÃ¡lida.' }
    if ($Start) {
        Write-Host 'Iniciando servicios definidos en Docker Compose...'
        docker compose -f $compose --env-file $envPath up -d
        if ($LASTEXITCODE -ne 0) { throw 'Docker Compose no pudo iniciar los servicios.' }
    } else {
        Write-Host 'ValidaciÃ³n completada. Usa -Start para iniciar los servicios.'
    }
} finally { Pop-Location }

Write-Host 'InstalaciÃ³n/verificaciÃ³n finalizada.' -ForegroundColor Green



 } | Select-Object -First 1
if (-not $compose) {
    throw "No se encontrÃ³ un archivo Docker Compose en $repoRoot. Ejecuta el instalador desde el repositorio completo."
}
Write-Host "Compose: $compose"
# Solo crea directorios y archivos auxiliares; nunca elimina ni sobreescribe datos existentes.
$directories = @('mariadb', 'redis-cache', 'redis-queue', 'frappe-sites', 'evolution', 'docling', 'n8n', 'backups')
foreach ($relative in $directories) {
    $path = Join-Path $InstallRoot $relative
    if (-not (Test-Path -LiteralPath $path)) {
        if ($PSCmdlet.ShouldProcess($path, 'Crear directorio')) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
    }
}

$envPath = Join-Path $InstallRoot '.env'
$envExample = Join-Path $repoRoot '.env.example'
if (-not (Test-Path -LiteralPath $envPath)) {
    if (Test-Path -LiteralPath $envExample) {
        if ($PSCmdlet.ShouldProcess($envPath, 'Copiar plantilla .env.example')) { Copy-Item -LiteralPath $envExample -Destination $envPath }
    } else {
        if ($PSCmdlet.ShouldProcess($envPath, 'Crear archivo .env vacÃ­o')) { New-Item -ItemType File -Path $envPath -Force | Out-Null }
    }
    Write-Warning "Se creÃ³ $envPath. Completa secretos localmente; nunca los publiques."
} else {
    Write-Host "Se conserva el .env existente."
}

Push-Location $repoRoot
try {
    docker compose -f $compose config --quiet
    if ($LASTEXITCODE -ne 0) { throw 'La configuraciÃ³n de Docker Compose no es vÃ¡lida.' }
    if ($Start) {
        Write-Host 'Iniciando servicios definidos en Docker Compose...'
        docker compose -f $compose --env-file $envPath up -d
        if ($LASTEXITCODE -ne 0) { throw 'Docker Compose no pudo iniciar los servicios.' }
    } else {
        Write-Host 'ValidaciÃ³n completada. Usa -Start para iniciar los servicios.'
    }
} finally { Pop-Location }

Write-Host 'InstalaciÃ³n/verificaciÃ³n finalizada.' -ForegroundColor Green




