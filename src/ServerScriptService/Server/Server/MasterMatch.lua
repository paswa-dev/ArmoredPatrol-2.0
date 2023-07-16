local get = _G.get
local Player = get("Player")
local Communication = get("Communication")

local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local MatchPlayers = {}

local States = Instance.new("Folder")
States.Name = "Communication"
States.Parent = ServerScriptService

local MatchStatus = Instance.new("BoolValue")
MatchStatus.Name = "MatchStatus"
MatchStatus.Parent = States

local function OnPlayerAdded(__Player)
	local PlayerData = Player.new(__Player)
	MatchPlayers[__Player] = PlayerData
end
local function OnPlayerRemoved(__Player) end
local function OnMatchStart() end
local function OnMatchEnd() end

local function OnMatchChange(Value)
	if Value then
		OnMatchStart()
	elseif not Value then
		OnMatchEnd()
	end
end

local function __init__()
	MatchStatus.Changed:Connect(OnMatchChange)
	Players.PlayerAdded:Connect(OnPlayerAdded)
	Players.PlayerRemoving:Connect(OnPlayerRemoved)
end

return {
	Init = __init__,
}
