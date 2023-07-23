local UserInputService = game:GetService("UserInputService")
local Framework = _G.get("Viewmodel")
local Viewmodel = _G.Viewmodel

local cos, sin = math.cos, math.sin

local function BobbingCurve(t, frequency, amplitude)
	return Vector2.new(cos((frequency * 0.5) * t), sin(frequency * t)) * amplitude
end

--[[

Properties of Weapon Class
--]]
local Weapon = Framework.new(Viewmodel)

Weapon.Spring("Vector", Vector3.zero, 10, 1)
Weapon.Spring("AimVector", Vector3.zero, 10, 1)
Weapon.Spring("Rotation", Vector3.zero, 10, 1)
Weapon.Spring("Recoil", Vector3.zero, 15, 0.5)
Weapon.Spring("RecoilAngle", Vector3.zero, 4, 0.5)
Weapon.Spring("Sway", Vector2.zero, 15, 2)
Weapon.Spring("Bobbing", Vector3.zero, 15, 1)

function Weapon:Mounted(properties)
	local Springs = self.Springs
	local Settings = properties.Settings
	self:Set("Aiming", false)
	self:Set("AimAttachment", properties.AimAttachment)
	self:Set("Settings", Settings)
	Springs.Rotation.Target = Vector3.new(math.pi / 2, 0, 0) --// Aim it down
	Springs.Vector.Target = Settings.offset
	print(Settings.offset)
	--// Initiate keybinds and other singals/functions in :Set/:Get
end

function Weapon:Updated(dt)
	--// Variables
	local isAiming = self:Get("Aiming")
	local AimLocation = self:Get("AimAttachment")
	--// Cached
	local Center = self.Viewmodel.PrimaryPart
	local Springs = self.Springs
	local AimVector = Vector3.zero
	--// Calculations
	local RCFrame: CFrame = self.CFrame
	--// Check
	if isAiming then
		local A = RCFrame:ToObjectSpace(Center.CFrame)
		local B = A:PointToObjectSpace(AimLocation.WorldPosition)
		AimVector = A.Position - B
	end

	Springs.AimVector.Target = AimVector
	print(Springs.Vector.Position)
	RCFrame = RCFrame * CFrame.new(Springs.Vector.Position + Springs.AimVector.Position)
	RCFrame = RCFrame * CFrame.Angles(self:Unpack(Springs.Rotation.Position))
	RCFrame = RCFrame * CFrame.Angles(self:Unpack(Springs.RecoilAngle.Position))
	RCFrame = RCFrame * CFrame.new(Springs.Recoil.Position)
	RCFrame = RCFrame * CFrame.new(Springs.Bobbing.Position)
	RCFrame = RCFrame * CFrame.Angles(self:Unpack(Springs.Sway.Position, "YXX", "__-"))
	self.CFrame = RCFrame
end

function Weapon:Unmounted() end

function Weapon:Rendered()
	local Springs = self.Springs
	Springs.Rotation.Target = Vector3.zero --// Its now in the FORWARD POSITION
end

function Weapon:Unrendered()
	local Springs = self.Springs
	Springs.Rotation.Target = Vector3.new(math.pi / 2, 0, 0)
	task.wait(2) --// This does yield the unrendering portion.
end

function Weapon:Animated() end

function Weapon:SoundPlayed() end

return Weapon
