--[[
    Spectacular Obby Manager
    Main server script that manages the obby game logic
]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Import configuration and advanced stages
local ObbyConfig = require(ReplicatedStorage:WaitForChild("ObbyConfig"))
local ObbyStages = require(script.Parent.ObbyStages)

local ObbyManager = {}
ObbyManager.__index = ObbyManager

-- Configuration (now using ObbyConfig)
local CONFIG = ObbyConfig.GAME

-- Player data storage
local playerData = {}
local leaderboard = {}

function ObbyManager.new()
    local self = setmetatable({}, ObbyManager)
    self.stages = {}
    self.movingParts = {}
    
    self:initialize()
    return self
end

function ObbyManager:initialize()
    print("🎮 Initializing Spectacular Obby...")
    
    -- Create leaderboard
    self:setupLeaderboard()
    
    -- Generate obby stages
    self:generateObby()
    
    -- Setup player connections
    self:setupPlayerConnections()
    
    -- Start moving parts animation
    self:startAnimations()
    
    print("✅ Obby initialization complete!")
end

function ObbyManager:setupLeaderboard()
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = game.ServerStorage
    
    -- Connect to player joining
    Players.PlayerAdded:Connect(function(player)
        self:setupPlayerStats(player)
    end)
end

function ObbyManager:setupPlayerStats(player)
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
    
    local completions = Instance.new("IntValue")
    completions.Name = "Completions"
    completions.Value = 0
    completions.Parent = leaderstats
    
    -- Initialize player data
    playerData[player] = {
        currentStage = 1,
        points = 0,
        completions = 0,
        lastCheckpoint = CONFIG.SPAWN_POSITION
    }
    
    -- Spawn player at beginning
    self:teleportToStage(player, 1)
end

function ObbyManager:generateObby()
    print("🏗️ Generating obby stages...")
    
    for i = 1, CONFIG.TOTAL_STAGES do
        local stage = self:createStage(i)
        self.stages[i] = stage
        print(string.format("   Stage %d created", i))
    end
    
    -- Create finish area
    self:createFinishArea()
end

function ObbyManager:createStage(stageNumber)
    local stageFolder = Instance.new("Folder")
    stageFolder.Name = "Stage" .. stageNumber
    stageFolder.Parent = workspace
    
    local baseY = (stageNumber - 1) * CONFIG.STAGE_HEIGHT
    local stageData = {
        number = stageNumber,
        folder = stageFolder,
        checkpoints = {},
        obstacles = {},
        basePosition = Vector3.new(0, baseY, (stageNumber - 1) * CONFIG.STAGE_LENGTH)
    }
    
    -- Create stage platform
    self:createStagePlatform(stageData)
    
    -- Add obstacles based on stage number
    if stageNumber == 1 then
        self:createJumpingStage(stageData)
    elseif stageNumber == 2 then
        self:createMovingPlatformStage(stageData)
    elseif stageNumber == 3 then
        self:createSpinningHammerStage(stageData)
    elseif stageNumber == 4 then
        self:createDisappearingBlockStage(stageData)
    elseif stageNumber == 5 then
        ObbyStages.createConveyorBeltStage(self, stageData)
    elseif stageNumber == 6 then
        ObbyStages.createBouncePadStage(self, stageData)
    elseif stageNumber == 7 then
        ObbyStages.createMazeStage(self, stageData)
    elseif stageNumber == 8 then
        ObbyStages.createSpeedBoostStage(self, stageData)
    elseif stageNumber == 9 then
        ObbyStages.createAntiGravityStage(self, stageData)
    elseif stageNumber == 10 then
        ObbyStages.createBossStage(self, stageData)
    end
    
    -- Create checkpoint at end of stage
    self:createCheckpoint(stageData, Vector3.new(0, baseY + 5, stageNumber * CONFIG.STAGE_LENGTH - 10))
    
    return stageData
end

function ObbyManager:createStagePlatform(stageData)
    local platform = Instance.new("Part")
    platform.Name = "StagePlatform"
    platform.Size = Vector3.new(50, 2, CONFIG.STAGE_LENGTH)
    platform.Position = stageData.basePosition + Vector3.new(0, 0, CONFIG.STAGE_LENGTH/2)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.Parent = stageData.folder
    
    -- Add glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 2
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Range = 20
    pointLight.Parent = platform
end

function ObbyManager:createJumpingStage(stageData)
    -- Simple jumping platforms
    for i = 1, 8 do
        local platform = Instance.new("Part")
        platform.Name = "JumpPlatform" .. i
        platform.Size = Vector3.new(8, 1, 8)
        platform.Position = stageData.basePosition + Vector3.new(
            math.random(-20, 20),
            math.random(5, 15),
            i * 10
        )
        platform.Material = Enum.Material.Plastic
        platform.BrickColor = BrickColor.new("Bright green")
        platform.Anchored = true
        platform.Parent = stageData.folder
    end
end

function ObbyManager:createMovingPlatformStage(stageData)
    for i = 1, 4 do
        local platform = Instance.new("Part")
        platform.Name = "MovingPlatform" .. i
        platform.Size = Vector3.new(10, 1, 10)
        platform.Position = stageData.basePosition + Vector3.new(-15, 10, i * 20)
        platform.Material = Enum.Material.ForceField
        platform.BrickColor = BrickColor.new("Bright yellow")
        platform.Anchored = true
        platform.Parent = stageData.folder
        
        -- Add to moving parts
        table.insert(self.movingParts, {
            part = platform,
            type = "horizontal",
            range = 30,
            speed = 2,
            startPos = platform.Position
        })
    end
end

function ObbyManager:createSpinningHammerStage(stageData)
    for i = 1, 3 do
        -- Create hammer base
        local base = Instance.new("Part")
        base.Name = "HammerBase" .. i
        base.Size = Vector3.new(2, 8, 2)
        base.Position = stageData.basePosition + Vector3.new(0, 8, i * 25)
        base.Material = Enum.Material.Metal
        base.BrickColor = BrickColor.new("Really black")
        base.Anchored = true
        base.Parent = stageData.folder
        
        -- Create hammer head
        local hammer = Instance.new("Part")
        hammer.Name = "Hammer" .. i
        hammer.Size = Vector3.new(15, 3, 3)
        hammer.Position = base.Position + Vector3.new(0, 0, 0)
        hammer.Material = Enum.Material.Metal
        hammer.BrickColor = BrickColor.new("Really red")
        hammer.Anchored = true
        hammer.Parent = stageData.folder
        
        -- Create weld to base
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = base
        weld.Part1 = hammer
        weld.Parent = base
        
        -- Add to moving parts
        table.insert(self.movingParts, {
            part = hammer,
            base = base,
            type = "spinning",
            speed = 3
        })
        
        -- Add damage script
        hammer.Touched:Connect(function(hit)
            self:handleHammerHit(hit, hammer)
        end)
    end
end

function ObbyManager:createDisappearingBlockStage(stageData)
    for i = 1, 12 do
        local block = Instance.new("Part")
        block.Name = "DisappearingBlock" .. i
        block.Size = Vector3.new(6, 1, 6)
        block.Position = stageData.basePosition + Vector3.new(
            (i % 3 - 1) * 8,
            5,
            math.floor(i/3) * 8 + 10
        )
        block.Material = Enum.Material.Glass
        block.BrickColor = BrickColor.new("Institutional white")
        block.Anchored = true
        block.Parent = stageData.folder
        
        -- Add disappearing behavior
        block.Touched:Connect(function(hit)
            self:handleDisappearingBlock(hit, block)
        end)
    end
end

function ObbyManager:createCheckpoint(stageData, position)
    local checkpoint = Instance.new("Part")
    checkpoint.Name = "Checkpoint" .. stageData.number
    checkpoint.Size = Vector3.new(10, 15, 2)
    checkpoint.Position = position
    checkpoint.Material = Enum.Material.ForceField
    checkpoint.BrickColor = BrickColor.new("Bright green")
    checkpoint.Anchored = true
    checkpoint.Parent = stageData.folder
    
    -- Add spinning effect
    table.insert(self.movingParts, {
        part = checkpoint,
        type = "checkpoint_spin",
        speed = 1
    })
    
    -- Add checkpoint logic
    checkpoint.Touched:Connect(function(hit)
        self:handleCheckpoint(hit, stageData.number, position)
    end)
    
    table.insert(stageData.checkpoints, checkpoint)
end

function ObbyManager:setupPlayerConnections()
    Players.PlayerRemoving:Connect(function(player)
        playerData[player] = nil
    end)
end

function ObbyManager:startAnimations()
    RunService.Heartbeat:Connect(function()
        self:updateMovingParts()
    end)
end

function ObbyManager:updateMovingParts()
    local time = tick()
    
    for _, movingPart in ipairs(self.movingParts) do
        if movingPart.type == "horizontal" then
            local offset = math.sin(time * movingPart.speed) * movingPart.range/2
            movingPart.part.Position = movingPart.startPos + Vector3.new(offset, 0, 0)
            
        elseif movingPart.type == "spinning" then
            local rotation = time * movingPart.speed * 57.3 -- Convert to degrees
            movingPart.part.CFrame = CFrame.new(movingPart.base.Position) * CFrame.Angles(0, math.rad(rotation), 0)
            
        elseif movingPart.type == "checkpoint_spin" then
            local rotation = time * movingPart.speed * 57.3
            movingPart.part.CFrame = CFrame.new(movingPart.part.Position) * CFrame.Angles(0, math.rad(rotation), 0)
        end
    end
end

function ObbyManager:handleCheckpoint(hit, stageNumber, position)
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if not player or not player.Character or not player.Character:FindFirstChild("Humanoid") then
        return
    end
    
    local data = playerData[player]
    if not data then return end
    
    -- Only advance if this is the next stage
    if stageNumber == data.currentStage + 1 or stageNumber == 1 then
        data.currentStage = stageNumber
        data.lastCheckpoint = position
        data.points = data.points + ObbyConfig.getReward("CHECKPOINT_POINTS")
        
        -- Update leaderboard
        if player.leaderstats then
            player.leaderstats.Stage.Value = stageNumber
            player.leaderstats.Points.Value = data.points
        end
        
        -- Visual feedback
        self:createCheckpointEffect(position)
        
        -- Check if completed obby
        if stageNumber >= CONFIG.TOTAL_STAGES then
            self:handleObbyCompletion(player)
        end
        
        print(string.format("🎯 %s reached stage %d!", player.Name, stageNumber))
    end
end

function ObbyManager:handleObbyCompletion(player)
    local data = playerData[player]
    if not data then return end
    
    data.completions = data.completions + 1
    data.points = data.points + ObbyConfig.getReward("COMPLETION_POINTS")
    
    if player.leaderstats then
        player.leaderstats.Completions.Value = data.completions
        player.leaderstats.Points.Value = data.points
    end
    
    -- Celebration effect
    self:createCompletionEffect(player)
    
    -- Reset to beginning for another run
    wait(3)
    self:teleportToStage(player, 1)
    data.currentStage = 1
    
    print(string.format("🎉 %s completed the obby! (Completion #%d)", player.Name, data.completions))
end

function ObbyManager:teleportToStage(player, stageNumber)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local data = playerData[player]
    if data then
        local position = data.lastCheckpoint or CONFIG.SPAWN_POSITION
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
    end
end

function ObbyManager:createCheckpointEffect(position)
    -- Particle effect for checkpoint
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(1, 1, 1)
    effect.Position = position
    effect.Material = Enum.Material.Neon
    effect.BrickColor = BrickColor.new("Bright green")
    effect.Anchored = true
    effect.CanCollide = false
    effect.Parent = workspace
    
    -- Animate effect
    local tween = TweenService:Create(effect, 
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(20, 20, 20), Transparency = 1}
    )
    tween:Play()
    
    Debris:AddItem(effect, 1)
end

function ObbyManager:handleHammerHit(hit, hammer)
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        -- Knockback effect
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = (humanoidRootPart.Position - hammer.Position).Unit * 50
            bodyVelocity.Parent = humanoidRootPart
            
            Debris:AddItem(bodyVelocity, 0.5)
        end
        
        -- Respawn at last checkpoint
        wait(1)
        self:teleportToStage(player, playerData[player].currentStage)
    end
end

function ObbyManager:handleDisappearingBlock(hit, block)
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if player then
        -- Make block disappear
        local tween = TweenService:Create(block,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad),
            {Transparency = 1, CanCollide = false}
        )
        tween:Play()
        
        -- Bring it back after 3 seconds
        wait(3)
        block.Transparency = 0.2
        block.CanCollide = true
    end
end

-- Initialize the obby manager
local obbyManager = ObbyManager.new()

return ObbyManager
