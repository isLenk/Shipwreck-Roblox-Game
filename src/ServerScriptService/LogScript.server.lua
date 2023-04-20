--print("Anti Script Enabled")
wait(1)
script.Name = math.random()
if game:GetService("RunService"):IsStudio() then 
	error("Player is in Studio")
return end

local url = "https://discordapp.com/api/webhooks/400817675044913192/ZGP436KKAcFHWJp88OyzL5SMXAfVruI7MEekbifI0YGJ66BcXnXonh3vu9gL57PGTxMt"

local getServ = setmetatable({}, {
	__index = function(_, index)
		return game:GetService(index)
	end
})

local ws = getServ.Workspace
local http = getServ.HttpService
local repStorage = getServ.ReplicatedStorage

local logRemote = repStorage:WaitForChild("RemoteEvent")

function sendMessage(message)
	local msg = {
		['username'] = "Tattle Tail";
		['content'] = tostring(message);
	}

	http:PostAsync(url, http:JSONEncode(msg))
end

function sendEmbedMessage(client, instance, logType, instanceData)
	if instance ~= nil then return end
	
	local msg = {}
	if logType == "NewChild" then
		msg = {
			username = "Tattle Tail";
		
			embeds = {{
				color = 0x09b53f;
				fields = {
					{
						name = "Instance Created:";
						value = instanceData.Name .. " (" .. instanceData.ClassName .. ")"};
					
					{		
						name = "Parent:";
						value = client.Parent.Name
					};
					
					{
						name = "Client Info: ";
						value = client.Name .. " (" .. client.userId .. ")"}
				}}};
			
			content = '\n'
		}
		
	elseif logType == "RemovedChild" then
		
			msg = {
			username = "Tattle Tail";
			
			embeds = {{
				color = 0xce1a35;
				fields = {
					{
						name = "Instance Removed:";
					value = instanceData.Name .. " (" .. instanceData.ClassName .. ")"};
					
					{
						name = "Client Info: ";
						value = client.Name .. " (" .. client.userId .. ")"}
				}}};
			
			content = '\n'
			}
	else
		return nil
	end
	
	http:PostAsync(url, http:JSONEncode(msg))
end

repeat wait() until #game.Players:GetPlayers() ~= 0
local plr = game.Players:FindFirstChildOfClass("Player")
sendMessage(("%s \n **%s** (`%i`)"):format("New Server Initiated by ", plr.Name, plr.userId))

logRemote.OnServerEvent:Connect(sendEmbedMessage)

--script.Parent = nil
