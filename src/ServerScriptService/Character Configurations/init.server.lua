print("Character Configurations Operational")

local shared_datastore = game:GetService("ReplicatedStorage"):WaitForChild("SharedDatabase").PlayerData

function createInstance(class, properties)
	local _tempInstance = Instance.new(class)
	for i,v in pairs(properties) do
		_tempInstance[i] = v
	end
	return _tempInstance
end

-- When the player is added to the game
function newPlayer(player)
	local dataFolderSpecifier = string.format("%s_%d", player.Name, player.UserId)	
	warn("Creating data folder: " .. dataFolderSpecifier)
	
	local playerData = createInstance("Folder", {Name = dataFolderSpecifier; Parent = shared_datastore})
	
	local localData = createInstance("Folder", {Name = "LocalData"; Parent = playerData;})
		script.PlayerHotkeys:Clone().Parent = localData
		local inventorySize = createInstance("IntValue", {Name = "InventorySize"; Value = 30; Parent = localData})
		local reachDistance = createInstance("IntValue", {Name = "ReachDistance"; Value = 100; Parent = localData})
		local mouseLocked = createInstance("BoolValue", {Name = "MouseLocked"; Value = false; Parent = localData})	
		local typing = createInstance("BoolValue", {Name = "Typing"; Value = false; Parent = localData})	
		local loaded = createInstance("BoolValue", {Name = "Loaded"; Value = false; Parent = localData})
		local quickEquip = createInstance("Folder", {Name = "QuickEquip"; Parent = localData})
			for slotNum = 1,4 do
				local slotData = createInstance("ObjectValue", {
					Name = "slot" .. slotNum;
				Parent = quickEquip})
				
				local holderData = createInstance("ObjectValue", {
					Name = "holder";
					Parent = slotData
				})
			end
		
	local memory = createInstance("Folder", {Name = "Memory"; Parent = playerData})
		local resources = createInstance("Folder", {Name = "Resources"; Parent = memory})
		local consumable = createInstance("Folder", {Name = "Consumable"; Parent = memory})
		local blueprints = createInstance("Folder", {Name = "Blueprints"; Parent = memory})
			local equipment = createInstance("Folder", {Name = "Equipment"; Parent = blueprints})
			local structures = createInstance("Folder", {Name = "Structures"; Parent = blueprints})
		local stats = createInstance("Folder", {Name = "Stats"; Parent = memory})
			local mobsKilled = createInstance("IntValue", {Name = "MobsKilled"; Value = 0; Parent = stats})
			local timeAlive = createInstance("IntValue", {Name = "TimeAlive"; Value = 0; Parent = stats})
	
	local myHealth = createInstance("Folder", {Name = "MyHealth"; Parent = playerData})	
		local health = createInstance("NumberValue", {Name = "Health"; Value = 100; Parent = myHealth})
		local oxygen = createInstance("NumberValue", {Name = "Oxygen"; Value = 100; Parent = myHealth})
--		local sanity = createInstance("NumberValue", {Name = "Sanity"; Value = 100; Parent = myHealth})
		local engram = createInstance("IntValue", {Name = "Engram"; Value = 0; Parent = myHealth})
		local const_Decline = createInstance("Folder", {Name = "const_Decline"; Parent = myHealth})
			local hunger = createInstance("NumberValue", {Name = "Hunger"; Value = 100; Parent = const_Decline})
			local thirst = createInstance("NumberValue", {Name = "Thirst"; Value = 100; Parent = const_Decline})
	
	
	if playerData ~= nil then
		print(dataFolderSpecifier .. " - was successfully created!")		
	end
	
	local playerKey	= createInstance("ObjectValue", {Name = "PlayerData"; Value = playerData; Parent = player})
	
	game.ServerStorage.Assets.GUI.StartMenu:Clone().Parent = player.PlayerGui
	-- When game is ready. Load datastore information here.
end

function playerRemoving(player)
	
end

game.Players.PlayerRemoving:Connect(playerRemoving)
game.Players.PlayerAdded:Connect(newPlayer)