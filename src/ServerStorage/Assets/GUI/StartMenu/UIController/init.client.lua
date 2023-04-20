if game.Players.LocalPlayer == nil then return end

repeat wait(2) until game.Players.LocalPlayer.PlayerData.Value.LocalData.Loaded.Value == true or game["Run Service"]:IsStudio()
print("Repre")
local playerButtons = script.Parent:WaitForChild("PlayerButtons")
local cameraModule = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("CameraData"))

local Visuals = {
	Prepare = function()
		local letterBox = script.Parent:WaitForChild("LetterBox")
		for letterIndex = 1, #letterBox:GetChildren() do  -- Make Letters invisible	
			local letter = letterBox:GetChildren()[letterIndex]			
			if letter:isA("GuiObject") then
				letter.ImageTransparency = 1
			end
		end;
		letterBox.Position = UDim2.new(0.5,0,0.5,0)
		letterBox.Size = UDim2.new(0,1200,0,200)
	
		letterBox.UIGridLayout.CellPadding = UDim2.new(0,-100,0,0)
		letterBox.UIGridLayout.CellSize = UDim2.new(0, 200, 0, 200)
		
		local playerButtons = script.Parent:WaitForChild("PlayerButtons")
		for buttonIndex = 1, #playerButtons:GetChildren() do -- Position buttons below screen
			playerButtons:GetChildren()[buttonIndex].Position = playerButtons:GetChildren()[buttonIndex].Position + UDim2.new(0,0,2,0)		
		end
	end;
	
	Tween = {
		Shipwreck_Title = function()		
			local letterBox = script.Parent:WaitForChild("LetterBox")
	
			for _,v in pairs(letterBox:GetChildren()) do  -- Make letters visible
				wait(0.3)			
				spawn(function()
					if v:isA("GuiObject") then
						v.ImageTransparency = 1
						for i = v.ImageTransparency,0, -0.05 do
							wait()
							v.ImageTransparency = i
						end
					end
				end)
			end
			
				game:GetService("TweenService"):Create(letterBox.UIGridLayout, -- Adjust UI GridLayout
					TweenInfo.new(4,Enum.EasingStyle.Sine, Enum.EasingDirection.In),
					{CellPadding = UDim2.new(0, -60,0, 0), CellSize = UDim2.new(0,150,0,150)}):Play()
				
			wait(4)
			
			letterBox:TweenPosition(UDim2.new(0.5,0,0.1,10), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 3) -- Tween Upwards
			wait(2)
		end;
		PlayerButtons	= function()

			for buttonIndex = 1, #playerButtons:GetChildren() do
			local button = playerButtons:GetChildren()[buttonIndex]	
				button:TweenPosition(button.Position - UDim2.new(0,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 2)
			end
		end
		
	};
	
	Camera = function()
		local angles = cameraModule:returnMenuAngles()
		
		
		local blur = Instance.new("BlurEffect")
		blur.Size = 10
		blur.Parent = workspace.CurrentCamera
		
		local colorCorrection = Instance.new("ColorCorrectionEffect")
		colorCorrection.Saturation = -0.2
		colorCorrection.TintColor = Color3.fromRGB(166, 166, 166)
		colorCorrection.Parent = workspace.CurrentCamera
		
		local selectedAngle = angles[math.random(#angles)] 
		
		repeat wait()
			workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable		
			workspace.CurrentCamera.CFrame = selectedAngle
		until workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable	 and	
		workspace.CurrentCamera.CFrame == selectedAngle
	end		
}

local buttonToggles = 	{
	changelog = script.Parent:WaitForChild("Changelog");
	character_customization = script.Character_Customization;
	servers = script.Servers
						}

local buttonFunctions = {
	[playerButtons.Changelog] = function()
		buttonToggles.changelog.Visible = not buttonToggles.changelog.Visible
	end;
	
	[playerButtons.Join_Session] = function()
		workspace.CurrentCamera:ClearAllChildren()
		game.ReplicatedStorage.SharedDatabase.Remotes.FromClient:WaitForChild("SpawnCharacter"):FireServer()
		script.Parent:Destroy()
	end;
	
	[playerButtons.My_Character] = function()
		local obj = buttonToggles.character_customization:Clone()
			obj.Enabled = true
			obj.Parent = game.Players.LocalPlayer.PlayerGui
		script.Parent.Enabled = false
	end;
	
	[playerButtons.Servers] = function()
		local obj = buttonToggles.servers:Clone()
			obj.Enabled = true
			obj.Parent = game.Players.LocalPlayer.PlayerGui
		script.Parent.Enabled = false
	end;
	
	[playerButtons.Settings] = function()
		
	end
}

for buttonObject, buttonFunc in pairs(buttonFunctions) do
	buttonObject.MouseButton1Click:Connect(buttonFunc)
end

Visuals:Prepare()
Visuals:Camera()

Visuals.Tween:Shipwreck_Title()
Visuals.Tween:PlayerButtons()
