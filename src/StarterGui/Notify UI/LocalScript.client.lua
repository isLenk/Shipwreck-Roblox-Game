local sharedDatabase = game:GetService("ReplicatedStorage").SharedDatabase
local player = game.Players.LocalPlayer

local myData = sharedDatabase.PlayerData:FindFirstChild(("%s_%i"):format(player.Name, player.UserId))

local itemTemplate = script:WaitForChild("ItemCollected")

local inventoryAreas = {
	{myData.Memory.Resources, sharedDatabase.Resources};
	{myData.Memory.Blueprints.Equipment, sharedDatabase.Blueprints.Equipment};
	{myData.Memory.Blueprints.Structures, sharedDatabase.Blueprints.Structures};
	{myData.Memory.Consumable, sharedDatabase.Consumable};
}

function setTransparency(gui, newTransparency, increaseValue)
	if gui:isA("ImageLabel") then
		for i = gui.ImageTransparency, newTransparency, increaseValue do
			wait()
			gui.ImageTransparency = i
		end
	elseif gui:isA("TextLabel") then
		for i = gui.TextTransparency, newTransparency, increaseValue do
			wait()
			gui.TextTransparency = i
		end
	elseif gui:isA("Frame") then
		for i = gui.BackgroundTransparency, newTransparency, increaseValue do
			wait()
			gui.BackgroundTransparency = i
		end
	end
	
end

for _,v in pairs(inventoryAreas) do
	v[1].ChildAdded:Connect(function(newChild)
		if v[2]:FindFirstChild(newChild.Name) == nil then game:GetService("Debris"):AddItem(newChild,2) return end
		local serverItemData = v[2][newChild.Name]
		local temp = itemTemplate:Clone()
		temp.ItemImage.Image = serverItemData.ItemImage.Image
		temp.ItemName.Text = serverItemData.Name:gsub("_"," ")
		
		temp.BackgroundTransparency = 1
		
		
		temp.Parent = script.Parent.ItemContainer
		
		spawn(function()
			spawn(function()
				setTransparency(temp, 0, -0.1)
			end)
			
			
			for _,object in pairs(temp:GetDescendants()) do
				spawn(function()
					if object:isA("ImageLabel") then
						setTransparency(object, 0, -0.1)
					elseif object:isA("TextLabel") then
						setTransparency(object, 0, -0.1)
					end
					
				end)
			end
		
		wait(5)
		
			spawn(function()
				setTransparency(temp, 1, 0.1)
			end)
			
			
			for _,object in pairs(temp:GetDescendants()) do
				spawn(function()
					if object:isA("ImageLabel") then
						setTransparency(object, 1, 0.1)
					elseif object:isA("TextLabel") then
						setTransparency(object, 1, 0.1)
					end
					
				end)
			end
		end)
		game:GetService("Debris"):AddItem(temp, 6)	
		
	end)
end