-- Axe Script 

local user = game:GetService("Players"):GetPlayerFromCharacter(script:FindFirstAncestorOfClass("Model"):FindFirstAncestorOfClass("Model")) 
local char = user.Character
--print(user.Name .. " | Axe Script Functional") 

local properties = { 
	chopDamage = script.Parent.Configurations.ChopDamage.Value;
 	 -- When the to ol is equipped, set to true 
  	toolState = false;
 	 -- Position tool after dequip 
 	sideWeldCFrame = CFrame.new(1,1,1); 
 	 -- Get Size of Tool * 0.05. 
 	weight = 5 or script:FindFirstAncestorOfClass("Model"):GetExtentsSize() * Vector3.new(0.05,0.05,0.05) 
} 

local touchFunc;
local chopFired = false

local functions = {
	treeFell = function(_, target)
		if target:FindFirstAncestorOfClass("Model").Name:find("Fallen") then 
			print("Target is already dead")
		return end
		target:FindFirstAncestorOfClass("Model").Name = "Fallen " .. target:FindFirstAncestorOfClass("Model").Name
		
		game:GetService("ReplicatedStorage").SharedDatabase.Remotes.FromServer:WaitForChild("Resource"):Fire(target, 2)
		local fellingScript = script.FellingEffect:Clone()
		fellingScript.Parent = target
		fellingScript.Fell:Fire(target)
	end;
		
	
	isChoppable = function(_,target)
		if target.Parent:FindFirstChild("isTree") or target.Parent:FindFirstChild("canChop") then	
			return true
		else
			return false
		end
	end;
	
	WeldToHand = function()
		script.Parent:SetPrimaryPartCFrame(char.RightHand.CFrame)
		local weld = Instance.new("Weld")
		weld.C0 = char.RightHand.CFrame
		weld.C1 = script.Parent:GetPrimaryPartCFrame()
		weld.Part0 = char.RightHand
		weld.Part1 = script.Parent.Handle
		weld.Parent = weld.Part0
	end;
	
	Equip = function(self) 
		properties.toolState = true; 
		self:WeldToHand()	
	end;
	
	Dequip = function()
		properties.toolState = false; 
	end;
	
	Chop = function(self)
		if chopFired then 
			if typeof(touchFunc) == 'RBXScriptConnection' then
				touchFunc:Disconnect()
			end
		end
		chopFired = true
		
		touchFunc = script.Parent.Handle.Touched:Connect(function(hit)
			if self:isChoppable(hit) then
				touchFunc:Disconnect()
				if hit.Parent:FindFirstChild("ChopSound") then return end
				local chopSound = Instance.new("Sound")
					chopSound.Name = 'ChopSound'
					chopSound.SoundId = "rbxassetid://159798345"
					chopSound.PlayOnRemove = true
					chopSound.MaxDistance = 150
					chopSound.Parent = hit
					chopSound:Destroy()
				
				if hit.Parent.Health.Value > 0 then
					hit.Parent.Health.Value = hit.Parent.Health.Value - properties.chopDamage
				end
				if hit.Parent.Health.Value <= 0 then
					self:treeFell(hit)
				end
			end
			touchFunc:Disconnect()
		end)
		
	end
}


-- This will automatically equip when the tool has been added to character
functions:Equip() 

script.Parent:WaitForChild("Chop").OnServerEvent:Connect(function(self)
	if not self then return	end -- In case self is nil for any reason
	functions:Chop()
end)

 