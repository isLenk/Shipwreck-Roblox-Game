local module = {}
	local monsters = {
		["Bloodworm"] = 25;
	}
	
	module.getDamage = function(_,creature)
		return monsters[creature.Name]
	end
	
return module
