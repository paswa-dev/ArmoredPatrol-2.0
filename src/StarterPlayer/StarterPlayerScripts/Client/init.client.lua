function _G.get(file_name)
	local FoundModule = script.Main:FindFirstChild(file_name)
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

for _, module in next, script.Client:GetChildren() do
	local LoadedModule = LazyLoad(module)
	if LoadedModule["Init"] then
		LoadedModule.Init()
	end
end

script.Main:Destroy()
script.Client:Destroy()
