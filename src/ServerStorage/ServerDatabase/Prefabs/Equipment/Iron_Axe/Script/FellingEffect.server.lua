script.Fell.Event:Connect(function(target)

		target.Parent:SetPrimaryPartCFrame(target.Parent:GetPrimaryPartCFrame() * CFrame.new(0,1.5,0))
		if target.Parent:FindFirstChild("Trunk") then
			target.Parent.Trunk.Anchored = false
			local trunk = target.Parent.PrimaryPart
			 local oldPos = workspace.Tree:GetPrimaryPartCFrame()
			 --[[game.TweenService:Create(trunk, 
				TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{CFrame = oldPos * CFrame.new(0, -trunk.Size.Y/2, trunk.Size.Y / 2)* CFrame.Angles(math.rad(90),0,0)}):Play()	]]
		end
		for _,v in pairs(target.Parent:GetChildren()) do
			if v.Name == "Foliage" and v:isA("BasePart") then
				v.CanCollide = false
				v.Anchored = false
				local weld = Instance.new("Weld")
				weld.Part0 = target:FindFirstAncestorOfClass("Model").PrimaryPart
				weld.Part1 = v
				weld.C0 = weld.Part1.CFrame * weld.Part0.CFrame:inverse()
				weld.Parent = weld.Part0
			end
		end
		
		delay(2, function()
			print("Resuming")
			for _,v in pairs(target.Parent:GetChildren()) do
				if v:isA("BasePart") then
					spawn(function()
						wait(3)
						for i = 0,1.1,0.01 do
							wait(0.05)
							v.Transparency = i
						end
						v.CanCollide = false
					end)
				end
			end
		end)
end)