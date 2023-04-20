--[[
	@purp - Equip/Dequip given slot data
--]]

local remote_setToolState = game:GetService("ReplicatedStorage").SharedDatabase.Remotes.FromClient:WaitForChild("SetToolState")
local myData = game.Players.LocalPlayer.PlayerData.Value

local mySlots = myData.LocalData.QuickEquip

local slotData = { 
	
	equipItem = function(slot)
		remote_setToolState:FireServer(slot, "equip")
	end;
	
	checkSlotKey = function(self, key)
		if key.KeyCode == Enum.KeyCode.One then
			self.equipItem(mySlots.slot1)
		elseif key.KeyCode == Enum.KeyCode.Two then
			self.equipItem(mySlots.slot2)
		elseif key.KeyCode == Enum.KeyCode.Three then
			self.equipItem(mySlots.slot3)
		elseif key.KeyCode == Enum.KeyCode.Four then
			self.equipItem(mySlots.slot4)
		end
	end
}
