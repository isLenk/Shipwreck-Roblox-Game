
function makePlayer(plr)
	local player = script:WaitForChild("PlayerContainer"):Clone()
	player.Name = plr.Name .. "_" .. plr.UserId
	player.PlayerName.Text = plr.Name
	player.Parent = script.Parent.Players
end

function takePlayer(plr)
	script.Parent.Players[plr.Name .. "_" .. plr.UserId]:Destroy()
end

for _,v in pairs(game.Players:GetPlayers()) do
	makePlayer(v)
end

game.Players.PlayerAdded:Connect(makePlayer)
game.Players.PlayerRemoving:Connect(takePlayer)