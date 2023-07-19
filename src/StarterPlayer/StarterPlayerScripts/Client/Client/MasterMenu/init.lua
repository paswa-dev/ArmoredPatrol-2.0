local TWEENSERVICE = game:GetService("TweenService")
local REPLICATEDSTORAGE = game:GetService("ReplicatedStorage")

local NETWORK = REPLICATEDSTORAGE.Network

local CHANGE_TEAM_REQUEST = NETWORK.ChangeTeam
local SPAWN_REQUEST = NETWORK.Spawn
local DIED = NETWORK.Reload

local get = _G.get
local ROACT = get("Roact")

local New = ROACT.createElement
local COMPONENTS, CONTAINED = script.Components, {}

for _, value in next, COMPONENTS:GetChildren() do
	CONTAINED[value.Name] = require(value)
end

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local function __init__()
	local Handle = nil
	local GUI = New("ScreenGui", {
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		Name = "Menu",
	}, {
		Options = New(CONTAINED["Options"], {
			position = UDim2.fromScale(0.5, 0.5),
			size = UDim2.fromScale(0.5, 0.6),
			scales = true,
			cellsize = 0.3,
			[1] = {
				text = " Spawn",
				textsize = 15,
				callback = function()
					print("DO Spawn")
					SPAWN_REQUEST:FireServer()
					ROACT.unmount(Handle)
				end,
			},
			[2] = {
				text = " Change Team",
				textsize = 15,
				callback = function()
					print("DO ChangeTeam")
					CHANGE_TEAM_REQUEST:FireServer()
				end,
			},
		}),
	})
	DIED.OnClientEvent:Connect(function()
		Handle = ROACT.mount(GUI, PlayerGui)
	end)
	Handle = ROACT.mount(GUI, PlayerGui)
end

return {
	Init = __init__,
}
