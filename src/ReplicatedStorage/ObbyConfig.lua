--[[
    Obby Configuration Module
    Centralized settings for the obby game
]]--

local ObbyConfig = {}

-- Game Settings
ObbyConfig.GAME = {
    TOTAL_STAGES = 10,
    SPAWN_POSITION = Vector3.new(0, 10, 0),
    STAGE_HEIGHT = 50,
    STAGE_LENGTH = 100,
    MAX_PLAYERS = 50,
}

-- Rewards
ObbyConfig.REWARDS = {
    CHECKPOINT_POINTS = 10,
    COMPLETION_POINTS = 500,
    FIRST_COMPLETION_BONUS = 1000,
    DAILY_COMPLETION_BONUS = 100,
}

-- Stage Configurations
ObbyConfig.STAGES = {
    [1] = {
        name = "Jumping Basics",
        difficulty = "Easy",
        description = "Learn the fundamentals of jumping!",
        platforms = 8,
        special_features = {"Basic jumping platforms"}
    },
    [2] = {
        name = "Moving Platforms",
        difficulty = "Easy",
        description = "Time your jumps with moving platforms!",
        platforms = 4,
        special_features = {"Horizontally moving platforms"}
    },
    [3] = {
        name = "Spinning Hammers",
        difficulty = "Medium",
        description = "Avoid the deadly spinning hammers!",
        hammers = 3,
        special_features = {"Spinning obstacles", "Knockback damage"}
    },
    [4] = {
        name = "Disappearing Blocks",
        difficulty = "Medium",
        description = "Quick! The blocks won't last forever!",
        blocks = 12,
        special_features = {"Temporary platforms", "Time pressure"}
    },
    [5] = {
        name = "Conveyor Chaos",
        difficulty = "Medium",
        description = "Navigate the conveyor belt maze!",
        belts = 8,
        special_features = {"Conveyor belt movement", "Direction control"}
    },
    [6] = {
        name = "Bounce Paradise",
        difficulty = "Medium",
        description = "Use bounce pads to reach new heights!",
        bounce_pads = 6,
        special_features = {"High jumps", "Momentum control"}
    },
    [7] = {
        name = "Lost in the Maze",
        difficulty = "Hard",
        description = "Find your way through the labyrinth!",
        maze_size = "30x21",
        special_features = {"Complex pathfinding", "Multiple routes"}
    },
    [8] = {
        name = "Speed Demon",
        difficulty = "Hard",
        description = "Race through the speed rings!",
        speed_rings = 8,
        special_features = {"Speed boost", "Enhanced jumping", "Time trial"}
    },
    [9] = {
        name = "Zero Gravity",
        difficulty = "Very Hard",
        description = "Master movement in anti-gravity!",
        floating_platforms = 12,
        special_features = {"Anti-gravity zones", "3D movement", "Floating obstacles"}
    },
    [10] = {
        name = "Boss Battle",
        difficulty = "Extreme",
        description = "Face the ultimate challenge!",
        boss_arms = 4,
        safe_spots = 4,
        special_features = {"Giant spinning boss", "Safe zones", "Pattern recognition"}
    }
}

-- Visual Settings
ObbyConfig.VISUALS = {
    NEON_BRIGHTNESS = 2,
    LIGHT_RANGE = 20,
    PARTICLE_LIFETIME = 1,
    ANIMATION_SPEED = 1,
    
    COLORS = {
        CHECKPOINT = Color3.fromRGB(0, 255, 127),
        DANGER = Color3.fromRGB(255, 68, 68),
        BOOST = Color3.fromRGB(0, 162, 255),
        NEUTRAL = Color3.fromRGB(156, 163, 175),
        COMPLETE = Color3.fromRGB(255, 215, 0),
    }
}

-- Audio Settings
ObbyConfig.AUDIO = {
    MASTER_VOLUME = 0.5,
    SFX_VOLUME = 0.4,
    MUSIC_VOLUME = 0.3,
    
    SOUNDS = {
        CHECKPOINT = "rbxasset://sounds/electronicpingshort.wav",
        COMPLETION = "rbxasset://sounds/victory.wav",
        RESET = "rbxasset://sounds/button-09.wav",
        SPEED_BOOST = "rbxasset://sounds/impact_water.mp3",
        DAMAGE = "rbxasset://sounds/impact_generic.mp3",
        BOUNCE = "rbxasset://sounds/boing.mp3",
    }
}

-- Physics Settings
ObbyConfig.PHYSICS = {
    KNOCKBACK_FORCE = 50,
    BOUNCE_FORCE = 100,
    SPEED_BOOST_MULTIPLIER = 3.125, -- 50/16 (normal speed is 16)
    JUMP_BOOST_MULTIPLIER = 2, -- 100/50 (normal jump is 50)
    ANTI_GRAVITY_FORCE = 196.2, -- Counteracts workspace gravity
    
    MOVEMENT_SPEEDS = {
        NORMAL = 16,
        BOOSTED = 50,
        CONVEYOR = 20,
    },
    
    JUMP_POWERS = {
        NORMAL = 50,
        BOOSTED = 100,
        BOUNCE_PAD = 120,
    }
}

-- Timing Settings
ObbyConfig.TIMING = {
    DISAPPEARING_BLOCK_DELAY = 0.5, -- Seconds before block starts disappearing
    DISAPPEARING_BLOCK_FADE = 0.5,  -- Seconds to fade out
    DISAPPEARING_BLOCK_RESPAWN = 3,  -- Seconds before block reappears
    
    SPEED_BOOST_DURATION = 5,        -- Seconds speed boost lasts
    KNOCKBACK_DURATION = 0.5,        -- Seconds knockback force applies
    
    CHECKPOINT_EFFECT_DURATION = 1,  -- Seconds for checkpoint visual effect
    COMPLETION_CELEBRATION = 3,      -- Seconds for completion screen
    
    HAMMER_ROTATION_SPEED = 3,       -- Rotations per second
    PLATFORM_MOVE_SPEED = 2,         -- Movement speed multiplier
    BOSS_ROTATION_SPEED = 1.5,       -- Boss rotation speed
}

-- Developer Settings
ObbyConfig.DEBUG = {
    SHOW_STAGE_INFO = false,
    SHOW_PHYSICS_DEBUG = false,
    ENABLE_ADMIN_COMMANDS = false,
    LOG_PLAYER_PROGRESS = true,
    ENABLE_TELEPORT_COMMANDS = false,
}

-- Leaderboard Settings
ObbyConfig.LEADERBOARD = {
    TOP_PLAYERS_COUNT = 10,
    UPDATE_INTERVAL = 5, -- Seconds between leaderboard updates
    SHOW_GLOBAL_STATS = true,
    SHOW_SESSION_STATS = true,
}

-- Anti-Cheat Settings
ObbyConfig.ANTICHEAT = {
    MAX_SPEED_THRESHOLD = 100,       -- Maximum allowed player speed
    MAX_JUMP_HEIGHT = 200,           -- Maximum allowed jump height
    TELEPORT_DETECTION = true,       -- Detect suspicious teleportation
    STAGE_SKIP_PROTECTION = true,    -- Prevent skipping stages
    CHECKPOINT_VALIDATION = true,    -- Validate checkpoint touches
}

-- Export functions for easy access
function ObbyConfig.getStageConfig(stageNumber)
    return ObbyConfig.STAGES[stageNumber] or {}
end

function ObbyConfig.getReward(rewardType)
    return ObbyConfig.REWARDS[rewardType] or 0
end

function ObbyConfig.getColor(colorType)
    return ObbyConfig.VISUALS.COLORS[colorType] or Color3.fromRGB(255, 255, 255)
end

function ObbyConfig.getSound(soundType)
    return ObbyConfig.AUDIO.SOUNDS[soundType] or ""
end

function ObbyConfig.getPhysicsValue(valueType)
    return ObbyConfig.PHYSICS[valueType] or 0
end

function ObbyConfig.getTiming(timingType)
    return ObbyConfig.TIMING[timingType] or 1
end

return ObbyConfig
