@echo off
setlocal EnableExtensions
title Windows Photo Viewer - Uninstall Height Fit Patch

net session >nul 2>&1
if errorlevel 1 (
    echo This uninstaller must be run as Administrator.
    echo Right-click this BAT file and choose "Run as administrator".
    echo.
	echo Press any key to quit...
	pause>nul
    exit /b 1
)

set "DLL=%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll"
set "BACKUP=%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll.bak"

echo Windows Photo Viewer - Uninstall Height Fit Patch
echo =================================================
echo.
echo Target:
echo "%DLL%"
echo.

if not exist "%BACKUP%" (
    echo ERROR: Original backup was not found:
    echo "%BACKUP%"
    echo.
    echo Nothing has been changed.
	echo.
    echo Press any key to quit...
	pause>nul
    exit /b 1
)

echo - All Windows Photo Viewer processes (dllhost.exe) will be terminated.
echo - Explorer will be temporarily closed and restart automatically when uninstalling finishes.
echo.
pause
echo.

taskkill /f /im dllhost.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo Taking temporary ownership of PhotoViewer.dll...
if exist "%DLL%" (
    takeown /f "%DLL%" /a >nul 2>&1
    icacls "%DLL%" /grant *S-1-5-32-544:F >nul 2>&1
)

echo Restoring the original PhotoViewer.dll...
copy /y "%BACKUP%" "%DLL%" >nul
if errorlevel 1 (
    set "UNINSTALLERR=20"
    goto :cleanup
)

set "UNINSTALLERR=0"

:cleanup
echo Restoring TrustedInstaller ownership...
if exist "%DLL%" icacls "%DLL%" /setowner "NT SERVICE\TrustedInstaller" >nul 2>&1

start "" explorer.exe

echo.
if not "%UNINSTALLERR%"=="0" (
    echo UNINSTALL FAILED.
    echo Explorer has been restarted.
    echo.
    pause
    exit /b %UNINSTALLERR%
)

echo Patch uninstalled successfully.
echo Original PhotoViewer.dll has been restored.
echo "%BACKUP%" remained on disk for safety. You may delete it manually.
echo Explorer has been restarted.
echo.
pause
endlocal
