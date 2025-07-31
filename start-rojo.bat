@echo off
echo 🎮 Spectacular Obby - Rojo Server Launcher
echo.

REM Check if rojo.exe exists in current directory
if exist "rojo.exe" (
    echo ✅ Found rojo.exe in project folder
    echo 🚀 Starting Rojo server for your spectacular obby...
    echo.
    echo 📡 Server will be available at: http://localhost:34872
    echo 🔌 Connect Roblox Studio to this address
    echo.
    echo Press Ctrl+C to stop the server when done testing
    echo.
    .\rojo.exe serve
) else (
    echo ❌ rojo.exe not found in current directory
    echo.
    echo Please download rojo.exe first:
    echo 1. Go to: https://github.com/rojo-rbx/rojo/releases/latest
    echo 2. Download: rojo-win64.exe
    echo 3. Rename to: rojo.exe
    echo 4. Put it in: c:\git\roblox\roblox\
    echo 5. Run this script again
    echo.
    echo Opening download page...
    start https://github.com/rojo-rbx/rojo/releases/latest
)

pause
