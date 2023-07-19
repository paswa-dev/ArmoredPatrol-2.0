local Roact = _G.get("Roact")
local Component, New = Roact.Component, Roact.createElement
local Button = Component:extend("ImageButton")

local function ImageTextButton(props)
	return New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = props.position,
		Size = props.size,
	}, {
		Image = New("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			Image = props.Image,
			BackgroundColor3 = Color3.fromHex("F0EDEE"),
			ScaleType = Enum.ScaleType.Crop,
			BorderSizePixel = 0,
			ZIndex = 1,
		}),
		Text = New("TextButton", {
			Name = props.name,
			BorderSizePixel = 0,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 0.2),
			BackgroundColor3 = Color3.fromHex("0A090C"),
			Text = props.text,
			TextSize = props.textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Code,
			[Roact.Event.MouseEnter] = props.Hover,
			[Roact.Event.MouseLeave] = props.Unhover,
			[Roact.Event.Activated] = props.Click,
		}),
	})
end

function Button:render()
	return New(ImageTextButton, self.props)
end

return Button
