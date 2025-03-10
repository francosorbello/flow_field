@echo off

set OUT_DIR=build\desktop
if not exist %OUT_DIR% mkdir %OUT_DIR%

odin build source\main_desktop -out:%OUT_DIR%\game_desktop.exe -debug
IF %ERRORLEVEL% NEQ 0 exit /b 1

echo Desktop build created in %OUT_DIR%