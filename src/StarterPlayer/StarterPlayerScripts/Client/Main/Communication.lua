local Class = { Started = false }
Class.channels = {}

local function __init__() --// Yes this is from python. :(
	if not Class.Started then
		Class.route = Instance.new("BindableEvent")
		Class.route_event = Class.route.Event

		Class._route_connection = Class.route_event:Connect(function(channel_name, ...)
			local FunctionBin = Class.channels[channel_name]
			if FunctionBin then
				for _, func in pairs(FunctionBin) do
					func(...)
				end
			end
		end)

		Class.Started = true
	end
end

function Class.channel(channel_name)
	local Reference = Class.channels
	Reference[channel_name] = Reference[channel_name] or {}
	return {
		Push = function(...)
			Class.route:Fire(channel_name, ...)
		end,
		Recieve = function(callback)
			table.insert(Reference[channel_name], callback)
			return function()
				table.remove(Reference[channel_name], table.find(Reference[channel_name], callback))
			end
		end,
	}
end

__init__()

return Class
