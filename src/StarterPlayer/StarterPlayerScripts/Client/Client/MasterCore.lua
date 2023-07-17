local get = _G.get
local Fusion = get("Fusion")
local LocalPlayer = get("Local")
local UICore = get("UICore")
local DisableCore = get("DisableCore")
local PlayerGUI = LocalPlayer.PlayerGUI

--// Health
local function Vitals(Parent)
	local Object = UICore.Component("ImageLabel")({
		Text = "Spawn",
	})
	Object.Parent = Parent
end
--// Teams/Players
local function PlayerView(Parent) end
--// Backpack - Another script?

function __init__()
	local ScreenGui = Fusion.New("ScreenGui")({
		Name = "NewCore",
		ResetOnSpawn = false,
		Parent = PlayerGUI,
	})
	DisableCore()
	Vitals(ScreenGui)
	PlayerView(ScreenGui)
end

return {
	Init = __init__,
}
