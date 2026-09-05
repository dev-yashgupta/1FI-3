# ============================================================
# auto_commit.ps1
# Usage:
#   One-shot:   .\auto_commit.ps1 [-Message "your message"]
#   Watch mode: .\auto_commit.ps1 -Watch [-IntervalMinutes 5]
# ============================================================

param(
    [string]$Message = "",
    [switch]$Watch,
    [int]$IntervalMinutes = 5
)

$RepoDir = $PSScriptRoot
Set-Location $RepoDir

function Invoke-Commit {
    param([string]$Msg)

    if ([string]::IsNullOrWhiteSpace($Msg)) {
        $Msg = "auto: snapshot $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }

    Write-Host "[auto_commit] Staging all changes..." -ForegroundColor Cyan
    git add -A

    $status = git status --porcelain
    if (-not $status) {
        Write-Host "[auto_commit] Nothing to commit. Working tree clean." -ForegroundColor Yellow
        return
    }

    Write-Host "[auto_commit] Committing: $Msg" -ForegroundColor Green
    git commit -m $Msg

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[auto_commit] Done." -ForegroundColor Green
    } else {
        Write-Host "[auto_commit] ERROR: commit failed." -ForegroundColor Red
    }
}

if ($Watch) {
    Write-Host "[auto_commit] Watch mode ON - committing every $IntervalMinutes minute(s). Ctrl+C to stop." -ForegroundColor Magenta
    while ($true) {
        Invoke-Commit -Msg $Message
        Start-Sleep -Seconds ($IntervalMinutes * 60)
    }
} else {
    Invoke-Commit -Msg $Message
}
