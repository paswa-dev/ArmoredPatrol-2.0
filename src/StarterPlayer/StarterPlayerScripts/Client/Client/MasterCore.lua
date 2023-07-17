local get = _G.get
local Fusion = get("Fusion")
local LocalPlayer = get("Local")
local PlayerGUI = LocalPlayer.PlayerGUI

--// Health
local function Vitals(Parent) end
--// Teams/Players
local function PlayerView(Parent) end
--// Backpack - Another script?

function __init__()
	local ScreenGui = Fusion.New("ScreenGui")({
		Name = "NewCore",
		ResetOnSpawn = false,
		Parent = PlayerGUI,
	})
	Vitals(ScreenGui)
	PlayerView(ScreenGui)
end

return {
	Init = __init__,
}
