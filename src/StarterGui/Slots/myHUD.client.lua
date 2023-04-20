wait()
local fol_db = game:GetService("ReplicatedStorage").SharedDatabase;
local database = {
	blueprints = fol_db.Blueprints;
	myData = game.Players.LocalPlayer.PlayerData.Value;
}

local db_slotsContainer = database.myData.LocalData.QuickEquip
local slotsContainer = script.Parent.Slots

local qe_slots = script.Parent.Slots

local equipSlots = {

	slotContainer = {	
		{qe_slots.slot1; Enum.KeyCode.One};
		{qe_slots.slot2; Enum.KeyCode.Two};
		{qe_slots.slot3; Enum.KeyCode.Three};
		{qe_slots.slot4; Enum.KeyCode.Four};
	};
	
	func_equipSlot = function(self)
		local selectedSlot = nil
		game:GetService("UserInputService").InputEnded:Connect(function(key)
			for _,v in pairs(self.slotContainer) do
				if (key.KeyCode == v[2]) then
					if selectedSlot ~= v then -- When you are selected a different slot
						if selectedSlot ~= nil then
							selectedSlot[1].BorderSizePixel = 0
							--selectedSlot[1].BorderColor3 = Color3.fromRGB(76, 76, 76)
							selectedSlot[1].BackgroundColor3 = Color3.fromRGB(76, 76, 76)
						end
						selectedSlot = v
						selectedSlot[1].BorderSizePixel = 2
						selectedSlot[1].BorderColor3 = Color3.fromRGB(0, 170, 255)
						selectedSlot[1].BackgroundColor3 = Color3.fromRGB(0, 170, 255)
						if selectedSlot[1].SlotObject.Value ~= nil then
						--	print("Equipping")
							fol_db.Remotes.FromClient.SetToolState:FireServer(selectedSlot[1].SlotObject.Value, "equip")
						end
					else
						if selectedSlot ~= nil then
							selectedSlot[1].BorderSizePixel = 0
						--	selectedSlot[1].BorderColor3 = Color3.fromRGB(76, 76, 76)
							selectedSlot[1].BackgroundColor3 = Color3.fromRGB(76, 76, 76)
							fol_db.Remotes.FromClient.SetToolState:FireServer(selectedSlot[1].SlotObject.Value, "unequip")
						end
						selectedSlot = nil
					end
				end
			end
		end)	
	end;
	
	writeFunctions = function(self)
		self:func_equipSlot()
		for _,slot in pairs(db_slotsContainer:GetChildren()) do
			--print("Accessing : " .. typeof(slot))
			-- Update slot icon whenever the slot value updates.
			local function slotFunction(slot)
				local slotKey = slotsContainer[slot.Name]
				if slot.Value == nil then
					slotKey.SlotObject.Value = nil
					slotKey.ItemImage.Image = ""
					return			
				end
				
				slotKey.SlotObject.Value = slot.Value
				slotKey.ItemImage.Image = slot.Value.ItemImage.Image
			end
			slot:GetPropertyChangedSignal("Value"):Connect(function()
				slotFunction(slot)
			end)
		end
	end
}

equipSlots:writeFunctions()


