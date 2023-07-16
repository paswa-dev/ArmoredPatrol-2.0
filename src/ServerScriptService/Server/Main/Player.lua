--// Contains/Loads specific data's about the specific player!
local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:FindFirstChild("PlayerCommunication") or Instance.new("RemoteEvent")
Remote.Name = "PlayerCommunication"
Remote.Parent = ReplicatedStorage

local get = _G.get
local Datastore = get("Datastore")

local Class = {}
Class.__index = Class

function Class.new(player)
	local config = {}
	config.Datastore = Datastore.new(player)
	config.Player = player
	config.Data = {}

	task.spawn(function()
		player.Team = Teams:WaitForChild("NEUTRAL")
	end)

	return setmetatable(config, Class)
end

function Class:SetTeam(index) end

function Class:Set(name, value)
	return self.Player:SetAttribute(name, value)
end

function Class:Get(name)
	return self.Player:GetAttribute(name)
end

function Class:Communicate(...)
	Remote:FireClient(self.Player, ...)
end

return Class
