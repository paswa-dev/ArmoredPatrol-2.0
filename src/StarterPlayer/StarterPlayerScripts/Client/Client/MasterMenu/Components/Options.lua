local Parent = script.Parent

local ImageButton = require(Parent.ImageButton)
local Grid = require(Parent.Grid)

local Roact = _G.get("Roact")
local Component, New = Roact.Component, Roact.createElement
local Options = Component:extend("Options")

local function TweenElement(rbx)
	rbx:TweenPosition(UDim2.fromScale(0.1, 1), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.1, true)
	task.wait(0.1)
	rbx:TweenPosition(UDim2.fromScale(0, 1), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.1, true)
end

local function NewImageButton(props)
	print(props)
	return New(ImageButton, {
		name = props.name or "",
		position = props.position or UDim2.fromScale(0, 0),
		size = props.size or UDim2.fromScale(0, 0),
		text = props.text or " Placeholder",
		textSize = props.textsize or "15",
		Hover = function(rbx)
			rbx:TweenSize(UDim2.fromScale(1, 0.25), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.6, true)
		end,
		Unhover = function(rbx)
			rbx:TweenSize(UDim2.fromScale(1, 0.2), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.5, true)
		end,
		Click = function(rbx)
			TweenElement(rbx)
			if props.callback then
				props.callback(rbx)
			end
		end,
	})
end

function Options:render()
	assert(#self.props <= 4, "Cannot have more then 4 options...")
	local Pack = {}
	for _, props in next, self.props do
		if typeof(props) == "table" then
			table.insert(Pack, NewImageButton(props))
		end
	end
	return New("Frame", {
		Position = self.props.position,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = self.props.size,
		BackgroundTransparency = 1,
	}, {
		Fragment = Roact.createFragment(Pack),
		Options = New(Grid, {
			rowamount = 2,
			cellsize = self.props.cellsize,
			scales = self.props.scales,
		}),
	})
end

return Options
