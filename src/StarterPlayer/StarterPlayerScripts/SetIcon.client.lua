--[[
	@purp - Set mouse icon to given asset id
--]]

local iconDecals = {
	interact = "rbxassetid://1082136708";
	hide = "rbxassetid://1082139056"
}


game:GetService("ContentProvider"):PreloadAsync({iconDecals.hide, iconDecals.interact})

function setIcon(icon)
	game.Players.LocalPlayer:GetMouse().Icon = icon
end

setIcon(iconDecals.hide)

--game:GetService("UserInputService").MouseIconEnabled = false