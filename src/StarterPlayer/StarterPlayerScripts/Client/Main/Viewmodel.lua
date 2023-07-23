local SoundBin = game.SoundService --// Where the sounds should be dumped
local Debris = game:GetService("Debris")
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
:Animated(animation_name, anim_instance)
:SoundPlayed(sound_name, sound_instance)

--]]

local function MotorModel(main, other)
	if main:FindFirstChild("MotorFramework") then
		main.MotorFramework:Destroy()
	end
	local Motor = Instance.new("Motor6D")
	Motor.Name = "MotorFramework"
	Motor.Part0 = main
	Motor.Part1 = other
	Motor.Parent = main
	return Motor
end

local CF = CFrame.new
local Angle = CFrame.Angles

function Class.new(viewmodel)
	local self = {}

	--// Public Variables

	self.CFrame = CFrame.identity
	self.Settings, self.Model = nil, nil
	self.Viewmodel = viewmodel:Clone()
	self.Animator = self.Viewmodel:FindFirstChildWhichIsA("Animator", true)

	self.Viewmodel:SetAttribute("Enabled", false)

	self.Animations = {}
	self.Sounds = {}
	self.Springs = {}
	self.Values = {}

	self.Enabled = false
	--// Internals

	function self.LoadModel(model)
		self.Model = model
	end

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

	--// Connections

	self.EnabledChanged = self.Viewmodel:GetAttributeChangedSignal("Enabled"):Connect(function()
		self.Enabled = self.Viewmodel:GetAttribute("Enabled")
	end)

	return setmetatable(self, { __index = Class })
end

--// Lifecycle events
function Class:Mounted() end
function Class:Unmounted() end
function Class:Rendered() end
function Class:Unrendered() end
function Class:Updated() end
function Class:Animated() end
function Class:SoundPlayed() end

--// Utility

function Class:Set(index, value)
	self.Values[index] = value
end

function Class:Get(index)
	return self.Values[index]
end

function Class:Unpack(Vector: Vector3 | Vector2, Order: string, NegateOrder: string)
	Order = Order or "XYZ"
	NegateOrder = NegateOrder or "___"
	local Packed = {}
	for i = 1, 3 do
		local Axis = Order:sub(i, i)
		local Negate = NegateOrder:sub(i, i)
		local Negated = Negate == "-"
		table.insert(Packed, Negated and -Vector[Axis] or Vector[Axis])
	end
	return table.unpack(Packed)
end

function Class:LoadAnimation(name: string, animation: Animation)
	assert(self.Animator, "No animator has been provided, stopping...")
	local Loaded = self.Animator:LoadAnimation(animation)
	self.Animations[name] = Loaded
end

function Class:PlayAnimation(name: string)
	local Anim = self.Animations[name]
	if not Anim then
		error("Does not exist")
	end
	Anim:Play()
	self:Animated(name, Anim)
end

function Class:LoadSound(name: string, sound: Sound)
	self.Sounds[name] = sound
end

function Class:PlaySound(name: string)
	local New = self.Sounds[name] and self.Sounds[name]:Clone() or nil
	assert(New ~= nil, "Could not find sound, is it loaded?")
	New.Parent = SoundBin
	New:Play()
	self:SoundPlayed(name, New)
	Debris:AddItem(New, New.TimeLength)
end

--// Actual stuff

function Class:Mount(model: Model, ...)
	self.LoadModel(model)

	MotorModel(self.Viewmodel.PrimaryPart, self.Model:IsA("BasePart") and self.Model or self.Model.PrimaryPart)

	self:Mounted(...)
	self.Enabled = true
	self.Viewmodel.Parent = Camera
	self:Rendered(...)
	task.spawn(function()
		while self.Enabled do
			local DT = task.wait()
			self.CFrame = Camera.CFrame
			self.UpdateSprings(DT)
			self:Updated(DT)
			self.Viewmodel:PivotTo(self.CFrame)
		end
	end)
end

function Class:Unmount(...)
	self.Unrendered(...)
	self.Viewmodel.Parent = nil
	self:Unmounted(...)
	self.Viewmodel:SetAttribute("Enabled", false) --// Respect the script
end

function Class:Destroy()
	if self.Enabled then
		self:Unmount()
	end
	self.Viewmodel:Destroy()
	self.EnabledChanged:Disconnect()
	self = nil
	return nil
end

return Class
