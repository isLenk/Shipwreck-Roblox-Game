local options = script.Parent.Parent:WaitForChild("Options")

script.Parent.Event:Connect(function(option)
	
	if #options:GetChildren() == 0 then return end
	if option == options.Play then
		option:TweenSize(UDim2.new(0,0,0, option.Size.Y.Offset), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 1, false)
		option.BorderSizePixel = 0
		option.TextLabel.Visible = false
		
		wait(2)
		for _, x in pairs(script.Parent.Parent:GetChildren()) do
			if x:isA("GuiObject") then
				spawn(function()
					x:TweenPosition(x.Position + UDim2.new(0,0,1,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 2, false)
				end)
			end
		end
		wait(2)
		workspace.CurrentCamera:ClearAllChildren()
		game.ReplicatedStorage.SharedDatabase.Remotes.FromClient:WaitForChild("SpawnCharacter"):FireServer()
		script.Parent.Parent:Destroy()
		return 
	end
	
	if option == options.Character then
		script:FindFirstAncestorOfClass("ScreenGui").Enabled = false
		local charCustomizer = script:FindFirstAncestorOfClass("ScreenGui").ButtonTabs.CharacterCustomization:Clone()
		charCustomizer.Enabled = true
		charCustomizer.Parent = game.Players.LocalPlayer.PlayerGui
	end
	
	if option == options.Credits then
		script.Parent.Parent.Credits.Visible = true
	end
	
	if option == options.Changelog then
		script.Parent.Parent.Changelog.Visible = not script.Parent.Parent.Changelog.Visible 
	end
	print("Ended")
end)