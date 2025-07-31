--[[
    Obby Client Manager
    Handles client-side UI, effects, and player experience
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ObbyClient = {}
ObbyClient.__index = ObbyClient

function ObbyClient.new()
    local self = setmetatable({}, ObbyClient)
    
    self.gui = nil
    self.currentStage = 1
    self.sounds = {}
    
    self:initialize()
    return self
end

function ObbyClient:initialize()
    print("🎮 Initializing client-side obby experience...")
    
    -- Create UI
    self:createUI()
    
    -- Setup sounds
    self:setupSounds()
    
    -- Setup effects
    self:setupEffects()
    
    -- Monitor player stats
    self:monitorStats()
    
    print("✅ Client initialization complete!")
end

function ObbyClient:createUI()
    -- Main UI container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ObbyUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    self.gui = screenGui
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.Parent = screenGui
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Stage display
    local stageLabel = Instance.new("TextLabel")
    stageLabel.Name = "StageLabel"
    stageLabel.Size = UDim2.new(1, 0, 0.3, 0)
    stageLabel.Position = UDim2.new(0, 0, 0, 0)
    stageLabel.BackgroundTransparency = 1
    stageLabel.Text = "Stage: 1/10"
    stageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    stageLabel.TextScaled = true
    stageLabel.Font = Enum.Font.GothamBold
    stageLabel.Parent = mainFrame
    
    -- Points display
    local pointsLabel = Instance.new("TextLabel")
    pointsLabel.Name = "PointsLabel"
    pointsLabel.Size = UDim2.new(1, 0, 0.25, 0)
    pointsLabel.Position = UDim2.new(0, 0, 0.3, 0)
    pointsLabel.BackgroundTransparency = 1
    pointsLabel.Text = "Points: 0"
    pointsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    pointsLabel.TextScaled = true
    pointsLabel.Font = Enum.Font.Gotham
    pointsLabel.Parent = mainFrame
    
    -- Completions display
    local completionsLabel = Instance.new("TextLabel")
    completionsLabel.Name = "CompletionsLabel"
    completionsLabel.Size = UDim2.new(1, 0, 0.25, 0)
    completionsLabel.Position = UDim2.new(0, 0, 0.55, 0)
    completionsLabel.BackgroundTransparency = 1
    completionsLabel.Text = "Completions: 0"
    completionsLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    completionsLabel.TextScaled = true
    completionsLabel.Font = Enum.Font.Gotham
    completionsLabel.Parent = mainFrame
    
    -- Reset button
    local resetButton = Instance.new("TextButton")
    resetButton.Name = "ResetButton"
    resetButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    resetButton.Position = UDim2.new(0.1, 0, 0.8, 0)
    resetButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    resetButton.Text = "Reset to Start"
    resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetButton.TextScaled = true
    resetButton.Font = Enum.Font.GothamBold
    resetButton.Parent = mainFrame
    
    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 6)
    resetCorner.Parent = resetButton
    
    -- Reset button functionality
    resetButton.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        end
    end)
    
    -- Instructions panel
    local instructionsFrame = Instance.new("Frame")
    instructionsFrame.Name = "InstructionsFrame"
    instructionsFrame.Size = UDim2.new(0, 250, 0, 150)
    instructionsFrame.Position = UDim2.new(1, -270, 0, 20)
    instructionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    instructionsFrame.BorderSizePixel = 0
    instructionsFrame.BackgroundTransparency = 0.3
    instructionsFrame.Parent = screenGui
    
    local instructionsCorner = Instance.new("UICorner")
    instructionsCorner.CornerRadius = UDim.new(0, 12)
    instructionsCorner.Parent = instructionsFrame
    
    local instructionsTitle = Instance.new("TextLabel")
    instructionsTitle.Name = "Title"
    instructionsTitle.Size = UDim2.new(1, 0, 0.25, 0)
    instructionsTitle.Position = UDim2.new(0, 0, 0, 0)
    instructionsTitle.BackgroundTransparency = 1
    instructionsTitle.Text = "🎯 Obby Controls"
    instructionsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    instructionsTitle.TextScaled = true
    instructionsTitle.Font = Enum.Font.GothamBold
    instructionsTitle.Parent = instructionsFrame
    
    local instructions = Instance.new("TextLabel")
    instructions.Name = "Instructions"
    instructions.Size = UDim2.new(1, -20, 0.75, 0)
    instructions.Position = UDim2.new(0, 10, 0.25, 0)
    instructions.BackgroundTransparency = 1
    instructions.Text = [[WASD - Move
Space - Jump
Shift - Run
R - Reset to checkpoint

🎪 Features:
• Moving platforms
• Spinning hammers  
• Disappearing blocks
• Speed boost rings
• Anti-gravity zones]]
    instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
    instructions.TextSize = 12
    instructions.Font = Enum.Font.Gotham
    instructions.TextXAlignment = Enum.TextXAlignment.Left
    instructions.TextYAlignment = Enum.TextYAlignment.Top
    instructions.Parent = instructionsFrame
    
    -- Minimap
    self:createMinimap()
end

function ObbyClient:createMinimap()
    local minimapFrame = Instance.new("Frame")
    minimapFrame.Name = "Minimap"
    minimapFrame.Size = UDim2.new(0, 200, 0, 150)
    minimapFrame.Position = UDim2.new(1, -220, 1, -170)
    minimapFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minimapFrame.BorderSizePixel = 0
    minimapFrame.BackgroundTransparency = 0.2
    minimapFrame.Parent = self.gui
    
    local minimapCorner = Instance.new("UICorner")
    minimapCorner.CornerRadius = UDim.new(0, 8)
    minimapCorner.Parent = minimapFrame
    
    local minimapTitle = Instance.new("TextLabel")
    minimapTitle.Name = "Title"
    minimapTitle.Size = UDim2.new(1, 0, 0.2, 0)
    minimapTitle.Position = UDim2.new(0, 0, 0, 0)
    minimapTitle.BackgroundTransparency = 1
    minimapTitle.Text = "📍 Progress Map"
    minimapTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimapTitle.TextScaled = true
    minimapTitle.Font = Enum.Font.GothamBold
    minimapTitle.Parent = minimapFrame
    
    -- Create stage indicators
    for i = 1, 10 do
        local stageIndicator = Instance.new("Frame")
        stageIndicator.Name = "Stage" .. i
        stageIndicator.Size = UDim2.new(0, 15, 0, 15)
        stageIndicator.Position = UDim2.new(0, 10 + (i-1) * 18, 0, 30)
        stageIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        stageIndicator.BorderSizePixel = 0
        stageIndicator.Parent = minimapFrame
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = stageIndicator
        
        local stageNum = Instance.new("TextLabel")
        stageNum.Size = UDim2.new(1, 0, 1, 0)
        stageNum.BackgroundTransparency = 1
        stageNum.Text = tostring(i)
        stageNum.TextColor3 = Color3.fromRGB(255, 255, 255)
        stageNum.TextScaled = true
        stageNum.Font = Enum.Font.GothamBold
        stageNum.Parent = stageIndicator
    end
end

function ObbyClient:setupSounds()
    -- Create sound effects
    self.sounds.checkpoint = Instance.new("Sound")
    self.sounds.checkpoint.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    self.sounds.checkpoint.Volume = 0.5
    self.sounds.checkpoint.Parent = workspace
    
    self.sounds.completion = Instance.new("Sound")
    self.sounds.completion.SoundId = "rbxasset://sounds/victory.wav"
    self.sounds.completion.Volume = 0.7
    self.sounds.completion.Parent = workspace
    
    self.sounds.reset = Instance.new("Sound")
    self.sounds.reset.SoundId = "rbxasset://sounds/button-09.wav"
    self.sounds.reset.Volume = 0.3
    self.sounds.reset.Parent = workspace
    
    self.sounds.speedBoost = Instance.new("Sound")
    self.sounds.speedBoost.SoundId = "rbxasset://sounds/impact_water.mp3"
    self.sounds.speedBoost.Volume = 0.4
    self.sounds.speedBoost.Parent = workspace
end

function ObbyClient:setupEffects()
    -- Particle system for player trail
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        self:createPlayerTrail(player.Character.HumanoidRootPart)
    end
    
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        self:createPlayerTrail(character.HumanoidRootPart)
    end)
end

function ObbyClient:createPlayerTrail(humanoidRootPart)
    local attachment = Instance.new("Attachment")
    attachment.Name = "TrailAttachment"
    attachment.Parent = humanoidRootPart
    
    local trail = Instance.new("Trail")
    trail.Name = "PlayerTrail"
    trail.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 162, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    trail.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    }
    trail.Lifetime = 1
    trail.MinLength = 0
    trail.FaceCamera = true
    trail.Attachment0 = attachment
    trail.Attachment1 = attachment
    trail.Parent = humanoidRootPart
end

function ObbyClient:monitorStats()
    -- Monitor leaderstats changes
    if player:FindFirstChild("leaderstats") then
        self:updateStatsDisplay()
        
        player.leaderstats.Stage.Changed:Connect(function()
            self:updateStatsDisplay()
            self:onStageChange()
        end)
        
        player.leaderstats.Points.Changed:Connect(function()
            self:updateStatsDisplay()
        end)
        
        player.leaderstats.Completions.Changed:Connect(function()
            self:updateStatsDisplay()
            self:onCompletion()
        end)
    else
        player.ChildAdded:Connect(function(child)
            if child.Name == "leaderstats" then
                wait(0.1)
                self:updateStatsDisplay()
                
                child.Stage.Changed:Connect(function()
                    self:updateStatsDisplay()
                    self:onStageChange()
                end)
                
                child.Points.Changed:Connect(function()
                    self:updateStatsDisplay()
                end)
                
                child.Completions.Changed:Connect(function()
                    self:updateStatsDisplay()
                    self:onCompletion()
                end)
            end
        end)
    end
end

function ObbyClient:updateStatsDisplay()
    if not player:FindFirstChild("leaderstats") then return end
    
    local stage = player.leaderstats.Stage.Value
    local points = player.leaderstats.Points.Value
    local completions = player.leaderstats.Completions.Value
    
    -- Update UI
    local mainFrame = self.gui:FindFirstChild("MainFrame")
    if mainFrame then
        mainFrame.StageLabel.Text = string.format("Stage: %d/10", stage)
        mainFrame.PointsLabel.Text = string.format("Points: %d", points)
        mainFrame.CompletionsLabel.Text = string.format("Completions: %d", completions)
    end
    
    -- Update minimap
    self:updateMinimap(stage)
end

function ObbyClient:updateMinimap(currentStage)
    local minimap = self.gui:FindFirstChild("Minimap")
    if not minimap then return end
    
    for i = 1, 10 do
        local indicator = minimap:FindFirstChild("Stage" .. i)
        if indicator then
            if i < currentStage then
                -- Completed stages
                indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
            elseif i == currentStage then
                -- Current stage
                indicator.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                
                -- Pulse animation
                local tween = TweenService:Create(indicator,
                    TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {Size = UDim2.new(0, 18, 0, 18)}
                )
                tween:Play()
            else
                -- Future stages
                indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end
        end
    end
end

function ObbyClient:onStageChange()
    -- Play checkpoint sound
    if self.sounds.checkpoint then
        self.sounds.checkpoint:Play()
    end
    
    -- Create celebration effect
    self:createCelebrationEffect()
    
    -- Show stage notification
    self:showStageNotification()
end

function ObbyClient:onCompletion()
    -- Play completion sound
    if self.sounds.completion then
        self.sounds.completion:Play()
    end
    
    -- Show completion celebration
    self:showCompletionCelebration()
end

function ObbyClient:createCelebrationEffect()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = player.Character.HumanoidRootPart
    
    -- Create fireworks effect
    for i = 1, 5 do
        spawn(function()
            wait(i * 0.1)
            
            local firework = Instance.new("Part")
            firework.Size = Vector3.new(1, 1, 1)
            firework.Position = rootPart.Position + Vector3.new(
                math.random(-10, 10),
                math.random(5, 15),
                math.random(-10, 10)
            )
            firework.Material = Enum.Material.Neon
            firework.BrickColor = BrickColor.new("Bright yellow")
            firework.Anchored = true
            firework.CanCollide = false
            firework.Parent = workspace
            
            local tween = TweenService:Create(firework,
                TweenInfo.new(1, Enum.EasingStyle.Quad),
                {Size = Vector3.new(15, 15, 15), Transparency = 1}
            )
            tween:Play()
            
            game:GetService("Debris"):AddItem(firework, 1)
        end)
    end
end

function ObbyClient:showStageNotification()
    local notification = Instance.new("Frame")
    notification.Name = "StageNotification"
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(0.5, -150, 0, -100)
    notification.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    notification.BorderSizePixel = 0
    notification.Parent = self.gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "🎯 Checkpoint Reached!"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = notification
    
    -- Animate in
    local tweenIn = TweenService:Create(notification,
        TweenInfo.new(0.5, Enum.EasingStyle.Back),
        {Position = UDim2.new(0.5, -150, 0, 50)}
    )
    tweenIn:Play()
    
    -- Animate out
    wait(2)
    local tweenOut = TweenService:Create(notification,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {Position = UDim2.new(0.5, -150, 0, -100), Transparency = 1}
    )
    tweenOut:Play()
    
    tweenOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

function ObbyClient:showCompletionCelebration()
    -- Full screen celebration
    local celebration = Instance.new("Frame")
    celebration.Name = "CompletionCelebration"
    celebration.Size = UDim2.new(1, 0, 1, 0)
    celebration.Position = UDim2.new(0, 0, 0, 0)
    celebration.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    celebration.BackgroundTransparency = 0.8
    celebration.Parent = self.gui
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.8, 0, 0.3, 0)
    text.Position = UDim2.new(0.1, 0, 0.35, 0)
    text.BackgroundTransparency = 1
    text.Text = "🎉 OBBY COMPLETED! 🎉"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.Parent = celebration
    
    -- Animate celebration
    local tween = TweenService:Create(text,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {TextSize = text.TextSize * 1.2}
    )
    tween:Play()
    
    -- Remove after 3 seconds
    game:GetService("Debris"):AddItem(celebration, 3)
end

-- Initialize the client manager
local obbyClient = ObbyClient.new()

return ObbyClient
