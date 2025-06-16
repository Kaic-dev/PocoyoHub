-- Main Initialization Module
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Load local modules using HttpGet
local LeaderboardUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaic-dev/PocoyoHub/refs/heads/main/modules/ui/leaderboard"))()
local PlayerInfo = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaic-dev/PocoyoHub/refs/heads/main/modules/utils/player_info"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaic-dev/PocoyoHub/refs/heads/main/modules/services/esp"))()
local ServiceLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaic-dev/PocoyoHub/refs/heads/main/modules/services/service_loader"))()

-- Constants
local OBSERVE_SOUND_ID = "rbxassetid://138081500"
local MOD_SOUND_ID = "rbxassetid://9113085764"

-- Private variables
local observedPlayer = nil
local leaderboardGui, scrollingFrame = nil, nil
local playerLabels = {}

-- Private functions
local function createPlayerLabel(player)
    local label = Instance.new("TextLabel")
    label.Name = "PlayerLabel_" .. player.Name
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = scrollingFrame

    return label
end

local function updateLeaderboard()
    for player, label in pairs(playerLabels) do
        if not player or not player.Parent then
            label:Destroy()
            playerLabels[player] = nil
        else
            label.Text = PlayerInfo:getPlayerLabel(player, observedPlayer)
            LeaderboardUI:updatePlayerLabelAppearance(player, label, observedPlayer)
        end
    end
end

local function handlePlayerAdded(player)
    if player == Players.LocalPlayer then return end

    local label = createPlayerLabel(player)
    playerLabels[player] = label

    -- Create ESP for the player
    ESP:createESP(player, PlayerInfo)

    -- Update the leaderboard
    updateLeaderboard()
end

local function handlePlayerRemoving(player)
    if playerLabels[player] then
        playerLabels[player]:Destroy()
        playerLabels[player] = nil
    end

    ESP:removeESP(player)

    if player == observedPlayer then
        observedPlayer = nil
    end

    updateLeaderboard()
end

local function handleInputBegan(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.RightAlt then
        local newState = ESP:togglePlayerESP()
        print("Player ESP:", newState and "Enabled" or "Disabled")
    elseif input.KeyCode == Enum.KeyCode.LeftAlt then
        local newState = ESP:toggleTrinketESP()
        print("Trinket ESP:", newState and "Enabled" or "Disabled")
    end
end

-- Public functions
local Init = {}

function Init:initialize()
    -- Load remote modules
    local webhookSuccess, WebhookModule = ServiceLoader:loadWebhookModule()
    if not webhookSuccess then
        warn("Failed to load WebhookModule:", WebhookModule)
        return
    end

    local soundSuccess, SoundManager = ServiceLoader:loadSoundModule()
    if not soundSuccess then
        warn("Failed to load SoundModule:", SoundManager)
        return
    end

    -- Get configurations
    local webhookConfig = ServiceLoader:getWebhookConfig()
    local soundConfig = ServiceLoader:getSoundConfig()

    -- Initialize ESP
    ESP:initialize()

    -- Create leaderboard
    leaderboardGui, scrollingFrame = LeaderboardUI:create()

    -- Set up player handling
    for _, player in ipairs(Players:GetPlayers()) do
        handlePlayerAdded(player)
    end

    Players.PlayerAdded:Connect(handlePlayerAdded)
    Players.PlayerRemoving:Connect(handlePlayerRemoving)

    -- Set up input handling
    UserInputService.InputBegan:Connect(handleInputBegan)

    -- Set up periodic updates
    game:GetService("RunService").Heartbeat:Connect(updateLeaderboard)

    -- Send webhook notification
    local clientId = game:GetService("RbxAnalyticsService"):GetClientId()
    local embed = WebhookModule:CreateEmbed(
        "Script executed!",
        Players.LocalPlayer.Name .. " has executed PocoyoHub.\n\n**Client Information:**\nHardware ID: `" .. clientId .. "`",
        16711680,
        "Powered by Rogue Lineage",
        webhookConfig.Thumbnail,
        webhookConfig.Thumbnail
    )

    WebhookModule:SendMessage(
        webhookConfig.URL,
        webhookConfig.BotName,
        webhookConfig.BotAvatar,
        embed
    )

    -- Play initialization sound
    SoundManager:playSound(soundConfig.ModSound)

    -- Log version and environment
    print("PocoyoHub v" .. ServiceLoader:getVersion())
    if ServiceLoader:isDevMode() then
        print("Running in development mode")
    end
end

return Init
