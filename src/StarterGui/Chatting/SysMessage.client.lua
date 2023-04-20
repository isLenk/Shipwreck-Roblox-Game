--[[
	This script reads player key input and invokes messages to the server that'll replicate throughout all clients
	The chat will clean out 100 message old text
--]]

local prop = {
	tbChatBox = script.Parent.ChatBox.ChatBorder.Chat;
	messageTemplate = script:WaitForChild("MessageTemplate");
	chat = script.Parent.ChatBox.Chat;
	uiLayout = script:WaitForChild("UIListLayout")
}

local function setupChat()
	prop.chat:ClearAllChildren()
	prop.uiLayout:Clone().Parent = prop.chat
end

local oldMessageCap = 60;

local function getMessage(enterPressed)
	game.Players.LocalPlayer.PlayerData.Value.LocalData.Typing.Value = false
	if enterPressed and #prop.tbChatBox.Text:gsub(" ", "") ~= 0 then
		print(prop.tbChatBox.Text)
		game.ReplicatedStorage.SharedDatabase.Remotes.FromClient.SendMessage:FireServer(prop.tbChatBox.Text)
		prop.tbChatBox.Text = ""
	end
end

local function removeOldMessages()
	if #prop.chat:GetChildren()-1 > oldMessageCap then
		prop.chat["100"]:Destroy()
	end
end

local function onMessage(playerName, msg)

	for _,msg in pairs(prop.chat:GetChildren()) do
		if msg:isA("Frame") then
			-- Increment name by 1 e.x. 1 > 2
			msg.Name = tostring(tonumber(msg.Name) + 1)
		end
	end
	
	removeOldMessages()
	local msgTemp = prop.messageTemplate:Clone()
	msgTemp.Name = "1"
	msgTemp.Message.Text = ("%s: %s"):format(playerName,msg)
	msgTemp.Message.NameHighlight.Text = ("%s:"):format(playerName)
	
	if playerName == "SERVER" then
		msgTemp.BackgroundColor3 = Color3.fromRGB(85, 170, 127)
		msgTemp.Message.TextColor3 = Color3.fromRGB(0,0,0)
	end	
	
	msgTemp.Parent = prop.chat
	
	script.Parent.ChatBox.Chat.CanvasSize = UDim2.new(0,0,0,#script.Parent.ChatBox.Chat:GetChildren() * prop.messageTemplate.Size.Y.Offset)
	script.Parent.ChatBox.Chat.CanvasPosition = Vector2.new(0, script.Parent.ChatBox.Chat.CanvasSize.Y.Offset)
end

local function onInput(key)
	if (key.KeyCode == Enum.KeyCode.Slash) then
		game.Players.LocalPlayer.PlayerData.Value.LocalData.Typing.Value = true
		prop.tbChatBox:CaptureFocus()
	end	
end

prop.tbChatBox.FocusLost:Connect(getMessage)
setupChat()
game:GetService("UserInputService").InputEnded:Connect(onInput)
game:GetService("ReplicatedStorage").SharedDatabase.Remotes.FromServer:WaitForChild("Message").OnClientEvent:Connect(onMessage)