local Client = script.Client
local Main = script.Main

local function Set(name, value)
	script.Parent:SetAttribute(name, value)
end

local function Get(name)
	script.Parent:GetAttribute(name)
end

local Loaded = 1

Set("Expected", #Client:GetChildren())
Set("Loaded", Loaded)

_G.get = function(file_name)
	local FoundModule = Main:FindFirstChild(file_name)
	return FoundModule and require(FoundModule) or nil
end

local function LazyLoad(file)
	local now = os.clock()
	local _module = require(file)
	if os.clock() - now > 0.1 then
		print(`{file.Name} was lazy loaded.`)
	end

	return _module
end

for _, module in next, Client:GetChildren() do
	task.spawn(function()
		local LoadedModule = LazyLoad(module)
		if LoadedModule["Init"] then
			LoadedModule.Init()
		end
		Loaded += 1
		Set("Loaded", Loaded)
	end)
end
