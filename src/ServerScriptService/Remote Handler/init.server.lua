-- Services
local sharedDatabase = game:GetService("ReplicatedStorage").SharedDatabase
local physicsService = game:GetService("PhysicsService")


local remotesFolder = game:GetService("ReplicatedStorage").SharedDatabase.Remotes

-- Client Remotes
local setToolState		= remotesFolder.FromClient:WaitForChild("SetToolState")
local forage 			= remotesFolder.FromClient:WaitForChild("Forage")
local get_gameData 		= remotesFolder.FromClient:WaitForChild("Get_GameData")
local spawnCharacter	= remotesFolder.FromClient:WaitForChild("SpawnCharacter")
local sendMessage 		= remotesFolder.FromClient:WaitForChild("SendMessage")
local craft 			= remotesFolder.FromClient:WaitForChild("Craft")
local construct			= remotesFolder.FromClient:WaitForChild("Construct")
local getModel 			= remotesFolder.FromClient:WaitForChild("GetModel")
local sendFeedback		= remotesFolder.FromClient:WaitForChild("SendFeedback")
local dropInventoryItem = remotesFolder.FromClient:WaitForChild("DropInventoryItem")

-- Server Remotes
local dropResources 	= remotesFolder.FromServer:WaitForChild("DropResources")
local rMessage			= remotesFolder.FromServer:WaitForChild("Message")
local placeStructure 	= remotesFolder.FromServer:WaitForChild("PlaceStructure")
local getCharacterEdit  = remotesFolder.FromServer:WaitForChild("GetCharacterEdit")

-- Shared Remotes ("c" Client, "s" Server
local cDamageEntity 	= remotesFolder.Shared:WaitForChild("cDamageEntity")
local sDamageEntity		= cDamageEntity:WaitForChild("sDamageEntity")

-- Other Remotes
local serverMsg 		= rMessage:WaitForChild("ServerMessage")

-- Prefab Shortcuts
local serverPrefabs 	= game:GetService("ServerStorage").ServerDatabase.Prefabs
local serverEquipment	= serverPrefabs.Equipment
local serverResources 	= serverPrefabs.Resource
local serverAssets			= game:GetService("ServerStorage").Assets

-- Modules
local gameDataModule = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("Module_GameData"))

-- Feedback Datastore
local feedbackDatastore = game:GetService("DataStoreService"):GetDataStore("Shipwreck - Feedback Log")

-- Function Services
local function dropAllLoot(player)
	wait(0.5)
	local memory = player.PlayerData.Value.Memory
	local exclusions = {
		memory.Blueprints.Structures;
	}
	
	for _,object in pairs(memory:GetDescendants()) do
		game.Debris:AddItem(object, 1)
		local objectClone	= serverPrefabs[object.Parent.Name][object.Name]:Clone()
		objectClone:SetPrimaryPartCFrame(player.Character:GetPrimaryPartCFrame() * CFrame.new(math.random(-1,1), math.random(-1, 1), math.random(-1,1)) * CFrame.Angles(math.rad(40),0,0))
		objectClone.Parent = workspace
	end
end

local function onDeath(target)
	if target:FindFirstChild("Death") then return end
	local blocker = Instance.new("IntValue")
	blocker.Name = "Death"
	blocker.Parent = target
	local targetModel = target;
	if target:isA("Player") then
		targetModel = target.Character
		dropAllLoot(target)
	end	
	
	targetModel:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
		
	for ins = 1, #targetModel:GetChildren() do
		if targetModel:GetChildren()[ins]:isA("BasePart") then
			spawn(function()
				wait(6)
				
				targetModel:GetChildren()[ins].Anchored = true
				targetModel:GetChildren()[ins].CanCollide = false
				game:GetService("TweenService"):Create(targetModel:GetChildren()[ins], 
					TweenInfo.new(3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
					{Size = Vector3.new(0,0,0); Transparency = 1; 
				CFrame = CFrame.new(targetModel:GetChildren()[ins].Position) * CFrame.new(Vector3.new(5,3,0)) * CFrame.Angles(30,90,10)}):Play()
				
			end)
		end
	end
end
local function sdFindObj(objName)
	for _,object in pairs(sharedDatabase.Blueprints:GetDescendants()) do
		if object.Name == objName then
			return object
		end
	end
	return nil
end
local function findPointOnMap() -- Function: SPAWN_CHARACTER
	local chosenTerrain = workspace.TerrainHolder:GetChildren()[math.random(#workspace.TerrainHolder:GetChildren())]
	
	if chosenTerrain:isA("BasePart") and chosenTerrain.Material == Enum.Material.Grass then		
		return chosenTerrain.Position + Vector3.new(
			math.random(-chosenTerrain.Size.X / 2, chosenTerrain.Size.X / 2),
			math.random(-chosenTerrain.Size.Y / 2, chosenTerrain.Size.Y / 2),
			math.random(-chosenTerrain.Size.Z / 2, chosenTerrain.Size.Z / 2)
		)
	else
		findPointOnMap()
	end
end

-- Bindable Event - Functions
local PLACE_STRUCTURE 		 = function(objectName, objCFrame)
	local obj = serverPrefabs.Structures:FindFirstChild(objectName)
--	print("Place Structure Remote > Placing object")
	if obj then
		local objClone = obj:Clone()
		objClone:SetPrimaryPartCFrame(objCFrame)
		objClone.Parent = workspace.Structures
	end
end
local SERVER_MESSAGE		 = function(message)
	print("Server Message created: " .. message)
	rMessage:FireAllClients("SERVER", message)
end
local DROP_RESOURCE			 = function(instance, dropDelay)
	
	local dropPoint = CFrame.new(instance.Position) -- Get object position to place resources in
	wait(dropDelay)
	if instance.Parent:isA("Model") and instance.Parent.PrimaryPart then -- If the object has a bunch of parts and is bunched in a model, get CFrame
		dropPoint = instance.Parent:GetPrimaryPartCFrame()
	end
	
	local targetCollisionPart = nil
	
	if instance:isA("Model") then
		targetCollisionPart = instance.PrimaryPart
	else
		targetCollisionPart = instance
	end
	
	physicsService:SetPartCollisionGroup(targetCollisionPart, "Enviroment")
	

	for _,drop in pairs(instance.Parent.ResourceDrops:GetChildren()) do
		for qDrop = 1,drop.Value do
			local res = serverResources:FindFirstChild(drop.Name)
			if res then
				wait()
				local res = res:Clone()
				physicsService:SetPartCollisionGroup(res.PrimaryPart, "Resource")
				
				res:SetPrimaryPartCFrame(dropPoint * CFrame.new(math.random(-3, 3), math.random(-2,2), math.random(-3,3) ))
				res.PrimaryPart.Anchored = false
				res.Parent = workspace
			end
		end
	end
end
local DAMAGE_ENTITY			 = function(target, damage)
	if game.Players:GetPlayerFromCharacter(target) ~= nil then -- Given object is player model
		game.Players:GetPlayerFromCharacter(target).PlayerData.Value.MyHealth.Health.Value = game.Players:GetPlayerFromCharacter(target).PlayerData.Value.MyHealth.Health.Value - damage
		if game.Players:GetPlayerFromCharacter(target).PlayerData.Value.MyHealth.Health.Value <= 0 then
			onDeath(game.Players:GetPlayerFromCharacter(target))
end
	elseif target:isA("Player") then -- Given parameter is Player Object
		target.PlayerData.Value.MyHealth.Health.Value = target.PlayerData.Value.MyHealth.Health.Value - damage
		if target.PlayerData.Value.MyHealth.Health.Value <= 0 then
			onDeath(target)
		end
	elseif target:FindFirstChildOfClass("Humanoid") then -- Given object has humanoid
		target:FindFirstChildOfClass("Humanoid").Health = target:FindFirstChildOfClass("Humanoid").Health
		if target:FindFirstChildOfClass("Humanoid").Health <= 0 then
			onDeath(target)
		end
	end
end

-- Remote Function - Functions
local GET_MODEL 			 = function(client, modelName) -- Termporarily moves a asset model clone into the workspace 'ModelClone' folder
	for _,v in pairs(serverPrefabs:GetDescendants()) do
		if v.Name == modelName then
			local objClone = v:Clone()
			objClone.Parent = workspace.Hologram.ModelClone
			delay(5,function() -- Remove the temporary object
				objClone:Destroy()
			end)
			return objClone
		end
	end
end
local CRAFT					 = function(player, objectName, quantity)
	--print(player.Name, objectName, quantity)
	local requiredResources = {}
	local obj = sdFindObj(objectName)
	
	if obj then
		for o = 1, quantity do
			local playerResources = player.PlayerData.Value.Memory.Resources
			local function removeResources()
				for resourceName, value in pairs(requiredResources) do
	
					for val = 1, value do
						if playerResources:FindFirstChild(resourceName) then
							playerResources[resourceName].Name = "[_R_]" .. playerResources[resourceName].Name 
						else						
							return false
						end
					end			
				end		
				return true
			end
			
			for _,res in pairs(obj.Resources:GetChildren()) do
				requiredResources[res.Name] = res.Value
			end
			
			if #playerResources:GetChildren() < 1 then return end
				
			local revResources = removeResources()
				
				local deletable = {}	
				for resNum = 1,#playerResources:GetChildren() do
					
					local resource = playerResources:GetChildren()[resNum]
					if revResources == false then
						resource.Name = resource.Name:gsub("[_R_]", "")
					end
					
					if revResources == true then
						if resource.Name:find("[_R_]") then
							table.insert(deletable, resource)
						end
					end
					
				end
				
				for _,removable in pairs(deletable) do
					removable:Destroy()
				end
				
				if revResources == false then
					return
				end
			
			for objNumber = 1, #serverPrefabs:GetDescendants() do
				local serverObj = serverPrefabs:GetDescendants()[objNumber]
				
				if serverObj.Name == obj.Name then
					obj = serverObj
				end
			end
			
			obj:Clone().Parent = player.PlayerData.Value.Memory.Blueprints[obj.Parent.Name]
		end
	end
end
local GET_GAMEDATA			 = function(player, data)
	if data == "changelog" then
		return gameDataModule:getLog()
	end
	return "Doesn't exist, like your waifu!"
end
local ON_FEEDBACK			 = function(client, feed) 
	if feedbackDatastore:GetAsync("FeedbackLog") == nil then
		print("Creating new Feedback Log")
		feedbackDatastore:SetAsync("FeedbackLog", {})
	end
	
	local success = pcall(function()
		local logPlaceholder = feedbackDatastore:GetAsync("FeedbackLog")
		table.insert(logPlaceholder, client.Name .. "-" .. feed)
		print(table.concat(logPlaceholder, ", "))
		feedbackDatastore:UpdateAsync("FeedbackLog", logPlaceholder)
	end)
	
	if success then
		print("Successful")
		return true
	else
		print("Unsuccessful")
		return false
	end
end

-- Remote Event - Functions
local CONSTRUCT 			 = function(client, selected, cframe) -- Move asset into workspace 'Structures' and play CFrame
	local clientData = client.PlayerData.Value
	if selected == nil then warn("Selected is NIL") return end
	if clientData.Memory.Blueprints.Structures:FindFirstChild(selected.Name) and selected.PrimaryPart then
		local newPlace = selected:Clone()
		
		newPlace:SetPrimaryPartCFrame(cframe)
		
		newPlace.Parent = workspace.Structures
		

		local function runAnimation(object)
			local tweenData = TweenInfo.new(
				2,
				Enum.EasingStyle.Back,
				Enum.EasingDirection.Out
			)
			
			for _,v in pairs(object:GetDescendants()) do
				if v:isA("BasePart") then
					local orig_Trans = v.Transparency
					local defCanCollide = v.CanCollide
					local defCFrame = v.CFrame
					
					v.CanCollide = false
					v.Transparency = 1
					v.CFrame = v.CFrame * CFrame.new(Vector3.new(math.random(0,8), math.random(0,8), math.random(0,8))) * CFrame.Angles(math.rad(math.random(0,90)), math.rad(math.random(0,90)), math.rad(math.random(0,90)))
					
					delay(0.5, function() 
						delay(0.2, function()
							game.TweenService:Create(v, tweenData, {CFrame = defCFrame}):Play()
						end)
						
						for transparency = 1, orig_Trans, -0.1 do
							v.Transparency = transparency
							wait()
						end
						
						v.Transparency = orig_Trans
						v.CanCollide = defCanCollide
					end)
					
				end
			end
		end
		
		runAnimation(newPlace)
		
		clientData.Memory.Blueprints.Structures:FindFirstChild(selected.Name):Destroy()
		return true
	else
		return false
	end	
end
local SPAWN_CHARACTER		 = function(player)
	player.PlayerData.Value.MyHealth.Health.Value = 100	
	
	local function placeCharacterOnMap()
		print("Placing Character on Map")
		local dropPoint = findPointOnMap()
		
		local success = pcall(function()
			local start = dropPoint + Vector3.new(0,250,0)
			ray = Ray.new(start, (dropPoint - start).unit * 300)
		end)
		
		if not success then placeCharacterOnMap() return end
		
		local hit, pos, NA, material = workspace:FindPartOnRay(ray)
		
		if hit and material ~= Enum.Material.Water then
			player:LoadCharacter()
			player.Character:MoveTo(pos + Vector3.new(0,5,0))
			player.Character.Head.face.Transparency = 1
	
			local characterData = getCharacterEdit:Invoke(player)
			
			if characterData and characterData[1] and typeof(characterData[1]) == "string" then
				
				local newBodyColors = Instance.new("BodyColors")
				local config = {
					[0] = "HeadColor";
					[1] = "LeftArmColor";
					[2] = "LeftLegColor";
					[3] = "RightArmColor";
					[4] = "RightLegColor";
					[5] = "TorsoColor"
				}
				
				local rep = 0
				for ColorNumber in characterData[1]:gmatch("%d+") do
						newBodyColors[config[rep]] = BrickColor.new(ColorNumber)
						rep = rep + 1
				end
				
				newBodyColors.Parent = player.Character
			end
			return
		else
			wait(0.25)
			warn("Unsuccessful Raycast, remapping")
			placeCharacterOnMap()
			return
		end
		
	end

	placeCharacterOnMap()	
end
local SEND_MESSAGE			 = function(player, message)
	if message == "" then return end
	local function getText(msg, userId)
		local success = pcall(function()
			game:GetService("TextService"):FilterStringAsync(message, player.userId)
		end)
		if success then
			return true
		end
		return false
	end
		local msgObj = getText(message, player.userId)
	if msgObj then
		--print( game:GetService("TextService"):FilterStringAsync(message, player.userId):GetNonChatStringForBroadcastAsync())
		rMessage:FireAllClients(player.Name, game:GetService("TextService"):FilterStringAsync(message, player.userId):GetNonChatStringForBroadcastAsync())
		return
	end
	rMessage:FireAllClients(player.Name, "******")
end
local FORAGE				 = function(client, object)
	-- Check For: Storage Capacity Exceeded, Existence of object, distance of object.
	if object == nil then return end
	if object.PrimaryPart and (client.Character:GetPrimaryPartCFrame().p - object.PrimaryPart.Position).magnitude > 10 then return	end
	--print("Passed Magnitude") 
	local inventorySize = client.PlayerData.Value.LocalData.InventorySize.Value

	local lookFors = {
		client.PlayerData.Value.Memory.Blueprints.Structures,
		client.PlayerData.Value.Memory.Blueprints.Equipment,
		client.PlayerData.Value.Memory.Resources,
		client.PlayerData.Value.Memory.Consumable,
	}
	for _,check in pairs(lookFors) do
		if #check:GetChildren() >= inventorySize then return end  --- Bug Fix Marker
	end
	--print("Passed Inventory Size w/ Ratio: ", getPlayerKey(client).LocalData.InventorySize.Value, #getPlayerKey(client).Memory.Blueprints:GetDescendants() - 2  )
	
	local function checkObjectInFolder(folderName, objectName)
		for _,v in pairs(folderName:GetDescendants()) do
			if objectName == v.Name then
				return true
			end
		end
		return false
	end
	
	local parent = nil
	

		
	if checkObjectInFolder(sharedDatabase.Blueprints.Equipment, object.Name) then
		parent = client.PlayerData.Value.Memory.Blueprints.Equipment
	end
		
	if checkObjectInFolder(sharedDatabase.Resources, object.Name) then
		parent = client.PlayerData.Value.Memory.Resources
	end
	
	if checkObjectInFolder(sharedDatabase.Consumable, object.Name) then
		parent = client.PlayerData.Value.Memory.Consumable
	end
	
	local objClone = object:Clone()
	object:Clone().Parent = parent -- Place object into inventory
	object:Destroy()
	objClone.Name = "NA REPLICATE"
	for _,v in pairs(objClone:GetChildren()) do
		if v:isA("BasePart") then
			v.Locked = true
			v.CanCollide = false
			v.Anchored = true
			spawn(function()
				for i = v.Transparency, 1, 0.1 do
					v.Transparency = i
					wait()
				end
			end)
			spawn(function()
				local curPos = v.Position
				game:GetService("TweenService"):Create(v, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = curPos + Vector3.new(0,20,0); Size = v.Size / Vector3.new(2,2,2)}):Play()
			end)
		end
	end
	
	objClone.Parent = workspace
	
	game:GetService("Debris"):AddItem(objClone, 1.5)
		
end
local SET_TOOL_STATE		 = function(client, tool, state)
	if tool == nil then return end
	if serverEquipment:FindFirstChild(tool.Name) == nil then
		warn("Requested Tool does not exist")
	return end
	if not client.PlayerData.Value.Memory.Blueprints.Equipment:FindFirstChild(tool.Name) then
		warn("Non existent object in inventory")	
		return
	end
	
	local function removeTools()
		for _,v in pairs(client.Character:GetChildren()) do
			if v.Name:find('Tool') then
				v:Destroy()
			end
		end
	end
	
	if state == "equip" then
		removeTools()
		wait()
		local tool = serverEquipment:FindFirstChild(tool.Name):Clone()
		if tool then
			tool.Name = "Tool " .. tool.Name
			tool.Parent = client.Character
		else
			warn("Tool does not exist")
		end
	elseif state == "unequip" then
		removeTools()
	elseif state == "drop" then
		client.PlayerData.Value.Memory.Blueprints.Equipment:FindFirstChild(tool.Name):Destroy()
		local toolClone = serverEquipment:FindFirstChild(tool.Name):Clone()
		toolClone:SetPrimaryPartCFrame(client.Character:GetPrimaryPartCFrame() * CFrame.new(0,-3,0))
		toolClone.Parent = workspace
	else
		warn("State was not specified or is invalid")
	end	
end
local CLIENT_DAMAGE_ENTITY	 = function(client, target, damage)
	DAMAGE_ENTITY(target, damage)
end
local DROP_INVENTORY_ITEM 	 = function(client, itemName)
	local memory = client.PlayerData.Value.Memory
	
	local object = memory:FindFirstChild(itemName, true)
	if object then
		local serverObject = serverPrefabs[object.Parent.Name][object.Name]:Clone()
		serverObject:SetPrimaryPartCFrame(client.Character:GetPrimaryPartCFrame()  * CFrame.new(math.random(-1,1), math.random(-1, 1), math.random(-1,1)) * CFrame.Angles(math.rad(40),0,0))
		serverObject.Parent = workspace
		object:Destroy()
	end
	
end


-----------------------------------------------------------------------------

-- Bindable Event Listeners
placeStructure		.Event:Connect(PLACE_STRUCTURE)
serverMsg			.Event:Connect(SERVER_MESSAGE)
dropResources		.Event:Connect(DROP_RESOURCE)
sDamageEntity		.Event:Connect(DAMAGE_ENTITY)

-- Remote Function Listeners
getModel			.OnServerInvoke = GET_MODEL
craft				.OnServerInvoke = CRAFT
get_gameData		.OnServerInvoke = GET_GAMEDATA
sendFeedback		.OnServerInvoke = ON_FEEDBACK

-- Remote Event Listeners
construct			.OnServerEvent:Connect(CONSTRUCT)
spawnCharacter		.OnServerEvent:Connect(SPAWN_CHARACTER)
sendMessage			.OnServerEvent:Connect(SEND_MESSAGE)
forage				.OnServerEvent:Connect(FORAGE)
setToolState		.OnServerEvent:Connect(SET_TOOL_STATE) 
cDamageEntity		.OnServerEvent:Connect(CLIENT_DAMAGE_ENTITY)
dropInventoryItem	.OnServerEvent:Connect(DROP_INVENTORY_ITEM)

-- Write Physics Collision
physicsService:CreateCollisionGroup("Enviroment")
physicsService:CreateCollisionGroup("Resource")
physicsService:CollisionGroupSetCollidable("Enviroment", "Resource", false) -- Make Enviroment and Resource groups uncollidable


