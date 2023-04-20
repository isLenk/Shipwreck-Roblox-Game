local partsPerRegion = 6
local resourceSpawnTime = 10 * 60

math.randomseed(tick())

local resources = game.ServerStorage.ServerDatabase.Prefabs.Resource

local function spawnResources()
	for _,terrain in pairs(workspace.TerrainHolder:GetChildren()) do
		if math.random(3) == 2 then
			for pointNumber = 1, partsPerRegion do
				if math.random(2) == 1 then
					local pointInArea = terrain.Position + 
							Vector3.new(
								math.random(-terrain.Size.Y, terrain.Size.Y),
								0,
								math.random(-terrain.Size.Z, terrain.Size.Z)
							)
							
						
					local start = pointInArea + Vector3.new(0,80,0)
					local ray = Ray.new(
						start,
						(pointInArea - start).unit * 180)
					
					local hit, position = workspace:FindPartOnRay(ray)
					
					if hit and hit.Material == Enum.Material.Grass then
						local resource = resources:GetChildren()[math.random(#resources:GetChildren())]:Clone()
						resource:SetPrimaryPartCFrame(CFrame.new(position + Vector3.new(0,2,0)) * CFrame.Angles(math.random(math.rad(70)),0,math.random(math.rad(70))))
						delay(3, function()
							resource.PrimaryPart.Anchored = true
						end)
						--warn("Dropping " .. resource.Name .. " at point: ", resource:GetPrimaryPartCFrame().Position)
						resource.Parent = workspace
					end
					wait(0.15)
				end
			end
		end
	end
end

spawnResources()

while wait(resourceSpawnTime) do
	spawnResources()
end