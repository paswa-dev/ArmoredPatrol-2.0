local TWEENSERVICE = game:GetService("TweenService")

local get = _G.get
local ROACT = get("Roact")

local New = ROACT.createElement
local COMPONENTS, CONTAINED = script.Components, {}

for _, value in next, COMPONENTS:GetChildren() do
	CONTAINED[value.Name] = require(value)
end

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local function __init__()
	local GUI = New("ScreenGui", {
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		Name = "Menu",
	}, {
		Button = New(CONTAINED["ImageButton"], {
			name = "Button",
			position = UDim2.fromScale(0.5, 0.5),
			size = UDim2.fromScale(0.2, 0.2),
			text = " Button!",
			textSize = 15,
			Hover = function(rbx)
				rbx:TweenSize(UDim2.fromScale(1, 0.3), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 1, true)
			end,
			Unhover = function(rbx)
				rbx:TweenSize(UDim2.fromScale(1, 0.2), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.5, true)
			end,
			Click = function(rbx)
				rbx:TweenPosition(
					UDim2.fromScale(0.1, 1),
					Enum.EasingDirection.InOut,
					Enum.EasingStyle.Quart,
					0.2,
					true
				)
				task.wait(0.1)
				rbx:TweenPosition(UDim2.fromScale(0, 1), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.2, true)
			end,
		}),
	})
	ROACT.mount(GUI, PlayerGui)
end

return {
	Init = __init__,
}
