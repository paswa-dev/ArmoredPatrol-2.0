local Viewmodel = nil

local Class = { Started = false }

local function __init__()
	if not Class.Started then
		_G.Viewmodel = Viewmodel
		Class.Started = true
	end
end

function Class.createItem(name, ...)
	local Script = script:FindFirstChild(name)
	return Script and require(Script).new(...) or nil
end

__init__()
return Class
