--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

--Modules
local Linker = require(ReplicatedStorage:WaitForChild("linker"))

--InitScript
local Engine = {}
Engine.AddonService = {}
-- Load Addons
function Engine.AddonService:Load()
    local AddonsModule = require(Linker.Engine.Shared.Addons.Config)

    local UnpackagedAddons = {}
    for _, Table in AddonsModule.Addons do
        print("[Server] [Engine.AddonService:CollectAddons] Loading: "..tostring(_))
        Table["Source"] = HttpService:GetAsync(Table["Source"])

        local success, Module = pcall(function()
            return loadstring(Table["Source"])()
        end)
        
        if success then
            print("Successfully loaded Addon: ")
        end

        UnpackagedAddons[_] = Table
    end

    print("[Server] [Engine.AddonService:CollectAddons] Returning Addons for init...")
    return UnpackagedAddons
end

--Main/RunTime
print("SERVER RUNNING")

local Addons = Engine.AddonService:Load()
print("Addons:", Addons)