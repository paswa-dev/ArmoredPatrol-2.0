local TEAM_SERVICE = game:GetService("Teams")

local TEAMS = {
	{ "NEUTRAL", BrickColor.new("Medium stone grey"), true },
	{ "US FORCES", BrickColor.new("Pastel Blue"), false },
	{ "RUSSIA FORCES", BrickColor.new("Bright red"), false },
}

local function TeamObject(name, color, auto)
	local Team = Instance.new("Team")
	Team.Name = name
	Team.TeamColor = color
	Team.AutoAssignable = auto
	Team.Parent = TEAM_SERVICE
	return Team
end
--// TODO: Setup remotes and stuff
local function __init__()
	for _, TEAM in next, TEAMS do
		TeamObject(TEAM[1], TEAM[2], TEAM[3])
	end
end

return { Init = __init__ }
