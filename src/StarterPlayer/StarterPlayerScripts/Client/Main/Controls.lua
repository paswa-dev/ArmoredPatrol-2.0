local UIS = game:GetService("UserInputService")

type Input = Enum.KeyCode | Enum.UserInputType
type InputCallback = (state: Enum.UserInputState) -> ()

type MapData = {
	[string]: InputCallback,
}

type InputMapData = {
	[Input]: string,
}

local function ForPairs(t, callback)
	for index, value in pairs(t) do
		callback(index, value)
	end
end

local Class = {}
Class._inputMap = {}
Class._map = {}

local function OnInput(input, gpe)
	if not gpe then
		local CaughtInput = input.KeyCode == Enum.KeyCode.Unknown and input.UserInputType or input.KeyCode
		local Entry = Class._inputMap[CaughtInput]

		if Entry then
			ForPairs(Entry, function(_, value)
				Class._map[value](input.UserInputState)
			end)
		end
	end
end

--// Map connects string to function/callback

function Class.BulkMap(Map: MapData)
	ForPairs(Map, function(index, value)
		Class.Map(index, value)
	end)
end

function Class.Map(map_index: string, callback: InputCallback)
	Class._map[map_index] = callback
end

--// InputMap connects Input to String

function Class.BulkInputMap(InputMap: InputMapData)
	ForPairs(InputMap, function(index, value)
		Class.InputMap(index, value)
	end)
end

function Class.R_InputMap(input: Input, map_index: string)
	local InputMap = Class._inputMap[input]
	if InputMap then
		local Index = table.find(InputMap, map_index)
		if Index then
			table.remove(Class._inputMap[input], Index)
		end
	end
end

function Class.InputMap(input: Input, map_index: string)
	local InputMap = Class._inputMap[input]
	if not InputMap then
		Class._inputMap[input] = {}
	end
	table.insert(Class._inputMap[input], map_index)
end

UIS.InputBegan:Connect(OnInput)
UIS.InputEnded:Connect(OnInput)
UIS.InputChanged:Connect(OnInput)

return Class
