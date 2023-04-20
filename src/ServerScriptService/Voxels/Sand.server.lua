local voxelFolder = game.ServerStorage:WaitForChild("Voxels") or workspace:WaitForChild("Voxels")
local sd = game:GetService("ReplicatedStorage").SharedDatabase
local fol_VerifySetup = sd:WaitForChild("VerifySetup")
local prep_water = fol_VerifySetup:WaitForChild("1.WaterVoxel")
local prep_sand = fol_VerifySetup:WaitForChild("2.SandVoxel")

local voxelParent = voxelFolder.Sand
local sandVoxel = voxelParent.SandVoxel
	
local function writeNewVoxel(lastVoxel, addVector)
	local voxelClone = lastVoxel:Clone()
	voxelClone.Position = voxelClone.Position + addVector
	voxelClone.Parent = voxelParent
	
	local avoxelClone = lastVoxel:Clone()
	avoxelClone.Position = -avoxelClone.Position + Vector3.new(0, avoxelClone.Position.Y * 2,0) - addVector
	avoxelClone.Parent = voxelParent

	return voxelClone
end

--if game["Run Service"]:IsStudio() then
--	prep_sand.Value = true
--	return
--end

local function beginVoxelCreation()
	prep_sand.FillRate.Value = "Cloning voxels"
	local gridMax = 5
	local elevationCap = 10
	local function makeRow()
		for z = 1,gridMax / 2 do
			wait()
			writeNewVoxel(sandVoxel, Vector3.new(sandVoxel.Size.X,math.random(-elevationCap,elevationCap),sandVoxel.Size.Z * z))
		end
		
		for z = -(gridMax / 2),-1, 1 do
			wait()
			writeNewVoxel(sandVoxel, Vector3.new(sandVoxel.Size.X,math.random(elevationCap,elevationCap),sandVoxel.Size.Z * z))
		end
	end
	
		
	for z = -(gridMax / 2),-1, 1 do
		wait()
		writeNewVoxel(sandVoxel, Vector3.new(0,0,sandVoxel.Size.Z * z))
	end
		
	prep_sand.FillRate.Value = "Adjusting voxels"
	for x = 1, gridMax / 2 do
		-- Write X
		makeRow()
		local newVoxel = writeNewVoxel(sandVoxel, Vector3.new(sandVoxel.Size.X / 2,0,0))
		wait()	
		sandVoxel = newVoxel
	end
	
	for i = 1,#voxelParent:GetChildren() do
		print("Filling Sand: " .. i .. "/", #voxelParent:GetChildren())
		prep_sand.FillRate.Value = i .. "/" .. #voxelParent:GetChildren()
		local part = voxelParent:GetChildren()[i]
		workspace.Terrain:FillBall(part.CFrame.p, part.Size.X, Enum.Material.Sand)
		part.Transparency = 1
		wait(.015)
	end
	
	prep_sand.Value = true
end

prep_water.Changed:Connect(function()
	if prep_water.Value == true then
		print("Starting sand generation")
		beginVoxelCreation()
	end
end)


