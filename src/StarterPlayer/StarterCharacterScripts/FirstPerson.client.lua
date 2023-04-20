--[[
	@purp - Set camera properties to FP
--]]
wait()
local camera = workspace.CurrentCamera
camera.CameraSubject = game.Players.LocalPlayer.Character.Head

local player = game.Players.LocalPlayer
local char = player.Character
if not char then
	char = player.CharacterAdded:wait()
end

function removeAppearance()
	game.Players.LocalPlayer.Character.Humanoid:RemoveAccessories()
	for _,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:isA("BasePart") then
			v.Transparency = 1
			if v.Parent:isA("Accessory") then
				v.Parent:Destroy()
			end
		end
	end
	
	if char:FindFirstChildOfClass("Accessory") then
		removeAppearance()
	end
end


function pointToCamera()
	if not char or not char.HumanoidRootPart then return end
	char.HumanoidRootPart.CFrame = 
		CFrame.new(char.HumanoidRootPart.Position,Vector3.new(camera.CFrame.lookVector.X, 0, camera.CFrame.lookVector.Z)+char.HumanoidRootPart.Position)
end

removeAppearance()
game.ReplicatedStorage.SharedDatabase.PlayerData:WaitForChild(("%s_%d"):format(player.Name, player.UserId)).LocalData.MouseLocked.Value = true
game:GetService("RunService"):BindToRenderStep("playerCameraUpdater", Enum.RenderPriority.Camera.Value - 1, pointToCamera)

