local dummy = game.Players.LocalPlayer.Character

local camera = workspace.CurrentCamera
local root = dummy:FindFirstChild("HumanoidRootPart")
local neck = dummy:FindFirstChild("Neck", true)
local neckYOffset = neck.C0.Y
local waist = dummy:FindFirstChild("Waist", true)
local waistYOffset = waist.C0.Y

game:GetService("RunService").RenderStepped:Connect(function()
	local cameraDirection = root.CFrame:toObjectSpace(camera.CFrame).lookVector.unit
	if neck then
		neck.C0 = CFrame.new(0,neckYOffset,0) * CFrame.Angles(math.asin(cameraDirection.y,0,0), -math.asin(cameraDirection.x), 0)
		waist.C0 = CFrame.new(0,waistYOffset,0) * CFrame.Angles(math.asin(cameraDirection.y / 1.8), -math.asin(cameraDirection.x / 2.5),0)
	end
end)