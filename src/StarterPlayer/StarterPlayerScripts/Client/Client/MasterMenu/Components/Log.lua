local Roact = _G.get("Roact")
local Component, New = Roact.Component, Roact.createElement
local Log = Component:extend("Log")

local function List() end

function Log:render()
	return nil
end

return Log
