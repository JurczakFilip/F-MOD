--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local EncodingService = game:GetService("EncodingService")

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
        print(string.format("================[SERVER] [Engine.AddonService]================"))
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
        --Abord after 3 failed attempts
        if not success then
            warn(string.format("[Server] [Engine.AddonService] Aboorting addon: %s", _))
        end
        
        -- Unpack for meta data
        local Data = nil
        success, Data = pcall(function()
            print(string.format("[Server] [Engine.AddonService] Unpacking Addon: %s", _))
            return loadstring(Addon)()
        end)

        if not success then
            warn(string.format("[Server] [Engine.AddonService] Failed to unpack Addon: %s", _))
        end

        print(string.format("[Server] [Engine.AddonService] Successfully Unpacked: [%s] - %s", _, Data["MetaData"]["Name"]))
        print(string.format("[Server] [Engine.AddonService] Unpacking code: [%s] - %s", _, Data["MetaData"]["Name"]))

        local Code
        success, Code = pcall(function()
            return loadstring(Data["Code"])()
        end)

        if not success then
            warn(string.format("[Server] [Engine.AddonService] Failed to unpack code for: [%s] - %s", _, Data["MetaData"]["Name"]))
        end

        print(string.format("[Server] [Engine.AddonService] Successfully Unpacked code for: [%s] - %s", _, Data["MetaData"]["Name"]))
        print(string.format("[Server] [Engine.AddonService] initializing... [%s] - %s", _, Data["MetaData"]["Name"]))

        success = pcall(function()
            return Code.Server:Init()
        end) 

        if not success then 
            warn(string.format("[Server] [Engine.AddonService] Failed to initialize code! [%s] - [%s]", _, Data["MetaData"]["Name"]))
        end

        print(string.format("[Server] [Engine.AddonService] Successfully initialized: [%s] - [%s]", _, Data["MetaData"]["Name"]))

        table.insert(Engine.AddonService.AddonsToSendToClient, Data)
    end
end

function Engine.AddonService:SendAddonsToClient(plr)
    print(string.format("[Server] [Engine.AddonService] Sending Addons to: %s", plr["Name"]))
    task.wait(3)

    for _, Addon in Engine.AddonService.AddonsToSendToClient do
        print(string.format("[Server] [Engine.AddonService] Sending: [%s] - %s",_, Addon["MetaData"]["Name"]))
        
        local success, JSON_ENCODED = pcall(function()
            return HttpService:JSONEncode(Addon)
        end)
        
        if not success then
            warn(string.format("[Server] [Engine.AddonService] Failed to encode Addon into JSON: [%s] - %s", _, Addon["MetaData"]["Name"]))
        end

        local Buffer
        success, Buffer = pcall(function()
            return buffer.fromstring(JSON_ENCODED)
        end)

        if not success then
            warn(string.format("[Server] [Engine.AddonService] Failed to set Buffer for: [%s] - %s", _, Addon["MetaData"]["Name"]))
        end

        local CompressedBuffer 
        success, CompressedBuffer = pcall(function()
            return EncodingService:CompressBuffer(Buffer, Enum.CompressionAlgorithm.Zstd, 9)
        end)

        if not success then
            warn(string.format("[Server] [Engine.AddonService] Failed to compress Buffer for: [%s] - %s", _, Addon["MetaData"]["Name"]))
        end

        print(string.format("[Server] [Engine.AddonService] Before Addon Compression: %s", buffer.len(Buffer)))
        print(string.format("[Server] [Engine.AddonService] After Addon Compression: %s", buffer.len(CompressedBuffer)))

        print(string.format("[Server] [Engine.AddonService] Sending now: %s", Addon["MetaData"]["Name"]))
        Linker.Engine.Shared:WaitForChild("Remotes"):FindFirstChild("ReplicateAddons"):FireClient(plr, CompressedBuffer)
    end

end

--Main/RunTime
Engine.AddonService:Load()

Players.PlayerAdded:Connect(function(plr)
    Engine.AddonService:SendAddonsToClient(plr)
end)