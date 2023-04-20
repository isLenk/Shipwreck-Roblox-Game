
local humanoid = script.Parent:FindFirstChildOfClass("Humanoid")
local self = script:FindFirstAncestorOfClass("Model")
humanoid.Jump = true

local character = script.Parent
local health = humanoid.Health


local mod_personality = require(game:GetService("ReplicatedStorage").Modules.AI:WaitForChild("AIPersonality_Module"))
local mod_combat = require(game:GetService("ReplicatedStorage").Modules.AI:WaitForChild("AI_Combat"))

local personality = mod_personality:getPersonality("Gies")

humanoid.Health = personality.Health
humanoid.WalkSpeed = personality.WalkSpeed

local isAtPeace = true


-- When the NPC gets hit, check for what hit it
local function healthChanged(newHealth)
	if newHealth < health and newHealth > 0 and isAtPeace then 
		isAtPeace = false
		
		mod_combat:DecideChoice(personality, character) -- Hand over controls to module
		isAtPeace = true
	end 
end

local function onDied()
	character.Name = "Dead " .. character.Name
	humanoid:LoadAnimation(character:WaitForChild("MobAnimate"):WaitForChild("Death")):Play()	
	wait(.5)
	local ray = Ray.new(character:GetPrimaryPartCFrame().p, (character:GetPrimaryPartCFrame().p - (character:GetPrimaryPartCFrame().p + Vector3.new(0,10,0)) ).unit * 100)
	
	local hit,pos,nor = workspace:FindPartOnRay(ray, character)
	print(pos)
	character:SetPrimaryPartCFrame(CFrame.new(pos))
	for i = 1,#character:GetChildren() do
		if character:GetChildren()[i]:isA("BasePart") then
			character:GetChildren()[i].Anchored = true
		end
	end
end

local pfService = game:GetService("PathfindingService")
local function makePath()
	return pfService:FindPathAsync(self:GetPrimaryPartCFrame().p, self:GetPrimaryPartCFrame().p + Vector3.new(
		math.random(-personality.walkRange, personality.walkRange),
		0,
		math.random(-personality.walkRange, personality.walkRange)
	)):GetWaypoints()
end

local function moveRandom()
	local wayPoints = makePath()
	for i = 2, #wayPoints, 3 do
		humanoid:MoveTo(wayPoints[i].Position)
		repeat wait() until (self:GetPrimaryPartCFrame().p - wayPoints[i].Position).magnitude < 10
	end
	return true
end

humanoid.Died:Connect(onDied)
humanoid.HealthChanged:Connect(healthChanged)
moveRandom()

while wait(math.random(personality.walkRest)) do
	moveRandom()
end