repeat wait() until game.Players.LocalPlayer

local canAnimate = true
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
playerGui:SetTopbarTransparency(0)

script.Parent.Frame.informationBox.GameTitle.Text = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
script.Parent.Frame.informationBox.currentProcess.Text = "Loading Assets"
script.Parent.Frame.informationBox.processCompletion.Visible = false

game.ReplicatedStorage:WaitForChild("SharedDatabase")

spawn(function() -- TIMER
	local minutes = 0
	local seconds = 0
	
	repeat wait(1)
		seconds = seconds + 1
		if seconds > 59 then
			minutes = minutes + 1
			seconds = 0
		end
		
		script.Parent.Frame.informationBox:WaitForChild("time").Text = minutes .. ":" .. seconds
		if seconds < 10 then
			script.Parent.Frame.informationBox:WaitForChild("time").Text = minutes .. ":0" .. seconds
		end
	until not canAnimate
end)

spawn(function() -- Raining Debris
repeat
	for i = 1,15 do
		local debrisClone = script.Debris:Clone()
		debrisClone.Position = UDim2.new(math.random(1,100) / 100, 0, 0, 0)
		debrisClone.Parent = script.Parent.Frame
		spawn(function()
			wait(math.random(1,3))
			local fallTime = math.random(3,5)
			debrisClone:TweenPosition(UDim2.new(debrisClone.Position.X.Scale, 0, 1,0), "InOut","Quad", fallTime)
			game.Debris:AddItem(debrisClone, fallTime)
		end)
		
	end
	wait(3)
until not canAnimate
end)

spawn(function() -- Box Rotation
repeat wait()
	for i = script.Parent.Frame.informationBox.Loading.Rotation,script.Parent.Frame.informationBox.Loading.Rotation + 45, 5 do
	script.Parent.Frame.informationBox.Loading.Rotation = i
	wait()
	end
	wait(2)
until not canAnimate
end)

local contentService = game:GetService("ContentProvider")
local totalAssets = contentService.RequestQueueSize

while contentService.RequestQueueSize > 0 do
	script.Parent.Frame.informationBox.assetsLoaded.Text = (totalAssets - contentService.RequestQueueSize) .. " / " .. totalAssets
	script.Parent.Frame.informationBox.completionPercent.Text = 
		math.floor(((totalAssets - contentService.RequestQueueSize) / totalAssets )* 100) .. "%" 
	wait()
end
script.Parent.Frame.informationBox.assetsLoaded.Text = totalAssets .. " / " .. totalAssets

script.Parent.Frame.informationBox.currentProcess.Text = "Filling world..."
for x = 100, 50, -1 do -- Reset to 50%
	script.Parent.Frame.informationBox.completionPercent.Text = x .. "%"
	wait()
end

script.Parent.Frame.informationBox.notice.Text = "Currently mass loading, expect lag for now"
script.Parent.Frame.informationBox.processCompletion.Visible = true

local lastVoxelNum;
for voxelNum = 1, #game.ReplicatedStorage.SharedDatabase.VerifySetup:GetChildren() do
	local voxelValue;
	wait(0.5)
	for i = 1, #game.ReplicatedStorage.SharedDatabase.VerifySetup:GetChildren() do
		if game.ReplicatedStorage.SharedDatabase.VerifySetup:GetChildren()[i].Name:find(voxelNum) then
			voxelValue = game.ReplicatedStorage.SharedDatabase.VerifySetup:GetChildren()[i]
		end
	end
	
	spawn(function()
		lastVoxelNum = voxelNum
		repeat wait()
			script.Parent.Frame.informationBox.processCompletion.Text = voxelValue.FillRate.Value
		until voxelNum ~= lastVoxelNum
	end)
	
	repeat wait()
		
		for x = 0, 3 do
			script.Parent.Frame.informationBox.currentProcess.Text = "Filling: " .. (voxelValue.Name):gsub("Voxel", ""):gsub(voxelNum .. "." , "") .. string.rep(".", x)
			
			if voxelValue.Value == true then break end
			wait(.25)
		end
		wait(0.5)
		for x = 3,0, -1 do
			script.Parent.Frame.informationBox.currentProcess.Text = "Filling: " .. (voxelValue.Name):gsub("Voxel", ""):gsub(voxelNum .. "." , "") .. string.rep(".", x)
			if voxelValue.Value == true then break end
			wait(.25)
		end
		
	until voxelValue.Value == true
	
	script.Parent.Frame.informationBox.completionPercent.Text = 50 + ((50 / #game.ReplicatedStorage.SharedDatabase.VerifySetup:GetChildren()) * voxelNum) .. "%"
end

script.Parent.Frame.informationBox.currentProcess.Text = "Completed"

local function endLoad()
	wait(1)
	canAnimate = false
	wait(1)
	script.Parent.Frame.informationBox:TweenSize(UDim2.new(0,0, script.Parent.Frame.informationBox.Size.Y.Offset,0),"InOut","Quad",2)
	wait(1.5)
	script.Parent.Frame:WaitForChild("TopBar"):TweenSize(UDim2.new(1,0,0.5,0),"InOut","Quad",1)
	script.Parent.Frame:WaitForChild("BottomBar"):TweenSize(UDim2.new(1,0,-0.5,0),"InOut","Quad",1)
	wait(1)
	local initColor = script.Parent.Frame:WaitForChild("TopBar").BackgroundColor3
	local initColor1 = script.Parent.Frame:WaitForChild("BottomBar").BackgroundColor3
	local loadingColor = script.Parent.Frame.informationBox:WaitForChild("Loading").BackgroundColor3
	for i = 0,1,.1 do
		wait()
		script.Parent.Frame:WaitForChild("TopBar").BackgroundColor3 = initColor:lerp(Color3.fromRGB(25, 25, 25), i)
		script.Parent.Frame:WaitForChild("BottomBar").BackgroundColor3 = initColor1:lerp(Color3.fromRGB(25, 25, 25), i)
		script.Parent.Frame.informationBox:WaitForChild("Loading").BackgroundColor3 = loadingColor:lerp(Color3.fromRGB(25, 25, 25), i)
	end
	wait(1)
	local hideObject = function(v)
		repeat wait()
			v.Transparency = v.Transparency + 0.1
		until v.Transparency > 1
	end
	
	for _,v in pairs(script.Parent.Frame:GetDescendants()) do
		if v:isA("GuiObject") then
			local thread = coroutine.create(hideObject)
			coroutine.resume(thread,v)
		end
	end
	
	local thread = coroutine.create(hideObject)
			coroutine.resume(thread,script.Parent.Frame)
	wait(2.5)
	playerGui:SetTopbarTransparency(1)
	game.ReplicatedStorage.SharedDatabase.PlayerData:FindFirstChild(game.Players.LocalPlayer.Name .. "_" .. game.Players.LocalPlayer.UserId).LocalData.Loaded.Value = true
	script.Parent:Destroy()
end

endLoad()