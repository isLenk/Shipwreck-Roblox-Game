--[[
	@purp - Collect world objects
--]]
local player = game.Players.LocalPlayer
local char = player.Character
local mouse = player:GetMouse()

local processing = false

function calculateCollectTime(object)
	return (object:GetExtentsSize().X * 0.05) + 
			(object:GetExtentsSize().Y * 0.05) + 
			(object:GetExtentsSize().Z * 0.05)
end

local interactionGui = game.Players.LocalPlayer.PlayerGui.Interaction

local sharedDatabase = game:GetService("ReplicatedStorage"):WaitForChild("SharedDatabase")

local mod_hotkey = require(game.Players.LocalPlayer.PlayerData.Value.LocalData:WaitForChild("PlayerHotkeys"))

function activateSequence(object) 
	processing = true
	spawn(function()
		if object == nil then return end
		finishedSequence = interactionGui.runCollectBar:Invoke(calculateCollectTime(object:FindFirstAncestorOfClass("Model")))
	end)
	while not finishedSequence do
		if char.Humanoid.MoveDirection ~= Vector3.new(0,0,0) then
			interactionGui.revokeRequest:Invoke()
			processing = false
			return false
		end
		wait()
	end
	wait(.1)
	processing = false
	return true
end

local collectableObjectFolders = {
	sharedDatabase.Blueprints.Equipment,
	sharedDatabase.Consumable,
	sharedDatabase.Resources,
}

function checkObjectInFolder(folder, objectName)
	for _,v in pairs(folder:GetDescendants()) do
		if v.Name == objectName then
			return true
		end
	end
end

function verifyCollectable(target)
	if target == nil then return end
	for _,v in pairs(collectableObjectFolders) do
		if checkObjectInFolder(v, target.Name) then
			return true
		end
	end
	return false
end

game:GetService("UserInputService").InputEnded:Connect(function(key)
	if key.KeyCode == mod_hotkey:getKey("Forage") then
		if processing then return end
		local target = mouse.Target
		
		if target and not target.Locked and target.Parent:isA("Model") then	
			if not verifyCollectable(target:FindFirstAncestorOfClass("Model")) then return end
			if (target.Position - char:GetPrimaryPartCFrame().p).magnitude < 10 then
				if activateSequence(target) then
					target:FindFirstAncestorOfClass("Model").Name = "LocalBlocker"
					game.ReplicatedStorage.SharedDatabase.Remotes.FromClient.Forage:FireServer(target:FindFirstAncestorOfClass("Model"))
				end
			end
		end
	end
end)
