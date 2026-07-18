local RunService = game:GetService("RunService")

local HelloWorld_Addon = {}
HelloWorld_Addon.__index = HelloWorld_Addon

HelloWorld_Addon.Config = {}
HelloWorld_Addon.Config.Name = "HelloWorld_Addon"
HelloWorld_Addon.Config.Description = "My Amazing Hello World Addon!"

if RunService:IsClient() then
    function HelloWorld_Addon.Init()
        setmetatable({}, HelloWorld_Addon)
        print("Hello Client!")
    end
end

if RunService:IsServer() then
    function HelloWorld_Addon.Init()
        setmetatable({}, HelloWorld_Addon)
        print("Hello Server!")
    end
end

return HelloWorld_Addon