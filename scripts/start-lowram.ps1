[CmdletBinding(SupportsShouldProcess=$true)]
param([string]$InstallRoot='D:\ReclutaProntoOS-V2', [switch]$WithDocling)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repoRoot=Split-Path -Parent $PSScriptRoot
$envPath=Join-Path $InstallRoot '.env'
if (!(Test-Path $envPath)) { throw "Falta $envPath. Ejecuta install-recluta-pronto.ps1 y completa credenciales locales." }
docker info *> $null
if ($LASTEXITCODE -ne 0) { throw 'Docker Engine no está accesible. Inicia Docker Engine/WSL2 y vuelve a ejecutar.' }
$profiles=@('erpnext','integrations')
if ($WithDocling) { $profiles += 'docling' }
Push-Location $repoRoot
try {
  if ($PSCmdlet.ShouldProcess('Docker Compose','Arrancar perfil LOW-RAM')) {
    docker compose --env-file $envPath -f compose.yaml --profile $profiles up -d --remove-orphans
    if ($LASTEXITCODE -ne 0) { throw 'No se pudieron arrancar los servicios LOW-RAM.' }
  }
} finally { Pop-Location }
