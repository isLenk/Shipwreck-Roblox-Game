canDamage = false

attackAnim = {
	script.Parent:WaitForChild("SwordSlash1"),
}


function onActivated()
	
	local chosenAttack = math.random(1,#attackAnim)
	for attackType = 1,#attackAnim do
		if attackType == chosenAttack and not canDamage then
			script.Parent.Handle.Trail.Enabled = true
			canDamage = true
			local character = game.Players.LocalPlayer.Character
			if not character or not character.Parent then
				game.Players.LocalPlayer.Character:wait()
			end
			
			local attack = character.Humanoid:LoadAnimation(attackAnim[attackType])
			attack:Play()
			attack.KeyframeReached:connect(function(keyName)
				if (keyName == "KF0.89999997615814") then
					canDamage = false
					script.Parent.Handle.Trail.Enabled = false
				end
			end)
		end
	end
end

function onUnequipped()
	script.Parent.Handle.Trail.Enabled = false
end

script.Parent.Unequipped:connect(onUnequipped)
script.Parent.Activated:connect(onActivated)