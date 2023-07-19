local Roact = _G.get("Roact")
local Component, New = Roact.Component, Roact.createElement
local FlatOptions = Component:extend("FlatOptions")

local function List()
	return New("UIListLayout", {
		Padding = UDim.new(0, 5),
	})
end

function FlatOptions:render()
	return nil
end

return FlatOptions
