local RP = game:GetService("ReplicatedStorage")
local Master = RP.Master
local Viewmodel = Master.Viewmodel

local Class = { Started = false }

local function __init__()
	if not Class.Started then
		_G.Viewmodel = Viewmodel
		Class.Started = true
		Class.Items = {
			Gernade = require(Class.Items),
		}
	end
end

__init__()
return Class
