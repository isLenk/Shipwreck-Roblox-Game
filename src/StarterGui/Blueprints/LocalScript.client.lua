local myLocalData = game.Players.LocalPlayer.PlayerData.Value.LocalData

local mod_hotkey = require(myLocalData:WaitForChild("PlayerHotkeys"))


local function openBlueprints()
	if myLocalData.Typing.Value == true then return end
	script.Parent.Enabled = not script.Parent.Enabled
end

game:GetService("UserInputService").InputEnded:Connect(function(key)
	if (key.KeyCode == mod_hotkey:getKey("Blueprint")) then
		openBlueprints()
	end
end)


local sharedDatabase = game:GetService("ReplicatedStorage").SharedDatabase

local db = {
	Equipment = sharedDatabase.Blueprints.Equipment;
	Structures = sharedDatabase.Blueprints.Structures;
}

local contentsLayout = script:WaitForChild("ContentsLayout")
local slotTemplate = script:WaitForChild("SlotTemplate")

local main =  script.Parent.Main

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local searchBar = script.Parent.Main.lbl_blueprint:WaitForChild("searchBar")

local btCreate = main.Details:WaitForChild("Create")
local btQuantity = btCreate:WaitForChild("quantity")

-- Details Bar
local fr_details = main:WaitForChild("Details")

local resourceTemplate = script:WaitForChild("resourceTemplate")

local detail = {
	object_name = fr_details:WaitForChild("lbl_objectName");
	resourceList = fr_details:WaitForChild("resourceList");
	objectImage = fr_details:WaitForChild("objectImage");
	objectType = fr_details:WaitForChild("lbl_type");
	description = fr_details:WaitForChild("lbl_description")
}

local function resetDetails()
		
	detail.description.Text = "Description."
	detail.objectImage.Image = ""
	detail.objectType.Text = "Class Name"
	detail.object_name.Text = "Object Name"
	
	detail.resourceList:ClearAllChildren()
end

local rCraft = sharedDatabase.Remotes.FromClient:WaitForChild("Craft")

local selectedObj = nil;
-- BASIC NEEDS

local function displayDetails(ins_object)
	
	if selectedObj == nil then
		resetDetails()
		
		if not ins_object:FindFirstChild("ItemImage") then error("Missing ItemImage") end
		if not ins_object:FindFirstChild("ItemDescription") then error("Missing ItemDescription") end
		if not ins_object:FindFirstChild("Resources") then error("Missing resource folder") end
		
		detail.description.Text = ins_object.ItemDescription.Text
		detail.objectImage.Image = ins_object.ItemImage.Image
		detail.objectType.Text = ins_object.Parent.Name
		detail.object_name.Text = ins_object.Name:gsub("_", " ")
		
		Instance.new("UIListLayout", detail.resourceList)
		
		for resourceIndex = 1, #ins_object.Resources:GetChildren() do
			local resource = ins_object.Resources:GetChildren()[resourceIndex]
			local resourceSlot = resourceTemplate:Clone()
			resource.Name = resource.Name
			resourceSlot.Text = resourceSlot.Text:format(resource.Value, resource.Name)
			resourceSlot.Parent = detail.resourceList
		end
	end
end

local function giveSlotFunctions(ins_slot, blueprintObject)
	if ins_slot:isA("Frame") then
		
		local function onMouseEnter() -- When player is hovering over item
			if selectedObj == ins_slot then return end
			ins_slot.BackgroundColor3 = Color3.fromRGB(0, 96, 144)
			ins_slot.lbl_objectName.TextColor3 = Color3.fromRGB(255,255,255)
			ins_slot.lbl_class.TextColor3 = Color3.fromRGB(255,255,255)
			if selectedObj == nil then
				displayDetails(blueprintObject)
			end
		end
		
		local function onMouseLeave() -- When player leaves item
			if selectedObj == ins_slot then return end
			ins_slot.BackgroundColor3 = Color3.fromRGB(247, 247, 247)
			ins_slot.lbl_objectName.TextColor3 = Color3.fromRGB(0,0,0)
			ins_slot.lbl_class.TextColor3 = Color3.fromRGB(0,0,0)
		end
		
		local function onClick()
			if ins_slot ~= selectedObj then
				if selectedObj and selectedObj:isA("GuiObject") then -- Return old selected object to previous settings
					selectedObj.BackgroundColor3 = Color3.fromRGB(247, 247, 247)
					selectedObj.lbl_objectName.TextColor3 = Color3.fromRGB(0,0,0)
					selectedObj.lbl_class.TextColor3 = Color3.fromRGB(0,0,0)
					selectedObj = nil
				end				
				-- Set new selected object and change data
				displayDetails(blueprintObject)
				selectedObj = ins_slot
				selectedObj.BackgroundColor3 = Color3.fromRGB(0,170,255)
				selectedObj.lbl_objectName.TextColor3 = Color3.fromRGB(255,255,255)
				selectedObj.lbl_class.TextColor3 = Color3.fromRGB(255,255,255)
				
			else
				selectedObj.BackgroundColor3 = Color3.fromRGB(247, 247, 247)
				selectedObj.lbl_objectName.TextColor3 = Color3.fromRGB(0,0,0)
				selectedObj.lbl_class.TextColor3 = Color3.fromRGB(0,0,0)
				selectedObj = nil
				
			end
		end
		
		ins_slot.overlayBox.MouseEnter:Connect(onMouseEnter)
		ins_slot.overlayBox.MouseLeave:Connect(onMouseLeave)
		ins_slot.overlayBox.MouseButton1Click:Connect(onClick)
	end
end

local function addSlot(ins_object)
	local objectSlot = slotTemplate:Clone()
	objectSlot.Name = ins_object.Name
	objectSlot.lbl_objectName.Text = ins_object.Name:gsub("_", " ")
	objectSlot.lbl_class.Text = ins_object.Parent.Name
	if ins_object:FindFirstChild("ItemImage") then
		objectSlot.Image.Image = ins_object.ItemImage.Image
	else
		warn("Blueprint Script: Missing \"ItemImage\" file from " .. objectSlot.Name)
	end
	giveSlotFunctions(objectSlot, ins_object)
	objectSlot.Parent = main.Contents
end

local function resetContents()
	main.Contents:ClearAllChildren()
	wait()
	contentsLayout:Clone().Parent = main.Contents
end

-- Start the setup
local function build()
	resetContents()

	
	for _, dbKey in pairs(db) do
		for _, object in pairs(dbKey:GetChildren()) do
			addSlot(object)
		end
	end
end



local function search(strName)
	resetContents()
	
	for _, dbKey in pairs(db) do
		for _, object in pairs(dbKey:GetChildren()) do
			if (object.Name):lower():find(strName:lower()) then
				addSlot(object)
			end 
		end
	end
end


-- Search Bar typing
searchBar.Focused:Connect(function()
	local lastText = "";
	build()
	while searchBar:IsFocused() do
		
		if (searchBar.Text):find("%S+") == nil then
			
			if lastText ~= searchBar.Text then
				lastText = searchBar.Text
				build()
			end			
			
		else
			
			if lastText ~= searchBar.Text then
				lastText = searchBar.Text
				search(searchBar.Text)
			end
			
		end
		wait()
	end
	
end)

local function onCreate()
	if btQuantity.Text ~= "0" and selectedObj ~= nil then
		rCraft:InvokeServer(selectedObj.Name, tonumber(btQuantity.Text))
	end
end

focused = false
local function onFocus()
	focused = true
	repeat wait()
		if btQuantity.Text:find("%D+") then
			btQuantity.Text = btQuantity.Text:gsub("%D+", "")
		end
		
		if btQuantity.Text ~= "" and tonumber(btQuantity.Text) > 99 then
			btQuantity.Text = "99"
		end
		
		if btQuantity.Text:find(".") == nil then
			btQuantity.Text = "1"
		end
	until not focused
end

build()

btCreate.MouseButton1Click:Connect(onCreate)

btQuantity.FocusLost:connect(function() focused = false end)
btQuantity.Focused:connect(onFocus)

