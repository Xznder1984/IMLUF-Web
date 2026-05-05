@echo off
SETLOCAL EnableDelayedExpansion

echo ==========================================
echo       IMF Browser Git Push Tool
echo ==========================================

:: Check if we are in a git repository
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] No git repository found in this directory.
    echo Make sure you run this script from the folder containing the .git folder.
    pause
    exit /b 1
)

:: Get the current branch name
for /f "tokens=*" %%i in ('git rev-parse --abbrev-ref HEAD') do set BRANCH=%%i
echo [INFO] Current branch: %BRANCH%

:: Ask for commit message
set /p COMMIT_MSG="Enter commit message (or press Enter for 'Update IMF Browser'): "
if "%COMMIT_MSG%"=="" set COMMIT_MSG="Update IMF Browser"

echo [INFO] Adding changes...
git add .

:: Check if there are actually changes to commit
git diff-index --quiet HEAD --
if %errorlevel% equ 0 (
    echo [INFO] No changes to commit.
    goto PUSH_STEP
)

echo [INFO] Committing changes...
git commit -m %COMMIT_MSG%

:PUSH_STEP
echo [INFO] Pushing to GitHub...
git push origin %BRANCH%

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo [SUCCESS] Project pushed to GitHub successfully!
    echo ==========================================
) else (
    echo.
    echo ==========================================
    echo [ERROR] Failed to push to GitHub. 
    echo Please check your internet connection and GitHub credentials.
    echo ==========================================
)

pause
ENDLOCAL
