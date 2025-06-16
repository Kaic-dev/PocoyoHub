-- RemoteModule Configuration
-- Purpose: Centralized configuration for all remote module URLs
-- Origin: GitHub repository for PocoyoHub

local RemoteURLs = {
    -- Core Modules
    WebhookModule = "https://raw.githubusercontent.com/Kaic-dev/PocoyoHub/refs/heads/main/webhookModule",
    SoundModule = "https://raw.githubusercontent.com/Kaic-dev/PocoyoHub/refs/heads/main/soundModule",
    
    -- Version tracking
    Version = "1.0.0",
    
    -- Environment configuration
    IsDevMode = false,
    
    -- Webhook configuration
    WebhookConfig = {
        URL = "https://discord.com/api/webhooks/1309557441033142302/K5xLDqYbj-nGxPqx2u1N24aYhE-8GdRF_OPcx4GPs_JuuWeUbORbzPRZ886wX1K9wDkV",
        BotName = "Rogue Lineage",
        BotAvatar = "https://cdn2.steamgriddb.com/thumb/77802f137800d7b8dda6ec21772dcde5.jpg",
        Thumbnail = "https://cdn2.steamgriddb.com/thumb/77802f137800d7b8dda6ec21772dcde5.jpg"
    },
    
    -- Sound configuration
    SoundConfig = {
        ObserveSound = "rbxassetid://138081500",
        ModSound = "rbxassetid://9113085764"
    }
}

return RemoteURLs 
