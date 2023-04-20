Handle = nil

function onUnequipped()
	if script.Parent.Parent == workspace or script.Parent.Parent.className ~= "Backpack" then
		return
	end

	local char = script.Parent.Parent.Parent.Character
	if char ~= nil then
		local torso = char:findFirstChild("UpperTorso") or char:FindFirstChild("Torso")
		local tool = char:findFirstChild(script.Parent.Name)
		if torso ~= nil and tool == nil then
			local model = Instance.new("Model")
			model.Name = script.Parent.Name
			model.Parent = char

			handle = script.Parent.Handle:clone()
			handle.CanCollide = false
			handle.Name = script.Parent.Name
			handle.Parent = model

			local weld = Instance.new("Weld")
			weld.Name = "BackWeld"
			weld.Part0 = torso
			weld.Part1 = handle
			weld.C0 = CFrame.new(-0.2,.5,0.8)
			weld.C0 = weld.C0 * CFrame.fromEulerAnglesXYZ(math.rad(-180),math.rad(-180),100)
			weld.Parent = handle
		end
	end
end


function onEquipped()
	if handle ~= nil then 
		handle.Parent:remove()
	end
end


script.Parent.Unequipped:connect(onUnequipped)
script.Parent.Equipped:connect(onEquipped)
		