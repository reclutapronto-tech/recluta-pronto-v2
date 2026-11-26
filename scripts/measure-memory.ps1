param([int]$Seconds=10)
$ErrorActionPreference='Stop'
docker info *> $null
if($LASTEXITCODE -ne 0){ throw 'Docker Engine no está accesible.' }
Write-Host 'Servicio;Memoria;Limite;CPU'
docker stats --no-stream --format '{{.Name}};{{.MemUsage}};{{.CPUPerc}}'
