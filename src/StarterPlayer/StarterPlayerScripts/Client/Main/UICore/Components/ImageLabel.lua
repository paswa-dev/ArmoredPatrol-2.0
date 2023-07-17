local GET = _G.get
local Fusion = GET("Fusion")
local New, Children = Fusion.New, Fusion.Children

local function Component(text, textColor, gradientColor, image_id, image_transparency)
	return New("ImageLabel")({
		Name = "TextBin",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		LayoutOrder = 0,
		Position = UDim2.fromScale(0.407, 0.13),
		Size = UDim2.fromScale(0.2, 0.82),

		[Children] = {
			New("Frame")({
				Name = "Gradient",
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.fromScale(1, 0.5),

				[Children] = {
					New("UIGradient")({
						Name = "UIGradient",
						Color = NumberSequence.new({
							NumberSequenceKeypoint.new(0, gradientColor),
							NumberSequenceKeypoint.new(1, gradientColor),
						}),
						Rotation = -90,
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(0.29, 0.1),
							NumberSequenceKeypoint.new(0.555, 0.381),
							NumberSequenceKeypoint.new(1, 1),
						}),
					}),

					New("TextButton")({
						Name = "Value",
						FontFace = Font.new("rbxassetid://12187362578"),
						TextColor3 = textColor,
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						AnchorPoint = Vector2.new(0.5, 1),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.5, 1),
						Size = UDim2.fromScale(1, 0.2),
						Text = text,

						[Children] = {
							New("UITextSizeConstraint")({
								Name = "UITextSizeConstraint",
								MaxTextSize = 35,
							}),
						},
					}),
				},
			}),
		},
	})
end

return function(Data)
	local Object = Component(Data.Text, Data.TextColor3, Data.GradientColor3, Data.Image, Data.ImageTransparency)
	return {
		Object = Object,
		TextObject = Object.Gradient.Value,
	}
end
