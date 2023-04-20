local remotesFolder = game:GetService("ReplicatedStorage").SharedDatabase.Remotes
local sharedDatabase = game:GetService("ReplicatedStorage").SharedDatabase

local serverAssets = game:GetService("ServerStorage").Assets
local npcModels = serverAssets.NPC

local rSpawnNPC = remotesFolder.FromServer:WaitForChild("SpawnNPC")

local spawnerModule = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("SpawnerModule"))

--[[
	Spawn an NPC in specific location, and specify kin type.
--]]

local function spawnNPC(spawner)
	local spawnerData = spawnerModule:getSpawner(spawner:FindFirstAncestorOfClass("Model"))
	
	local npc = npcModels:FindFirstChild(spawnerData.Class)
	if npc then	
		local npc = npc:Clone()
		local hum = npc:FindFirstChildOfClass("Humanoid")
		if spawner:isA("BasePart") then
			npc:SetPrimaryPartCFrame(CFrame.new(spawner.Position))
			hum.Home.Value = spawner
			
			hum.Kin.Value = spawner.Kin.Value
			
			local npcHolder = Instance.new("ObjectValue")
			npcHolder.Name = "NPCHolder"
			npcHolder.Value = npc			
			npcHolder.Parent = spawner.Kin
			
			npc.Humanoid.Died:Connect(function()
				npcHolder:Destroy()
			end)
			
		end

		npc.Parent = workspace
	end
end

rSpawnNPC.Event:Connect(spawnNPC)