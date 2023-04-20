local rShrink = script.Parent:WaitForChild("Shrink")
local hitShrinkValue = Vector3.new(0.25,0.25,0.25)
local minimumSize = 3

local damage = script.Parent.Configurations.HitDamage.Value
 
rShrink.OnServerEvent:Connect(function(client, hit)
	if (hit.Position - client.Character:GetPrimaryPartCFrame().p).magnitude < 20 then
		hit.Size = hit.Size - hitShrinkValue
		hit.Health.Value = hit.Health.Value - damage
		if hit.Health.Value < 15 then
			hit.Anchored = false
		end
		
		if hit.Health.Value <= 0 then
			hit.isMinable.Value = false
			spawn(function()
				for hitTransparency = hit.Transparency, 1, 0.05 do
					hit.Transparency = hitTransparency
					wait()
				end
				
				game:GetService("ReplicatedStorage").SharedDatabase.Remotes.FromServer:WaitForChild("Resource"):Fire(hit)
				game.Debris:AddItem(hit)
			end)
		end
	end
end)