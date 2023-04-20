--[[
	@purp - Log clients actions
--]]
repeat wait()
	script.Parent = nil
until script.Parent == nil

print("Client Logger Operational")

local getServ = setmetatable({}, {
	__index = function(_, index)
		return game:GetService(index)
	end
})

local loggedServices = {
	getServ.Workspace,
	getServ.Lighting,
	getServ.ReplicatedStorage,
	getServ.Players,
	getServ.ServerScriptService,
	getServ.StarterGui,
	getServ.StarterPack,
}

local ignoreClass = {
	["Frame"] = true;
	["ColorCorrectionEffect"] = true;
	["BlurEffect"] = true;
	["ImageLabel"] = true;
	
}

for serviceIndex = 1,#loggedServices do
	for _,child in pairs(loggedServices[serviceIndex]:GetChildren()) do
		child.ChildAdded:Connect(function(_child)
			if ignoreClass[_child.ClassName] then return end
			
			for _,x in pairs(_child:GetDescendants()) do
				game.ReplicatedStorage.RemoteEvent:FireServer(x, "NewChild", {Name = x.Name; ClassName = x.ClassName; Parent = x.Parent.Name;})			
			end
			
			game.ReplicatedStorage.RemoteEvent:FireServer(_child, "NewChild", {Name = _child.Name; ClassName = _child.ClassName; Parent = _child.Parent.Name;})			
		end)
	end
	
	for _,child in pairs(loggedServices[serviceIndex]:GetDescendants()) do
		child.ChildRemoved:Connect(function(_child)
			if ignoreClass[_child.ClassName] then return end
			game.ReplicatedStorage.RemoteEvent:FireServer(_child, "RemovedChild", {Name = _child.Name; ClassName = _child.ClassName;})
		end)
	end
end
