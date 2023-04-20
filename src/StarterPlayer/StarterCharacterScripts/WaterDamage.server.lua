local humanoid = script.Parent:WaitForChild("Humanoid")

humanoid.StateChanged:Connect(function(_, newState)
	if newState == Enum.HumanoidStateType.Swimming then
		while humanoid:GetState() == Enum.HumanoidStateType.Swimming do
			game.ReplicatedStorage.SharedDatabase.Remotes.Shared.cDamageEntity.sDamageEntity:Fire(script.Parent, 5)
			wait(1)
		end
	end
end)