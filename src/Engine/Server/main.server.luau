--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

--Modules
local Linker = require(ReplicatedStorage:WaitForChild("linker"))

--InitScript
local Engine = {}
Engine.AddonService = {}
Engine.AddonService.RunningAddons = {}
-- Load Addons
function Engine.AddonService:Load()
    local AddonsModule = require(Linker.Engine.Shared.Addons.Config)

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

function Engine.AddonService:ReplicateToClient(plr)
    print(string.format("[Server] [Engine.AddonService:ReplicateToClient] Replicating All Addons to %s.", plr.Name))

    for _, Addon in Engine.AddonService.RunningAddons do
        print("[Server] [Engine.AddonService:ReplicateToClient] Replicating:",tostring(Addon.Config.Name))

        --Convert table into json
        local JSON_Packet = HttpService:JSONEncode(Addon)
    
        local Buffer = buffer.fromstring(tostring(JSON_Packet))

        print("Buffer.len:", buffer.len(Buffer))
        print("Buffer.tostring:",buffer.tostring(Buffer))
    end
end

function Engine:PlayerAdded(plr)
    print("[Server] [Engine:PlayerAdded] Player:", plr.Name,"Connected!")
    task.wait(5)
    print("[Server] [Engine:PlayerAdded] Replicating Addons to client!")
    Engine.AddonService:ReplicateToClient(plr)
end

--Main/RunTime
Engine.AddonService:Load()

Players.PlayerAdded:Connect(function(plr)
    Engine:PlayerAdded(plr)
end)