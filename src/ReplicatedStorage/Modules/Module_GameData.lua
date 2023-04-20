local module = {}
	local log = {
		{"PA6.35", "Tree Fix"},
		{"PA6.3", "First Hostile Creature: Bloodworm"},
		{"PA6.0", "Building Mechanics"},
		{"PA5.1", "Recreated Menu"},
		{"PA5.0", "Modified Inventory"},
		{"PA4.7", "Added NPC spawners"},
		{"PA4.5", "Terrain loader semi-done"},
		{"PA4.1", "Combat System semi-done"},
		{"PA3.9", "Humanoid NPCs can pick up weapons"},
		{"PA3.6", "Added new AI system"},
		{"PA3.4", "Message System created"},
		{"PA3.3", "Lighting schemes (Fantasy / Realistic)"},
		{"PA3.2", 'Game renamed to "Shipwreck"'},
		{"PA3.2", "Islands spread out more"},
		{"PA3.1e", "Stone things, pond, typha, raised water"},
		{"PA3.1", "Mushrooms, tree variants, cave..."},
		{"PA3.0", "Imported prototype scripts"},
		{"PA2.8", "2.0+ Have Changed Code Structure"},
		{"PA2.6", "Webhook Client Logging"},
		{"PA2.5", "Forage System Semi-Complete"},
		{"PA2.42", "Forage Collecting Bar"},
		{"PA2.4", "Pointer Notifier Created"},
		{"PA2.3", "Quick Slots Fixed"}, 
		{"PA2.22", "New Walk Animation"},
		{"PA2.2", "Custom First Person"},
		{"PA1.29", "Fixed Layout Order Bug"},
		{"PA1.27", "Fixed Reverse Camera Interpolation Bug"},
		{"PA1.25", "Added Loading Screen (REAL)"},
		{"PA1.2", "Released for Pre-Alpha"},
		{"PA1.0", "Unlisted Development"},
	}
	
	function module:getLog()
		return log
	end
return module
