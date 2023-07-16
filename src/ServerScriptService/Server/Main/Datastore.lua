local HTTP = game:GetService("HttpService")
local Datastore = game:GetService("DataStoreService")
local PlayerDS = Datastore:GetDataStore("Data", "Player")

local function PlayerToID(player)
	return "P" .. player.UserId
end

local DS = {}
DS.__index = DS

function DS.new(player)
	local config = setmetatable({ ID = PlayerToID(player) }, DS)
	config.Data = HTTP:JSONDecode(config:RawGet(config.ID) or "{}")
	return config
end

function DS:RawGet(Index)
	local Success, Response = pcall(function()
		return PlayerDS:GetAsync(Index)
	end)
	return Success and Response or nil
end

function DS:RawSet(Index, Value)
	local Success, Response = pcall(function()
		return PlayerDS:SetAsync(Index, Value)
	end)
	return Success
end

function DS:RawUpdate(Index, Callback)
	local Succes, Response = pcall(function()
		local NewData = Callback(self:RawGet(Index))
		if NewData == nil then
			error("Nil was attempted")
		end
		self:RawSet(Index, NewData)
	end)
	return Succes
end

function DS:Get(Index)
	return Index and self.Data[Index] or self.Data
end

function DS:Set(Index, Value)
	if Index then
		local Reference = self.Data
		Reference[Index] = Value
	else
		self.Data = Value
	end
end

function DS:Update(Callback)
	local New = Callback(self.Data)
	DS:Set(New)
end

function DS:Save()
	local Encoded = HTTP:JSONEncode(self.Data)
	if DS:RawSet(Encoded) then
		print("Set yay!")
	else
		print("bro didn't work")
	end
end

return DS
