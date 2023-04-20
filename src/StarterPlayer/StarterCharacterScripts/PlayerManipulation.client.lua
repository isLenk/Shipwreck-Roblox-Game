--[[
 	@purp - Change players properties to games settings
--]]

local player = game.Players.LocalPlayer
local playerKey = ("%s_%d"):format(player.Name, player.userId)
local myData = game:GetService("ReplicatedStorage").SharedDatabase.PlayerData:WaitForChild(playerKey)



myData.LocalData.MouseLocked:GetPropertyChangedSignal("Value"):Connect(function()
	local newValue = myData.LocalData.MouseLocked.Value
	if newValue == true then
		player.CameraMode = Enum.CameraMode.Classic
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		player.Character.Humanoid.WalkSpeed = 14
	else
		player.CameraMode = Enum.CameraMode.Classic
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		player.Character.Humanoid.WalkSpeed = 0
	end
end)
