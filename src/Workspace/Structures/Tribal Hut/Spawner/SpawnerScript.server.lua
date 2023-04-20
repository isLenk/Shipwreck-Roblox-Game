local remotesFolder = game:GetService("ReplicatedStorage").SharedDatabase.Remotes
local rSpawnNPC = remotesFolder.FromServer:WaitForChild("SpawnNPC")

local spawnerModule = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("SpawnerModule"))

local structure = script:FindFirstAncestorOfClass("Model")
local kin = script.Parent:WaitForChild("Kin")
local spawner = script.Parent

local spawnData = spawnerModule:getSpawner(structure)

wait()

function addNPC()
	if #kin:GetChildren() < spawnData.Capacity then
		--print("Creating NPC")
		rSpawnNPC:Fire(spawner)
	end
end

for i = 1,spawnData.Capacity do
	addNPC()
	wait()
end

kin.ChildRemoved:Connect(function()
	if #kin:GetChildren() < spawnData.Capacity then
		addNPC()
	end
end)