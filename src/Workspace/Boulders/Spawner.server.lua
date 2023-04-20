local boulderData = {}
local boulders = workspace:WaitForChild("Boulders")

local function saveBoulders()
	for childNum = 1, #boulders:GetChildren() do
		local child = boulders:GetChildren()[childNum]
		if child:isA("BasePart") then
			boulderData[child] = child:Clone() 
		end 
	end
end

local function spawnBoulder(obj)
	wait(math.random(260,500))
	obj:Clone().Parent = boulders
end

local function boulderFunctions()
	for object, clone in pairs(boulderData) do
		pcall(function()		
			object.Health.Changed:Connect(function()
				if object.Health.Value <= 0 then		
					spawnBoulder(clone)
				end
			end)
		end)
	end
end

saveBoulders()
boulderFunctions()
