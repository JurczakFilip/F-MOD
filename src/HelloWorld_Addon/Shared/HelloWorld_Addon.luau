return { 
    MetaData = {
        Name        = "Hello World Addon",
        Description = "My Hello World Addon!",
        Config      = {
            CustomMessage = nil
        }
    },

    Code = [[
    -- Any services you want
    local RunService = game:GetService("RunService")

    --Addon Setup
    local HelloWorldAddon = {}
    HelloWorldAddon.Server = {}
    HelloWorldAddon.Client = {}
    HelloWorldAddon.Config = {}

    -- Pre-defined functions here
    function HelloWorldAddon:Hello()
        if RunService:IsClient() then
            print("Hello Client!")
        else
            print("Hello Server!")
        end

        if HelloWorldAddon.Config.CustomMessage then
            print(string.format("[CUSTOM MESSAGE]: %s", HelloWorldAddon.Config.CustomMessage))
        end
    end

    -- Run Code for Server Here
    function HelloWorldAddon.Server:Init()
        HelloWorldAddon:Hello()
    end

    -- Run Code for Client Here
    function HelloWorldAddon.Client:Init()
        HelloWorldAddon:Hello()
    end

    return HelloWorldAddon
]]
}