for _,v in pairs(script.Parent:GetChildren()) do
	spawn(function()
		if v:isA("BasePart") then
			v.Anchored = false
			wait(3)
			v.Anchored = true
		end
	end)
end