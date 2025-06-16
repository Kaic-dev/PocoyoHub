-- Player Info Module
local Players = game:GetService("Players")

local PlayerInfo = {}

-- Private functions
local function getEdict(player)
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return "None" end

    local edictItems = {
        ["Seer"] = {"Intent"},
        ["Healer"] = {"Mederi"},
        ["Blademaster"] = {"Verto"}
    }

    for edict, items in pairs(edictItems) do
        for _, itemName in ipairs(items) do
            if backpack:FindFirstChild(itemName) then
                return edict
            end
        end
    end

    return "None"
end

local function getRogueName(player)
    local firstName = player:GetAttribute("FirstName") or "Unknown"
    local lastName = player:GetAttribute("LastName") or "Unknown"
    local houseRank = player:GetAttribute("HouseRank") or ""

    if houseRank == "Owner" then
        return string.format("Lord %s %s", firstName, lastName)
    elseif houseRank == "Member" then
        return string.format("%s %s", firstName, lastName)
    elseif houseRank == "" then
        return firstName
    end
    return "[RogueName]"
end

-- Public functions
function PlayerInfo:getPlayerInfo(player)
    if not player then return nil end

    local character = player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    local health = humanoid and humanoid.Health or 0
    local maxHealth = humanoid and humanoid.MaxHealth or 100
    local edict = getEdict(player)
    local rogueName = getRogueName(player)
    local isMaxEdict = player:GetAttribute("MaxEdict") or false
    local backpack = player:FindFirstChild("Backpack")
    local hasObserve = backpack and backpack:FindFirstChild("Observe")
    local isGreaterNavaran = backpack and backpack:FindFirstChild("Jack")

    return {
        name = player.Name,
        rogueName = rogueName,
        health = health,
        maxHealth = maxHealth,
        edict = edict,
        isMaxEdict = isMaxEdict,
        hasObserve = hasObserve,
        isGreaterNavaran = isGreaterNavaran,
        character = character,
        backpack = backpack
    }
end

function PlayerInfo:getPlayerLabel(player, observedPlayer)
    local info = self:getPlayerInfo(player)
    if not info then return nil end

    local healthPercentage = math.floor((info.health / info.maxHealth) * 100)
    local labelText = string.format("[%s] %s (%s) [%d%%]", 
        info.edict,
        info.rogueName,
        info.name,
        healthPercentage
    )

    return labelText
end

function PlayerInfo:getAllPlayers()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            table.insert(players, player)
        end
    end
    return players
end

return PlayerInfo 
