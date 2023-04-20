-- Used to detect nearby weapons to collect

local self = script:FindFirstAncestorOfClass("Model")
local regionSize = 30
local regionUpdateTime = 1.35
local hum = self:FindFirstChildOfClass("Humanoid")


local canSteal = math.random(1,3) -- DEF: 20% chance

function checkRegion()			
		local x = self:GetPrimaryPartCFrame().p - Vector3.new(regionSize, regionSize, regionSize)
		local y = self:GetPrimaryPartCFrame().p + Vector3.new(regionSize, regionSize, regionSize)
		local region = Region3.new(x,y)
		
		local partsInRegion = workspace:FindPartsInRegion3WithIgnoreList(region, {self})
		local nearestPlayer = nil
		if #partsInRegion ~= 0 then
			for partNumber = 1,#partsInRegion do
				local part = partsInRegion[partNumber]
				local player = game.Players:GetPlayerFromCharacter(part:FindFirstAncestorOfClass("Model"))
				if player then
					if nearestPlayer == nil then
						nearestPlayer = player
					end
					
					if (player.Character:GetPrimaryPartCFrame().p - script:FindFirstAncestorOfClass("Model"):GetPrimaryPartCFrame().p).magnitude < 
						(nearestPlayer.Character:GetPrimaryPartCFrame().p - script:FindFirstAncestorOfClass("Model"):GetPrimaryPartCFrame().p).magnitude then
						nearestPlayer = player
					end
				end
			end
			
			if nearestPlayer then
				if script.Parent.ChasePlayer:Invoke(nearestPlayer) then
					return true
				end
			end
		end
	return true
end

while wait(regionUpdateTime) do
	checkRegion()
end