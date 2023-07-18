local Client = script.Client
local Main = script.Main

script:SetAttribute("Finished", false)

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
	end)
end
script:SetAttribute("Finished", true)
