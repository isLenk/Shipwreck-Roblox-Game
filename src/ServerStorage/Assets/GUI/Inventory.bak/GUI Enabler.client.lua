local player = game.Players.LocalPlayer
local playerKey = ("%s_%d"):format(player.Name, player.UserId)
local myLocalData = game.ReplicatedStorage.SharedDatabase.PlayerData:WaitForChild(playerKey).LocalData

local mod_hotkey = require(myLocalData:WaitForChild("PlayerHotkeys"))
local blur = Instance.new("BlurEffect")
local colorCorrection = Instance.new("ColorCorrectionEffect")

colorCorrection.TintColor = Color3.fromRGB(255,255,255)
colorCorrection.Brightness = -0.1
blur.Size = 0

repeat wait(1) until myLocalData.Loaded.Value == true

print("Prepared")

local operating = false

script.Parent.Enabled = false


script.Parent:GetPropertyChangedSignal("Enabled"):Connect(function()
	if script.Parent.Enabled then
		myLocalData.MouseLocked.Value = false
	else
		myLocalData.MouseLocked.Value = true
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(key)
	if (key.KeyCode == mod_hotkey:getKey("Inventory")) and not operating then
		operating = true
		script.Parent.Enabled = not script.Parent.Enabled
		
		local initColor = colorCorrection.TintColor
		if script.Parent.Enabled == true then
			
			spawn(function()
				for i = 0,1, 0.1 do -- Darken Screen
					colorCorrection.TintColor = initColor:lerp(Color3.fromRGB(150,150,150), i)
					wait()
				end
				colorCorrection.TintColor = Color3.fromRGB(150,150,150)
			end)
			
			spawn(function()
				for i = 0, 14 do
					blur.Size = i
					wait()
				end
			end)
			colorCorrection.Parent = workspace.CurrentCamera
			blur.Parent = workspace.CurrentCamera
		else
			
			spawn(function()
				for i = 0,1, 0.15 do -- Darken Screen
					colorCorrection.TintColor = initColor:lerp(Color3.fromRGB(255,255,255), i)
					wait()
				end
				colorCorrection.TintColor = Color3.fromRGB(255,255,255)
				colorCorrection.Parent = nil;
			end)
			
			spawn(function()
				for i = blur.Size,0, -1 do
					blur.Size = i
					wait()
				end
				blur.Parent = nil
			end)
		end
	wait(0.25)
	operating = false
	end
end)