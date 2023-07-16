local Players = game:GetService("Players")

local function Object()
	local Data = {
		name = "No Name",
		players = {},
	}

	function Data.AddPlayer(player)
		table.insert(Data.players, player)
	end

	function Data.RemovePlayer(player)
		table.remove(Data.players, table.find(Data.players, player))
	end

	return Data
end

local function ForPairs(t, callback)
	for i, v in pairs(t) do
		callback(i, v)
	end
end

local Team = {}
Team.Teams = { Object(), Object() }

function Team.Get(name)
	local Found = nil
	ForPairs(Team.Teams, function(_, Team)
		if Team.name == name then
			Found = Team
		end
	end)
	return Found
end

function Team.Rename(One, Two)
	Team.Teams[1].name = One
	Team.Teams[2].name = Two
end

function Team.AddPlayer(Indice, player: Player)
	local Team = Team.Teams[Indice]
	if Team then
		Team.AddPlayer(player)
		player:SetAttribute("Team", Team.name)
	end
end

function Team.RemovePlayer(Indice, player: Player)
	local Team = Team.Teams[Indice]
	if Team then
		Team.RemovePlayer(player)
		player:SetAttribute("Team", "None")
	end
end

return Team
