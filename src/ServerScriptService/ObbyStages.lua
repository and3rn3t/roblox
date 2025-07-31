--[[
    Advanced Obby Stages
    Additional complex stage implementations
]]--

local ObbyStages = {}
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Conveyor Belt Stage
function ObbyStages.createConveyorBeltStage(obbyManager, stageData)
    for i = 1, 8 do
        local belt = Instance.new("Part")
        belt.Name = "ConveyorBelt" .. i
        belt.Size = Vector3.new(12, 1, 8)
        belt.Position = stageData.basePosition + Vector3.new(0, 5, i * 10)
        belt.Material = Enum.Material.Metal
        belt.BrickColor = BrickColor.new("Dark stone grey")
        belt.Anchored = true
        belt.Parent = stageData.folder
        
        -- Add conveyor effect texture
        local surface = Instance.new("SurfaceGui")
        surface.Face = Enum.NormalId.Top
        surface.Parent = belt
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        frame.Parent = surface
        
        -- Add movement pattern
        for j = 1, 4 do
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0.2, 0, 0.8, 0)
            arrow.Position = UDim2.new(j * 0.2 - 0.1, 0, 0.1, 0)
            arrow.Text = "→"
            arrow.TextColor3 = Color3.fromRGB(255, 255, 0)
            arrow.TextScaled = true
            arrow.BackgroundTransparency = 1
            arrow.Parent = frame
        end
        
        -- Conveyor movement logic
        belt.Touched:Connect(function(hit)
            local humanoidRootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local bodyVelocity = humanoidRootPart:FindFirstChild("ConveyorVelocity")
                if not bodyVelocity then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Name = "ConveyorVelocity"
                    bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
                    bodyVelocity.Velocity = Vector3.new(0, 0, 20) -- Forward movement
                    bodyVelocity.Parent = humanoidRootPart
                    
                    -- Remove when not touching
                    spawn(function()
                        while bodyVelocity.Parent do
                            wait(0.1)
                            local touching = false
                            for _, part in pairs(humanoidRootPart:GetTouchingParts()) do
                                if part.Name:find("ConveyorBelt") then
                                    touching = true
                                    break
                                end
                            end
                            if not touching then
                                bodyVelocity:Destroy()
                                break
                            end
                        end
                    end)
                end
            end
        end)
    end
end

-- Bounce Pad Stage
function ObbyStages.createBouncePadStage(obbyManager, stageData)
    for i = 1, 6 do
        local pad = Instance.new("Part")
        pad.Name = "BouncePad" .. i
        pad.Size = Vector3.new(8, 2, 8)
        pad.Position = stageData.basePosition + Vector3.new(
            math.random(-15, 15),
            3,
            i * 15
        )
        pad.Material = Enum.Material.Neon
        pad.BrickColor = BrickColor.new("Hot pink")
        pad.Anchored = true
        pad.Parent = stageData.folder
        
        -- Add bounce effect
        pad.Touched:Connect(function(hit)
            local humanoidRootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Velocity = Vector3.new(0, 100, 0) -- Upward bounce
                bodyVelocity.Parent = humanoidRootPart
                
                -- Bounce effect animation
                local tween = TweenService:Create(pad,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = Vector3.new(10, 1, 10)}
                )
                tween:Play()
                
                wait(0.2)
                local tween2 = TweenService:Create(pad,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = Vector3.new(8, 2, 8)}
                )
                tween2:Play()
                
                Debris:AddItem(bodyVelocity, 0.5)
            end
        end)
    end
end

-- Maze Stage
function ObbyStages.createMazeStage(obbyManager, stageData)
    local mazeSize = 30
    local wallHeight = 10
    
    -- Create maze walls
    local maze = {
        "111111111111111111111111111111",
        "100000000000000000000000000001",
        "101110111011101110111011101101",
        "100010001000100010001000100001",
        "111010101110101110101110101111",
        "100010100000100000100000101001",
        "101110111111101111101111101101",
        "100000100000000000100000000001",
        "111111101111111110101111111111",
        "100000001000000010100000000001",
        "101111101011111010101111101101",
        "100000100010001010100010001001",
        "111110111110101010111110111011",
        "100010000000101010000000100001",
        "101011111110101011111110101101",
        "100010000010101010000010100001",
        "111110111010101010111010111111",
        "100000101010101010101010000001",
        "101111101010101010101011111101",
        "100000000010000010000000000001",
        "111111111111111111111111111111"
    }
    
    for row = 1, #maze do
        for col = 1, #maze[row] do
            if maze[row]:sub(col, col) == "1" then
                local wall = Instance.new("Part")
                wall.Name = "MazeWall"
                wall.Size = Vector3.new(2, wallHeight, 2)
                wall.Position = stageData.basePosition + Vector3.new(
                    (col - #maze[row]/2) * 2,
                    wallHeight/2,
                    (row - #maze/2) * 2 + 50
                )
                wall.Material = Enum.Material.Cobblestone
                wall.BrickColor = BrickColor.new("Brown")
                wall.Anchored = true
                wall.Parent = stageData.folder
            end
        end
    end
    
    -- Add maze entrance and exit
    local entrance = Instance.new("Part")
    entrance.Name = "MazeEntrance"
    entrance.Size = Vector3.new(4, 1, 4)
    entrance.Position = stageData.basePosition + Vector3.new(-25, 3, 30)
    entrance.Material = Enum.Material.Grass
    entrance.BrickColor = BrickColor.new("Bright green")
    entrance.Anchored = true
    entrance.Parent = stageData.folder
    
    local exit = Instance.new("Part")
    exit.Name = "MazeExit"
    exit.Size = Vector3.new(4, 1, 4)
    exit.Position = stageData.basePosition + Vector3.new(25, 3, 70)
    exit.Material = Enum.Material.Grass
    exit.BrickColor = BrickColor.new("Bright red")
    exit.Anchored = true
    exit.Parent = stageData.folder
end

-- Speed Boost Stage
function ObbyStages.createSpeedBoostStage(obbyManager, stageData)
    -- Create speed boost rings
    for i = 1, 8 do
        local ring = Instance.new("Part")
        ring.Name = "SpeedRing" .. i
        ring.Size = Vector3.new(12, 12, 2)
        ring.Position = stageData.basePosition + Vector3.new(0, 10, i * 12)
        ring.Material = Enum.Material.ForceField
        ring.BrickColor = BrickColor.new("Cyan")
        ring.Anchored = true
        ring.CanCollide = false
        ring.Parent = stageData.folder
        
        -- Make it a ring shape
        ring.Shape = Enum.PartType.Cylinder
        
        -- Add rotation
        table.insert(obbyManager.movingParts, {
            part = ring,
            type = "ring_spin",
            speed = 2
        })
        
        -- Speed boost effect
        ring.Touched:Connect(function(hit)
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 50 -- Boost speed
                humanoid.JumpPower = 100 -- Boost jump
                
                -- Create speed effect
                local effect = Instance.new("Part")
                effect.Size = Vector3.new(1, 1, 1)
                effect.Position = ring.Position
                effect.Material = Enum.Material.Neon
                effect.BrickColor = BrickColor.new("Cyan")
                effect.Anchored = true
                effect.CanCollide = false
                effect.Parent = workspace
                
                local tween = TweenService:Create(effect,
                    TweenInfo.new(1, Enum.EasingStyle.Quad),
                    {Size = Vector3.new(25, 25, 25), Transparency = 1}
                )
                tween:Play()
                Debris:AddItem(effect, 1)
                
                -- Reset speed after 5 seconds
                wait(5)
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end)
    end
end

-- Anti-Gravity Stage
function ObbyStages.createAntiGravityStage(obbyManager, stageData)
    -- Create anti-gravity zone
    local gravityZone = Instance.new("Part")
    gravityZone.Name = "AntiGravityZone"
    gravityZone.Size = Vector3.new(50, 30, 80)
    gravityZone.Position = stageData.basePosition + Vector3.new(0, 15, 40)
    gravityZone.Material = Enum.Material.ForceField
    gravityZone.BrickColor = BrickColor.new("Light blue")
    gravityZone.Anchored = true
    gravityZone.CanCollide = false
    gravityZone.Transparency = 0.7
    gravityZone.Parent = stageData.folder
    
    -- Create floating platforms
    for i = 1, 12 do
        local platform = Instance.new("Part")
        platform.Name = "FloatingPlatform" .. i
        platform.Size = Vector3.new(6, 1, 6)
        platform.Position = stageData.basePosition + Vector3.new(
            math.random(-20, 20),
            math.random(5, 25),
            math.random(10, 70)
        )
        platform.Material = Enum.Material.Neon
        platform.BrickColor = BrickColor.new("White")
        platform.Anchored = true
        platform.Parent = stageData.folder
        
        -- Add floating animation
        table.insert(obbyManager.movingParts, {
            part = platform,
            type = "float",
            range = 5,
            speed = 1,
            startPos = platform.Position
        })
    end
    
    -- Anti-gravity effect
    gravityZone.Touched:Connect(function(hit)
        local humanoidRootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local bodyPosition = humanoidRootPart:FindFirstChild("AntiGravity")
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.Name = "AntiGravity"
                bodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
                bodyPosition.P = 3000
                bodyPosition.D = 500
                bodyPosition.Parent = humanoidRootPart
                
                -- Maintain current Y position
                spawn(function()
                    while bodyPosition.Parent do
                        bodyPosition.Position = Vector3.new(
                            humanoidRootPart.Position.X,
                            humanoidRootPart.Position.Y,
                            humanoidRootPart.Position.Z
                        )
                        wait(0.1)
                        
                        -- Check if still in zone
                        local inZone = false
                        for _, part in pairs(humanoidRootPart:GetTouchingParts()) do
                            if part.Name == "AntiGravityZone" then
                                inZone = true
                                break
                            end
                        end
                        if not inZone then
                            bodyPosition:Destroy()
                            break
                        end
                    end
                end)
            end
        end
    end)
end

-- Boss Stage (Final Challenge)
function ObbyStages.createBossStage(obbyManager, stageData)
    -- Create boss arena
    local arena = Instance.new("Part")
    arena.Name = "BossArena"
    arena.Size = Vector3.new(80, 2, 80)
    arena.Position = stageData.basePosition + Vector3.new(0, 0, 40)
    arena.Material = Enum.Material.Cobblestone
    arena.BrickColor = BrickColor.new("Really black")
    arena.Anchored = true
    arena.Parent = stageData.folder
    
    -- Create boss (giant spinning obstacle)
    local boss = Instance.new("Part")
    boss.Name = "Boss"
    boss.Size = Vector3.new(30, 5, 30)
    boss.Position = stageData.basePosition + Vector3.new(0, 10, 40)
    boss.Material = Enum.Material.Neon
    boss.BrickColor = BrickColor.new("Really red")
    boss.Anchored = true
    boss.Parent = stageData.folder
    boss.Shape = Enum.PartType.Cylinder
    
    -- Add boss arms
    for i = 1, 4 do
        local arm = Instance.new("Part")
        arm.Name = "BossArm" .. i
        arm.Size = Vector3.new(25, 3, 3)
        arm.Position = boss.Position
        arm.Material = Enum.Material.Metal
        arm.BrickColor = BrickColor.new("Dark red")
        arm.Anchored = true
        arm.Parent = stageData.folder
        
        -- Weld to boss
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = boss
        weld.Part1 = arm
        weld.Parent = boss
        
        -- Position arms at 90-degree intervals
        arm.CFrame = boss.CFrame * CFrame.Angles(0, 0, math.rad(i * 90))
        
        -- Damage on touch
        arm.Touched:Connect(function(hit)
            obbyManager:handleHammerHit(hit, arm)
        end)
    end
    
    -- Add boss spinning
    table.insert(obbyManager.movingParts, {
        part = boss,
        type = "boss_spin",
        speed = 1.5
    })
    
    -- Create safe spots
    for i = 1, 4 do
        local safeSpot = Instance.new("Part")
        safeSpot.Name = "SafeSpot" .. i
        safeSpot.Size = Vector3.new(8, 3, 8)
        safeSpot.Position = stageData.basePosition + Vector3.new(
            math.cos(math.rad(i * 90)) * 35,
            3,
            math.sin(math.rad(i * 90)) * 35 + 40
        )
        safeSpot.Material = Enum.Material.Grass
        safeSpot.BrickColor = BrickColor.new("Bright green")
        safeSpot.Anchored = true
        safeSpot.Parent = stageData.folder
    end
end

return ObbyStages
