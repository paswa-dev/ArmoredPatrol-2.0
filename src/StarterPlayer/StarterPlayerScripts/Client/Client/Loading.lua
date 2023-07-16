local get = _G.get

local Parent = script.Parent.Parent
local TweenService = game:GetService("TweenService")

local function ForPairs(t, callback)
	for index, value in pairs(t) do
		callback(index, value)
	end
end

local Fusion = get("fusion")

local TweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

local Player = game.Players.LocalPlayer
local Expected = Parent:GetAttribute("Expected")
local Loaded = Parent:GetAttributeChangedSignal("Loaded")

local PlayerGUI = Player:WaitForChild("PlayerGui")

local Scale = 6

local function init()
	local Loading = Fusion.New("ScreenGui")({
		Name = "LoadingUI",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		[Fusion.Children] = Fusion.New("Frame")({
			Name = "MainFrame",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(0.078431, 0.078431, 0.078431),
			[Fusion.Children] = Fusion.New("Frame")({
				Name = "StatusBar",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(0, 0),
				Position = UDim2.fromScale(0.5, 0.8),
				BackgroundColor3 = Color3.new(0.133333, 0.133333, 0.133333),
				[Fusion.Children] = {
					Fusion.New("UICorner")({
						Name = "Corner",
						CornerRadius = UDim.new(0.1, 0),
					}),
					Fusion.New("UIStroke")({
						Name = "Stroke",
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.new(1, 0, 0),
						Thickness = 1.5,
					}),
				},
			}),
		}),
		Parent = PlayerGUI,
	})
	print("Created Instance")
	local function Close()
		local Tweens = {
			TweenService:Create(Loading.MainFrame, TweenInformation, { BackgroundTransparency = 1 }),
			TweenService:Create(Loading.MainFrame.StatusBar, TweenInformation, { BackgroundTransparency = 1 }),
			TweenService:Create(Loading.MainFrame.StatusBar.Stroke, TweenInformation, { Transparency = 1 }),
		}

		ForPairs(Tweens, function(_, tween)
			tween:Play()
		end)
		Tweens[1].Completed:Wait()
		ForPairs(Tweens, function(_, tween)
			tween:Destroy()
		end)
	end
	local Connection
	print("Established")
	Connection = Loaded:Connect(function()
		local CurrentLoaded = Parent:GetAttribute("Loaded")
		local Alpha = (CurrentLoaded / Expected) / Scale
		local Tween =
			TweenService:Create(Loading.MainFrame.StatusBar, TweenInformation, { Size = UDim2.new(Alpha, 0, 0.01, 0) })
		Tween:Play()
		Tween.Completed:Once(function()
			Tween:Destroy()
		end)

		if CurrentLoaded == Expected then
			task.delay(3, Close)
			Connection:Disconnect()
		end
	end)
end

return {
	Init = function() end,
}
