local changelog = game:GetService("ReplicatedStorage").SharedDatabase.Remotes.FromClient:WaitForChild("Get_GameData"):InvokeServer("changelog")

script.Parent.Updates:ClearAllChildren()

script.UIListLayout:Clone().Parent = script.Parent.Updates
wait()
local indexNum = 0
for _,v in pairs(changelog) do
	local template = script.Template:Clone()
	template.Name = tostring("Upd",indexNum)
	template.UpdateText.Text = "v" .. v[1] .. ": " .. v[2]
	template.UpdateText.Version.Text = "v" .. v[1] .. ": "
	template.LayoutOrder = indexNum
	template.Parent = script.Parent.Updates
	indexNum = indexNum + 1
end

script.Parent.Updates.CanvasSize = UDim2.new(0,0,0,(#changelog * script.Template.Size.Y.Offset) + 25)