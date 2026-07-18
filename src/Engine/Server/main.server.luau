--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

--Modules
local Linker = require(ReplicatedStorage:WaitForChild("linker"))

--InitScript
local Engine = {}
Engine.AddonService = {}
Engine.AddonService.AddonsToSendToClient = {}
-- Load Addons
function Engine.AddonService:Load()
    local AddonsModule = require(Linker.Engine.Shared.Addons.Config)

    -- Load Addon
   for _, Table in AddonsModule.Addons do
        print(string.format("[SERVER] [Engine.AddonService] Loading: %s",_))
        local success = false
        local Addon = nil

        -- 3 attempts to load addon
        for attempt = 1, 3 do
            success, Addon = pcall(function()
                return HttpService:GetAsync(Table["Source"])
            end) 
            if success then
                print(string.format("[Server] [Engine.AddonService] Successfully Loaded: %s",_))
                break
            else
                warn(string.format("[Server] [Engine.AddonService] Failed to load: %s, Retrying in 2 seconds...",_))
                task.wait(1)
            end
        end
        -- If Unsuccessfuly to load addon
        if not success then
            warn(string.format("[Server] [Engine.AddonService] Aborting Addon: %s", _))
            return
        end

        success, Addon = pcall(function()
            return loadstring(Addon)()
        end)

        if not success then
            warn(string.format("[Server] [Engine.AddonService] Failed to unpack addon: %s", _))
            return
        else
            print(string.format("[Server] [Engine.AddonService] Successfully Unpacked Addon: %s",_))
        end

        print(Addon["Contents"])
        local contents = Addon["Contents"]
        local code = nil
        success, code = pcall(function()
            return loadstring(contents)()
        end)

        if not success then
            warn(string.format("[Server] [Engine.AddonService Failed to unpack Addon Code: %s",_))
        else
            print(code)
        end

    end
end

--Main/RunTime
Engine.AddonService:Load()
print("[Engine.AddonService.AddonsToSendToClient]:",Engine.AddonService.AddonsToSendToClient)