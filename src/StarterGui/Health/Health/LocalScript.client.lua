local playerData = game.ReplicatedStorage.SharedDatabase.PlayerData:WaitForChild(("%s_%s"):format(game.Players.LocalPlayer.Name, game.Players.LocalPlayer.UserId))

playerData.MyHealth.Health.Changed:Connect(function()
	script.Parent.Bar:TweenSize(UDim2.new(playerData.MyHealth.Health.Value / 100, 0, 1, 0), "InOut", "Quad", 0.35, true)
	script.Parent.TextLabel.Text = "HP: " .. playerData.MyHealth.Health.Value .. " / 100"

end)

-- game.ReplicatedStorage.SharedDatabase.Remotes.FromClient.DamagePlayer:FireServer(5)