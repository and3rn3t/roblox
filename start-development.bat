@echo off
echo 🎮 Spectacular Roblox Obby - Development Setup
echo.
echo This script will help you set up the development environment.
echo.
echo === SETUP INSTRUCTIONS ===
echo.
echo 1. ROBLOX STUDIO METHOD (Easiest):
echo    - Open Roblox Studio
echo    - Create a new place
echo    - Copy scripts from 'src' folder to respective locations in Studio
echo    - Press F5 to test
echo.
echo 2. ROJO METHOD (Advanced):
echo    - Install Rojo: https://rojo.space/docs/installation/
echo    - Run: rojo serve
echo    - Install Rojo plugin in Studio
echo    - Connect to localhost:34872
echo.
echo === WHAT HAPPENS WHEN YOU TEST ===
echo.
echo ✨ ObbySetup.lua will automatically:
echo    - Create spawn platform and terrain
echo    - Setup beautiful lighting and skybox
echo    - Create welcome sign
echo    - Configure game settings
echo.
echo 🏗️ ObbyManager.lua will then:
echo    - Generate all 10 obby stages
echo    - Create moving platforms, hammers, mazes
echo    - Setup checkpoint and scoring systems
echo    - Enable leaderboards
echo.
echo 🎨 ObbyClient.lua provides:
echo    - Modern UI with progress tracking
echo    - Minimap showing stage completion
echo    - Sound effects and celebrations
echo    - Particle effects
echo.
echo === TESTING TIPS ===
echo.
echo • Use WASD to move, Space to jump
echo • Touch green checkpoints to save progress
echo • Avoid red spinning hammers
echo • Use bounce pads and speed rings strategically
echo • Complete all 10 stages to win!
echo.
echo === FILE STRUCTURE ===
echo.
dir /b src
echo.
echo Ready to create your spectacular obby! 🚀
echo.
pause
