local module = {}
	spawners = {
		["Tribal Hut"] = {
			Class = "Humanoid";
			Capacity = 3;
		}
	}
	
	module.getSpawner = function(_, spawner)
		--print("Attempting to find: " .. spawner.Name)
		if spawners[spawner.Name] then
			return spawners[spawner.Name]
		end
		return nil
	end
	
return module