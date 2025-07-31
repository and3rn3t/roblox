@echo off
echo 🚀 Installing Foreman and Rojo for Your Spectacular Obby
echo.
echo === STEP 1: Download Foreman ===
echo.
echo Please visit: https://github.com/Roblox/foreman/releases
echo Download: foreman-win64.zip (latest release)
echo.
echo === STEP 2: Extract and Install ===
echo.
echo 1. Extract foreman.exe from the zip file
echo 2. Move foreman.exe to a folder in your PATH (like C:\Windows\System32)
echo    OR create a new folder like C:\tools\ and add it to your PATH
echo.
echo === STEP 3: Install Rojo ===
echo.
echo Open a new command prompt and run:
echo   foreman install
echo.
echo This will automatically install Rojo based on your foreman.toml file!
echo.
echo === STEP 4: Start Syncing ===
echo.
echo   rojo serve
echo.
echo === ALTERNATIVE: Quick Manual Install ===
echo.
echo If you prefer, you can also:
echo 1. Download rojo.exe directly from: https://github.com/rojo-rbx/rojo/releases
echo 2. Place it in this project folder
echo 3. Run: .\rojo.exe serve
echo.
echo Your project is ready either way! 🎮
echo.
pause
start https://github.com/Roblox/foreman/releases
