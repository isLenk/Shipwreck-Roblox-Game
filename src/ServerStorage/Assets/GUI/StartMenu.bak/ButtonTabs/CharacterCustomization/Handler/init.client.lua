-- game.ReplicatedFirst.LocalScript:ClearAllChildren(); game.StarterGui["Character Customization"]:Clone().Parent = game.ReplicatedFirst.LocalScript
if script.Parent.Parent:isA("Folder") then return end
local model = script.Model_Dummy
model.Parent = workspace.CurrentCamera
local bodyRotator = model.HumanoidRootPart.BodyRotator
local contextActionService = game:GetService("ContextActionService")
local editCharacterRemote = game:GetService("ReplicatedStorage").SharedDatabase.Remotes.FromClient:WaitForChild("EditCharacter")
	local charInfo = editCharacterRemote:InvokeServer("GET")
	local color3Data;
	
	
	if charInfo then	
		 color3Data = charInfo[1]
	end
	
function setPostEffects(value)
	for _,v in pairs(workspace.CurrentCamera:GetChildren()) do
		if v:isA("PostEffect") then
			v.Enabled = value
		end
	end
end

setPostEffects(false)

local cameraData = {} -- Save camera properties
	cameraData["CameraType"] = workspace.CurrentCamera.CameraType
	cameraData["CFrame"] = workspace.CurrentCamera.CFrame
	
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
workspace.CurrentCamera.CFrame = model:GetPrimaryPartCFrame() * CFrame.new(3,1,-6) * CFrame.Angles(0,math.rad(180),0)

local applying = false

local selectedLimb = nil
local selectedColor = nil

local function loadCharacterColors()
	if color3Data and typeof(color3Data) == "string" then
		local config = {
			[0] = "HeadColor";
			[1] = "LeftArmColor";
			[2] = "LeftLegColor";
			[3] = "RightArmColor";
			[4] = "RightLegColor";
			[5] = "TorsoColor"
		}
		
		local rep = 0
		for ColorNumber in color3Data:gmatch("%d+") do
				model.BodyColors[config[rep]] = BrickColor.new(ColorNumber)
				rep = rep + 1
		end
		
	end
end

local function loadPallete()
	script:WaitForChild("PaletteLayout"):Clone().Parent = script.Parent.CharacterFrame.Color.Palette
	
	for colorIndex = 1, 127 do
		local _BrickColor = BrickColor.palette(colorIndex)
		local square = script:WaitForChild("PaletteSquare"):Clone()
		square.BackgroundColor3 = _BrickColor.Color
		square.Name = _BrickColor.Name
		square.MouseButton1Click:Connect(function()
			if selectedLimb then
				if selectedColor and selectedColor ~= square then -- Deborder last square
					selectedColor.BorderSizePixel = 0
				end
				model.BodyColors[model.Humanoid:GetLimb(selectedLimb).Name .. "Color3"] = square.BackgroundColor3
				script.Parent.CharacterFrame.Color.ColorName.Text = _BrickColor.Name
				square.BorderSizePixel = 2
				selectedColor = square
			end		
		end)
		
		square.Parent = script.Parent.CharacterFrame.Color.Palette
	end
end

-- Model Dragging and Limb Highlighting
contextActionService:BindActionAtPriority("DummyRotateLeft", 
	function(_, state)
		if state == Enum.UserInputState.Begin then
			bodyRotator.AngularVelocity = Vector3.new(0, -2, 0)
		else
			bodyRotator.AngularVelocity = Vector3.new(0, 0, 0)
		end
		
	end, false, Enum.ContextActionPriority.Default.Value, Enum.PlayerActions.CharacterLeft)

contextActionService:BindActionAtPriority("DummyRotateRight", 
	function(_, state)
		if state == Enum.UserInputState.Begin then
			bodyRotator.AngularVelocity = Vector3.new(0, 2, 0)
		else
			bodyRotator.AngularVelocity = Vector3.new(0, 0, 0)
		end
end, false, Enum.ContextActionPriority.Default.Value, Enum.PlayerActions.CharacterRight)

local function formatBodycolors()
	local colorFormat = "HeadColor,LeftArmColor,LeftLegColor,RightArmColor,RightLegColor,TorsoColor"
	local colorHolder = "HeadColor,LeftArmColor,LeftLegColor,RightArmColor,RightLegColor,TorsoColor"
	-- Steps: Replace Property name with palette index values then return
	for property in colorFormat:gmatch("%w+") do
		colorHolder = colorHolder:gsub(property, tostring(model.BodyColors[property].Number))
	end
	
--	print("Completed Format:", colorHolder)
	return colorHolder
end

script.Parent.CharacterFrame.Apply.MouseButton1Click:Connect(function()
	if applying then return end
	applying = true
	
	contextActionService:UnbindAction("DummyRotateLeft")
	contextActionService:UnbindAction("DummyRotateRight")
	
	for i = 1,0, -0.05 do -- Enter Fade
		script.Parent.FadeOut.BackgroundTransparency = i
		wait()
	end
	
	script.Parent.FadeOut.BackgroundTransparency = 0
	
	game.ReplicatedStorage.SharedDatabase.Remotes.FromClient.EditCharacter:InvokeServer("SAVE", {formatBodycolors()})
	
	script.Parent.CharacterFrame:Destroy()
	script.Parent.KeyDrag:Destroy()
	script.Parent.clickDragNotice:Destroy()
	
	for i,v in pairs(cameraData) do -- Return camera properties
		workspace.CurrentCamera[i] = v
	end
	
	setPostEffects(true)
	script:FindFirstAncestorOfClass("PlayerGui"):FindFirstChild("StartMenu").Enabled = true
	wait(1)
	
	for i = 0, 1.1, 0.1 do -- Exit Fade
		script.Parent.FadeOut.BackgroundTransparency = i
		wait()
	end
	
	script.Parent:Destroy()
end)


local mouse = game.Players.LocalPlayer:GetMouse()


local startPos = 0
local currentPos = 0
local dragging = false

local function getRay()
	local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (mouse.UnitRay.Origin - workspace.CurrentCamera.CFrame.Position).Unit * 40)
	return workspace:FindPartOnRayWithIgnoreList(ray, {model.HumanoidRootPart})
end
	
local function endRotation()
	for i = bodyRotator.AngularVelocity.Y, -0.05 do
		bodyRotator.AngularVelocity = Vector3.new(0,i,0)
		wait()
	end
	
	bodyRotator.AngularVelocity = Vector3.new(0,0,0)
end

	
local limbOnMouseDown = nil

mouse.Button1Down:Connect(function()
	limbOnMouseDown = nil
	
	local hit = getRay()
	if hit == nil or hit:FindFirstAncestorOfClass("Model") ~= model then return end
	limbOnMouseDown = hit
	
	dragging = true
	startPos = mouse.X
end)

local limbHighlighter = script.LimbHighligher:Clone()
	limbHighlighter.Parent = model

local selectedLimbHighlighter = script.SelectedLimb:Clone()
	selectedLimbHighlighter.Parent = model
	
mouse.Move:Connect(function()
	if dragging == false then 
		local hit = getRay()
		limbHighlighter.Adornee = nil
		if hit and selectedLimb ~= hit and hit:FindFirstAncestorOfClass("Model") == model then
			limbHighlighter.Adornee = hit
		end
		
		return	
	else
		currentPos = mouse.X
		
		bodyRotator.AngularVelocity = Vector3.new(0, -((startPos - currentPos) / 30), 0)
		print(bodyRotator.AngularVelocity.Y)
	end

end)

mouse.Button1Up:Connect(function()
	local hit = getRay()
	
	if hit and limbOnMouseDown == hit and selectedLimbHighlighter.Adornee == hit then -- Deselect
		script.Parent.CharacterFrame.SelectedLimb.Text = "Select a Limb"
		script.Parent.CharacterFrame.Color.ColorName.Text = ""
		selectedLimb = nil
		selectedLimbHighlighter.Adornee = nil
		if selectedColor then
			selectedColor.BorderSizePixel = 0
		end
		selectedColor = nil
		
	elseif hit and limbOnMouseDown == hit then -- Select
		selectedLimb = hit
		selectedLimbHighlighter.Adornee = hit
		script.Parent.CharacterFrame.SelectedLimb.Text = ("\"%s\""):format(model.Humanoid:GetLimb(selectedLimb).Name)
		
		if selectedColor then -- Select color from limb
			selectedColor.BorderSizePixel = 0
		end
		
		selectedColor = script.Parent.CharacterFrame.Color.Palette:FindFirstChild(selectedLimb.BrickColor.Name)
		
		script.Parent.CharacterFrame.Color.ColorName.Text = selectedLimb.BrickColor.Name
		if selectedLimb then
			selectedColor.BorderSizePixel = 2
		end
	end
	
	dragging = false
	endRotation()
end)

loadCharacterColors()
loadPallete()