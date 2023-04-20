-- Any asterisk(*) in comment means that it's changes
local myDataKey = string.format("%s_%d", game.Players.LocalPlayer.Name, game.Players.LocalPlayer.UserId)

local fol_database = game:GetService("ReplicatedStorage").SharedDatabase -- Shared Database Folder
	local fol_blueprints = fol_database.Blueprints -- Game Blueprints Folder
	local fol_playerdata = fol_database.PlayerData -- Game Player Data
		local fol_myData = fol_playerdata:WaitForChild(myDataKey) -- My Data
			local fol_myLocalData = fol_myData.LocalData
				local fol_quickEquip = fol_myLocalData.QuickEquip

local slotsContainer = script.Parent:WaitForChild("slotsContainer")
local quickEquipContainer = script.Parent:WaitForChild("quickEquip")
local categories = script.Parent.Categories

local dropRemote = fol_database.Remotes.FromClient:WaitForChild("Drop")

local categoryOptions = { -- CategoryName = {Button, Game Folder, My Folder}
	equipment = {categories.Equipment, fol_blueprints.Equipment, fol_myData.Memory.Blueprints.Equipment};
	structures = {categories.Structures, fol_blueprints.Structures, fol_myData.Memory.Blueprints.Structures};
	resources = {categories.Resources, fol_database.Resources, fol_myData.Memory.Resources};
	consumable = {categories.Consumable, fol_database.Consumable, fol_myData.Memory.Consumable};
}

local selectedCategory = categoryOptions.consumable -- This variable holds the entire array of the class

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local declippedSlot = script.DeclippedSlot

local endItemDrag = true

local currentlyEntered = nil
--	This is what the slot the mouse is hovering over	
local objectHoveredOn = nil
function updateSlots()
	if currentlyEntered and not endItemDrag and declippedSlot.ItemName.Value ~= '' then -- Item Drag is false
		currentlyEntered.Image = declippedSlot.Image	
		currentlyEntered.ItemName.Value = declippedSlot.ItemName.Value
		if fol_myLocalData.QuickEquip:FindFirstChild(currentlyEntered.Name) then
			fol_myLocalData.QuickEquip[currentlyEntered.Name].Value = selectedCategory[2][declippedSlot.ItemName.Value]
		end
	end
	
	endItemDrag = true
	currentlyEntered = nil
end

mouse.Button1Up:Connect(function()
	endItemDrag = true
	updateSlots()
end)



local function declipSlotItem(slot)
	 --	 Guard: Prevent the slot from declipping when the slot is empty
	if slot.ItemName == "" or endItemDrag == false then return end
	endItemDrag = false
	
	declippedSlot.ItemName.Value = slot.ItemName.Value
	declippedSlot.Image = slot.Image
	spawn(function()
		declippedSlot.Visible = true
		while endItemDrag == false do --	*Loop that updates the slot position to mouse
			declippedSlot.Position = UDim2.new(0,mouse.X,0, mouse.Y) - 
				UDim2.new(0, declippedSlot.Size.X.Offset / 2, 0, declippedSlot.Size.Y.Offset / 2)
			wait()
		end
		
		-- When the drag is completed, find location and assign it to designated area.
		declippedSlot.Visible = false
		declippedSlot.Parent = script
		updateSlots()
	end)
	wait()
	declippedSlot.Parent = script.Parent.Parent.Parent.Parent
end

local function fetchInventory()
	--[[
		@purp Assign inventory items to their proper slots, also load only the select categories
	--]]
	
	-- Step 1: Clear the inventory slots
	
	selectedCategory[1].BackgroundColor3 = Color3.fromRGB(25,25,25)
	for _,slot in pairs(slotsContainer:GetChildren()) do
		if slot:isA("ImageButton") then -- Since there is a UIGridLayout, then we must ignore it
			slot.Image = ""
		end
	end
	
	local myItemsFromCategory = {}
	-- Step 2: Find what player has
	for _,item in pairs(selectedCategory[3]:GetChildren()) do -- Get Items that are in inventory folder (Userdata Value)
		-- Guard: Check to see if the item exists within the game blueprints
		if selectedCategory[2]:FindFirstChild(item.Name) == nil then 
			warn(item.Name, " does not exist inside ", selectedCategory[2])
			return
		end
		table.insert(myItemsFromCategory, item.Name)		
	end
	
	-- Step 3: Get the [myItemsFromCategory] values count. Then assign them to the players inventory
	for slotIndex = 1,#myItemsFromCategory do
		local key;
		if slotIndex < 10 then
			key = "slot_0" .. slotIndex
		else
			key = "slot_" .. slotIndex
		end
		
		local slot = slotsContainer:FindFirstChild(key)
		--print("Finding Key: " .. myItemsFromCategory[slotIndex])
		slot.Image = selectedCategory[2]:FindFirstChild(myItemsFromCategory[slotIndex]).ItemImage.Image
		slot.ItemName.Value = selectedCategory[2]:FindFirstChild(myItemsFromCategory[slotIndex]).Name
	end
end


for _,slotButton in pairs(slotsContainer:GetChildren()) do -- Get slots so that we can activate functions for interactions (Slot Disconnecting)
	if slotButton:isA("GuiButton") then
		slotButton.MouseButton1Down:Connect(function()
			declipSlotItem(slotButton)
		end)
		
		slotButton.MouseButton1Click:Connect(function()
			currentlyEntered = nil
			endItemDrag = true
		end)
		
		-- The method to drop items
		slotButton.MouseEnter:Connect(function()
			if slotButton.ItemName.Value ~= '' then
				objectHoveredOn = slotButton
			end
		end)
		
		slotButton.MouseLeave:Connect(function()
			if objectHoveredOn then
				--print("Left: " .. objectHoveredOn.Name)
				objectHoveredOn = nil
			end
		end)
	end
end

game:GetService("UserInputService").InputEnded:Connect(function(key)
	local function clearObject()
		
		dropRemote:FireServer(objectHoveredOn.ItemName.Value)
		objectHoveredOn.Image = ""
		objectHoveredOn.ItemName.Value = ""
	end
	
	if (key.KeyCode == Enum.KeyCode.Z) then
		if objectHoveredOn then
			--	Clean out the slots that contain the objects name			
			for _,v in pairs(quickEquipContainer:GetChildren()) do
				if v:isA("ImageButton") then
					if v.ItemName.Value == objectHoveredOn.ItemName.Value then
						v.ItemName.Value = ""
						v.Image = ""
				end
				end
			end
			
			clearObject()
		end
	end	
end)

for _,object in pairs(quickEquipContainer:GetChildren()) do -- Set currently entered values
	if object:isA("ImageButton") then
		object.MouseEnter:Connect(function() -- Hold
			currentlyEntered = object
		end)
		
		object.MouseButton1Click:Connect(function()	-- Drop
			currentlyEntered = object
			updateSlots()
		end)
		
		object.MouseButton2Click:Connect(function() -- Cancel
			object.Image = ""
			fol_myLocalData.QuickEquip[currentlyEntered.Name].Value = nil
		end)
	end
end

for _,category in pairs(categoryOptions) do
	
	-- Change top button
	category[1].MouseButton1Click:Connect(function()
		selectedCategory[1].BackgroundColor3 = Color3.fromRGB(40,40,40)
		selectedCategory = category
		fetchInventory()
	end)
	
	category[3].ChildAdded:Connect(function()
		fetchInventory()
	end)
	
	category[3].ChildRemoved:Connect(function()
		fetchInventory()
	end)
end


fetchInventory() -- Initial Bootup of function
