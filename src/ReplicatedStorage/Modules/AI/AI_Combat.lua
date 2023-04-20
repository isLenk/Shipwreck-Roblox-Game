	local module = {}
	local pfService = game:GetService("PathfindingService")
	
	function makePathFromPoints(pointA, pointB)
		return pfService:FindPathAsync(pointA, pointB):GetWaypoints()
	end	
	
	local combatStyles = {
		["Nearest"] = {
			start = function()
				
			end;
		};
		
		["Furthest"] = {
			start = function()
				
			end;
		};
		
		["Provoker"] = {		
			start = function(_, character, personality)
				print(typeof(character))
				if not character:FindFirstChild("Aggressors") then error(script:GetFullName().. " - No aggressor folder within NPC") return end
				
				local hum = character:FindFirstChildOfClass("Humanoid")
				local provoker;
				local weapon;
				
				-- Get Aggressor
				if #character.Aggressors:GetChildren() == 1 then
					provoker = character.Aggressors:FindFirstChildOfClass("IntValue") -- Get the only aggressor
				elseif #character.Aggressors:GetChildren() > 1 then
					local chosenAggressor = math.random(#character.Aggressors:GetChildren())
					for aggressorNumber, aggressor in pairs(character.Aggressors:GetChildren()) do
						if aggressorNumber == chosenAggressor then
							provoker = aggressor
						end
					end
				end
				
				repeat wait(0.25)
				hum:MoveTo(workspace[provoker.Name]:GetPrimaryPartCFrame().p + Vector3.new(math.random(-2,2),0,math.random(-2,2)))
				
				if character.RightHand:FindFirstChild("equipped") then
					weapon = character.RightHand.equipped.Part1:FindFirstAncestorOfClass("Model")
					if game.ServerStorage.ServerDatabase.Prefabs.Weapons[weapon.Name] then
						
					end
				end
				until hum.Health <= 0 or workspace[provoker.Name].Humanoid.Health <= 0 
				or (character:GetPrimaryPartCFrame().p - workspace[provoker.Name]:GetPrimaryPartCFrame().p).magnitude > personality.viewDistance
			print("Ended Aggression")
			return true			
			end;
		};
		
		["Passive"] = {
						
			start = function(_, character, personality)
				local hum = character:FindFirstChildOfClass("Humanoid")
				local nearestPlayer = module:CheckForNearestPlayer(character, 50)
				local path = makePathFromPoints(character:GetPrimaryPartCFrame().p, Vector3.new(
					math.random(-35,35),
					0,
					math.random(-35,35)						
					))
				for i = 2,#path do				
				hum:MoveTo(path[i].Position)
				if math.random(15) == 3 then
					hum.Jump = true
				end
				repeat wait() until (character:GetPrimaryPartCFrame().p - path[i].Position).magnitude < 5 or (character:GetPrimaryPartCFrame().p - nearestPlayer:GetPrimaryPartCFrame().p).magnitude > 25
					if (character:GetPrimaryPartCFrame().p - nearestPlayer:GetPrimaryPartCFrame().p).magnitude > 25 then
						return
					end
					end
				return
				end
		}
	};
	
	module.AttackPlayer = function(_, character, player)
		if not character or not player then error(script:GetFullName() .. " - Character or Player do not exist") return end		
			
		if character.RightHand and character.RightHand:FindFirstChild("equipped") then
		--	warn("ATTACKING")
			local weapon = character.RightHand.equipped.Part1:FindFirstAncestorOfClass("Model")
			warn("Using Weapon: " .. weapon.Name)
			local weaponAttack = weapon:FindFirstChild("Attack")
			if not weaponAttack then warn("Cannot find Weapon Attack") return end
			local charHum = character:FindFirstChildOfClass("Humanoid")
			repeat wait(0.15) 
			if math.random(1,10) == 1 then charHum.Jump = true end 
			charHum:MoveTo(player:GetPrimaryPartCFrame().p + Vector3.new(math.random(-2,2),0,math.random(-2,2))) 
			if (character:GetPrimaryPartCFrame().p - player:GetPrimaryPartCFrame().p).magnitude < 8 then
				weaponAttack:Fire()
			end
			until player:FindFirstChildOfClass("Humanoid"):GetState() == Enum.HumanoidStateType.Dead or 
			(character:GetPrimaryPartCFrame().p - player:GetPrimaryPartCFrame().p).magnitude > 45 or
			character.RightHand:FindFirstChild("equipped") == nil or
			charHum:GetState() == Enum.HumanoidStateType.Dead

			wait(0.5)
			return true
		end
	end
	
	module.CheckForNearestEntity = function(_, character, viewDistance)
		local nearestEntity;
		
		for _,child in pairs(workspace:GetChildren()) do
			if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChildOfClass("Humanoid").Health > 0 and child.PrimaryPart and character.PrimaryPart then
				local tribe = child:FindFirstChildOfClass("Humanoid"):FindFirstChild("Tribe")
				if tribe and child:FindFirstChildOfClass("Humanoid").Tribe.Value == character:FindFirstChildOfClass("Humanoid").Tribe.Value then
				
				else
					if nearestEntity == nil then
						nearestEntity = child
					end
					
					local childMagnitude = (child:GetPrimaryPartCFrame().p - character:GetPrimaryPartCFrame().p).magnitude
					if childMagnitude <= viewDistance and 
						childMagnitude < (nearestEntity:GetPrimaryPartCFrame().p - character:GetPrimaryPartCFrame().p).magnitude then
						nearestEntity = child
					end
				end
			end
		end		
		
		if nearestEntity ~= nil then
			return nearestEntity
		end
	end
	
	module.CheckForNearestPlayer = function(_, character, viewDistance)
		local nearestPlayer = nil
		
		for _,player in pairs(game.Players:GetPlayers()) do
			if player.Character then
				if nearestPlayer == nil then -- Assign nearest player variable to random player to use magnitude comparison.
					nearestPlayer = player.Character
				end
					
				local cur_playerMag = (player.Character:GetPrimaryPartCFrame().p - character:GetPrimaryPartCFrame().p).magnitude 
					
				if player.Character and cur_playerMag <= viewDistance then
					-- Compare Two magnitudes
					if cur_playerMag < (nearestPlayer:GetPrimaryPartCFrame().p - character:GetPrimaryPartCFrame().p).magnitude then
						nearestPlayer = player
					end
				end
			end
		end
				if nearestPlayer and (nearestPlayer:GetPrimaryPartCFrame().p - character:GetPrimaryPartCFrame().p).magnitude <= viewDistance then
					return nearestPlayer
				end
		return nil
	end -- Linked to Aggressive / Nearest
	
	module.DecideChoice = function(_, personality, character)
		if personality.combatStyle == nil or character == nil then
			warn(script:GetFullName() .. " - Missing combatStyle or character")
			return
		end
		if combatStyles[personality.combatStyle] == nil then return end
		combatStyles[personality.combatStyle]:start(character, personality)
		return
	end
	return module
