# 🚀 Quick Start Guide

## Testing Your Spectacular Obby

### Method 1: Roblox Studio (Recommended for beginners)

1. **Open Roblox Studio**
2. **Create a new place** (Baseplate template works fine)
3. **Copy the scripts manually:**

```text
src/ReplicatedStorage/ObbyConfig.lua 
→ Copy to ReplicatedStorage in Studio

src/ServerScriptService/ObbyManager.lua
→ Copy to ServerScriptService in Studio

src/ServerScriptService/ObbyStages.lua  
→ Copy to ServerScriptService in Studio

src/ServerScriptService/ObbySetup.lua
→ Copy to ServerScriptService in Studio

src/StarterPlayer/StarterPlayerScripts/ObbyClient.lua
→ Copy to StarterPlayer > StarterPlayerScripts in Studio
```

4. **Press F5 or click the Play button** to test locally
5. **Watch the magic happen!** 🎪

### Method 2: Using Rojo (Advanced)

1. **Install Rojo:** [https://rojo.space/docs/installation/](https://rojo.space/docs/installation/)
2. **Run in terminal:**

   ```bash
   cd c:\git\roblox\roblox
   rojo serve
   ```

3. **Install Rojo plugin in Studio**
4. **Connect to localhost:34872**
5. **Press F5 to test**

## What You'll See

### 🏗️ Automatic Setup

- **Spawn platform** with neon spawn point
- **Beautiful lighting** with atmosphere effects
- **Welcome sign** with instructions
- **10 generated stages** with unique challenges

### 🎮 Gameplay Features

- **Stage 1:** Basic jumping platforms
- **Stage 2:** Moving platforms
- **Stage 3:** Spinning hammers (avoid them!)
- **Stage 4:** Disappearing blocks
- **Stage 5:** Conveyor belts
- **Stage 6:** Bounce pads
- **Stage 7:** Complex maze
- **Stage 8:** Speed boost rings
- **Stage 9:** Anti-gravity zone
- **Stage 10:** Epic boss battle

### 🎨 UI Elements

- **Progress tracker** showing current stage
- **Points system** with leaderboard
- **Minimap** showing completed stages
- **Reset button** to restart
- **Instructions panel**

### 🎵 Audio & Effects

- **Checkpoint sounds** when reaching new stages
- **Celebration effects** with fireworks
- **Particle trails** following the player
- **Completion fanfare** when finishing

## Controls

- **WASD** - Move
- **Space** - Jump
- **Shift** - Run faster
- **R** - Reset to checkpoint

## Troubleshooting

### Scripts not working?

- Make sure scripts are in the correct folders
- Check the output window for errors
- Verify all 5 script files are copied

### Performance issues?

- Reduce `TOTAL_STAGES` in ObbyConfig.lua
- Lower visual effect settings
- Test with fewer players

### Obby not generating?

- Check that ObbySetup.lua runs first
- Verify ObbyManager.lua is in ServerScriptService
- Look for error messages in output

## Customization

Want to modify the obby? Check out `ObbyConfig.lua` for easy settings:

- Change stage count
- Adjust point rewards
- Modify colors and effects
- Tweak physics settings

Happy testing! 🎉
