@echo off
setlocal EnableExtensions

cd /d "%~dp0"

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo This folder is not a git repository.
    exit /b 1
)

set "commit_message=%~1"

if "%commit_message%"=="" (
    set /p "commit_message=Enter commit message: "
)

if "%commit_message%"=="" (
    echo Commit message is required.
    exit /b 1
)

git add -A
if errorlevel 1 (
    echo Failed to stage changes.
    exit /b 1
)

git commit -m "%commit_message%"
exit /b %errorlevel%