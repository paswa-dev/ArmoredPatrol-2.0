local RFirst = game:GetService("ReplicatedFirst")
local _Spring = require(script.MoreSpring)
local _Run = _G.get("RunService")

local NewID = _Run.NewID
local Remove = _Run.Remove
local Add = _Run.Add

local SWrapper = {}

SWrapper.new = function(value, speed, damping, multi: boolean)
	local CurrentSpring = multi and _Spring:MultiAxisSpring(value, speed, damping)
		or _Spring:Spring(value, speed, damping)
	local SpecialID = NewID()
	local SpringConfig = {
		_spring = CurrentSpring,
	}
	function SpringConfig:Destroy()
		Remove(SpecialID)
		CurrentSpring = nil
		SpecialID = nil
	end
	Add(SpecialID, function(dt)
		CurrentSpring:TimeSkip(dt)
	end)
	return SpringConfig
end

return SWrapper
