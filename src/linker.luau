local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local linker = {}

--Shared links
linker.Engine = {}

linker.Engine.Shared = ReplicatedStorage:WaitForChild("Engine")

--Client links
if RunService:IsClient() then
    linker.Engine.Client = StarterPlayerScripts:WaitForChild("Engine")
end

--Server links
if RunService:IsServer() then
    linker.Engine.Server = ServerScriptService:WaitForChild("Engine")
end

return linker