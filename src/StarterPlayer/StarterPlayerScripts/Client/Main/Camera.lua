local get = _G.get
local Spring = get("Spring")
local RunService = get("RunService")
local Player = get("Local")

local RandomObject = Random.new()
local ShakeSpring = Spring.new(Vector2.zero, 25, 0.1, false)

local function Random2DUnit()
	return Vector2.new(RandomObject:NextNumber(-1, 1), RandomObject:NextNumber(-1, 1))
end

local Class = {}

function Class.Shake(intensity)
	local NewShakeVector = Random2DUnit() * intensity
	ShakeSpring._spring:Impulse(NewShakeVector)
end

RunService.Add(RunService.NewID(), function()
	local SpringVec = ShakeSpring._spring.Position
	Player.Humanoid.CameraOffset = Vector3.new(SpringVec.X, SpringVec.Y, 0)
end)
return Class
