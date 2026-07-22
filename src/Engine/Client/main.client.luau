--Services
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EncodingService = game:GetService("EncodingService")

--Modules
local Linker = require(ReplicatedStorage:WaitForChild("linker"))

--InitScript
local Engine = {}
Engine.AddonService = {}
-- Addons
function Engine.AddonService:DecodeAddon(BufferedAddon)
    local success 
    local Decompressed_Buffer
    local BufferString
    local Data
    local Code

    success, Decompressed_Buffer = pcall(function()
        return EncodingService:DecompressBuffer(BufferedAddon, Enum.CompressionAlgorithm.Zstd, 9)
    end)
    
    success, BufferString = pcall(function()
        return buffer.tostring(Decompressed_Buffer)
    end)

    success, Data = pcall(function()
        return HttpService:JSONDecode(BufferString)
    end)

    success, Code = pcall(function()
        return loadstring(Data["Code"])()
    end)

    print(string.format("[Client] [Engine.AddonService] LOADED ADDON: %s",Data["MetaData"]["Name"]))
    Data.Client:Init()
end

Linker.Engine.Shared:WaitForChild("Remotes"):FindFirstChild("ReplicateAddons").OnClientEvent:Connect(function(Addon)
    Engine.AddonService:DecodeAddon(Addon)
end)


