local uiListLayout = script:WaitForChild("UIListLayout")
local objTemplate = script:WaitForChild("SlotObject")

local sharedDatabase = game:GetService("ReplicatedStorage").SharedDatabase
local myStructures = sharedDatabase.PlayerData:WaitForChild(("%s_%d"):format(game.Players.LocalPlayer.Name, game.Players.LocalPlayer.UserId)).Memory.Blueprints.Structures
local structures = sharedDatabase.Blueprints.Structures

local buildFrame = script.Parent.BodyFrame.BuildFrame
local empty = script.Parent.BodyFrame.BuildFrame:WaitForChild("Empty")

local requestBuild = game.Players.LocalPlayer:WaitForChild("RequestBuild")

local function update()
	empty.Visible = false
	buildFrame.ScrollingFrame:ClearAllChildren()
	wait()
	uiListLayout:Clone().Parent = buildFrame.ScrollingFrame
	for i = 1, #myStructures:GetChildren() do
		local objSlot = objTemplate:Clone()
		if structures:FindFirstChild(myStructures:GetChildren()[i].Name) then
			local struct = structures[myStructures:GetChildren()[i].Name]
			objSlot.objectName.Text = struct.Name:gsub("_", " ")
			objSlot.slotImage.Image = struct.ItemImage.Image
			
			-- Build Request Function			
			objSlot.MouseButton1Click:Connect(function()
				requestBuild:Fire(myStructures:GetChildren()[i].Name)				
			end)
			
			objSlot.Parent = buildFrame.ScrollingFrame
		end
		
		
		buildFrame.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,objTemplate.Size.Y.Offset * (#buildFrame.ScrollingFrame:GetChildren() - 1))
	end
	
	if #myStructures:GetChildren() == 0 then
		empty.Visible = true
	end
end

myStructures.ChildAdded:Connect(update)
myStructures.ChildRemoved:Connect(update)

