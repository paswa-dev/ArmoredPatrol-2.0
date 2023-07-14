local get = _G.get
local Controls = get("Controls")

local module = {}

function module.Init()
	Controls.Map("Scroll", function(state)
		print(state)
	end)

	Controls.InputMap(Enum.UserInputType.MouseWheel, "Scroll")
end

return module
