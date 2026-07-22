return { 
    MetaData = {
        Name        = "Hello World Addon",
        Description = "My Hello World Addon!",
        Version     = "1.0.0",
        Config      = {
            CustomMessage = nil
        }
    },

    Code = [[
    -- Any services you want
    local RunService = game:GetService("RunService")

    --Addon Setup
    local HelloWorldAddon = {}
    HelloWorldAddon.Config = {}

    -- Pre-defined functions here
    function HelloWorldAddon:Hello()
        print("Hello Client!")

        if HelloWorldAddon.Config.CustomMessage then
            print(string.format("[CUSTOM MESSAGE]: %s", HelloWorldAddon.Config.CustomMessage))
        end
    end

    -- Run Code for Server Here
    function HelloWorldAddon:Init()
        HelloWorldAddon:Hello()
    end

    return HelloWorldAddon
]]
}