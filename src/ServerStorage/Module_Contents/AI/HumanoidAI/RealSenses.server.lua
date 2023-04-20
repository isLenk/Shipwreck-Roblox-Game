-- Used to detect nearby weapons to collect

local self = script:FindFirstAncestorOfClass("Model")
local regionSize = 30
local pickupRange = 5
local focusLostRange = 80
local regionUpdateTime = 0.35
local hum = self:FindFirstChildOfClass("Humanoid")

local weaponsFolder = game.ServerStorage.ServerDatabase.Prefabs.Equipment.Weapons

local canSteal = math.random(1,3) -- DEF: 20% chance

local function showRegion(region,x,y)
	
	local part1 = Instance.new("Part")
	part1.Size = Vector3.new(1,1,1)
	part1.Shape = "Ball"
	part1.Color = Color3.fromRGB(255,0,0)	
	part1.Material = Enum.Material.Neon
	part1.Position = x
	part1.Anchored = true
	part1.Parent = workspace
	
	local part2 = Instance.new("Part")
	part2.Size = Vector3.new(1,1,1)
	part2.Position = y
	part2.Shape = "Ball"
	part2.Color = Color3.fromRGB(0,0,255)
	part2.Material = Enum.Material.Neon
	part2.Anchored = true
	part2.Parent = workspace
	
	local regionShower = Instance.new("Part")
	regionShower.Anchored = true
	regionShower.Transparency = 0.75
	regionShower.Material = Enum.Material.SmoothPlastic
	regionShower.CFrame = region.CFrame
	regionShower.Size = region.Size	
	regionShower.CanCollide = false
	regionShower.Parent = workspace
	
	game.Debris:AddItem(part1, regionUpdateTime)
	
	game.Debris:AddItem(part2, regionUpdateTime)
	
	game.Debris:AddItem(regionShower, regionUpdateTime)
end

-- Greedy bastard. Taking others stuff
if canSteal == 1 then
	canSteal = true
else
	canSteal = false
end

--print("Can Steal: " .. (canSteal and "yes" or "no"))

function checkRegion()
	if self:FindFirstChild("RightHand") and not self.RightHand:FindFirstChild("equipped") then				
		local x = self:GetPrimaryPartCFrame().p - Vector3.new(regionSize, regionSize, regionSize)
		local y = self:GetPrimaryPartCFrame().p + Vector3.new(regionSize, regionSize, regionSize)
		local region = Region3.new(x,y)
		
		local partsInRegion = workspace:FindPartsInRegion3WithIgnoreList(region, {self})
		if #partsInRegion ~= 0 then
			for partNumber = 1,#partsInRegion do
				local part = partsInRegion[partNumber]
	
				if not part.Locked and part:FindFirstAncestorOfClass("Model") and not game.Players:GetPlayerFromCharacter(part:FindFirstAncestorOfClass("Model").Parent)
					and weaponsFolder:FindFirstChild(part:FindFirstAncestorOfClass("Model").Name) then
					
					if part:FindFirstAncestorOfClass("Model").Parent and part:FindFirstAncestorOfClass("Model").Parent:FindFirstChildOfClass("Humanoid") and not canSteal then
						return true
					end
					--[[spawn(function()
						local oldC0 = self.UpperTorso.Waist.C0
						local oldC1 = self.UpperTorso.Waist.C1
						self.UpperTorso.Waist.C0 = CFrame.new(0,0.5,-0.5)
						self.UpperTorso.Waist.C1 = CFrame.Angles(math.rad(35),0,0)
						repeat wait() until (self:GetPrimaryPartCFrame().p - part.Position).magnitude < pickupRange
						self.UpperTorso.Waist.C0 = oldC0
						self.UpperTorso.Waist.C1 = oldC1
					end)]]
					repeat wait() hum:MoveTo(part.Position) until (self:GetPrimaryPartCFrame().p - part.Position).magnitude < pickupRange or (self:GetPrimaryPartCFrame().p - part.Position).magnitude > focusLostRange
					
					if part:FindFirstAncestorOfClass("Model") then
						weaponsFolder[part:FindFirstAncestorOfClass("Model").Name]:Clone().Parent = self
						part:FindFirstAncestorOfClass("Model"):Destroy()
					end
					
					return true
				end
			end
		end
		--showRegion(region,x,y)
	end
	return true
end

while wait(regionUpdateTime) do
	checkRegion()
end