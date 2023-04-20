local inventorySlot = script.Parent.Parent:WaitForChild("InventorySlot")
local categories = script.parent.BodyFrame.InventoryFrame.Categories
local sharedDatabase = game:GetService("ReplicatedStorage").SharedDatabase
local slotsContainer = script.Parent.BodyFrame.InventoryFrame:WaitForChild("slotsContainer")
local playerData = sharedDatabase.PlayerData:WaitForChild(("%s_%s"):format(game.Players.LocalPlayer.Name, game.Players.LocalPlayer.UserId))

local playerInventory = {
	equipment = {categories:WaitForChild("Equipment"); playerData.Memory.Blueprints:WaitForChild("Equipment"); {}; sharedDatabase.Blueprints.Equipment};
	consumable = {categories:WaitForChild("Consumable"); playerData.Memory:WaitForChild("Consumable"); {}; sharedDatabase.Consumable};
	resources = {categories:WaitForChild("Resources"); playerData.Memory:WaitForChild("Resources"); {}; sharedDatabase.Resources};
}

local selectedCategory = playerInventory.consumable; -- Array value
local selectedSlot;
local draggedSlot;

local dropBox = script.Parent:WaitForChild("DropBox")

local slotSeperator = slotsContainer:WaitForChild("UIGrid_SlotsContainer")

local rDrop = sharedDatabase.Remotes.FromClient:WaitForChild("Drop")
local mouse = game.Players.LocalPlayer:GetMouse()

local function resetSlots()
	for objIndex = 1, #slotsContainer:GetChildren() do
		slotsContainer:GetChildren()[objIndex].Image = ""
		slotsContainer:GetChildren()[objIndex].Object.Value = nil
	end	
end

local function updateSlots(child, func)
	slotSeperator.Parent = nil
	print("Updating Slots")
	--selectedCategory[3] = {}

	local function modObjects()
		if func == "add" then
			for i = 1, #selectedCategory[3] do
				if selectedCategory[3][i] == 1 then
						selectedCategory[3][i] = selectedCategory[4]:FindFirstChild(child.Name)
					return 
				end
			end
			
		elseif func == "remove" then
			for i = 1, #selectedCategory[3] do
				if selectedCategory[3][i] == child then
					selectedCategory[3][i] = 1
					return
				end
			end
		end
	end
	
	local function updateFuncs()
		for objIndex = 1, #selectedCategory[3] do
			local lookForKey = objIndex
			if objIndex <= 9 then
				lookForKey = "0" .. objIndex
			end
			
			if typeof(selectedCategory[3][objIndex]) == "Instance" then
				slotsContainer["slot_" .. lookForKey].Image = selectedCategory[3][objIndex].ItemImage.Image
				slotsContainer["slot_" .. lookForKey].Object.Value = selectedCategory[3][objIndex]
			elseif selectedCategory[3][objIndex] == 1 then
				slotsContainer["slot_" .. lookForKey].Image = ""
				slotsContainer["slot_" .. lookForKey].Object.Value = nil
			end
		end
	end
	
	if #selectedCategory[3] == 0 then
		for i = 1, #selectedCategory[2]:GetChildren() do
			table.insert(selectedCategory[3],selectedCategory[4]:FindFirstChild(selectedCategory[2]:GetChildren()[i].Name)	)
		end
		
		for _ = 1, 30 - #selectedCategory[3] do
			table.insert(selectedCategory[3], 1)			
		end
			
	else
		modObjects()
	end
		updateFuncs()
		slotSeperator.Parent = slotsContainer
end

local function changeCategory(newCategory)
	if newCategory == selectedCategory then return end
	if selectedCategory == nil then selectedCategory = newCategory end
	
	for objectIndex = 1, #newCategory[1]:GetChildren() do -- Darken new category color
		newCategory[1]:GetChildren()[objectIndex].BackgroundColor3 = Color3.fromRGB(0, 61, 90)
	end
	
	for objectIndex = 1, #selectedCategory[1]:GetChildren() do -- return previous category color
		selectedCategory[1]:GetChildren()[objectIndex].BackgroundColor3 = Color3.fromRGB(9, 137, 207)
	end
	
	selectedCategory = newCategory
	updateSlots()
end


changeCategory(playerInventory.resources)


for _, categoryData in pairs(playerInventory) do
	categoryData[1].MouseButton1Click:Connect(function() -- Change Category
		changeCategory(categoryData)
	end)
	
	categoryData[2].ChildAdded:Connect(function(child) print("Updating Slot") updateSlots(child, "add") end)
	categoryData[2].ChildRemoved:Connect(function(child) updateSlots(child, "remove") end)
end

local function saveSlot()
	if selectedSlot.Parent == script.Parent.BodyFrame.InventoryFrame.quickEquip then return end
	local slot1 = selectedCategory[3][tonumber(selectedSlot.Name:sub(selectedSlot.Name:find("%d+")))] 
	local slot2	= selectedCategory[3][tonumber(draggedSlot.Name:sub(draggedSlot.Name:find("%d+")))]
	
	selectedCategory[3][tonumber(selectedSlot.Name:sub(selectedSlot.Name:find("%d+")))] = slot2
	selectedCategory[3][tonumber(draggedSlot.Name:sub(draggedSlot.Name:find("%d+")))] = slot1
end

local function addSlotFunctions(slot)
	slot.MouseEnter:Connect(function()
		selectedSlot = slot
	end)
		
		slot.MouseButton1Down:Connect(function()
		if selectedSlot and selectedSlot.Image ~= "" then
			dropBox.Visible = true
			draggedSlot = selectedSlot
			inventorySlot.Image = selectedSlot.Image
			inventorySlot.Visible = true
			repeat wait()
				inventorySlot.Position = UDim2.new(0, mouse.X, 0, mouse.Y) - UDim2.new(0, inventorySlot.Size.X.Offset / 2, 0, inventorySlot.Size.Y.Offset / 2)
			until inventorySlot.Visible == false
		end
	end)

	slot.MouseButton1Up:Connect(function()

		if selectedSlot and draggedSlot ~= nil then
			if draggedSlot.Object.Value and typeof(draggedSlot.Object.Value) == "Instance" and selectedCategory[4]:FindFirstChild(draggedSlot.Object.Value.Name) == nil then
				dropBox.Visible = false
				draggedSlot = nil
				print("Passed A")
				return
			end
			
			print("Passed B")	
	
			dropBox.Visible = false
			inventorySlot.Visible = false
			inventorySlot.Image = ""
			if draggedSlot ~= selectedSlot then
				saveSlot()
				local selectedSlotImage = selectedSlot.Image
				selectedSlot.Image = draggedSlot.Image
				draggedSlot.Image = selectedSlotImage
			end
			
			if selectedSlot.Parent == script.Parent.BodyFrame.InventoryFrame.quickEquip and playerData.LocalData.QuickEquip:FindFirstChild(selectedSlot.Name) and draggedSlot.Object.Value ~= nil then
				playerData.LocalData.QuickEquip[selectedSlot.Name].Value = selectedCategory[4][draggedSlot.Object.Value.Name]		
			end
			
			draggedSlot = nil;
		end
	end)
end

for _, slot in pairs(script.Parent.BodyFrame.InventoryFrame.quickEquip:GetChildren()) do
	if slot:isA("GuiButton") then
		addSlotFunctions(slot)
	end
end

for _, slot in pairs(slotsContainer:GetChildren()) do
	if slot:isA("GuiButton") then
		addSlotFunctions(slot)
	end
end

dropBox.MouseButton1Up:Connect(function()
	if selectedSlot and draggedSlot and draggedSlot.Object.Value then
		local objectValueName = draggedSlot.Object.Value.Name
		
		draggedSlot.Image = ""
		draggedSlot.Object.Value = nil
		
		dropBox.Visible = false
		inventorySlot.Visible = false
		inventorySlot.Image = ""
		
		selectedCategory[3][tonumber(draggedSlot.Name:sub(draggedSlot.Name:find("%d+")))] = 1

		draggedSlot = nil
		
		rDrop:FireServer(objectValueName)
		
	end
end)

dropBox.MouseEnter:Connect(function()
	dropBox.TrashCan.Image = "rbxgameasset://Images/Trash can open"
	selectedSlot = dropBox
end)

dropBox.MouseLeave:Connect(function()
	dropBox.TrashCan.Image = "rbxgameasset://Images/Trash Can Vector"
	selectedSlot = nil
end)
	