wait()
local attackRemote = script.Parent:WaitForChild("Attack")
local character = script.Parent:FindFirstAncestorOfClass("Model")
local hum = character:FindFirstChildOfClass("Humanoid")
local animationsFolder = script.Parent:WaitForChild("Animations")
local head = script.Parent:WaitForChild("Head")
local animations = {}

function writeToAnimations()
	for animationTrackNum = 1, #animationsFolder:GetChildren() do
		local animationTrack = animationsFolder:GetChildren()[animationTrackNum]
		animations[animationTrack.Name] = animationTrack
		print("Added track to table: " .. animationTrack.Name)
	end
end

writeToAnimations()

local attacking = false

local function getHits(length)
	local hitFunction;
	local canTakeInput = true
	spawn(function()
		wait(length)
		canTakeInput = false
		if typeof(hitFunction) == "RBXScriptConnection" then -- Disconnect if hitFunction became a function
			hitFunction:Disconnect()
		end
	end)
	
	hitFunction = head.Touched:Connect(function(hit)
		if canTakeInput and not hit:FindFirstAncestor(character.Name) and hit.Parent:FindFirstChildOfClass("Humanoid")  then
			canTakeInput = false
			script.Parent.AICreateDebris:Fire(nil, hit, head)
			game.ReplicatedStorage.SharedDatabase.Remotes.AI:WaitForChild("DamageHumanoid"):Fire(character, hit.Parent, script.Parent, hit)
		end
	end)
end

attackRemote.Event:Connect(function()
	if attacking then return end
	attacking = true
	local loadAnim = hum:LoadAnimation(animations.Attack)
	loadAnim:Play()
	
	getHits(loadAnim.Length)
	wait(loadAnim.Length)
	attacking = false
	return true
end)