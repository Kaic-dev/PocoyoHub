-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESP = {}

-- Private variables
local espInstances = {}
local characterConnections = {}
local renderSteppedConnections = {}

-- Private functions
local function createBillboardGui(player)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_" .. player.Name
    billboardGui.Size = UDim2.new(0, 500, 0, 100)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Adornee = player.Character and player.Character:FindFirstChild("Head")
    billboardGui.Parent = player.Character and player.Character:FindFirstChild("Head")

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboardGui

    local label = Instance.new("TextLabel")
    label.Name = "PlayerLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = frame

    return billboardGui, label
end

local function cleanupESP(player)
    if espInstances[player] then
        espInstances[player]:Destroy()
        espInstances[player] = nil
    end

    if characterConnections[player] then
        characterConnections[player]:Disconnect()
        characterConnections[player] = nil
    end

    if renderSteppedConnections[player] then
        renderSteppedConnections[player]:Disconnect()
        renderSteppedConnections[player] = nil
    end
end

-- Public functions
function ESP:initialize()
    -- Set initial ESP state
    getgenv().PlayerESP = false
    getgenv().TrinketESP = false

    -- Clean up existing ESP instances
    for player in pairs(espInstances) do
        cleanupESP(player)
    end
end

function ESP:createESP(player, playerInfo)
    if not player or not player.Character then return end

    local billboardGui, label = createBillboardGui(player)
    espInstances[player] = billboardGui

    -- Update label text
    label.Text = playerInfo:getPlayerLabel(player)

    -- Set up character connection
    characterConnections[player] = player.Character.ChildAdded:Connect(function(child)
        if child.Name == "Head" then
            billboardGui.Adornee = child
        end
    end)

    -- Set up render stepped connection
    renderSteppedConnections[player] = RunService.RenderStepped:Connect(function()
        if not getgenv().PlayerESP then
            billboardGui.Enabled = false
            return
        end

        local character = player.Character
        if not character then
            billboardGui.Enabled = false
            return
        end

        local head = character:FindFirstChild("Head")
        if not head then
            billboardGui.Enabled = false
            return
        end

        local distance = (head.Position - Camera.CFrame.Position).Magnitude
        if distance > 1000 then
            billboardGui.Enabled = false
            return
        end

        billboardGui.Enabled = true
        label.Text = playerInfo:getPlayerLabel(player)
    end)
end

function ESP:removeESP(player)
    cleanupESP(player)
end

function ESP:togglePlayerESP()
    getgenv().PlayerESP = not getgenv().PlayerESP
    return getgenv().PlayerESP
end

function ESP:toggleTrinketESP()
    getgenv().TrinketESP = not getgenv().TrinketESP
    return getgenv().TrinketESP
end

return ESP 
