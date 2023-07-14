local RS = game:GetService("RunService")

local clock = os.clock
local insert = table.insert
local remove = table.remove

local RSWrapper = {}
RSWrapper.Functions = {}

RSWrapper.NewID = function()
	return clock()
end

RSWrapper.Add = function(special_id: number | string, func: (dt: number) -> ())
	insert(RSWrapper.Functions, { Function = func, id = special_id })
end

RSWrapper.Remove = function(special_id: number | string)
	for index, entry in next, RSWrapper.Functions do
		if entry.id == special_id then
			remove(RSWrapper.Functions, index)
		end
	end
end

RSWrapper.Connection = RS.RenderStepped:Connect(function(dt)
	for _, v in RSWrapper.Functions do
		v.Function(dt)
	end
end)

return RSWrapper
