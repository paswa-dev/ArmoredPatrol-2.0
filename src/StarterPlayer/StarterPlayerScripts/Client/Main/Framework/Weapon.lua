local VIEWMODEL = _G.Viewmodel
local Controls = _G.get("Controls")
local Spring = require(script.Parent.Spring)

local Class = {}

local function MotorWeapon(main, other)
	local Motor = Instance.new("Motor6D")
	Motor.Part0 = main
	Motor.Part1 = other
	Motor.Parent = main
	return Motor
end

function Class.new(model: PVInstance)
	local Settings = model:FindFirstChild("settings")
	assert(Settings ~= nil, string.format("%s does not have settings", model.Name))

	local self = {}
	self.Settings = require(Settings)
	self.Viewmodel = VIEWMODEL:Clone()
	self.Weapon = model
	self.Animations = model:FindFirstChild("Anims")
	self.Sounds = model:FindFirstChild("Sounds")

	model:SetAttribute("Enabled", false)

	self.Enabled = false
	self.EnabledChanged = model:GetAttributeChangedSignal("Enabled"):Connect(function()
		self.Enabled = model:GetAttribute("Enabled")
	end)
	self.Springs = {}

	function self.Spring(name, value, speed, damping)
		local Spring = Spring.new(value)
		Spring._damper = damping or 1
		Spring._speed = speed or 1
		self.Springs[name] = Spring
		return Spring
	end

	function self.UpdateSprings(dt)
		for _, _spring in pairs(self.Springs) do
			_spring:TimeSkip(dt)
		end
	end

	self.Spring("Vector", Settings.Offset, 10, 1)
	self.Spring("Rotation", Vector3.new(-90, 0, 0), 10, 1)

	function self:OnMount()
		self.Springs["Rotation"]._target = Vector3.zero
	end

	MotorWeapon(self.Viewmodel.PrimaryPart, self.Weapon.PrimaryPart)
	return setmetatable(self, { __index = Class })
end

function Class:Mount()
	self.Enabled = true
	self.Viewmodel.Parent = workspace.CurrentCamera

	while self.Enabled do
		local DT = task.wait()
		self.UpdateSprings(DT)
	end
end

function Class:Unmount() end

return Class
