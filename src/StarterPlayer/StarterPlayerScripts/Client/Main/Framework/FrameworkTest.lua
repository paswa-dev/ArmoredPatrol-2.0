local VIEWMODEL = _G.Viewmodel
local Controls = _G.get("Controls")
local Spring = require(script.Parent.Spring)

local Camera = workspace.CurrentCamera

local Class = {}

--[[

Lifecycle events
:Updated
:Mounted
:Rendered
:Unrendered
:Unmounted
:Animated(animation_name)

--]]

local function Unpack(v3, order, negate_order)
	order = order or "XYZ"
	negate_order = negate_order or "___"
	local Packed = {}
	for i = 1, 3 do
		local Axis = order:sub(i, i)
		local Negate = negate_order:sub(i, i)
		local Negated = Negate == "-"
		table.insert(Packed, Negated and -v3[Axis] or v3[Axis])
	end
	return table.unpack(Packed)
end

local CF = CFrame.new
local Angle = CFrame.Angles

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
	self.CFrame = CFrame.identity
	self.Settings = require(Settings)
	self.Viewmodel = VIEWMODEL:Clone()
	self.Weapon = model

	self.Viewmodel:SetAttribute("Enabled", false)

	self.Enabled = false
	self.EnabledChanged = self.Viewmodel:GetAttributeChangedSignal("Enabled"):Connect(function()
		self.Enabled = self.Viewmodel:GetAttribute("Enabled")
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

	MotorWeapon(self.Viewmodel.PrimaryPart, self.Weapon.PrimaryPart)
	return setmetatable(self, { __index = Class })
end

function Class:Mount()
	self:Mounted()
	self.Enabled = true
	self.Viewmodel.Parent = Camera
	self:Rendered()
	local Springs = self.Springs
	task.spawn(function()
		while self.Enabled do
			local DT = task.wait()
			self.CFrame = Camera.CFrame
			self.UpdateSprings(DT)
			self.CFrame *= CF(Springs["Vector"].Position)
			self.CFrame *= Angle(Unpack(Springs["Rotation"].Position))
			self:Updated(DT)
			self.Viewmodel:PivotTo(self.CFrame)
		end
	end)
end

function Class:Unmount()
	self:Unmounted()
	self.Viewmodel:SetAttribute("Enabled", false) --// Respect the script
	self.Unrendered()
	self.Viewmodel.Parent = nil
end

return Class
