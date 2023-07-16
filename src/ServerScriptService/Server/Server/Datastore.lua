local Datastore = game:GetService("DataStoreService")
local PlayerDS = Datastore:GetDataStore("Data", "Player")

local function PlayerToID(player)
	return "P" .. player.UserId
end

local function IDToPlayer(ID)
	return string.sub(ID, 2, string.len(ID))
end --// Why did I need this?

local DS = {}
DS.__index = DS

function DS.new(player)
	local config = setmetatable({ ID = PlayerToID(player) }, DS)
	config.Data = config:Get() or {}
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

--function DS:RawIncrement(Index, Value) end

function DS:Get()
	return self:RawGet(self.ID)
end

function DS:Set(Value)
	return self:RawSet(self.ID, Value)
end

function DS:Update(Callback)
	return self:RawUpdate(self.ID, Callback)
end

--function DS:Increment(Value) end

return DS
