local GET = _G.get

local COMPONENTS_FOLDER, COMPONENTS = script.Components, {}
local CONTAINERS_FOLDER, CONTAINERS = script.Containers, {}
local UTILS = script.Utils

for _, Found in next, COMPONENTS_FOLDER:GetChildren() do
	COMPONENTS[Found.Name] = require(Found)
end

for _, Found in next, CONTAINERS_FOLDER:GetChildren() do
	CONTAINERS[Found.Name] = require(Found)
end

local ApplyProperties = require(UTILS.ApplyProperties)

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

--[[
@API

Updates Text or Properties on the mounted or unmounted components

--]]

local CoreModule = {}
CoreModule.PlayerGui = PlayerGui

function CoreModule.Component(name, ...)
	if COMPONENTS[name] then
		return COMPONENTS[name]
	end
end

function CoreModule.Container(name, ...)
	if CONTAINERS[name] then
		return CONTAINERS[name]
	end
end

return CoreModule
