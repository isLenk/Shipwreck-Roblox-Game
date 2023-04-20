-- Change Lighting
local lightingOptions = {
	Fantasy = {
		Lighting = {
			Ambient = Color3.fromRGB(155, 57, 172);
			ColorShift_Bottom = Color3.fromRGB(255, 108, 228);
			FogColor = Color3.fromRGB(144,144,144);
			FogEnd = 2000000
		};
		
		Terrain = {
			WaterColor = Color3.fromRGB(0, 170, 255);
			WaterReflectance =0.5;
			WaterTransparency = 0.5;
		}
		
	};
	
	Realistic = {
		Lighting = {
			Ambient = Color3.fromRGB(124, 124, 124);
			ColorShift_Bottom = Color3.fromRGB(22, 22, 22);
			FogColor = Color3.fromRGB(144,144,144);
			FogEnd = 2000
		};
		
		
		Terrain = {
			WaterColor = Color3.fromRGB(0,45,143);
			WaterReflectance = 0.12;
			WaterTransparency = 0.5;
		}
		
	}
}

--if game:GetService("RunService"):isStudio() then return end

local chosenLightingOption = lightingOptions.Realistic

local function changeLighting()
	for property,value in pairs(chosenLightingOption.Lighting) do
		game.Lighting[property] = value
	end
	
	for property,value in pairs(chosenLightingOption.Terrain) do
		workspace.Terrain[property] = value
	end
end

changeLighting()

game.Players.PlayerAdded:connect(function(plr)
	game.ReplicatedStorage.SharedDatabase.Remotes.FromServer.Message.ServerMessage:Fire(plr.Name .. " has entered the game")
end)
