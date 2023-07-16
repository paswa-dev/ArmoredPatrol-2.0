local Replicated = game:GetService("ReplicatedStorage")
local get = _G.get

local Communication = get("Communication")

local Player = { Started = false }

local function init()
	if not Player.Started then
		Player.Started = true
		Player.Channel = Communication.channel("Data")
		Player.Communication = Replicated:FindFirstChild("PlayerCommunication") :: RemoteEvent
		Player.Communication.OnClientEvent:Connect(Player.Channel.Push)
	end
end

init()
return Player
