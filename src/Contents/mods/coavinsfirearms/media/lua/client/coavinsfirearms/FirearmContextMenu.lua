require "ISUI/ISToolTip"
local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local function newToolTip()
	local toolTip = ISToolTip:new()
	toolTip:initialise()
	toolTip:setVisible(false)
	return toolTip
end

local function AddTooltip(option, text, name, texture)
	local tooltip = newToolTip()
	tooltip.description = text
	tooltip.texture = texture
	tooltip:setName(name)
	option.toolTip = tooltip
end

local function AddTooltipForData(option, type, data)
	local tex = getTexture('media/textures/Item_' .. type .. '.png')
	AddTooltip(option, FIREARMS.getTooltipTextForPartData(type, data), FIREARMS.getNameForPart(type), tex)
end

local function AddTooltipForItem(option, item)
	AddTooltip(option, FIREARMS.getTooltipTextForItem(item), item:getName(), item:getTex())
end

local function DisableOption(option, text)
	option.notAvailable = true
	AddTooltip(option, text)
end

local disassembleFirearm = function(player, item)
	ISInventoryPaneContextMenu.unequipItem(item, player:getPlayerNum())
	ISTimedActionQueue.add(ISDisassembleFirearm:new(player, item, 60*2))
end

local assembleFirearmParts = function(player, partA, partB)
	ISTimedActionQueue.add(ISAssembleFirearmParts:new(player, partA, partB, 60*3))
end

local removePartFromPart = function(player, item, partName)
	ISTimedActionQueue.add(ISRemoveFirearmPart:new(player, item, partName, 60*2))
end

local installFirearmPart = function(player, item, part)
	ISInventoryPaneContextMenu.equipWeapon(part, false, false, player:getPlayerNum());
	ISTimedActionQueue.add(ISInstallFirearmPart:new(player, item, part, 60*2))
end

local checkInventoryItem = function(player, context, item)
	if item:getContainer() ~= player:getInventory() then
		return
	end

	if FIREARMS.itemIsFirearm(item) then
		-- add info
		local infoOption = context:addOption(getText("ContextMenu_Firearm_AssemblyInfo"), item, nil)
		AddTooltipForItem(infoOption, item)

		local option = context:addOption(getText("ContextMenu_Firearm_Disassemble"), player, disassembleFirearm, item)

		-- Check if disassembly is not allowed
		local disableText = ''

		-- Upgrades must be removed
		if item:getAllWeaponParts():size() > 0 then
			disableText = disableText .. getText('ContextMenu_Firearm_ErrorHasAttachments') .. ' '
		end

		if item:getMagazineType() then
			-- Magazine must be ejected
			if item:isContainsClip() then
				disableText = disableText .. getText('ContextMenu_Firearm_ErrorHasMagazine') .. ' '
			end
		else
			-- Rounds must be ejected from internal magazine
			if item:getCurrentAmmoCount() > 0 then
				disableText = disableText .. getText('ContextMenu_Firearm_ErrorHasRounds') .. ' '
			end
			-- Chamber must be cleared
			if item:isRoundChambered() then
				disableText = disableText .. getText('ContextMenu_Firearm_ErrorNotCleared') .. ' '
			end
		end

		if disableText ~= '' then
			DisableOption(option, disableText)
		end

	elseif FIREARMS.itemIsPart(item) then
		local type = item:getType() -- Pistol
		local model = FIREARMS.getPartModel(type)
		if not model then
			return
		end

		local data = FIREARMS.getModData(item)
		FIREARMS.initializeComponentModData(item)

		-- add info
		local infoOption = context:addOption(getText("ContextMenu_Firearm_AssemblyInfo"), item, nil)
		AddTooltipForItem(infoOption, item)

		-- if this item can be combined with another part
		if model.CombinesWith then
			local subMenu = context:getNew(context)
			local lackingParts = true

			-- for each type that is compatible with this item
			local parts = player:getInventory():getAllTypeRecurse(model.CombinesWith)
			-- for each item of this type
			for k=0, parts:size() - 1 do
				local part = parts:get(k)
				local option = subMenu:addOption(part:getName(), player, assembleFirearmParts, item, part)
				AddTooltipForItem(option, part)
				lackingParts = false
			end

			-- put a placeholder if we don't have any options
			if lackingParts then
				local itemName = FIREARMS.getNameForPart(model.CombinesWith)
				local option = subMenu:addOption(itemName, player, nil)
				DisableOption(option, getText('ContextMenu_Firearm_NotFound', itemName))
			end

			local assembleOption = context:addOption(getText("ContextMenu_Firearm_Assemble"), item, nil)
			context:addSubMenu(assembleOption, subMenu)
		end

		if model.InsertsInto then
			local subMenuInstall = context:getNew(context)
			local lackingParts = true

			-- Add option to install
			local parts = player:getInventory():getAllTypeRecurse(model.InsertsInto)
			-- for each item of this type
			for k=0, parts:size() - 1 do
				local part = parts:get(k)
				FIREARMS.initializeComponentModData(part)
				local partData = FIREARMS.getModData(part)
				-- if a part of this type is not already installed
				if not partData.parts[type] then
					local option = subMenuInstall:addOption(part:getName(), player, installFirearmPart, part, item)
					AddTooltipForItem(option, part)
					lackingParts = false
				end
			end

			if lackingParts then
				local itemName = FIREARMS.getNameForPart(model.InsertsInto)
				local option = subMenuInstall:addOption(itemName, player, nil)
				DisableOption(option, getText('ContextMenu_Firearm_NotFoundEmpty', itemName))
			end

			local option = context:addOption(getText("ContextMenu_Firearm_InstallInto"), item, nil)
			context:addSubMenu(option, subMenuInstall)
		end

		-- if something can be removed from this item
		if model.Holds then
			local subMenuInstall = context:getNew(context)
			local doInstall = false
			local subMenuRemove = context:getNew(context)
			local doRemove = false

			-- for each part this item can hold
			for _,heldPart in ipairs(model.Holds) do
				if data.parts and data.parts[heldPart] then
					-- Add option to remove this part
					local optionText = getItemNameFromFullType('coavinsfirearms.' .. heldPart)
					local option = subMenuRemove:addOption(optionText, player, removePartFromPart, item, heldPart)
					AddTooltipForData(option, heldPart, data.parts[heldPart])
					doRemove = true
				else
					doInstall = true
					local lackingParts = true
					-- Add option to install, if we have a matching part
					local parts = player:getInventory():getAllTypeRecurse(heldPart)
					-- for each item of this type
					for k=0, parts:size() - 1 do
						local part = parts:get(k)
						local option = subMenuInstall:addOption(part:getName(), player, installFirearmPart, item, part)
						AddTooltipForItem(option, part)
						lackingParts = false
					end

					if lackingParts then
						local itemName = FIREARMS.getNameForPart(heldPart)
						local option = subMenuInstall:addOption(itemName, player, nil)
						DisableOption(option, getText('ContextMenu_Firearm_NotFound', itemName))
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

	if #items > 1 then
		return
	end

	for _,k in ipairs(items) do
		checkInventoryItem(player, context, k)
	end
end

Events.OnFillInventoryObjectContextMenu.Add(populateContextMenu)
