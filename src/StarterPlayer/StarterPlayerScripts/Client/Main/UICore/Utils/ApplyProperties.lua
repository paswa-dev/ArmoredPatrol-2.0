return function(object, properties)
	for index, value in pairs(properties) do
		object[index] = value
	end
end
