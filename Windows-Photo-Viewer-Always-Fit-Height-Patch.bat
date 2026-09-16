@echo off
setlocal EnableExtensions
title Windows Photo Viewer - Height Fit Patch

net session >nul 2>&1
if errorlevel 1 (
    echo This patch must be run as Administrator.
    echo Right-click this BAT file and choose "Run as administrator".
    echo.
    echo Press any key to quit...
	pause>nul
    exit /b 1
)

set "DLL=%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll"
set "BACKUP=%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll.bak"

echo Windows Photo Viewer - Always Fit Image Height Patch
echo ====================================================
echo.
echo Target:
echo "%DLL%"
echo.

if not exist "%DLL%" (
    echo ERROR: PhotoViewer.dll was not found.
    pause
    exit /b 1
)

echo Backup check...

if exist "%BACKUP%" (
	echo A backup PhotoViewer.dll.bak already exists.
	echo.
	goto BEGIN
)

if not exist "%BACKUP%" (
	copy "%DLL%" "%BACKUP%" >nul
	if exist "%BACKUP%" (
		echo PhotoViewer.dll.bak created.
		echo.
		goto BEGIN
	) else (
		echo ERROR: Could not create backup file!
		echo Press any key to quit...
		pause>nul
		exit /b 1
	)
)

:BEGIN
echo - All Windows Photo Viewer processes (dllhost.exe) will be terminated.
echo - Explorer will be temporarily closed and restart automatically when patching finishes.
echo.
pause
echo.

taskkill /f /im dllhost.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo Taking temporary ownership of PhotoViewer.dll...
takeown /f "%DLL%" /a >nul 2>&1
icacls "%DLL%" /grant *S-1-5-32-544:F >nul 2>&1

echo Restoring the clean original DLL...
copy /y "%BACKUP%" "%DLL%" >nul
if errorlevel 1 (
    set "PATCHERR=20"
    goto :cleanup
)

echo Applying new patch...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$p=$env:DLL;" ^
 "$b=[IO.File]::ReadAllBytes($p);" ^
 "$o1=0x40BE2; $o2=0x40C76;" ^
 "if($b.Length -le ($o2+1)){exit 10};" ^
 "if(($b[$o1] -ne 0x7F) -or ($b[$o1+1] -ne 0x55)){exit 11};" ^
 "if(($b[$o2] -ne 0x76) -or ($b[$o2+1] -ne 0x22)){exit 12};" ^
 "$b[$o1]=0xEB;" ^
 "$b[$o2]=0xEB;" ^
 "[IO.File]::WriteAllBytes($p,$b)"

set "PATCHERR=%ERRORLEVEL%"

:cleanup
echo.
echo Restoring TrustedInstaller ownership...
icacls "%DLL%" /setowner "NT SERVICE\TrustedInstaller" >nul 2>&1

start "" explorer.exe

echo.
if not "%PATCHERR%"=="0" (
    echo PATCH FAILED.
    echo Explorer has been restarted.
    echo.
    pause
    exit /b %PATCHERR%
)

echo Patch applied successfully.
echo Explorer has been restarted.
echo.
pause
endlocal
