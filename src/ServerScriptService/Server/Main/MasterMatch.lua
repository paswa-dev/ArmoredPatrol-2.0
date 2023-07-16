local get = _G.get
local Player = get("Player")
local Team = get("Team")
local Communication = get("Communication")

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local States = Instance.new("Folder")
States.Name = "Communication"
States.Parent = ServerScriptService

Players.PlayerAdded:Connect(function(__Player) end)
