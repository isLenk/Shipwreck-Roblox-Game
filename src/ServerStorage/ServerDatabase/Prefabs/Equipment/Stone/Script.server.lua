local swingAnimation = script.Parent:WaitForChild("SwingAnim")
local remoteFunction = script.Parent:WaitForChild("RemoteFunction")
local swinging = false

remoteFunction.OnServerInvoke = function()
	swinging = true
	local hum = script.Parent.Parent:FindFirstChildOfClass("Humanoid")
	if hum then -- The tool has been equipped, load animation
		local anim = hum:LoadAnimation(swingAnimation)
		anim:Play()
		wait(anim.Length)
		swinging = false
		return true
	end
end

local alreadyContacted = false

script.Parent.Handle.Touched:connect(function(hit)
	if alreadyContacted or not swinging then return end
	if hit:FindFirstChild("isMinable") == nil then return end
	
 		hit.isMinable.BoulderHealth.Value = hit.isMinable.BoulderHealth.Value - 5
		game:GetService("ReplicatedStorage").Remotes.ServerToClient:WaitForChild("SetTargetHPInfo")
				:FireClient(game.Players:GetPlayerFromCharacter(script.Parent.Parent), hit.isMinable.BoulderHealth.Value)	
	
	if hit.isMinable.BoulderHealth.Value <= 0 then
			hit.isMinable:Destroy()
			
			
			
				hit.CanCollide = false
				hit.Anchored = false
	end
	
	alreadyContacted = true
	
	for debrisPeble = 1,math.random(4,9) do
		local peble = Instance.new("Part")
		peble.Name = "Peble Debris"
		peble.Material = Enum.Material.Slate
		--peble.Shape = Enum.PartType.Ball
		peble.Size = Vector3.new(0.05,0.05,0.05)
		peble.Position = script.Parent.Handle.Position
		peble.Anchored = false
		peble.CanCollide = true
		
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(math.random(3,9), 15, math.random(3,9))		
		
		peble.Parent = workspace
		bodyVelocity.Parent = peble
		
		game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
		game:GetService("Debris"):AddItem(peble, 4)
	end
	wait(1)
	alreadyContacted = false
	end)