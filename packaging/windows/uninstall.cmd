<# :
@echo off
rem Swimlane Editor for Windows: removes what install.cmd added for the current user
rem (program folder, Start menu entry, entry in Settings > Apps). Diagram files are
rem not touched. /quiet: no pause at the end.
rem
rem Everything below the batch part is PowerShell, run as a command (see install.cmd).
rem The batch part is one block, which cmd reads before this file is deleted; "exit /b"
rem would read the deleted file again, so "(goto)" ends the batch and "cmd /c exit" sets
rem the exit code.
setlocal
set "SWL_SELF=%~f0"
cd /d "%TEMP%"
(
  powershell -NoProfile -NonInteractive -Command "Invoke-Expression (Get-Content -LiteralPath $env:SWL_SELF -Raw)"
  if errorlevel 1 (
    if /i not "%~1"=="/quiet" pause
    (goto) 2>nul & cmd /c exit 1
  )
  if /i not "%~1"=="/quiet" pause
  (goto) 2>nul & cmd /c exit 0
)
#>

$ErrorActionPreference = 'Stop'
$name = 'Swimlane Editor'
$dir  = Join-Path $env:LOCALAPPDATA "Programs\$name"
$menu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
$key  = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\SwimlaneEditor'

try {
    Remove-Item -LiteralPath (Join-Path $menu "$name.lnk"), (Join-Path $menu "$name.url") -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $key -Recurse -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $dir) { Remove-Item -LiteralPath $dir -Recurse -Force }
    Write-Host "$name is removed. Your diagram files are not touched."
    exit 0
} catch {
    Write-Host "Removing $name failed: $_ (is the editor still open?)" -ForegroundColor Red
    exit 1
}
