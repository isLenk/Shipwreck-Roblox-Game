wait()
local cameraModule = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("CameraData"))
local angles = cameraModule:returnMenuAngles()


local blur = Instance.new("BlurEffect")
blur.Size = 10

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Saturation = -0.2
colorCorrection.TintColor = Color3.fromRGB(166, 166, 166)

repeat wait() until game.Players.LocalPlayer ~= nil

local selectedAngle = angles[math.random(#angles)] 

repeat wait()
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable		
		workspace.CurrentCamera.CFrame = selectedAngle
until workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable		
		blur.Parent = workspace.CurrentCamera
		colorCorrection.Parent = workspace.CurrentCamera

