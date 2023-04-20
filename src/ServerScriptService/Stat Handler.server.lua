game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		spawn(function()		
			while character.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead do
				wait(1)
				player.PlayerData.Value.Memory.Stats.TimeAlive.Value = player.PlayerData.Value.Memory.Stats.TimeAlive.Value + 1
			end
		end)
	end)
end)