local module = {}
	-- Future Idea: Make Fight styles a priority level.
	local CombatStyles = {
		"Nearest"; -- Barbarians
		"Furthest"; -- Archers	
		"Provoker"; -- Warriors
		"Passive"; -- Animals.
	}
	
	local AIPersonality = {
		Humanoid = {
			characteristics = {
				walkRange = Vector2.new(15,30); -- Measured in studs
				walkRest = Vector2.new(5,15); -- Measured in seconds
				combatStyle = CombatStyles;
				viewDistance = Vector2.new(50,150); -- Aka F.O.V when aggrovated, this is view distance.
			};
			
			createRandomizedPersonality = function(self)
				local personalCharacteristics = {self.characteristics}
				personalCharacteristics.walkRange = self.characteristics.walkRange
				--personalCharacteristics.walkRange = math.random(self.characteristics.walkRange.X, self.characteristics.walkRange.Y)
				personalCharacteristics.walkRest = math.random(self.characteristics.walkRest.X, self.characteristics.walkRest.Y)
				personalCharacteristics.viewDistance = math.random(50,150)
				personalCharacteristics.combatStyle = CombatStyles[math.random(#CombatStyles)]
				return personalCharacteristics
			end
		};
		
		Gies = {
			characteristics = {
				walkRange = Vector3.new(35,55);
				walkRest = Vector2.new(10,15);
				combatStyle = "Passive";
				WalkSpeed = Vector2.new(20,32);
				Health = Vector2.new(150,250);
			};
			
			createRandomizedPersonality = function(self)
				local personalCharacteristics = {self.characteristics}
				personalCharacteristics.walkRange = self.characteristics.walkRange.X
				personalCharacteristics.walkRest = math.random(self.characteristics.walkRest.X, self.characteristics.walkRest.Y)
				personalCharacteristics.WalkSpeed = math.random(self.characteristics.WalkSpeed.X, self.characteristics.WalkSpeed.Y)
				personalCharacteristics.Health = math.random(self.characteristics.Health.X, self.characteristics.Health.Y)
				return personalCharacteristics
			end
		};
	}

		
	module.getPersonality = function(_,AIType)
		for aiName, aiPersonality in pairs(AIPersonality) do
		--	warn(("Personality Check: %s = %s"):format(aiName, AIType))
			if aiName == AIType then
				return aiPersonality:createRandomizedPersonality()		
			end
		end
		return nil
	end
return module
