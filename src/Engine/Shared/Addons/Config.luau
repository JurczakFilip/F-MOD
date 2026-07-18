local SoundService = game:GetService("SoundService")
local Config = {}

Config.Addons = {
    [1] = {
        ["Source"] = "https://raw.githubusercontent.com/JurczakFilip/F-MOD/refs/heads/master/src/HelloWorld_Addon/Shared/HelloWorld_Addon.luau", -- Link to module
        ["Config"] = {}  -- Config for module
    }
}

return Config