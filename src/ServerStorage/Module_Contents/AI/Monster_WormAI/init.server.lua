local chase = false
local monsterDamage = require(game:GetService("ReplicatedStorage").Modules.AI:WaitForChild("AI_MonsterDamage")):getDamage(script:FindFirstAncestorOfClass("Model"))

script.Parent:FindFirstChildOfClass("Humanoid").WalkSpeed = math.random(16, 30)

script.ChasePlayer.OnInvoke = function(player)
	chase = true
	while script.Parent:FindFirstChildOfClass("Humanoid"):GetState() ~= Enum.HumanoidStateType.Dead and player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and (player.Character:GetPrimaryPartCFrame().p - script.Parent:GetPrimaryPartCFrame().p).magnitude < 90 do
		local wp = game:GetService("PathfindingService"):FindPathAsync(script.Parent:GetPrimaryPartCFrame().p, player.Character:GetPrimaryPartCFrame().p):GetWaypoints()
		if #wp >= 2 then
		script.Parent:FindFirstChildOfClass("Humanoid"):MoveTo(wp[2].Position)
		end
		
		if (script.Parent.Head.CFrame.p - player.Character:GetPrimaryPartCFrame().Position).magnitude < 5 then
			script.Parent:FindFirstChildOfClass("Humanoid"):LoadAnimation(script.Parent.MobAnimate.Bite):Play()
			game.ReplicatedStorage.SharedDatabase.Remotes.Shared.cDamageEntity.sDamageEntity:Fire(player.Character, monsterDamage)
			chase = false
		end
		wait(math.random(35,50) / 100)
		
	end
	return true
end


repeat wait(math.random(5)) 
	if chase == false then
		local wayPoints = game:GetService("PathfindingService"):FindPathAsync(script.Parent:GetPrimaryPartCFrame().p, 
			script.Parent:GetPrimaryPartCFrame().p + Vector3.new(math.random(-15,15), 0, math.random(-15,15))):GetWaypoints()
		
		function walkRandom()
			for i = 1,#wayPoints do
				script.Parent:FindFirstChildOfClass("Humanoid"):MoveTo(wayPoints[i].Position)
				local start = tick()
				repeat wait() until (script.Parent:GetPrimaryPartCFrame().p - wayPoints[i].Position).magnitude < 5 or chase or tick() - start > 4
				if chase then return end
			end
		end
		
		walkRandom()
		
	end
	
	if math.random(3) == 2 then
		script.Parent:FindFirstChildOfClass("Humanoid"):LoadAnimation(script.Parent:WaitForChild("MobAnimate").Blink):Play()
	end
until nil
