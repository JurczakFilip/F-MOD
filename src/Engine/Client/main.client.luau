--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
        print("[Client] [Engine.AddonService:CollectAddons] Loading: "..tostring(_))
        Table["Source"] = game:HttpGet(Table["Source"])
        UnpackagedAddons[_] = Table
    end

    print("[Client] [Engine.AddonService:CollectAddons] Returning Addons for init...")
    return UnpackagedAddons
end

--Main/RunTime
--local Addons = Engine.AddonService:Load()
--print("Addons:", Addons)

Linker.Engine.Shared:WaitForChild("Remotes"):FindFirstChild("ReplicateAddons").OnClientEvent:Connect(function(Addon)
    print("Recieved")
    print(Addon)
end)