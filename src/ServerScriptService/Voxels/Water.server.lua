

local voxelParent = game.ServerStorage.Voxels:WaitForChild("Water") or workspace.Voxels:WaitForChild("Water")
local origWaterVoxel = voxelParent:WaitForChild("WaterVoxel")
local waterVoxel = origWaterVoxel

waterVoxel.CanCollide = false
waterVoxel.Anchored = true
waterVoxel.Locked = true

local preparedValue = game:GetService("ReplicatedStorage").SharedDatabase.VerifySetup:WaitForChild("1.WaterVoxel")
preparedValue.Value = false
preparedValue.FillRate.Value = "0/0"


--[[if game["Run Service"]:IsStudio() then
	preparedValue.Value = true
	return
end]]

local function writeNewVoxel(lastVoxel, addVector)
	local voxelClone = lastVoxel:Clone()
	voxelClone.Position = voxelClone.Position + addVector
	voxelClone.Parent = voxelParent
	
	local avoxelClone = lastVoxel:Clone()
	avoxelClone.Position = -avoxelClone.Position + Vector3.new(0, avoxelClone.Position.Y * 2,0) - addVector
	avoxelClone.Parent = voxelParent

	return voxelClone
end

local gridMax = 3

local function makeRow()
	for z = 1,gridMax do
		wait(.015)
		writeNewVoxel(waterVoxel, Vector3.new(waterVoxel.Size.X,0,waterVoxel.Size.Z * z))
	end
	
	for z = -gridMax,-1, 1 do
		wait(.015)
		writeNewVoxel(waterVoxel, Vector3.new(waterVoxel.Size.X,0,waterVoxel.Size.Z * z))
	end
end

	
for z = -gridMax,-1, 1 do
	wait(.015)
	writeNewVoxel(waterVoxel, Vector3.new(0,0,waterVoxel.Size.Z * z))
end
	
for x = 1, gridMax do
	-- Write X
	makeRow()
	local newVoxel = writeNewVoxel(waterVoxel, Vector3.new(waterVoxel.Size.X,0,0))
	wait(0)
	
	waterVoxel = newVoxel
end

waterVoxel = origWaterVoxel

for i = 1,#voxelParent:GetChildren() do
	print("Filling Water: " .. i .. "/", #voxelParent:GetChildren())
	preparedValue.FillRate.Value = i .. "/" .. #voxelParent:GetChildren()
	local part = voxelParent:GetChildren()[i]
	workspace.Terrain:FillBlock(part.CFrame, part.Size, Enum.Material.Water)
	part.Transparency = 1
	wait(.015)
end

print("Complete")
preparedValue.Value = true

--[[
for x = 1, -gridMax, -1 do
	-- Write X
	local newVoxel = writeNewVoxel(waterVoxel, -Vector3.new(waterVoxel.Size.X,0,0))
	
	for z = 1,gridMax do
		wait()
		local new_z_Voxel = writeNewVoxel(waterVoxel, Vector3.new(waterVoxel.Size.X,0,waterVoxel.Size.Z * z))
	end
	
	for z = -gridMax,-1,1 do
		wait()
		local new_z_Voxel = writeNewVoxel(waterVoxel, Vector3.new(waterVoxel.Size.X,0,waterVoxel.Size.Z * z))
	end
	wait(0)
		
	waterVoxel = newVoxel
end]]
