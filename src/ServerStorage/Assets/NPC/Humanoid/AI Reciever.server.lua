-- The AI Reciever should be universal. As long as it has the right humanoid name, then it should be fine.

local AiModule = require(game:GetService("ReplicatedStorage").Modules.AI:WaitForChild("AI_Module"))
local self = script:FindFirstAncestorOfClass("Model")
local success = AiModule:getAI(self, self:FindFirstChildOfClass("Humanoid").Name)

--[[
if success then
	print("local > Successfully granted AI to " .. self.name)
else
	print("local > Erorr, AI does not exist")
end]]