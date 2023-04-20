print("Running > Module Preperation Script")

local AIModulesFolder = game:GetService("ReplicatedStorage").Modules.AI
local aiModule = require(AIModulesFolder:WaitForChild("AI_Module"))

aiModule:PrepareModule()