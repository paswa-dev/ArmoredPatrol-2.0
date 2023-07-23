local RP = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Master = RP.Master
local Viewmodel = Master.Viewmodel
_G.Viewmodel = Viewmodel

local Class = { Started = false }

function Class.new(name)
	local Module = script:FindFirstChild(name)
	if Module then
		return require(Module)
	end
end

return Class
