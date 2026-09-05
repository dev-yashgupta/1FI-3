@echo off
:: ============================================================
:: auto_commit.bat
:: Auto-stages all changes and commits with a timestamped message.
:: Run from the workspace root:  auto_commit.bat [optional message]
:: ============================================================

set REPO_DIR=%~dp0
cd /d "%REPO_DIR%"

:: Build commit message
if "%~1"=="" (
    for /f "tokens=1-6 delims=/:. " %%a in ("%DATE% %TIME%") do (
        set MSG=auto: snapshot %%d-%%b-%%c %%e:%%f:%%g
    )
) else (
    set MSG=%~1
)

echo.
echo [auto_commit] Staging all changes...
git add -A

git diff --cached --quiet
if %ERRORLEVEL%==0 (
    echo [auto_commit] Nothing to commit. Working tree clean.
    exit /b 0
)

echo [auto_commit] Committing: %MSG%
git commit -m "%MSG%"

if %ERRORLEVEL%==0 (
    echo [auto_commit] Done.
) else (
    echo [auto_commit] ERROR: commit failed.
    exit /b 1
)
