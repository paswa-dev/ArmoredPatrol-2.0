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

local controls = {}
controls._inputMap = {}
controls._map = {}

local function OnInput(input, gpe)
	if not gpe then
		local CaughtInput = input.KeyCode == Enum.KeyCode.Unknown and input.UserInputType or input.KeyCode
		local Entry = controls._inputMap[CaughtInput]
		if Entry then
			ForPairs(Entry, function(_, value)
				controls._map[value](input.UserInputState)
			end)
		end
	end
end

--// Map connects string to function/callback

function controls.BulkMap(Map: MapData)
	ForPairs(Map, function(index, value)
		controls.Map(index, value)
	end)
end

function controls.Map(map_index: string, callback: InputCallback)
	controls._map[map_index] = callback
end

--// InputMap connects Input to String

function controls.BulkInputMap(InputMap: InputMapData)
	ForPairs(InputMap, function(index, value)
		controls.InputMap(index, value)
	end)
end

function controls.R_InputMap(input: Input, map_index: string)
	local InputMap = controls._inputMap[input]
	if InputMap then
		local Index = table.find(InputMap, map_index)
		if Index then
			table.remove(controls._inputMap[input], Index)
		end
	end
end

function controls.InputMap(input: Input, map_index: string)
	local InputMap = controls._inputMap[input]
	if InputMap then
		table.insert(controls._inputMap[input], map_index)
	end
end

UIS.InputBegan:Connect(OnInput)
UIS.InputEnded:Connect(OnInput)
UIS.InputChanged:Connect(OnInput)

return controls
