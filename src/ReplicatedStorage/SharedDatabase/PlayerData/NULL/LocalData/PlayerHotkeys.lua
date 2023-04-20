local module = {}
	local hotkeys = {
		Inventory =  Enum.KeyCode.Tab;
		Forage = Enum.KeyCode.E;
		Blueprint = Enum.KeyCode.C;
	}
	
	function module:setKey(key, newEnum)
		hotkeys[key] = newEnum;
	end
	
	function module:getKey(key)
		return hotkeys[key]
	end
	
return module
