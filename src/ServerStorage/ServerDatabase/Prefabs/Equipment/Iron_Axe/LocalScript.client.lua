local properties = {
  	ActivateAnimation = Instance.new("Animation"); 
	-- Instances
	Humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid");
	Tool = script.Parent;
	Activated = false;
	-- UserData
	Player = game.Players.LocalPlayer;
	Mouse = game.Players.LocalPlayer:GetMouse();
}

properties.ActivateAnimation.AnimationId = "rbxassetid://1026224375"
local chopEvent = script.Parent:WaitForChild("Chop")
local functions = {
	
	Activate = function()
		if properties.Activated then return end
			properties.Activated = true
			properties.Humanoid:LoadAnimation(properties.ActivateAnimation):Play()
			chopEvent:FireServer()
			wait(properties.Humanoid:LoadAnimation(properties.ActivateAnimation).Length)
			properties.Activated = false
	end;
	
	attachEvents = function(self)
		properties.Mouse.Button1Down:Connect(self.Activate)
	end
}

functions:attachEvents()