[CmdletBinding()]
param(
  [string]$FrappeUrl = 'http://localhost:8000',
  [string]$EvolutionUrl = 'http://localhost:8080',
  [string]$DoclingUrl = 'http://localhost:5001',
  [string]$N8nUrl = 'http://localhost:5678'
)
$ErrorActionPreference = 'Stop'
$checks = @(
  @{ Name='Frappe'; Url="$FrappeUrl/api/method/ping" },
  @{ Name='Evolution API'; Url="$EvolutionUrl/" },
  @{ Name='Docling Serve'; Url="$DoclingUrl/health" },
  @{ Name='n8n'; Url="$N8nUrl/healthz" }
)
$failed = @()
foreach ($check in $checks) {
  try {
    $response = Invoke-WebRequest -Uri $check.Url -UseBasicParsing -TimeoutSec 10
    Write-Host "$($check.Name): HTTP $($response.StatusCode)"
  } catch {
    $failed += "$($check.Name): $($_.Exception.Message)"
  }
}
if ($failed.Count) { $failed | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host 'E2E service smoke checks passed.' -ForegroundColor Green
