-- Leaderboard UI Module
local Players = game:GetService("Players")

-- Constants
local BILLBOARD_SIZE = UDim2.new(0, 500, 0, 100)
local MAINFRAME_SIZE = UDim2.new(1, 0, 1, 0)
local OFFSET_SCALE_INCREMENT = 0.20

local LeaderboardUI = {}

-- Private functions
local function createUIScale(parent)
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = parent
    return uiScale
end

local function updateScale(text, scale)
    local cleanedText = string.gsub(text, "[%[%]]", "")
    local length = #cleanedText
    scale.Scale = length <= 3 and 1 or 1 + ((length - 3) * OFFSET_SCALE_INCREMENT)
end

local function addUIStroke(label, color, thickness)
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = color
    uiStroke.Thickness = thickness
    uiStroke.Parent = label
    return uiStroke
end

local function createTextLabel(name, text, size, parent, color, textXAlign, textYAlign)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = text
    label.Size = size
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = textXAlign or Enum.TextXAlignment.Center
    label.TextYAlignment = textYAlign or Enum.TextYAlignment.Center
    label.Parent = parent

    addUIStroke(label, Color3.fromRGB(0, 0, 0), 2)
    return label
end

local function setupUIListLayout(parent, fillDirection, horizontalAlignment, verticalAlignment)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = fillDirection or Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = horizontalAlignment or Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = verticalAlignment or Enum.VerticalAlignment.Bottom
    layout.Parent = parent
end

-- Public functions
function LeaderboardUI:create()
    local leaderboardGui = Instance.new("ScreenGui")
    leaderboardGui.Name = "SuperLeaderBoard"
    leaderboardGui.ResetOnSpawn = false
    leaderboardGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local ImageButton = Instance.new("ImageButton")
    ImageButton.Name = "LeaderboardButton"
    ImageButton.AnchorPoint = Vector2.new(1, 0)
    ImageButton.BackgroundTransparency = 1
    ImageButton.Position = UDim2.new(1, 0, 0, 0)
    ImageButton.Size = UDim2.new(0.05, 150, 0, 240)
    ImageButton.Image = "rbxassetid://1327087642"
    ImageButton.ImageTransparency = 0.8
    ImageButton.Parent = leaderboardGui

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "LeaderboardScrollingFrame"
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.Position = UDim2.new(0, 15, 0, 10)
    scrollingFrame.Size = UDim2.new(1, -30, 1, 20)
    scrollingFrame.BottomImage = "rbxassetid://3515608177"
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 220)
    scrollingFrame.MidImage = "rbxassetid://3515608813"
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(245, 197, 130)
    scrollingFrame.ScrollBarThickness = 10
    scrollingFrame.TopImage = "rbxassetid://3515609176"
    scrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    scrollingFrame.Parent = ImageButton

    return leaderboardGui, scrollingFrame
end

function LeaderboardUI:updatePlayerLabelAppearance(player, label, observedPlayer)
    if not player or not label then
        warn("[DEBUG] Player or label is invalid")
        return
    end

    local isMaxEdict = player:GetAttribute("MaxEdict") or false
    local characterExists = player.Character ~= nil
    local backpack = player:FindFirstChild("Backpack")
    local hasObserve = backpack and backpack:FindFirstChild("Observe")
    local isGreaterNavaran = backpack and backpack:FindFirstChild("Jack")

    label.TextTransparency = characterExists and 0 or 0.3

    -- Update label appearance based on player state
    if player == observedPlayer then
        label.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold for observed player
    elseif isMaxEdict then
        label.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red for max edict
    elseif hasObserve then
        label.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green for observe
    elseif isGreaterNavaran then
        label.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan for greater navaran
    else
        label.TextColor3 = Color3.fromRGB(255, 255, 255) -- White for others
    end
end

return LeaderboardUI 
