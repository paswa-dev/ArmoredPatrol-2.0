local ContentProvider = game:GetService("ContentProvider")
local communication = { Started = false }
communication.channels = {}

local function __init__() --// Yes this is from python. :(
	if not communication.Started then
		communication.route = Instance.new("BindableEvent")
		communication.route_event = communication.route.Event

		communication._route_connection = communication.route_event:Connect(function(channel_name, ...)
			local FunctionBin = communication.channels[channel_name]
			if FunctionBin then
				for _, func in pairs(FunctionBin) do
					func(...)
				end
			end
		end)

		communication.Started = true
	end
end

function communication.channel(channel_name)
	local Reference = communication.Channels
	Reference[channel_name] = Reference[channel_name] or {}
	return {
		Push = function(...)
			communication.route:Fire(channel_name, ...)
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

return communication
