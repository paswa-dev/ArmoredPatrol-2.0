local get = _G.get
local Fusion = get("Fusion")
local LocalPlayer = get("Local")
local DisableCore = get("DisableCore")
local PlayerGUI = LocalPlayer.PlayerGUI

local Root = PlayerGUI:WaitForChild("Main Menu")

local function Dump()
	local T = {}
	return {
		Add = function(...)
			for _, Value in next, { ... } do
				table.insert(T, Value)
			end
		end,
		Dump = function()
			for _, v in next, T do
				if typeof(v) == "Instance" then
					v:Destroy()
				elseif typeof(v) == "RBXScriptConnection" then
					v:Disconnect()
				end
			end
		end,
	}
end

local Trashcan = Dump()

function __init__()
	local Pages = Root.Pages
	local Layout = Pages.Layout :: UIPageLayout
	local Main = Pages.Main
	local Gunsmith = Pages.Gunsmith

	_G.CoreActions = {
		Spawn = function()
			Trashcan.Dump()
			Layout:JumpTo(Main)
			Pages.Parent.Enabled = false
			--// Fire to server to spawn the player
		end,
	}

	local function PageChanged()
		Trashcan.Dump()
		local Property = Layout.CurrentPage
		require(script[Property.Name])(Property, Trashcan)
	end
	PageChanged()
	Layout:GetPropertyChangedSignal("CurrentPage"):Connect(PageChanged)

	DisableCore()
end

return {
	Init = __init__,
}
