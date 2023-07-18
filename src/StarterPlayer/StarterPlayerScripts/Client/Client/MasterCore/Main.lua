local TWEEN_SERVICE = game:GetService("TweenService")

local TWEENINFO = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local InformationLogRemote = nil --// Link tihs to a remote to update Information tab
local CurrentGarbage = nil
local PastColor = nil

local function Enter(object)
	TWEEN_SERVICE:Create(object.Gradient, TWEENINFO, { BackgroundColor3 = Color3.new(0, 0, 0) }):Play()
end

local function Leave(object)
	TWEEN_SERVICE:Create(object.Gradient, TWEENINFO, { BackgroundColor3 = PastColor }):Play()
end

local function Click(object)
	if object:FindFirstChild("Action") then
		local GlobalAction = _G.CoreActions[object.Action.Value]()
	end
end

return function(Frame, Garbage)
	local Options, Information = Frame.Options, Frame.Information
	PastColor, CurrentGarbage = Options:FindFirstChildWhichIsA("ImageButton").Gradient.BackgroundColor3, Garbage

	for _, Object: ImageButton in next, Options:GetChildren() do
		if Object:IsA("ImageButton") then
			Garbage.Add(
				Object.MouseEnter:Connect(function()
					Enter(Object)
				end),
				Object.MouseLeave:Connect(function()
					Leave(Object)
				end),
				Object.MouseButton1Click:Connect(function()
					Click(Object)
				end)
			)
		end
	end
end
