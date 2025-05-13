@echo off
:: =======================================
:: ARK: Survival Ascended Dedicated Server
:: =======================================

:: ---------- Configurable Parameters ----------
set SESSION_NAME="TITLE OF SERVER"
set STEAM_DIR=C:\Server\SteamCMD
set GAME_DIR=C:\Server\Games\Ark Survival Ascended
set INSTALL_DIR=%GAME_DIR%\%SESSION_NAME%
set SERVER_DIR=%INSTALL_DIR%\ShooterGame\Binaries\Win64
set LAUNCHER=ArkAscendedServer.exe

set PORT=7777
set PEER_PORT=7778
set QUERY_PORT=27015
set RCON_PORT=27020

set MAP=TheIsland_WP
set MAX_PLAYERS=20
set SERVER_PASSWORD="UPDATE PASSWORD"
set ADMIN_PASSWORD="UPDATE PASSWORD"
set ENABLE_CROSSPLAY=True
set MultiHome=192.168.1.122

:: ---------- Mods (Optional) ----------
:: set MOD_IDS=935408,937546,940022,929420

:: =======================================
:: Step 0: Install SteamCMD if Missing
:: =======================================
if not exist "%STEAM_DIR%\steamcmd.exe" (
    echo SteamCMD not found. 
    echo Installing SteamCMD...
    mkdir "%STEAM_DIR%" 2>nul
    powershell -Command "Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile '%STEAM_DIR%\steamcmd.zip'"
    powershell -Command "Expand-Archive -Path '%STEAM_DIR%\steamcmd.zip' -DestinationPath '%STEAM_DIR%'"
    del "%STEAM_DIR%\steamcmd.zip"
    echo SteamCMD installed successfully.
)

:: =======================================
:: Step 1: Install or Update Server
:: =======================================
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

if not exist "%SERVER_DIR%\%LAUNCHER%" (
    echo ARK Server not found. 
    echo Installing...
    "%STEAM_DIR%\steamcmd.exe" +login anonymous +force_install_dir "%INSTALL_DIR%" +app_update 2430930 validate +quit
) else (
    echo ARK server already installed.
    set /p updateChoice="Would you like to check for updates? (y/n): "
    if /i "%updateChoice%"=="y" (
        echo Updating ARK server...
        "%STEAM_DIR%\steamcmd.exe" +login anonymous +force_install_dir "%INSTALL_DIR%" +app_update 2430930 validate +quit
    )
)

:: =======================================
:: Step 2: Launch the Server
:: =======================================
cd /d "%SERVER_DIR%"

echo Launching %SESSION_NAME% from %SERVER_DIR%\%LAUNCHER%
start "" "%LAUNCHER%" ^
"%MAP%?listen?SessionName=%SESSION_NAME%?MaxPlayers=%MAX_PLAYERS%?ServerPassword=%SERVER_PASSWORD%?ServerAdminPassword=%ADMIN_PASSWORD%?Crossplay=%ENABLE_CROSSPLAY%?RCONEnabled=True?RCONPort=%RCON_PORT%?Mods=%MOD_IDS%" ^
-Port=%PORT% -PeerPort=%PEER_PORT% -QueryPort=%QUERY_PORT% -MultiHome=%MultiHome% -useallavailablecores -NoBattlEye -log > log.txt 2>&1

pause
