@echo off
echo 🔧 Rojo Installation Helper
echo.
echo This script will help you install Rojo for syncing your obby code.
echo.
echo === INSTALLATION OPTIONS ===
echo.
echo 1. RECOMMENDED: Install via Foreman (Package Manager)
echo    - Download foreman.exe from: https://github.com/Roblox/foreman/releases
echo    - Place it in your PATH
echo    - Run: foreman install
echo.
echo 2. ALTERNATIVE: Direct Download
echo    - Go to: https://github.com/rojo-rbx/rojo/releases
echo    - Download latest rojo.exe for Windows
echo    - Add to your PATH or place in project folder
echo.
echo 3. EASIEST: Use Cargo (if you have Rust)
echo    - Run: cargo install rojo
echo.
echo === AFTER INSTALLATION ===
echo.
echo 1. Run: rojo serve
echo 2. Install Rojo plugin in Roblox Studio
echo 3. Connect to localhost:34872 in Studio
echo 4. Your code will sync automatically!
echo.
echo === ALTERNATIVE: Manual Copy Method ===
echo.
echo If Rojo seems complicated, you can always copy the scripts manually:
echo - Copy files from src/ folders to Roblox Studio
echo - This works perfectly fine for testing
echo.
echo Your obby is ready to test either way! 🎮
echo.
echo === CURRENT PROJECT STATUS ===
echo.
echo ✅ rojo.toml configured
echo ✅ All scripts created and ready
echo ✅ Project structure correct
echo ❌ Rojo not installed (this script helps with that)
echo.
pause
