require "ISUI/ISToolTip"
local FIELDSTRIP = require('coavinsfieldstrip/FieldStrip')

local function newToolTip()
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	return toolTip;
end

local function DisableOption(option, text)
	option.notAvailable = true
	local tooltip = newToolTip();
	tooltip.description = text;
	option.toolTip = tooltip;
end

local disassembleFirearm = function(player, item)
	ISTimedActionQueue.add(ISDisassembleFirearm:new(player, item, 60*2))
end

local assembleFirearmParts = function(player, partA, partB)
	ISTimedActionQueue.add(ISAssembleFirearmParts:new(player, partA, partB, 60*3))
end

local removePartFromPart = function(player, item, partName)
	ISTimedActionQueue.add(ISRemoveFirearmPart:new(player, item, partName, 60*2))
end

local installFirearmPart = function(player, item, part)
end

local checkInventoryItem = function(player, context, item)
	local type = item:getFullType() -- Base.Pistol
	if not type then
		return
	end

	local cat = item:getDisplayCategory() -- Weapon
	if not cat then
		return
	end

	if item:getContainer() ~= player:getInventory() then
		return
	end

	if cat == 'Weapon' and FIELDSTRIP.getFirearmModelForType(type) then
		local option = context:addOption(getText("ContextMenu_Firearm_Disassemble"), player, disassembleFirearm, item)
		--if not isItemValid(player, type, item) then
		--DisableOption(option, "Unable")
		--end
	elseif cat == 'FirearmPart' then
		local model = FIELDSTRIP.getPartModel(item:getType())
		if not model then
			return
		end

		-- if this item can be combined with another part
		if model.CombinesWith then
			local subMenu = context:getNew(context)
			local doSubMenu = false

			-- for each type that is compatible with this item
			local parts = player:getInventory():getAllTypeRecurse(model.CombinesWith)
			-- for each item of this type
			for k=0, parts:size() - 1 do
				local part = parts:get(k)
				subMenu:addOption(part:getName(), player, assembleFirearmParts, item, part)
				doSubMenu = true
			end

			-- we have something to combine with
			if doSubMenu then
				local assembleOption = context:addOption(getText("ContextMenu_Firearm_Assemble"), item, nil)
				context:addSubMenu(assembleOption, subMenu)
			end
		end

		-- if something can be removed from this item
		if model.Holds then
			local subMenuInstall = context:getNew(context)
			local doInstall = false
			local subMenuRemove = context:getNew(context)
			local doRemove = false
			local data = FIELDSTRIP.getModData(item)

			-- for each part this item can hold
			for _,heldPart in ipairs(model.Holds) do
				if data[heldPart] then
					-- Add option to remove this part
					subMenuRemove:addOption(heldPart, player, removePartFromPart, item, heldPart)
					doRemove = true
				else
					-- Add option to install, if we have a matching part
					local parts = player:getInventory():getAllTypeRecurse(heldPart)
					-- for each item of this type
					for k=0, parts:size() - 1 do
						local part = parts:get(k)
						subMenuInstall:addOption(part:getName(), player, installFirearmPart, item, part)
						doInstall = true
					end
				end
			end

			if doInstall then
				local subOptionInstall = context:addOption(getText("ContextMenu_Firearm_InstallComponent"), item, nil)
				context:addSubMenu(subOptionInstall, subMenuInstall)
			end

			if doRemove then
				local subOptionRemove = context:addOption(getText("ContextMenu_Firearm_RemoveComponent"), item, nil)
				context:addSubMenu(subOptionRemove, subMenuRemove)
			end
		end
	end
end

local populateContextMenu = function(playerId, context, items)
	local player = getSpecificPlayer(playerId)

	items = ISInventoryPane.getActualItems(items)

	for _,k in pairs(items) do
		--if instanceof(k, "InventoryItem") then
			checkInventoryItem(player, context, k)
		--end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(populateContextMenu)
