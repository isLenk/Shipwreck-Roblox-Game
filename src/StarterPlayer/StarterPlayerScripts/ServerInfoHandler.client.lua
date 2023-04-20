local BAK_cameraData = workspace.CurrentCamera:Clone()

game.ReplicatedStorage.SharedDatabase.Remotes.FromServer:WaitForChild("SetCameraData").OnClientEvent:connect(function(data)
	warn("UIEOOOOOOOOOOOOOOOOO")
	if data == nil then
		print("Camera Data is Nil")
		workspace.CurrentCamera:Destroy()
		wait()
		BAK_cameraData.Parent = workspace
		wait()
		BAK_cameraData = workspace.CurrentCamera:Clone()
		return
	end
	
	for i,v in pairs(data) do
		workspace.CurrentCamera[i] = v
	end
end)