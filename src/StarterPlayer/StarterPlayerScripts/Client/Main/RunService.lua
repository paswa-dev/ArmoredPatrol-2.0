local RS = game:GetService("RunService")

local clock = os.clock
local insert = table.insert
local remove = table.remove

local Class = {}
Class.Functions = {}

Class.NewID = function()
	return clock()
end

Class.Add = function(special_id: number | string, func: (dt: number) -> ())
	insert(Class.Functions, { Function = func, id = special_id })
end

Class.Remove = function(special_id: number | string)
	for index, entry in next, Class.Functions do
		if entry.id == special_id then
			remove(Class.Functions, index)
		end
	end
end

Class.Connection = RS.RenderStepped:Connect(function(dt)
	for _, v in Class.Functions do
		v.Function(dt)
	end
end)

return Class
