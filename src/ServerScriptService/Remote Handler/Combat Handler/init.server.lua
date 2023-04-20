local toolStat_Module = require(game.ReplicatedStorage.Modules:WaitForChild("ToolStats_Module"))
local remotesFolder = game.ReplicatedStorage.SharedDatabase.Remotes
local damageHumanoid = remotesFolder.FromClient:WaitForChild("DamageHumanoid")
local AIdamageHumanoid = remotesFolder.AI:WaitForChild("DamageHumanoid")

function damageHum(client, npc, tool, hitPart)
	print("Tool Name: " .. tool.Name)
	if tool == nil or npc == nil then return end
	if client:isA("Player") and not client.Character[tool.Name] then print("Tool does not exist within players character") return end
	if client:isA("Player") and (client.Character:GetPrimaryPartCFrame().p - hitPart.Position).magnitude > toolStat_Module:GetHitRange(tool) + 3 then
		return
	elseif client:isA("Model") and (client:GetPrimaryPartCFrame().p - hitPart.Position).magnitude > toolStat_Module:GetHitRange(tool) + 3 then
		return
	end
	
	local damage = toolStat_Module:GetWeaponDamage(tool, hitPart)
	local checkPlayerDeath;
	
	local function addAggressor()
		if not client:isA("Player") then return end
		if npc:FindFirstChild("Aggressors") == nil then
			-- Store aggressors into here.
			local aggressorFolder = Instance.new("Folder")
			aggressorFolder.Name = "Aggressors"
			aggressorFolder.Parent = npc
		end
			
		if npc.Aggressors:FindFirstChild(client.Name) == nil then
			local aggressorTag = Instance.new("IntValue")
			aggressorTag.Name = client.Name
			aggressorTag.Value = 0
			aggressorTag.Parent = npc.Aggressors
		end
		
		npc.Aggressors[client.Name].Value = npc.Aggressors[client.Name].Value + damage -- Add to the total damage aggressor gave
		
		-- Remove aggressor tag if the aggressor dies before the npc
		checkPlayerDeath = client.Character.Humanoid.Died:Connect(function()
			if npc:FindFirstChildOfClass("Humanoid").Health > 0 then
				npc.Aggressors[client.Name]:Destroy()
			end
		end)
		
	end
	
	addAggressor()
	
	local headSize = npc.Head.Size.Y * 0.25
	local barLength = npc.Head.Size.X * 1.5
	
	local function weldHpBars(hp)
		local hp = hp -- Make HP overwritable
		local hpBackingPart = npc.Head.HpBarContainer
		local hpBarPart = hpBackingPart.HpBar
		
		-- Set HP to zero if its less or equal to zero
		if hp <= 0 then
			hp = 0
		end
		
		if npc.Head:FindFirstChild("HPWeld") then
			 npc.Head:FindFirstChild("HPWeld"):Destroy()
		end 
		
		hpBackingPart.CFrame = npc.Head.CFrame * CFrame.new(0,1.5,0):inverse()
		hpBarPart.CFrame = hpBackingPart.CFrame * CFrame.new((barLength - hp) / 2,0 ,0) -- example 3 - 1.35 
--		print(hpBackingPart.Size.X - hp)
		-- Weld HpBacking to head
		local headToBacking = Instance.new("Weld")
		headToBacking.Name = "HPWeld"
		headToBacking.Part0 = npc.Head
		headToBacking.Part1 = hpBackingPart
		headToBacking.C0 = headToBacking.Part1.CFrame:inverse() * headToBacking.Part0.CFrame	
		
		-- Weld HpBar to Backing
		local hpBarToBacking = Instance.new("Weld")
		hpBarToBacking.Part0 = hpBarPart
		hpBarToBacking.Part1 = hpBackingPart
		hpBarToBacking.C0 = hpBarToBacking.Part1.CFrame:inverse() * hpBarToBacking.Part0.CFrame
		
		headToBacking.Parent = headToBacking.Part0
		hpBarToBacking.Parent = hpBackingPart
	end
	
	local function makeHpBar()
		-- Create sort of background for HP bar to help display how much damage it has taken
		local hpBacking = Instance.new("Part")
		hpBacking.Name = "HpBarContainer"
		hpBacking.Size = Vector3.new(barLength,headSize - 0.025, headSize - 0.025)
		hpBacking.CFrame = npc.Head.CFrame * CFrame.new(0,1.5,0):inverse()
		hpBacking.Material = Enum.Material.SmoothPlastic
		hpBacking.Color = Color3.fromRGB(50,50,50)
		hpBacking.Transparency = 0.15
		hpBacking.CanCollide = false
		
		-- Create bar that shows how much health is left
		local HpBar = Instance.new("Part")
		HpBar.Name = "HpBar"
		HpBar.Size = Vector3.new(barLength,headSize, headSize)
		HpBar.CFrame = hpBacking.CFrame
		HpBar.Material = Enum.Material.SmoothPlastic
		HpBar.Color = Color3.fromRGB(100,0,0)
		HpBar.Transparency = 0
		HpBar.CanCollide = false
		
		hpBacking.Parent = npc.Head
		HpBar.Parent = hpBacking
		
		weldHpBars(0)
	end
	
	if not npc.Head:FindFirstChild("HpBarContainer") then
		makeHpBar()
	end
	
	npc:FindFirstChildOfClass("Humanoid"):TakeDamage(damage)
	

	local hpBar = npc.Head.HpBarContainer.HpBar
	-- Update Bar Statistics
	local newHpBarSize = (npc:FindFirstChildOfClass("Humanoid").Health / npc:FindFirstChildOfClass("Humanoid").MaxHealth) * barLength
	--print("NPC HEALTH: " .. npc:FindFirstChildOfClass("Humanoid").Health)
	hpBar.Size = Vector3.new(newHpBarSize, headSize, headSize)
	weldHpBars(newHpBarSize)
	
	if npc:FindFirstChildOfClass("Humanoid"):GetState() == Enum.HumanoidStateType.Dead or npc:FindFirstChildOfClass("Humanoid").Health <= 0 then
		game:GetService("Debris"):AddItem(npc.Head:FindFirstChild("HpBarContainer"), 0.5)
	end
		
end

AIdamageHumanoid.Event:Connect(damageHum)
damageHumanoid.OnServerEvent:Connect(damageHum)
