--// Contains/Loads specific data's about the specific player!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:FindFirstChild("PlayerCommunication") or Instance.new("RemoteEvent")
Remote.Name = "PlayerCommunication"
Remote.Parent = ReplicatedStorage

local get = _G.get
local Datastore = get("Datastore")
local Teams = get("Team")

local player = {}
player.__index = player

function player.new(player)
	local config = {}
	config.Datastore = Datastore.new(player)
	config.Player = player
	config.Data = {}
	return setmetatable(config, player)
end

function player:Set(name, value)
	return player:SetAttribute(name, value)
end

function player:Get(name)
	return player:GetAttribute(name)
end

function player:Communicate(...)
	Remote:FireClient(self.Player, ...)
end

return player
