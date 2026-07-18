--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

--Modules
local Linker = require(ReplicatedStorage:WaitForChild("linker"))

--InitScript
local Engine = {}
Engine.AddonService = {}
Engine.AddonService.RunningAddons = {}
-- Load Addons
function Engine.AddonService:Load()
    local AddonsModule = require(Linker.Engine.Shared.Addons.Config)

    local UnpackagedAddons = {}
    for _, Table in AddonsModule.Addons do
        print("[Server] [Engine.AddonService:Load] Loading: "..tostring(_))
        Table["Source"] = HttpService:GetAsync(Table["Source"])

        local success, Addon = pcall(function()
            return loadstring(Table["Source"])()
        end)
        
        if success then
            print("[Server] [Engine.AddonService:Load] Successfully loaded Addon:",tostring(Addon.Config.Name))
            print("[Server] [Engine.AddonService:Load] Initializing Addon:",tostring(Addon.Config.Name))
            local success, init = pcall(function()
                if Table["UserConfig"] then
                    Addon.Config.User = Table["UserConfig"]
                end
                return Addon.Init()
            end)
            if success then 
                print("[Server] [Engine.AddonService:Load] Successfully Initialized Addon:",tostring(Addon.Config.Name))
            else
                print("Failed to Initialize Addon:", tostring(Addon.Config.Name))
                return
            end
        else
            print("[Server] [Engine.AddonService:Load] Failed to load:",tostring(_))
            return
        end

        table.insert(Engine.AddonService.RunningAddons, Addon)
    end
end

function Engine.AddonService:ReplicateToClient()
    print("Nothing")
end

--Main/RunTime
Engine.AddonService:Load()

print("Engine.AddonService.RunningAddons:",Engine.AddonService.RunningAddons)