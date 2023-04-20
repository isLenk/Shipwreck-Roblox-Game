game.ReplicatedFirst:RemoveDefaultLoadingScreen()

if game:GetService("RunService"):IsStudio() then
	return
end
script["Loading Screen"]:Clone().Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")