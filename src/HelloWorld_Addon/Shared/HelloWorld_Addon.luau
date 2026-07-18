local RunService = game:GetService("RunService")

local HelloWorld_Addon = {}
HelloWorld_Addon.__index = HelloWorld_Addon

HelloWorld_Addon.Config = {}
HelloWorld_Addon.Config.Name = "HelloWorld_Addon"
HelloWorld_Addon.Config.Description = "My Amazing Hello World Addon!"

HelloWorld_Addon.UserConfig = {
    UserMsg = nil
}

function HelloWorld_Addon:Hello()
    if RunService:IsClient() then
        print("Hello Client!")
        
        if HelloWorld_Addon.UserConfig.UserMsg then
            print("UserMsg:",HelloWorld_Addon.UserConfig.UserMsg)
        end
    end

    if RunService:IsServer() then
        print("Hello Server!")

        if HelloWorld_Addon.UserConfig.UserMsg then
            print("UserMsg:",HelloWorld_Addon.UserConfig.UserMsg)
        end
    end
end

if RunService:IsClient() then
    function HelloWorld_Addon.Init()
        setmetatable({}, HelloWorld_Addon)
        HelloWorld_Addon:Hello()
    end
end

if RunService:IsServer() then
    function HelloWorld_Addon.Init()
        setmetatable({}, HelloWorld_Addon)
        HelloWorld_Addon:Hello()
    end
end

return HelloWorld_Addon