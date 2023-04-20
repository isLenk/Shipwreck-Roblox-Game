
wait(1)
-- Declarations
local remotes = game:GetService("ReplicatedStorage").SharedDatabase.Remotes
local editCharacter = remotes.FromClient:WaitForChild("EditCharacter")
local getCharacterEdit = remotes.FromServer:WaitForChild("GetCharacterEdit")

local datastore = game:GetService("DataStoreService")
local ds_characterCustomization = datastore:GetDataStore("Character_Customization_Saves")

editCharacter.OnServerInvoke = function(client, requestType, data)
	local CLIENT_KEY = client.Name .. "_" .. client.UserId 

	if requestType == "SAVE" and data then
		local paletteValues = "1,1,1,1,1,1";
		
		if data then
			if data[1] then	
			paletteValues = data[1]
			end
		end
		
		ds_characterCustomization:SetAsync(CLIENT_KEY, {paletteValues})	
		
	elseif requestType == "GET" then
		if ds_characterCustomization:GetAsync(CLIENT_KEY) ~= nil then
			return ds_characterCustomization:GetAsync(CLIENT_KEY)
		else
			return nil
		end
	end
end


getCharacterEdit.OnInvoke = function(client)
	local CLIENT_KEY = client.Name .. "_" .. client.UserId 
	
	if ds_characterCustomization:GetAsync(CLIENT_KEY) ~= nil then
		return ds_characterCustomization:GetAsync(CLIENT_KEY)
	else
		return nil
	end
end
