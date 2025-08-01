--[[
    Debug Script - Check what's happening
]]--

print("🔍 Starting debug check...")

-- Check if ReplicatedStorage exists and has ObbyConfig
local ReplicatedStorage = game:GetService("ReplicatedStorage")
print("✅ ReplicatedStorage found")

local function checkForObbyConfig()
    local config = ReplicatedStorage:FindFirstChild("ObbyConfig")
    if config then
        print("✅ ObbyConfig found in ReplicatedStorage")
        return true
    else
        print("❌ ObbyConfig NOT found in ReplicatedStorage")
        print("🔍 Available children in ReplicatedStorage:")
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            print("   - " .. child.Name)
        end
        return false
    end
end

local function checkForObbyStages()
    local stages = script.Parent:FindFirstChild("ObbyStages")
    if stages then
        print("✅ ObbyStages found in ServerScriptService")
        return true
    else
        print("❌ ObbyStages NOT found in ServerScriptService")
        print("🔍 Available children in ServerScriptService:")
        for _, child in pairs(script.Parent:GetChildren()) do
            print("   - " .. child.Name)
        end
        return false
    end
end

-- Wait a bit for everything to load
wait(2)

local configOK = checkForObbyConfig()
local stagesOK = checkForObbyStages()

if configOK and stagesOK then
    print("🎉 All modules found! ObbyManager should work.")
    print("💡 Try manually running ObbyManager from Studio console:")
    print("require(game.ServerScriptService.ObbyManager)")
else
    print("⚠️ Some modules missing. Let's create a simple version...")
    
    -- Create a simple obby without complex modules
    print("🏗️ Creating simple obby stages...")
    
    for i = 1, 3 do -- Just 3 stages for testing
        local stageFolder = Instance.new("Folder")
        stageFolder.Name = "Stage" .. i
        stageFolder.Parent = workspace
        
        local platform = Instance.new("Part")
        platform.Name = "Platform" .. i
        platform.Size = Vector3.new(20, 2, 20)
        platform.Position = Vector3.new(0, 10 + (i * 20), i * 30)
        platform.Material = Enum.Material.Neon
        platform.BrickColor = BrickColor.new("Bright blue")
        platform.Anchored = true
        platform.Parent = stageFolder
        
        -- Add some simple jumping platforms
        for j = 1, 5 do
            local jumpPlatform = Instance.new("Part")
            jumpPlatform.Name = "JumpPlatform" .. j
            jumpPlatform.Size = Vector3.new(6, 1, 6)
            jumpPlatform.Position = Vector3.new(
                math.random(-15, 15),
                10 + (i * 20) + math.random(2, 8),
                i * 30 + j * 5
            )
            jumpPlatform.Material = Enum.Material.Plastic
            jumpPlatform.BrickColor = BrickColor.new("Bright green")
            jumpPlatform.Anchored = true
            jumpPlatform.Parent = stageFolder
        end
        
        print("   ✅ Stage " .. i .. " created")
    end
    
    print("🎮 Simple obby created! You should see 3 stages with jumping platforms.")
end
