local get = _G.get
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local TAU = math.pi * 2
local HPI = math.pi * 0.5
local CNew = CFrame.new
local Angle = CFrame.Angles

local Spring = get("Spring")
local Signal = get("FastSignal")

local Class = {}
Class.__index = Class

--[[

Gun must contain
1. A folder with the animations
2. A folder with the sounds
3. Aim attachment named "AIM"
4. Barrel attachment named "BARREL"

--]]

local function Map(bin: Folder, callback)
	local Mapping = {}
	for _, File in next, bin:GetChildren() do
		Mapping[File.Name] = callback and callback(File) or File
	end
	return Mapping
end

local function MotorTogether(primary, secondary)
	local Motor = Instance.new("Motor6D")
	Motor.Part0 = primary
	Motor.Part1 = secondary
	Motor.Parent = primary
	return Motor
end

function Class.new(weapons_folder, weapon_viewmodel)
	assert(weapon_viewmodel.PrimaryPart ~= nil, "Must contain a primaryPart")
	local self = {}
	self.Folder = weapons_folder
	self.Viewmodel = weapon_viewmodel:Clone()
	self.PrimaryPart = self.Viewmodel.PrimaryPart
	self.Springs = {}
	self.Equipped = nil
	self.Activated = Signal.new()
	self.Active = false

	self.MappedAnimations = {}
	self.MappedSounds = {}

	self.Spring = function(name, v, s, d)
		local _spring = Spring.new(v)
		self.Springs[name] = _spring
		_spring._speed = s
		_spring._damping = d
		return _spring
	end

	self.Spring("Vector", Vector3.zero, 10, 1)
	self.Spring("AimVector", Vector3.zero, 10, 1)
	self.Spring("Rotation", Vector3.zero, 10, 1)
	self.Spring("RecoilVector", Vector3.zero, 15, 0.5)
	self.Spring("RecoilRotation", Vector3.zero, 4, 0.8)
	self.Spring("Sway", Vector2.zero, 4, 0.9)
	self.Spring("Bobble", Vector2.zero, 6, 0.9)

	local Springs = self.Springs

	self.Update = function(dt)
		local Vector = Springs["Vector"].Position
		local AimVector = Springs["AimVector"].Position
		local Rotation = Springs["Rotation"].Position
		local RecoilVector = Springs["RecoilVector"].Position
		local RecoilRotation = Springs["RecoilRotation"].Position
		local Sway = Springs["Sway"].Position
		local Bobble = Springs["Bobble"].Position
		local RenderedCFrame = self.PrimaryPart.CFrame
		RenderedCFrame *= CNew(Vector + AimVector)
		RenderedCFrame *= Angle(Rotation.X, Rotation.Y, Rotation.Z)
		RenderedCFrame *= CNew(RecoilVector)
		RenderedCFrame *= Angle(RecoilRotation.X, RecoilRotation.Y, RecoilRotation.Z)
		RenderedCFrame *= Angle(Sway.X, Sway.Y, Sway.Y)
		RenderedCFrame *= CNew(Bobble.X, Bobble.Y, 0)
	end

	self.Connection = RS.RenderStepped:Connect(function(dt)
		if self.Equipped then
			if self.Active then
				self.Activated:Fire()
				self.Active = false
			end
			for _, InsertedSpring in next, self.Springs do
				InsertedSpring:TimeSkip(dt)
			end
			self.Update(dt)
		end
	end)

	return setmetatable(self, Class)
end

function Class:Equip(name)
	local WeaponOfChoice = self.Folder:FindFirstChild(name)
	if WeaponOfChoice then
		local Springs = self.Springs
		if self.Equipped == WeaponOfChoice then
			return
		end
		self.Equipped = WeaponOfChoice:Clone()
		MotorTogether(self.PrimaryPart, self.Equipped.PrimaryPart)
		self.Viewmodel.Parent = Camera
		---
		local Equipped = self.Equipped
		local Animations = Equipped:FindFirstChild("Animations")
		local Sounds = Equipped:FindFirstChild("Sounds")
		local Activated = Equipped:FindFirstChild("Activated")
		local Animator = Equipped:FindFirstChild("Animator", true)
		if not Animations or not Sounds or not Activated or not Animator then
			error("Must have Animations, Sounds, Activated")
		end
		self.MappedAnimations = Map(Animations, function(f)
			return Animator:LoadAnimation(f)
		end)
		self.MappedSounds = Map(Sounds)
		local LoadedActivated = require(Activated)

		task.wait(0.5)

		self.Activated:Connect(function()
			LoadedActivated(self)
		end)

		self.MappedAnimations["Idle"]:Play()
		Springs["Rotation"].Target = Vector3.new(0, 0, 0)
	end
end

function Class:Unequip()
	if self.Equipped then
		self.Activated:DisconnectAll()
		self.Springs["Rotation"].Target = Vector3.new(HPI, 0, 0)
		task.wait(1)
		self.Equipped = nil
	end
end

return Class
