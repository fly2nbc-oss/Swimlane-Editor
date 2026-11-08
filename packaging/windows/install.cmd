<# :
@echo off
rem Swimlane Editor for Windows: installs for the current user, no admin rights needed.
rem Copies the editor to %LOCALAPPDATA%\Programs\Swimlane Editor, adds "Swimlane Editor"
rem to the Start menu (opens maximized in its own Edge window) and to Settings > Apps.
rem Run it again to update. /quiet: no pause at the end (for software distribution).
rem
rem Everything below the batch part is PowerShell. It runs as a command, not as a
rem script file, so a script execution policy does not stop it.
setlocal
set "SWL_SELF=%~f0"
cd /d "%TEMP%"
(
  powershell -NoProfile -NonInteractive -Command "Invoke-Expression (Get-Content -LiteralPath $env:SWL_SELF -Raw)"
  if errorlevel 1 (
    if /i not "%~1"=="/quiet" pause
    exit /b 1
  )
  if /i not "%~1"=="/quiet" pause
  exit /b 0
)
#>

$ErrorActionPreference = 'Stop'
$name = 'Swimlane Editor'
$src  = Split-Path -Parent $env:SWL_SELF
$dir  = Join-Path $env:LOCALAPPDATA "Programs\$name"
$html = Join-Path $dir 'swimlane-editor.html'
$icon = Join-Path $dir 'swimlane-editor.ico'
$menu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
$key  = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\SwimlaneEditor'

try {
    $files = 'swimlane-editor.html', 'swimlane-editor.ico', 'uninstall.cmd', 'LICENSE', 'NOTICE', 'THIRD_PARTY.md'
    foreach ($f in $files) {
        if (-not (Test-Path -LiteralPath (Join-Path $src $f))) {
            throw "$f is missing next to install.cmd. Unpack the whole ZIP file first, then run install.cmd from there."
        }
    }
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    foreach ($f in $files) { Copy-Item -LiteralPath (Join-Path $src $f) -Destination $dir -Force }
    # Files from a downloaded ZIP carry the "from the internet" mark; the installed copy doesn't need it.
    Get-ChildItem -LiteralPath $dir -File | Unblock-File

    $version = ''
    if ((Get-Content -LiteralPath $html -Raw) -match "const APP_VERSION = '([^']+)'") { $version = $Matches[1] }

    # Edge opens the file in an app window: no tabs, no address bar, own taskbar entry.
    $edge = $null
    $candidates = @(
        (Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe' -ErrorAction SilentlyContinue).'(default)'
        (Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe' -ErrorAction SilentlyContinue).'(default)'
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe')
        (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe')
    )
    foreach ($c in $candidates) {
        if ($c -and (Test-Path -LiteralPath $c.Trim('"'))) { $edge = $c.Trim('"'); break }
    }
    $url = 'file:///' + (($html -replace '%', '%25' -replace ' ', '%20' -replace '#', '%23') -replace '\\', '/')

    $lnkPath = Join-Path $menu "$name.lnk"
    $urlPath = Join-Path $menu "$name.url"
    Remove-Item -LiteralPath $lnkPath, $urlPath -ErrorAction SilentlyContinue
    $fallback = $false
    try {
        $shell = New-Object -ComObject WScript.Shell
        $lnk = $shell.CreateShortcut($lnkPath)
        if ($edge) { $lnk.TargetPath = $edge; $lnk.Arguments = "--start-maximized --app=`"$url`"" } else { $lnk.TargetPath = $html }
        $lnk.WorkingDirectory = $dir
        $lnk.IconLocation = "$icon,0"
        $lnk.WindowStyle = 3  # maximized
        $lnk.Description = 'Swimlane process diagrams'
        $lnk.Save()
    } catch {
        # Locked-down PowerShell (constrained language) may refuse the shortcut object.
        # An Internet shortcut needs none; it opens the editor in the default browser.
        Remove-Item -LiteralPath $lnkPath -ErrorAction SilentlyContinue
        Set-Content -LiteralPath $urlPath -Encoding Unicode -Value @('[InternetShortcut]', "URL=$url", "IconFile=$icon", 'IconIndex=0', 'ShowCommand=3')
        $fallback = $true
    }

    # Entry in Settings > Apps > Installed apps, for the current user only.
    New-Item -Path $key -Force | Out-Null
    $size = (Get-ChildItem -LiteralPath $dir -File | Measure-Object -Property Length -Sum).Sum
    Set-ItemProperty -LiteralPath $key -Name DisplayName -Value $name
    Set-ItemProperty -LiteralPath $key -Name DisplayVersion -Value $version
    Set-ItemProperty -LiteralPath $key -Name DisplayIcon -Value $icon
    Set-ItemProperty -LiteralPath $key -Name InstallLocation -Value $dir
    Set-ItemProperty -LiteralPath $key -Name UninstallString -Value "$env:ComSpec /c `"`"$(Join-Path $dir 'uninstall.cmd')`" /quiet`""
    Set-ItemProperty -LiteralPath $key -Name EstimatedSize -Value ([int]($size / 1024)) -Type DWord
    Set-ItemProperty -LiteralPath $key -Name NoModify -Value 1 -Type DWord
    Set-ItemProperty -LiteralPath $key -Name NoRepair -Value 1 -Type DWord

    Write-Host "$name $version is installed in $dir"
    Write-Host "Start it from the Start menu: $name"
    if ($fallback) { Write-Host 'It opens in your default browser (Windows did not allow the Edge app shortcut).' }
    elseif (-not $edge) { Write-Host 'Microsoft Edge was not found; it opens in your default browser.' }
    Write-Host 'To update, run install.cmd of the new version. To remove: Settings > Apps > Installed apps.'
    exit 0
} catch {
    Write-Host "Installation failed: $_" -ForegroundColor Red
    exit 1
}
