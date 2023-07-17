local get = _G.get
local Fusion = get("Fusion")
local LocalPlayer = get("Local")
local PlayerGUI = LocalPlayer.PlayerGUI

--// Health
local function Vitals(Parent)
	local function NewEntry(Name, Parent)
		return Fusion.New("Frame")({
			Name = Name,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.3, 0.3),
			[Fusion.Children] = {
				Fusion.New("TextLabel")({
					Name = "Value",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					TextScaled = true,
					Font = Enum.Font.Code,
					[Fusion.Children] = Fusion.New("UITextSizeConstraint")({
						MaxTextSize = 20,
					}),
				}),
				Fusion.New("UIStroke")({
					Color = Color3.new(0, 0.317647, 1),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Round,
					Thickness = 2,
				}),
				Fusion.New("UICorner")({
					CornerRadius = UDim.new(0, 5),
				}),
			},
			Parent = Parent,
		})
	end

	local VitalMain = Fusion.New("CanvasGroup")({
		AnchorPoint = Vector2.new(1, 1),
		Name = "Vitals",
		Size = UDim2.fromScale(0.2, 0.2),
		Position = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[Fusion.Children] = {
			Fusion.New("UIGridLayout")({
				CellSize = UDim2.fromScale(0.47619047619, 0.47619047619),
				FillDirectionMaxCells = 2,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		},
		Parent = Parent,
	})

	LocalPlayer.CharacterAdded:Connect(function(Info)
		local HealthObject = NewEntry("Health", VitalMain)
		HealthObject.Value.Text = Info.Humanoid.Health
		local Connection
		Connection = Info.Humanoid.HealthChanged:Connect(function(health)
			HealthObject.Value.Text = health
		end)
	end)
end
--// Teams/Players
local function PlayerView(Parent) end
--// Backpack - Another script?

function __init__()
	local ScreenGui = Fusion.New("ScreenGui")({
		Name = "NewCore",
		ResetOnSpawn = false,
		Parent = PlayerGUI,
	})
	Vitals(ScreenGui)
	PlayerView(ScreenGui)
end

return {
	Init = __init__,
}
