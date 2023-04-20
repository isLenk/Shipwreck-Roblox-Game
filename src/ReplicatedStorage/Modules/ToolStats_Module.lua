local module = {}
--[[
	PURPOSE
		STORE THE TOOL STATUS AND RETURN TO HANDLER
--]]
	local critical = {
		["Head"] = 15;
		["UpperTorso"] = 10;
		["LowerTorso"] = 5;
	}
	
	local tools = {
		Weapon = {
			["Stone_Spear"] = {
				Damage = Vector2.new(5,25);
				HitRange = 3;
			}
		}
	}
	
	module.GetWeaponDamage = function(_,tool, hit) -- As Instance
		if tools.Weapon[tool.Name] == nil then return 0 end
		local damage = tools.Weapon[tool.Name].Damage
		if critical[hit.Name] then
			return math.random(damage.X, damage.Y) + critical[hit.Name]
		end
		
		return math.random(damage.X, damage.Y)
	end
	
	module.GetHitRange = function(_,tool)
		--print(typeof(tool))

		if tools.Weapon[tool.Name] == nil then print("Does not exist") return 0 end
		return tools.Weapon[tool.Name].HitRange
	end
return module