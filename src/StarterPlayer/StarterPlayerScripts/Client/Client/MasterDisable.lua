local StarterGui = game:GetService("StarterGui")

local TO_DISABLE = {
	Enum.CoreGuiType.PlayerList,
	Enum.CoreGuiType.Backpack,
	Enum.CoreGuiType.Health,
	Enum.CoreGuiType.EmotesMenu,
}

local function __init__()
	for _, ENUM in next, TO_DISABLE do
		StarterGui:SetCoreGuiEnabled(ENUM, false)
	end
end

return {
	Init = __init__,
}
