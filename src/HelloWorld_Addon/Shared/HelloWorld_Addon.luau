local RunService = game:GetService("RunService")

local HelloWorld_Addon = {}

HelloWorld_Addon.Config = {}
HelloWorld_Addon.Config.Name = "HelloWorld_Addon"
HelloWorld_Addon.Config.Description = "My Amazing Hello World Addon!"

HelloWorld_Addon.Config.User = {
    UserMsg = nil
}

function HelloWorld_Addon:Hello()
    if RunService:IsClient() then
        print("Hello Client!")
        
        if HelloWorld_Addon.Config.User then
            print("UserMsg:",HelloWorld_Addon.Config.User)
        end
    end

    if RunService:IsServer() then
        print("Hello Server!")

        if HelloWorld_Addon.Config.User then
            print("UserMsg:",HelloWorld_Addon.Config.User)
        end
    end
end

HelloWorld_Addon.Server = {}
HelloWorld_Addon.Client = {}

function HelloWorld_Addon.Server:Init()
    HelloWorld_Addon:Hello()
end

function HelloWorld_Addon.Client:Init()
    HelloWorld_Addon:Hello()
end

return HelloWorld_Addon