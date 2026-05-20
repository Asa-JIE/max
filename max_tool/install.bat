@echo off
chcp 65001 >nul
setlocal

echo ============================================
echo MaxTool Installer
echo ============================================

set "TOOL_ROOT=%~dp0"

if "%TOOL_ROOT:~-1%"=="\" (
    set "TOOL_ROOT=%TOOL_ROOT:~0,-1%"
)

echo TOOL_ROOT:
echo %TOOL_ROOT%
echo.

set "MODULE_DIR=%LOCALAPPDATA%\Autodesk\3dsMax\2020 - 64bit\ENU\modules"

if not exist "%MODULE_DIR%" (
    mkdir "%MODULE_DIR%"
)

echo MODULE_DIR:
echo %MODULE_DIR%
echo.

set "MOD_FILE=%MODULE_DIR%\MaxTool.mod"

(
    echo + MaxTool 1.0 %TOOL_ROOT%
    echo scripts: scripts
    echo icons: icons
) > "%MOD_FILE%"

echo MOD CREATED:
echo %MOD_FILE%
echo.

set "STARTUP_DIR=%LOCALAPPDATA%\Autodesk\3dsMax\2020 - 64bit\ENU\scripts\startup"

if not exist "%STARTUP_DIR%" (
    mkdir "%STARTUP_DIR%"
)

copy /Y "%TOOL_ROOT%\scripts\startup\max_tool_startup.ms" "%STARTUP_DIR%\max_tool_startup.ms"

set "PATH_MANAGER=%TOOL_ROOT%\scripts\max_tool\core\path_manager.ms"

(
    echo global MAX_TOOL_ROOT
    echo MAX_TOOL_ROOT = @"%TOOL_ROOT%\scripts\max_tool"
) > "%PATH_MANAGER%"

echo.
echo ============================================
echo INSTALL SUCCESS
echo ============================================
pause
