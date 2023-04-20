local rCreateDebris = script.Parent:WaitForChild("CreateDebris")



rCreateDebris.OnServerEvent:Connect(function(_,hit, tool)
	if not hit:isA("BasePart") then return end

	for partCount = 1,10 do
		local debrisPart = Instance.new("Part")
		debrisPart.Material = hit.Material
		debrisPart.Color = hit.Color
		debrisPart.Size = Vector3.new(0.3, 0.5, 0.5)
		debrisPart.CFrame = CFrame.new(tool.Position) * CFrame.fromEulerAnglesXYZ(math.random(360),math.random(360),math.random(360)) 
		script.BodyThrust:Clone().Parent = debrisPart
		debrisPart.Parent = workspace.DebrisFolder
		spawn(function()
			wait(.5)
			debrisPart:ClearAllChildren()
			game.Debris:AddItem(debrisPart, 1)
			for debris_transparency = 0,1,0.1 do
				debrisPart.Transparency = debris_transparency
				wait(.1)
			end
		end)
	end
end)