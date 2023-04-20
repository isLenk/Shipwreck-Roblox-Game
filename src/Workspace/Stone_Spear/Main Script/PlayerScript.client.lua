local swingAnimation 	= script.Parent.Animations.Attack
local player			= game.Players.LocalPlayer
local swinging 			= false
local head 				= script.Parent:WaitForChild("Head")

print("Operational")
print(player.Name)
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
		if canTakeInput and not hit:FindFirstAncestor(player.Name) and hit.Parent:FindFirstChildOfClass("Humanoid")  then
			canTakeInput = false
			script.Parent.CreateDebris:FireServer(hit, head)
			game.ReplicatedStorage.SharedDatabase.Remotes.FromClient:WaitForChild("DamageHumanoid"):FireServer(hit.Parent, script.Parent, hit)
		end
	end)
end
--[[
	
local function setCollision(state)
	for _,v in pairs(script.Parent:GetChildren()) do
		if v:isA("BasePart") then
			v.CanCollide = state
		end
	end	
end

]]

local function doSwing()
	if swinging then return end
	swinging = true
	local loadAnim = player.Character.Humanoid:LoadAnimation(swingAnimation)
	loadAnim:Play()
	--setCollision(false)
	getHits(loadAnim.Length)
	
	wait(loadAnim.Length)
	swinging = false
	--setCollision(true)
end

player:GetMouse().Button1Down:Connect(function()
	doSwing()
end)