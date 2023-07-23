local Framework = _G.get("Viewmodel")
local Viewmodel = _G.VIEWMODEL

local cos, sin = math.cos, math.sin

local function BobbingCurve(t, frequency, amplitude)
	return Vector2.new(cos((frequency * 0.5) * t), sin(frequency * t)) * amplitude
end

local Weapon = Framework.new(Viewmodel)

Weapon.Spring("Vector", Vector3.zero, 10, 1)
Weapon.Spring("Rotation", Vector3.zero, 10, 1)
Weapon.Spring("Recoil", Vector3.zero, 15, 0.5)
Weapon.Spring("RecoilAngle", Vector3.zero, 4, 0.5)
Weapon.Spring("Sway", Vector2.zero, 15, 2)
Weapon.Spring("Bobbing", Vector3.zero, 15, 1)

function Weapon:Mounted()
	local Viewmodel = self.Viewmodel
	local Model = self.Model
end

function Weapon:Updated(dt)
	local Springs = self.Springs
	local CFrame: CFrame = self.CFrame
	CFrame = CFrame:ToWorldSpace()
end

function Weapon:Unmounted() end

function Weapon:Rendered() end

function Weapon:Unrendered() end

function Weapon:Animated() end

function Weapon:SoundPlayed() end
