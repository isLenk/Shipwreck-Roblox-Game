local humanoid = script.Parent.Humanoid
	local health = humanoid.Health
local character = script.Parent

humanoid.JumpPower = 30

local pfService = game:GetService("PathfindingService")

local mod_personality = require(game:GetService("ReplicatedStorage").Modules.AI:WaitForChild("AIPersonality_Module"))
local mod_combat = require(game:GetService("ReplicatedStorage").Modules.AI:WaitForChild("AI_Combat"))

local personality = mod_personality:getPersonality("Humanoid")

if personality == nil then
	error("> Missing Personality Type for Humanoid")
end

local isAtPeace = true

--personality.combatStyle = "Nearest" -- Overwrite for testing
-- When the NPC gets hit, check for what hit it
local function healthChanged(newHealth)
	if newHealth < health and newHealth > 0 and isAtPeace then 
		isAtPeace = false
		
		mod_combat:DecideChoice(personality, character) -- Hand over controls to module
		isAtPeace = true
	end 
end

--[[ PATH CALCULATING ]]---------------------------------------------------------------------
local function getWalkRange()
	return math.random(personality.walkRange.X, personality.walkRange.Y)
end

local function makePath()
	if character.PrimaryPart == nil then warn("PRIMARY PART MISSING") return end
	local range = getWalkRange()
	return pfService:FindPathAsync(character:GetPrimaryPartCFrame().p, character:GetPrimaryPartCFrame().p + Vector3.new(
		math.random(-range, range),
		0,
		math.random(-range, range))
	):GetWaypoints()
end

--[[ RANDOM WALK ]]---------------------------------------------------------------------
local endStep = false
local function timePassed()
	spawn(function()
		wait(2)
		endStep = true
	end)
end

local function randomWalk()
	if not isAtPeace then repeat wait() until isAtPeace end

	
	local wp = makePath()
	if wp == nil then return end
	for i = 2,#wp do
		--print("> Moving " .. character.Name .. " to: " .. tostring(wp[i].Position))
		humanoid:MoveTo(wp[i].Position)
		endStep = false
		timePassed()
		repeat wait() until character.PrimaryPart == nil or (character:GetPrimaryPartCFrame().p - wp[i].Position).magnitude < 5 or endStep == true
	end
	--print("> Action Successful: Walking")
	return true
end

randomWalk()
humanoid.HealthChanged:Connect(healthChanged)


if personality.combatStyle == "Nearest" then
	spawn(function()
		repeat wait()
					local nearestPlayer = mod_combat:CheckForNearestEntity(character, personality.viewDistance)
			--		warn("Nearest Player: " .. nearestPlayer.Name)
					if nearestPlayer ~= nil and character:FindFirstChild("RightHand") and character.RightHand:FindFirstChild("equipped") then
						-- Make character attack player
						mod_combat:AttackPlayer(character, nearestPlayer)
					end
		until character.PrimaryPart == nil
	end)
end
-- Make constant walking
while wait(math.random(personality.walkRest)) do  randomWalk() end