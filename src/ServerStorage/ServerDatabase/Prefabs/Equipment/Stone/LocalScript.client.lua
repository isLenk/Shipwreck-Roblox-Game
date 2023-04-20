local char = game.Players.LocalPlayer.Character
local swinging = false

if char == nil then
	char = game.Players.LocalPlayer.CharacterAdded.wait()
end

function onActivate()
	if swinging then return end
	local oldWs = char.Humanoid.WalkSpeed
	local oldJp = char.Humanoid.JumpPower
	swinging = true
	char.Humanoid.WalkSpeed = 0
	char.Humanoid.JumpPower = 0
	if script.Parent.RemoteFunction:InvokeServer() then
	char.Humanoid.WalkSpeed = oldWs
	char.Humanoid.JumpPower = oldJp
	swinging = false
	end
end

function onDeactivate()
	
end

script.Parent.Activated:connect(onActivate)
script.Parent.Deactivated:connect(onDeactivate)