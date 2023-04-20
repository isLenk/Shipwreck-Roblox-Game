script.Parent.Enabled = true
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
	mouse.TargetFilter = player.Character
local lbl_objectName = script.Parent.objectName


local reachDistance = 60

local collecting = false
local revokeCalled = false

local interactionBox = script.interactionBox
--// Bar Loader
local barRemote = script.Parent:WaitForChild("runCollectBar")
local collectBar = lbl_objectName.barHolder.collectBar
	collectBar.Visible = false

barRemote.OnInvoke = function(waitTime)
	collecting = true
	collectBar.Visible = true
	collectBar.Size = UDim2.new(0,0,1,0)
	collectBar:TweenSize(UDim2.new(1,0,1,0),"InOut","Quad", waitTime, false)
	wait(waitTime)
	if not revokeCalled then -- In case the request is overridden
		collectBar.Visible = false
		collecting = false
		return true
	else
		
		revokeCalled = false
	end
end

local revokeRemote = script.Parent:WaitForChild("revokeRequest")

revokeRemote.OnInvoke = function()
--	print("Recieved Revoke")
	revokeCalled = true
	collectBar.BackgroundColor3 = Color3.fromRGB(255,50,50)
	collectBar:TweenSize(UDim2.new(0,0,1,0),"Out","Quad", 0.5, true)
	wait(0.5)
	collecting = false
	collectBar.BackgroundColor3 = Color3.fromRGB(85,170,127)
	collectBar.Visible = false
end

--// Label Updater
function checkMouseInput()
	if collecting then
		lbl_objectName.Visible = true
	return end
	
	lbl_objectName.Visible = false
	interactionBox.Adornee = nil
	
	if not player.Character then return end
	if mouse.Target and not mouse.Target.Locked and mouse.Target:FindFirstAncestorOfClass("Model") then
		if mouse.Target.Name == "LocalBlocker" then
			lbl_objectName.Visible = false
			return
		end
		
		
		local magnitude = (player.Character:GetPrimaryPartCFrame().p - mouse.Target.Position).magnitude
		if magnitude < reachDistance then
			lbl_objectName.Visible = true
			if game.ReplicatedStorage.SharedDatabase.Resources:FindFirstChild(mouse.Target.Name) and not collecting and not mouse.Target:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
				interactionBox.Adornee = mouse.Target:FindFirstAncestorOfClass("Model")
			end
			lbl_objectName.Text = (" %s"):format((mouse.Target:FindFirstAncestorOfClass("Model").Name):gsub("_"," "))
		elseif magnitude > reachDistance and magnitude < (reachDistance * 2)-(reachDistance/2) then
			lbl_objectName.Visible = true
			lbl_objectName.Text = (" ???")
		end

		lbl_objectName.Size = UDim2.new(0,lbl_objectName.TextBounds.X + 10,0,lbl_objectName.TextBounds.Y)
		lbl_objectName.Position = UDim2.new(0.5, lbl_objectName.Size.X.Offset / 2, 0.5, lbl_objectName.Size.Y.Offset / 2)
	end
end

game:GetService("RunService").Heartbeat:Connect(checkMouseInput)