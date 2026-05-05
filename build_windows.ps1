# IMF Browser Build Script for Windows (PowerShell)

Write-Host "==========================================" -ForegroundColor Blue
Write-Host "       IMF Browser Windows Build System       " -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue

# 1. Directory Logic
$baseDir = "."
if (-not (Test-Path "src-tauri")) {
    $baseDir = "browser"
}

$tauriDir = Join-Path $baseDir "src-tauri"

# 2. Check Rust
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Rust (cargo) not found. Please install it from https://rustup.rs/" -ForegroundColor Red
    exit 1
}

# 3. Compilation
Write-Host "Compiling IMF Browser for Windows..." -ForegroundColor Cyan
Push-Location $tauriDir
try {
    cargo build --release
} catch {
    Write-Host "Build failed: $($_.Exception.Message)" -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location

# 4. Binary Handling
$binaryPath = Join-Path $baseDir "src-tauri\target\release\imf-browser.exe"

if (Test-Path $binaryPath) {
    Write-Host "Success! Binary located at: $binaryPath" -ForegroundColor Green
    
    if (Get-Command upx -ErrorAction SilentlyContinue) {
        Write-Host "Compressing binary with UPX..." -ForegroundColor Cyan
        & upx --best $binaryPath
    } else {
        Write-Host "UPX not found. Skipping compression." -ForegroundColor Yellow
    }
} else {
    Write-Host "Error: Binary not found at $binaryPath" -ForegroundColor Red
    exit 1
}

Write-Host "==========================================" -ForegroundColor Blue
Write-Host "Windows Build Process Completed!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Blue
