local get = _G.get

local Framework = get("Framework")

local function __init__()
	local Weapon = Framework.new("Weapon")
	local Model = game:GetService("ReplicatedStorage").Master.Weapons.MOSSBERG:Clone()
	Weapon:Mount(Model, {
		AimAttachment = Model:FindFirstChildWhichIsA("Attachment", true),
		Settings = require(Model.settings),
	})
end

return {
	Init = __init__,
}
