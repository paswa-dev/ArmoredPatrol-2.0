local get = _G.get
local Camera = get("Camera")

local function init()
	task.wait(10)
	print("Shook")
	Camera.Shake(60)
end

return {
	Init = init,
}
