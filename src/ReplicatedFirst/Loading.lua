local ReplicatedFirst = script.Parent
local Player = game.Players.LocalPlayer
local PlayerGUI = Player:WaitForChild("PlayerGui")
local Expected = ReplicatedFirst:GetAttribute("Expected")
local Loaded = ReplicatedFirst:GetAttributeChangedSignal("Loaded")

local function New(name)
	local OK, Response = pcall(Instance.new, name)
	if OK then
		return function(properties)
			for index, value in pairs(properties) do
				if index == "Child" then
					value.Parent = Response
				else
					Response[index] = value
				end
			end
			return Response
		end
	end
end

local Loading = New("ScreenGui")({
	Name = "LoadingUI",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	["Child"] = New("Frame")({
		Name = "MainFrame",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0.180392, 0.176470, 0.176470),
		["Child"] = New("Frame")({
			Name = "StatusBar",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(0, 0),
			Position = UDim2.fromScale(0.5, 0.8),
			BackgroundTransparency = 0,
			["Child"] = New("UICorner")({
				Name = "Corner",
				CornerRadius = UDim.new(0.01, 0),
			}),
			["Child"] = New("UIStroke")({}),
		}),
	}),
	Parent = PlayerGUI,
})
