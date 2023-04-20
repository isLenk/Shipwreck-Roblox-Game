
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
		local weld	 = Instance.new("Weld")
			weld.Part0	 = handle
			weld.Part1	 = head
			weld.C0		 = handle.CFrame:inverse() * head.CFrame
			weld.Parent	 = script.Parent
	end;
	
	weldToHand = function()
		local weld 	= Instance.new("Weld")
			weld.Part0	= character:WaitForChild("RightHand");
			weld.Part1	= handle;
			weld.C0		= character.RightHand.CFrame:inverse() * handle.CFrame * CFrame.fromEulerAnglesXYZ(-40,0,0);
			weld.Name	= "HandWeld";
			weld.Parent = weld.Part0
	end
}


--[[					FUNCTIONS					]]--

local function setupTool()
	script.Parent:SetPrimaryPartCFrame(character.RightHand.CFrame)
	TOOL_DATA:anchor(false)
	TOOL_DATA:weldTool()
	TOOL_DATA:weldToHand()
end

setupTool()
