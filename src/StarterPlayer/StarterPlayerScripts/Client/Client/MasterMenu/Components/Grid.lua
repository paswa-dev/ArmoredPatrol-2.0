local Roact = _G.get("Roact")
local Component, New = Roact.Component, Roact.createElement
local Grid = Component:extend("Grid")

local function GridComponent(props)
	return New("UIGridLayout", {
		CellSize = props.scales and UDim2.fromScale(props.cellsize, props.cellsize)
			or UDim2.fromOffset(props.cellsize, props.cellsize),
		CellPadding = UDim2.fromOffset(10, 10),
		FillDirectionMaxCells = props.rowamount,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	})
end

function Grid:render()
	return New(GridComponent, self.props)
end

return Grid
