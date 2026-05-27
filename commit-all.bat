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
if errorlevel 1 (
    echo Commit failed.
    exit /b 1
)

git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1
if errorlevel 1 (
    for /f %%i in ('git branch --show-current') do set "current_branch=%%i"
    if "%current_branch%"=="" (
        echo Commit succeeded, but the current branch could not be determined for push.
        exit /b 1
    )

    git remote get-url origin >nul 2>&1
    if errorlevel 1 (
        echo Commit succeeded, but no upstream is configured and remote "origin" was not found.
        echo Run: git push -u ^<remote^> %current_branch%
        exit /b 1
    )

    git push -u origin "%current_branch%"
    exit /b %errorlevel%
)

git push
exit /b %errorlevel%