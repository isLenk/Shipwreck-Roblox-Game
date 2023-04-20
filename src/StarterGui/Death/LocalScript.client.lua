
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid").Died:Connect(function()
		script.Parent.Enabled = true
		script.DeathColor:Clone().Parent = workspace.CurrentCamera
		
		script.Parent.RespawnButton.MouseButton1Click:Connect(function()
			workspace.CurrentCamera.DeathColor:Destroy()
			game.ReplicatedStorage.SharedDatabase.Remotes.FromClient:WaitForChild("SpawnCharacter"):FireServer()
		end)
		
		script.Parent.KillCount.Text = "Killed " .. game.Players.LocalPlayer.PlayerData.Value.Memory.Stats.MobsKilled.Value
		script.Parent.SurvivalTime.Text = "But hey, you survived for " .. game.Players.LocalPlayer.PlayerData.Value.Memory.Stats.TimeAlive.Value .. " seconds"
		
		script.Parent.RespawnButton.Position = UDim2.new(0.5,0, 1, 100)
		
		script.Parent.RespawnButton:TweenPosition(UDim2.new(0.5,0,0.5, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1)
		for _,v in pairs(script.Parent:GetChildren()) do
			if v:isA("TextLabel") then
				spawn(function()
					v.TextTransparency = 1
					for i = 1,0 , -0.1 do
						v.TextTransparency = i
						wait()
					end
				end)
				
			end
		end
		
		
	end)
end)