--[[ Character Change script
	Make character look more unique
--]]

local scales = script:WaitForChild("Scales")
local self = script:FindFirstAncestorOfClass("Model")
local hum = self:FindFirstChildOfClass("Humanoid")

wait()
for i = 1,#scales:GetChildren() do
	local scaleValue = scales:GetChildren()[i]
	if scaleValue then
		scaleValue.Value = math.random(80,120)/100
		scaleValue.Parent = hum
	end
end

for i = 1,#self:GetChildren() do
	local v = self:GetChildren()[i]
	if v:IsA("BasePart") then
		
	end
end