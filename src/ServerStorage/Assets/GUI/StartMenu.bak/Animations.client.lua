repeat wait(2)
until game:GetService("RunService").IsStudio or  game.Players.LocalPlayer and game:GetService("ReplicatedStorage").SharedDatabase.PlayerData:FindFirstChild(game.Players.LocalPlayer.Name .. "_" .. game.Players.LocalPlayer.UserId).LocalData.Loaded.Value == true

local doFunc = script.Parent:WaitForChild("DoFunction")
local letterBox = script.Parent.LetterBox
script.Parent.Changelog.Visible = false

for _,v in pairs(letterBox:GetChildren()) do
	if v:isA("GuiObject") then
		v.ImageTransparency = 1
	end
end

for _,v in pairs(script.Parent.Options:GetChildren()) do
	if v:isA("GuiObject") then
		v.BackgroundTransparency = 1
		v.TextLabel.TextTransparency = 1
		v.TextLabel.TextStrokeTransparency = 1
	end
end


letterBox.Size = UDim2.new(0,1200,0,200)
letterBox.Position = UDim2.new(0.5,0, 0.5, 0)

letterBox.UIGridLayout.CellPadding = UDim2.new(0,-100,0,0)
letterBox.UIGridLayout.CellSize = UDim2.new(0, 200, 0, 200)

script.Parent.PreAlpha.TextTransparency = 1
script.Parent.PreAlpha.TextStrokeTransparency = 1

spawn(function()
	game:GetService("TweenService"):Create(letterBox.UIGridLayout,
		TweenInfo.new(4,Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{CellPadding = UDim2.new(0, -60,0, 0), CellSize = UDim2.new(0,150,0,150)}):Play()
	letterBox:TweenPosition(UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 4)
end)

for _,v in pairs(letterBox:GetChildren()) do
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

wait(4)

letterBox:TweenPosition(UDim2.new(0.5,0,0.1,10), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 3)
wait(3)

for x = 1,0, -0.1 do
	script.Parent.PreAlpha.TextTransparency = x
	script.Parent.PreAlpha.TextStrokeTransparency = x
	wait()
end

spawn(function()
	repeat wait(4)
		for x = 0, 7 do
			script.Parent.PreAlpha.Rotation = x
			wait(.05)
		end
		
		for x = 7, 0, -1 do
			script.Parent.PreAlpha.Rotation = x
			wait(.05)
		end
		
		for x = 0, -7, -1 do
			script.Parent.PreAlpha.Rotation = x
			wait(.05)
		end
		
		for x = -7, 0, 1 do
			script.Parent.PreAlpha.Rotation = x
			wait(.05)
		end
	until nil
end)

local function closeOptions()
	for _,v in pairs(script.Parent.Options:GetChildren()) do
		if v.Name ~= "Credits" then
				v:TweenSize(UDim2.new(0,450,0, v.Size.Y.Offset), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
			else
				v:TweenSize(UDim2.new(0,275,0, v.Size.Y.Offset), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
			end
	end
end

local canClick = true
for _,v in pairs(script.Parent.Options:GetChildren()) do
	if v:isA("GuiObject") then
		spawn(function()
			wait(0.3)
			for i = 1,0, -0.1 do
			v.BackgroundTransparency = i
			v.TextLabel.TextTransparency = i
			v.TextLabel.TextStrokeTransparency = i
			wait()
			end
		end)
		

		v.MouseEnter:Connect(function()
			if canClick == false then return end
			closeOptions()
			wait()
			if v.Name ~= "Credits" then
				v:TweenSize(UDim2.new(0,500,0,v.Size.Y.Offset), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
			else
				v:TweenSize(UDim2.new(0,300,0, v.Size.Y.Offset), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
			end
		end)
		
		v.MouseLeave:Connect(function()
			if canClick == false then return end
			closeOptions()
		end)
		
		v.MouseButton1Down:Connect(function()
			if canClick == false then return end
			if v.Name == "Play" then
				canClick = false
			end
			doFunc:Fire(v)
		end)
	end
end
