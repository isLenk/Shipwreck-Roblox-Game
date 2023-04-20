--[[
	@purp - Manipulate character properties to make it more realistic
--]]

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
local humanoidProperties = {
	WalkSpeed = 14;
	JumpPower = 30;
}


	local function changeProperties(instance, properties)
		for i,v in pairs(properties) do
			instance[i] = v
		end
	end

changeProperties(char.Humanoid, humanoidProperties)

char:WaitForChild("Animate").run.RunAnim.AnimationId = "rbxassetid://01288460231"
end)