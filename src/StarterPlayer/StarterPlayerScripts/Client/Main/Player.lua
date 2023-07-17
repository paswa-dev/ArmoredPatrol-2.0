local Replicated = game:GetService("ReplicatedStorage")
local get = _G.get

local Communication = get("Communication")

local Class = { Started = false }

local function init()
	if not Class.Started then
		Class.Started = true
		Class.Channel = Communication.channel("Data")
		Class.Communication = Replicated:FindFirstChild("PlayerCommunication") :: RemoteEvent
		Class.Communication.OnClientEvent:Connect(Class.Channel.Push)
	end
end

init()
return Class
