local ReplicatedFirst = script.Parent
local TweenService = game:GetService("TweenService")

local TweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

local Player = game.Players.LocalPlayer
local Expected = ReplicatedFirst:GetAttribute("Expected")
local Loaded = ReplicatedFirst:GetAttributeChangedSignal("Loaded")
print(ReplicatedFirst:GetAttribute("Loaded"))
local Scale = 6

local function ForPairs(t, callback)
	for index, value in pairs(t) do
		callback(index, value)
	end
end

local function New(name)
	local OK, Response = pcall(Instance.new, name)
	if OK then
		return function(properties)
			for index, value in pairs(properties) do
				if index == "Child" then
					if typeof(value) == "table" then
						ForPairs(value, function(_, object)
							object.Parent = Response
						end)
					else
						value.Parent = Response
					end
				else
					Response[index] = value
				end
			end
			return Response
		end
	end
end

local PlayerGUI = Player:WaitForChild("PlayerGui")

local Loading = New("ScreenGui")({
	Name = "LoadingUI",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	["Child"] = New("Frame")({
		Name = "MainFrame",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0.078431, 0.078431, 0.078431),
		["Child"] = New("Frame")({
			Name = "StatusBar",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(0, 0),
			Position = UDim2.fromScale(0.5, 0.8),
			BackgroundColor3 = Color3.new(0.133333, 0.133333, 0.133333),
			["Child"] = {
				New("UICorner")({
					Name = "Corner",
					CornerRadius = UDim.new(0.01, 0),
				}),
				New("UIStroke")({
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

local function Close()
	print("Requested Closing")
	local Background = TweenService:Create(Loading.MainFrame, TweenInformation, { BackgroundTransparency = 1 })
	local Bar = TweenService:Create(Loading.MainFrame.StatusBar, TweenInformation, { BackgroundTransparency = 1 })
	Background:Play()
	Bar:Play()
	Bar.Completed:Wait()
	Background:Destroy()
	Bar:Destroy()
end

ReplicatedFirst:RemoveDefaultLoadingScreen()

local Connection
Connection = Loaded:Connect(function()
	local CurrentLoaded = ReplicatedFirst:GetAttribute("Loaded")
	print(CurrentLoaded)
	local Alpha = (CurrentLoaded / Expected) / Scale
	Loading.MainFrame.StatusBar:TweenSize(
		UDim2.new(Alpha, 0, 0.05, 0),
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Cubic,
		0.7,
		true
	)
	if CurrentLoaded == Expected then
		task.spawn(Close)
		Connection:Disconnect()
	end
end)
