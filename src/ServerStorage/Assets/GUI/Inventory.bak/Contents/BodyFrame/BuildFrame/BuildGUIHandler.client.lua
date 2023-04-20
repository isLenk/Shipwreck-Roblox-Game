local uiListLayout = script:WaitForChild("UIListLayout")
local objTemplate = script:WaitForChild("StructureObj")

local sharedDatabase = game:GetService("ReplicatedStorage").SharedDatabase
local myStructures = sharedDatabase.PlayerData:WaitForChild(("%s_%d"):format(game.Players.LocalPlayer.Name, game.Players.LocalPlayer.UserId)).Memory.Blueprints.Structures
local structures = sharedDatabase.Blueprints.Structures

local function update()
	script.Parent.ScrollingFrame:ClearAllChildren()
	wait()
	uiListLayout:Clone().Parent = script.parent.ScrollingFrame
	
	for i = 1, #myStructures:GetChildren() do
		local objClone = objTemplate:Clone()
		if structures:FindFirstChild(objClone.Name) then
			local struct = structures[myStructures:GetChildren()[i].Name]
			objClone.TextLabel.Text = struct.Name:gsub("_", " ")
			objClone.ImageLabel.Text = struct.ItemImage.Image
		end
		objClone.Parent = script.Parent.ScrollingFrame
		script.Parent.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,objTemplate.Size.Y.Offset * (#script.Parent.ScrollingFrame:GetChildren() - 1))
	end
end

structures.ChildAdded:Connect(update)
structures.ChildRemoved:Connect(update)