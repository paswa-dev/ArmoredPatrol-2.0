local player = {
	Started = false,
}

local function OnCharacter(character)
	player.Character = character
	player.Humanoid = character:WaitForChild("Humanoid")
	player.Root = character:WaitForChild("HumanoidRootPart")
	player.Animator = player.Humanoid:WaitForChild("Animator")
end

local function init()
	if not player.Started then
		player.Started = true
		player.Camera = workspace.CurrentCamera
		player.Player = game.Players.LocalPlayer
		player.PlayerGUI = player.Player:WaitForChild("PlayerGui")
		player.Character = player.Player.Character or player.Player.CharacterAdded:Wait()
		OnCharacter(player.Character)
		player.Player.CharacterAdded:Connect(OnCharacter)
	end
end

init()
return player
