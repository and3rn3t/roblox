--[[
    Simple Obby Manager (No Dependencies)
    This version creates a basic obby without requiring external modules
]]--

print("🎮 Starting Simple Obby Manager...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Simple configuration
local CONFIG = {
    TOTAL_STAGES = 5,
    STAGE_HEIGHT = 30,
    STAGE_LENGTH = 50,
}

local ObbyManager = {}
local movingParts = {}
local playerData = {}

-- Create leaderboard for players
local function setupPlayerStats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local stage = Instance.new("IntValue")
    stage.Name = "Stage"
    stage.Value = 1
    stage.Parent = leaderstats
    
    local points = Instance.new("IntValue")
    points.Name = "Points"
    points.Value = 0
    points.Parent = leaderstats
    
    playerData[player] = {
        currentStage = 1,
        points = 0,
    }
    
    print("📊 Set up stats for player: " .. player.Name)
end

-- Create a simple stage
local function createStage(stageNumber)
    print("🏗️ Creating stage " .. stageNumber)
    
    local stageFolder = Instance.new("Folder")
    stageFolder.Name = "Stage" .. stageNumber
    stageFolder.Parent = workspace
    
    local baseY = (stageNumber - 1) * CONFIG.STAGE_HEIGHT
    local baseZ = (stageNumber - 1) * CONFIG.STAGE_LENGTH
    
    -- Main platform
    local platform = Instance.new("Part")
    platform.Name = "MainPlatform"
    platform.Size = Vector3.new(30, 2, CONFIG.STAGE_LENGTH)
    platform.Position = Vector3.new(0, baseY, baseZ + CONFIG.STAGE_LENGTH/2)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.Parent = stageFolder
    
    -- Add some obstacles based on stage
    if stageNumber == 1 then
        -- Simple jumping platforms
        for i = 1, 6 do
            local jumpPart = Instance.new("Part")
            jumpPart.Size = Vector3.new(6, 1, 6)
            jumpPart.Position = Vector3.new(
                math.random(-10, 10),
                baseY + math.random(3, 8),
                baseZ + i * 8
            )
            jumpPart.Material = Enum.Material.Plastic
            jumpPart.BrickColor = BrickColor.new("Bright green")
            jumpPart.Anchored = true
            jumpPart.Parent = stageFolder
        end
        
    elseif stageNumber == 2 then
        -- Moving platform
        local movingPlatform = Instance.new("Part")
        movingPlatform.Size = Vector3.new(8, 1, 8)
        movingPlatform.Position = Vector3.new(0, baseY + 10, baseZ + 25)
        movingPlatform.Material = Enum.Material.ForceField
        movingPlatform.BrickColor = BrickColor.new("Bright yellow")
        movingPlatform.Anchored = true
        movingPlatform.Parent = stageFolder
        
        -- Add to moving parts
        table.insert(movingParts, {
            part = movingPlatform,
            type = "horizontal",
            range = 20,
            speed = 2,
            startPos = movingPlatform.Position
        })
        
    elseif stageNumber == 3 then
        -- Spinning obstacle
        local spinner = Instance.new("Part")
        spinner.Size = Vector3.new(20, 2, 2)
        spinner.Position = Vector3.new(0, baseY + 8, baseZ + 25)
        spinner.Material = Enum.Material.Metal
        spinner.BrickColor = BrickColor.new("Really red")
        spinner.Anchored = true
        spinner.Parent = stageFolder
        
        table.insert(movingParts, {
            part = spinner,
            type = "spinning",
            speed = 3
        })
        
    elseif stageNumber >= 4 then
        -- Combination of elements
        for i = 1, 4 do
            local obstacle = Instance.new("Part")
            obstacle.Size = Vector3.new(4, 1, 4)
            obstacle.Position = Vector3.new(
                math.random(-12, 12),
                baseY + math.random(3, 12),
                baseZ + i * 10
            )
            obstacle.Material = Enum.Material.Glass
            obstacle.BrickColor = BrickColor.new("Light blue")
            obstacle.Anchored = true
            obstacle.Parent = stageFolder
        end
    end
    
    -- Checkpoint at end
    local checkpoint = Instance.new("Part")
    checkpoint.Name = "Checkpoint" .. stageNumber
    checkpoint.Size = Vector3.new(8, 12, 2)
    checkpoint.Position = Vector3.new(0, baseY + 8, baseZ + CONFIG.STAGE_LENGTH - 5)
    checkpoint.Material = Enum.Material.ForceField
    checkpoint.BrickColor = BrickColor.new("Bright green")
    checkpoint.Anchored = true
    checkpoint.Parent = stageFolder
    
    -- Checkpoint touch detection
    checkpoint.Touched:Connect(function(hit)
        local player = Players:GetPlayerFromCharacter(hit.Parent)
        if player and playerData[player] then
            local data = playerData[player]
            if stageNumber == data.currentStage + 1 or stageNumber == 1 then
                data.currentStage = stageNumber
                data.points = data.points + 10
                
                -- Update leaderboard
                if player.leaderstats then
                    player.leaderstats.Stage.Value = stageNumber
                    player.leaderstats.Points.Value = data.points
                end
                
                print("🎯 " .. player.Name .. " reached stage " .. stageNumber)
                
                -- Completion check
                if stageNumber >= CONFIG.TOTAL_STAGES then
                    print("🎉 " .. player.Name .. " completed the obby!")
                    data.points = data.points + 100
                    if player.leaderstats then
                        player.leaderstats.Points.Value = data.points
                    end
                end
            end
        end
    end)
end

-- Animation system
local function updateMovingParts()
    local time = tick()
    
    for _, movingPart in ipairs(movingParts) do
        if movingPart.type == "horizontal" then
            local offset = math.sin(time * movingPart.speed) * movingPart.range/2
            movingPart.part.Position = movingPart.startPos + Vector3.new(offset, 0, 0)
            
        elseif movingPart.type == "spinning" then
            local rotation = time * movingPart.speed * 57.3
            movingPart.part.CFrame = CFrame.new(movingPart.part.Position) * CFrame.Angles(0, math.rad(rotation), 0)
        end
    end
end

-- Main initialization
local function initializeObby()
    print("🚀 Initializing Simple Obby...")
    
    -- Create all stages
    for i = 1, CONFIG.TOTAL_STAGES do
        createStage(i)
    end
    
    -- Start animation system
    RunService.Heartbeat:Connect(updateMovingParts)
    
    -- Setup player connections
    Players.PlayerAdded:Connect(setupPlayerStats)
    
    -- Setup existing players
    for _, player in pairs(Players:GetPlayers()) do
        setupPlayerStats(player)
    end
    
    print("✅ Simple Obby initialized with " .. CONFIG.TOTAL_STAGES .. " stages!")
    print("🎮 Players can now test the obby!")
end

-- Start the obby
initializeObby()

return ObbyManager
