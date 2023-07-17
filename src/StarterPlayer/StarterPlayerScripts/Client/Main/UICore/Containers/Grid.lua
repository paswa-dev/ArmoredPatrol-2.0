local GET = _G.get
local Fusion = GET("Fusion")
local New, Children = Fusion.New, Fusion.Children

local function Container(_Position, _Size, _CellSize, _CellPadding)
	return New("Frame")({
		Name = "Grid",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(34, 34, 34),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = _Position or UDim2.fromScale(0.5, 0.5),
		Size = _Size or UDim2.fromScale(1, 1),

		[Children] = {
			New("UIGridLayout")({
				Name = "UIGridLayout",
				CellPadding = _CellSize or UDim2.fromOffset(10, 10),
				CellSize = _CellPadding or UDim2.fromScale(0.2, 0.3),
				FillDirectionMaxCells = 2,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		},
	})
end

--[[
Position,
Size,
CellSize,
CellPadding
--]]

return function(data)
	local Object = Container(data.Position, data.Size, data.CellSize, data.CellPadding)
end
