
--[[
	INDEX (LINES):
		Variables
		Libraries
		Functions
--]]


--[[					VARIABLES					]]--
local character	 	= script.Parent:FindFirstAncestorOfClass("Model")
local handle	 	= script.Parent:WaitForChild(script.Parent.PrimaryPart.Name)
local head		 	= script.Parent:WaitForChild("Head")

--[[					LIBRARIES					]]--

local GENERAL = {
	createInstance = function (instance, instData)
		local instanceHolder = Instance.new(instance)
		--	Modify properties
		for property, value in pairs(instData) do
			instanceHolder[property] = value		
		end
		
		return instanceHolder
	end;
	
}


--[[
	TOOLDATA LIBRARY:
		makeWeld(Weld Information): Returns a created weld with given arguments
		weldToHand(): Creates a weld to the hand and attaches it to the players right hand
--]]

local TOOL_DATA = {
	anchor = function(_,setValue)
		for _,v in pairs(script.Parent:GetChildren()) do
			if v:isA("BasePart") then
				v.Anchored = setValue
			end
		end
	end;
	
	-- WELDING
	weldTool = function()
		for _,part in pairs(script.Parent:GetChildren()) do
			if part:isA("BasePart") and part ~= handle then
				local weld	 = Instance.new("Weld")
					weld.Part0	 = handle
					weld.Part1	 = part
					weld.C0		 = handle.CFrame:inverse() * part.CFrame
					weld.Parent	 = script.Parent
			end
		end
	end;
	
	weldToHand = function()
		if not character then return end
		local weld 	= Instance.new("Weld")
			weld.Part0	= character:WaitForChild("RightHand");
			weld.Part1	= handle;
			weld.C0		= character.RightHand.CFrame:inverse() * handle.CFrame * CFrame.fromEulerAnglesXYZ(-90,0,0);
			weld.Name	= "equipped";
			weld.Parent = weld.Part0
	end;
	
	CheckWielder = function()
		if not character then return end
		if game.Players:GetPlayerFromCharacter(character) ~= nil then
			print(character.Name .. ": Wielder is a player")
			script.PlayerScript.Parent = script.Parent
			script.Parent.PlayerScript.Disabled = false
			script:ClearAllChildren()
			return true
		end
			print(character.Name .. ": Wielder is not a player")
			script.AIScript.Parent = script.Parent
			script.Parent.AIScript.Disabled = false
			script:ClearAllChildren()
	end
}


--[[					FUNCTIONS					]]--

local function setupTool()
	if character then
		script.Parent:SetPrimaryPartCFrame(character.RightHand.CFrame)
	end
	TOOL_DATA:anchor(false)
	TOOL_DATA:weldTool()
	
	if not character then
		spawn(function()
			script.Parent.PrimaryPart.CanCollide = true
			TOOL_DATA:anchor(false)
			wait(1)
			TOOL_DATA:anchor(true)
		end)
	end
		
	TOOL_DATA:weldToHand()
	TOOL_DATA:CheckWielder()

	--script.Parent.Parent = workspace.PlayerEquips
end

setupTool()
