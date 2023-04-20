if not script.Parent.Parent:isA("PlayerGui") then return end

script.Parent.MainFrame.Back.MouseButton1Click:Connect(function()
	script.Parent:Destroy()
	game.Players.LocalPlayer.PlayerGui:WaitForChild("StartMenu").Enabled = true
end)