--[[
    Obby Setup Script
    Run this once to automatically set up the obby in your game
]]--

local ObbySetup = {}

function ObbySetup.createBasicTerrain()
    -- Clear existing terrain
    workspace.Terrain:ReadVoxels(workspace.Terrain.ReadVoxels(workspace.Terrain, Region3.new(Vector3.new(-1000, -1000, -1000), Vector3.new(1000, 1000, 1000))), 4)
    
    -- Create spawn area
    local spawnPlatform = Instance.new("Part")
    spawnPlatform.Name = "SpawnPlatform"
    spawnPlatform.Size = Vector3.new(30, 4, 30)
    spawnPlatform.Position = Vector3.new(0, 2, 0)
    spawnPlatform.Material = Enum.Material.Grass
    spawnPlatform.BrickColor = BrickColor.new("Bright green")
    spawnPlatform.Anchored = true
    spawnPlatform.Parent = workspace
    
    -- Add spawn location
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Size = Vector3.new(6, 1, 6)
    spawnLocation.Position = Vector3.new(0, 6, 0)
    spawnLocation.Material = Enum.Material.Neon
    spawnLocation.BrickColor = BrickColor.new("Bright blue")
    spawnLocation.CanCollide = false
    spawnLocation.Parent = workspace
end

function ObbySetup.setupLighting()
    local lighting = game:GetService("Lighting")
    
    -- Enhanced lighting settings
    lighting.Brightness = 2
    lighting.Ambient = Color3.fromRGB(70, 70, 70)
    lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    lighting.ShadowSoftness = 0.5
    lighting.ClockTime = 14
    lighting.FogEnd = 1000
    lighting.FogStart = 500
    lighting.GlobalShadows = true
    
    -- Add atmospheric effects
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 199)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2
    atmosphere.Haze = 0.3
    atmosphere.Parent = lighting
    
    -- Add bloom effect
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.4
    bloom.Size = 24
    bloom.Threshold = 1.2
    bloom.Parent = lighting
    
    -- Add color correction
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Brightness = 0.05
    colorCorrection.Contrast = 0.1
    colorCorrection.Saturation = 0.2
    colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
    colorCorrection.Parent = lighting
end

function ObbySetup.setupSkybox()
    local lighting = game:GetService("Lighting")
    
    -- Modern skybox
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex"
    sky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
    sky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
    sky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
    sky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
    sky.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
    sky.Parent = lighting
end

function ObbySetup.createWelcomeSign()
    -- Welcome sign near spawn
    local sign = Instance.new("Part")
    sign.Name = "WelcomeSign"
    sign.Size = Vector3.new(20, 12, 2)
    sign.Position = Vector3.new(0, 12, -25)
    sign.Material = Enum.Material.SmoothPlastic
    sign.BrickColor = BrickColor.new("Really black")
    sign.Anchored = true
    sign.Parent = workspace
    
    -- Sign surface
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.Parent = sign
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎮 SPECTACULAR OBBY"
    titleLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = surfaceGui
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Complete 10 challenging stages!\n\n🎯 Touch checkpoints to save progress\n⚡ Avoid obstacles and use power-ups\n🏆 Compete on the leaderboard"
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 24
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Center
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.Parent = surfaceGui
end

function ObbySetup.setupGameSettings()
    -- Configure workspace settings
    workspace.Gravity = 196.2
    workspace.FallenPartsDestroyHeight = -500
    
    -- Configure StarterGui
    local starterGui = game:GetService("StarterGui")
    starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
    starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false) -- Hide backpack since it's not needed
    
    -- Configure player settings
    local players = game:GetService("Players")
    players.CharacterAutoLoads = true
    players.RespawnTime = 3
end

-- Main setup function
function ObbySetup.setupObby()
    print("🏗️ Setting up Spectacular Obby...")
    
    ObbySetup.createBasicTerrain()
    print("   ✅ Terrain created")
    
    ObbySetup.setupLighting()
    print("   ✅ Lighting configured")
    
    ObbySetup.setupSkybox()
    print("   ✅ Skybox added")
    
    ObbySetup.createWelcomeSign()
    print("   ✅ Welcome sign created")
    
    ObbySetup.setupGameSettings()
    print("   ✅ Game settings configured")
    
    print("🎉 Obby setup complete! The ObbyManager will handle the rest.")
    print("💡 Tip: Players will spawn and the obby stages will be automatically generated!")
end

-- Auto-run setup
ObbySetup.setupObby()

return ObbySetup
