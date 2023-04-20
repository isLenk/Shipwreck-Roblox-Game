local module = {}
	local moduleContents = game:GetService("ServerStorage").Module_Contents
	local Contents_AI = moduleContents.AI
	local tableAI = {}	
	
	local animationContents = moduleContents.Animations
	
	local modulePrepared = false
	
	-- Should only be used once
	module.PrepareModule = function()
		tableAI = {} -- Clean module in case it has invalid information
		for _,moduleChild in pairs(Contents_AI:GetChildren()) do
			if moduleChild:IsA("Script") then
				tableAI[moduleChild.Name:gsub("AI", "")] = moduleChild
				--print("Module > Added AI type: " .. moduleChild.Name:gsub("AI", ""))
			end
		end
		modulePrepared = true
	end
	
	-- Part of giveAI
	findAI = function(AI_Name)
		--print("Module > Searching for: ".. AI_Name)
		-- In case the AI doesnt exist
		if not tableAI[AI_Name] then return nil end
		
		return tableAI[AI_Name]
	end
	
	getAnimations = function(Requester)
		if not modulePrepared then repeat wait() until modulePrepared end
		local animPack = animationContents:FindFirstChild(Requester:FindFirstChildOfClass("Humanoid").Name)
		if animPack then
			return animPack
		end
		warn("Could not find animation pack for " .. Requester.Name)
		return nil
	end
	
	-- The reciever scripts will use this.
	module.getAI = function(self, Requester, AI_Name)
		if not modulePrepared then repeat wait() until modulePrepared end
		local AI_Script = findAI(AI_Name)
		
		if AI_Script then 
			AI_Script:Clone().Parent = Requester -- Requester should be Model
		end
		
		local animPack = getAnimations(Requester)
		if animPack then
			local animator = animationContents:WaitForChild("MobAnimate"):Clone()
			for _,v in pairs(animPack:GetChildren()) do
				v:Clone().Parent = animator
			end
			animator.Parent = Requester
			
			return true
		end
		
		return false
	end
	
	
	
return module
