print("Player construction system")

-- Gives the player the ability to build
local player = game.Players.LocalPlayer
local Mouse = player:GetMouse()

local rReqBuild		= Instance.new("BindableEvent")
	rReqBuild.Name 		= "RequestBuild"
	rReqBuild.Parent 	= player
local rConstruct	= game:GetService("ReplicatedStorage").SharedDatabase.Remotes.FromClient:WaitForChild("Construct")
local rGetModel 	= game:GetService("ReplicatedStorage").SharedDatabase.Remotes.FromClient:WaitForChild("GetModel")
local selected 		= nil

local hologram;

local hRotation = 0

local removeHologram = function()
	if hologram == nil then return end
	hologram:Destroy()
	hologram = nil
end;
	
	
local hologramData = {
	
	makeHologram = function()
		if not selected then return end
		local hologram = selected:Clone()
		
		for _,part in pairs(hologram:GetDescendants()) do
			if part:isA("BasePart") then

				part.Color = Color3.fromRGB(255,255,255)--0,170,127)
				
				if part.Transparency ~= 1 then
					part.Transparency = 0.25
				end
				
				part.CanCollide = false
				part.Anchored = true
			end
		end
		hologram.Parent = workspace.Hologram
		return hologram
	end;
	
	moveHologram = function()
		if hologram == nil then return end
		local ray = Ray.new(
			workspace.CurrentCamera.CFrame.p,
			(Mouse.Hit.p - workspace.CurrentCamera.CFrame.p).unit * 100
		);
		local ignoreList = {player.Character; hologram; workspace.Structures}
		local hit, position, normal = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList);
		-- Check if there is a surface
		if hit then
			hologram:SetPrimaryPartCFrame(CFrame.new(position, position + normal) * CFrame.Angles(math.rad(-90),math.rad(hRotation),0))
		end
	end;
	
	placeObject = function()
		if hologram == nil then return end
		local askBuild = rConstruct:FireServer(selected, hologram:GetPrimaryPartCFrame())
		
		if askBuild == false then
			removeHologram()
		end
		
		if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
			removeHologram()
		end
	end;
	
	cancelObject = function()
		removeHologram()
	end;
	
	incrementRotation = function(self, incAmount)
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
			self:moveHologram()
			hRotation = hRotation + incAmount
		end
	end;

}

function onInput(key)
	if key.KeyCode == Enum.KeyCode.C then
		hologramData:cancelObject()
	end
end


-- Structure Modifier
game:GetService("UserInputService").InputEnded:Connect(onInput)

-- Rotate Structure
Mouse.WheelForward:Connect(function()
	hologramData.incrementRotation(hologramData, 15)	
end)


Mouse.WheelBackward:Connect(function()
	hologramData.incrementRotation(hologramData, -15)	
end)

Mouse.Move:Connect(hologramData.moveHologram)
Mouse.Button1Down:Connect(hologramData.placeObject)


-- Get Build request
rReqBuild.Event:Connect(function(structureName)
	selected = rGetModel:InvokeServer(structureName)
	hologram = hologramData:makeHologram()
end)
