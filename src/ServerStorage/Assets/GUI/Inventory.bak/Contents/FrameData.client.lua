local currentTab = script.Parent:WaitForChild("bt_currentTab")
local switchTab = script.Parent:WaitForChild("bt_switchTab")

local function nextTab()
	if currentTab.Text == "INVENTORY" then
		currentTab.Text = "BUILD"
		switchTab.Text = "INVENTORY"
		script.Parent.BodyFrame.BuildFrame.Visible = true
		script.Parent.BodyFrame.InventoryFrame.Visible = false
	else
		currentTab.Text = "INVENTORY"
		switchTab.Text = "BUILD"
		script.Parent.BodyFrame.InventoryFrame.Visible = true
		script.Parent.BodyFrame.BuildFrame.Visible = false
	end
end


switchTab.MouseButton1Down:Connect(nextTab)

-- GUI Dragging
local dragging = false
local dragConfirmationTime = 0.025
local mouse = game.Players.LocalPlayer:GetMouse()

local function mouseDown()
	dragging = true 
	wait(dragConfirmationTime)
	if dragging then
		repeat wait()
			script.Parent.Position = UDim2.new(0,mouse.X, 0,mouse.Y,0)
		until dragging == false
	end
end

local function mouseUp()
	dragging = false
end

local function onClick()
	dragging = false
end
	
currentTab.MouseButton1Down:Connect(mouseDown)
currentTab.MouseButton1Up:Connect(mouseUp)
currentTab.MouseButton1Click:Connect(onClick)
