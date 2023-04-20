local self = script:FindFirstAncestorOfClass("Model")
local wielder = self:FindFirstAncestorOfClass("Model")
if wielder == nil then return end
local hum = wielder:FindFirstChildOfClass("Humanoid")

hum.Died:Connect(function()
	self.PrimaryPart.CanCollide = true
	self.Parent = workspace
end)
