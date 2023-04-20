local swingAnimation 	= script.Parent.Animation.Swing
local player			= game.Players.LocalPlayer
local swinging 			= false
local head 				= script.Parent:WaitForChild("Head")
local rCreateDebris 	= script.Parent:WaitForChild("CreateDebris")
local rShrink			= script.Parent:WaitForChild("Shrink")
local function getHits(length)
	local hitFunction;
	local canTakeInput = true
	spawn(function()
		wait(length)
		canTakeInput = false
		if typeof(hitFunction) == "RBXScriptConnection" then -- Disconnect if hitFunction became a function
			hitFunction:Disconnect()
		end
	end)
	
	hitFunction = head.Touched:Connect(function(hit)
		if canTakeInput and not hit:FindFirstAncestor(player.Name) and hit:FindFirstChild("isMinable") and hit.isMinable.Value == true then
			canTakeInput = false
			rCreateDebris:FireServer(hit, head)
			rShrink:FireServer(hit)
		end
	end)
end

local function doSwing()
	if swinging then return end
	swinging = true
	local loadAnim = player.Character.Humanoid:LoadAnimation(swingAnimation)
	loadAnim:Play()
	
	getHits(loadAnim.Length)
	
	wait(loadAnim.Length)
	swinging = false
end

player:GetMouse().Button1Down:Connect(function()
	doSwing()
end)