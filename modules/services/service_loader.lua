-- RemoteModule Service Loader
-- Purpose: Handles loading of remote modules with proper error handling and security checks
-- Origin: Internal service loader for PocoyoHub

local RemoteURLs = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaic-dev/PocoyoHub/refs/heads/main/modules/config/remote_urls"))()

local ServiceLoader = {}

-- Private functions
local function validateModule(module)
    if type(module) ~= "table" then
        return false, "Invalid module format"
    end
    
    -- Add additional validation as needed
    return true
end

local function loadRemoteModule(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        return false, "Failed to download module: " .. tostring(result)
    end

    local moduleFunction, loadError = loadstring(result)
    if not moduleFunction then
        return false, "Failed to load module: " .. tostring(loadError)
    end

    local success, module = pcall(moduleFunction)
    if not success then
        return false, "Failed to execute module: " .. tostring(module)
    end

    local isValid, error = validateModule(module)
    if not isValid then
        return false, error
    end

    return true, module
end

-- Public functions
function ServiceLoader:loadWebhookModule()
    return loadRemoteModule(RemoteURLs.WebhookModule)
end

function ServiceLoader:loadSoundModule()
    return loadRemoteModule(RemoteURLs.SoundModule)
end

function ServiceLoader:getWebhookConfig()
    return RemoteURLs.WebhookConfig
end

function ServiceLoader:getSoundConfig()
    return RemoteURLs.SoundConfig
end

function ServiceLoader:isDevMode()
    return RemoteURLs.IsDevMode
end

function ServiceLoader:getVersion()
    return RemoteURLs.Version
end

return ServiceLoader 
