local me = game.Players.LocalPlayer
local initCameraType = workspace.CurrentCamera.CameraType
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
game:GetService("UserInputService").MouseIconEnabled = false

	game.Players.LocalPlayer.PlayerScripts:WaitForChild("ControlScript").Disabled = true

local timeOfSpawn = math.floor(tick())

while script.Parent.Humanoid:GetState() ~= Enum.HumanoidStateType.Landed 
or script.Parent.Humanoid:GetState() == Enum.HumanoidStateType.Freefall do
	if math.floor(tick()) - timeOfSpawn == 4 then
		break
	end
	wait()
end

local pfService = game:GetService("PathfindingService")

local path = pfService:FindPathAsync(workspace.CurrentCamera.CFrame.p, game.Players.LocalPlayer.Character.Head.Position)
local pathwp = path:GetWaypoints()

for i = 2, #pathwp, 10 do --pathwp[i + 1].Position game.Players.LocalPlayer.Character.Head.Position CFrame.new(pathwp[i + 2].Position + Vector3.new(0,5,0)
	workspace.CurrentCamera:Interpolate(CFrame.new(pathwp[i].Position + Vector3.new(0,5,0)), CFrame.new(game.Players.LocalPlayer.Character.Head.Position), 0.5)
	wait(.5)
end

	workspace.CurrentCamera.CameraType = initCameraType
	game:GetService("ReplicatedStorage").SharedDatabase.PlayerData:WaitForChild(("%s_%d"):format(me.Name, me.UserId)).LocalData.Loaded.Value = true
	--game.Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	game.Players.LocalPlayer.PlayerScripts:WaitForChild("ControlScript").Disabled = false
	game:GetService("UserInputService").MouseIconEnabled = true
	script.Parent:WaitForChild("PlayerManipulation").Disabled = false
	--script.Parent.FirstPerson.Disabled = false
	