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

local function AddTooltipForPartData(option, type, data)
	AddTooltip(option, FIREARMS.getTooltipTextForPartData(type, data), FIREARMS.getNameForPart(type), nil)
end

local function AddTooltipForPartItem(option, item)
	AddTooltip(option, FIREARMS.getTooltipTextForPartItem(item), item:getName(), item:getTex())
end

local function DisableOption(option, text)
	option.notAvailable = true
	AddTooltip(option, text)
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
	ISTimedActionQueue.add(ISInstallFirearmPart:new(player, item, part, 60*2))
end

local checkInventoryItem = function(player, context, item)
	local fullType = item:getFullType() -- Base.Pistol
	if not fullType then
		return
	end

	local type = item:getType() -- Pistol
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

	if cat == 'Weapon' and FIREARMS.getFirearmModelNameForFullType(fullType) then
		local option = context:addOption(getText("ContextMenu_Firearm_Disassemble"), player, disassembleFirearm, item)
		--if not isItemValid(player, type, item) then
		--DisableOption(option, "Unable")
		--end
	elseif cat == 'FirearmPart' then
		local model = FIREARMS.getPartModel(type)
		if not model then
			return
		end

		local data = FIREARMS.getModData(item)
		FIREARMS.initializeComponentModData(item)

		-- add info
		local infoOption = context:addOption(getText("ContextMenu_Firearm_AssemblyInfo"), item, nil)
		AddTooltipForPartItem(infoOption, item)

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
				AddTooltipForPartItem(option, part)
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
					local option = subMenuRemove:addOption(getItemNameFromFullType('coavinsfirearms.' .. heldPart), player, removePartFromPart, item, heldPart)
					AddTooltipForPartData(option, heldPart, data.parts[heldPart])
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
						AddTooltipForPartItem(option, part)
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
					AddTooltipForPartItem(option, part)
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
	end
end

local populateContextMenu = function(playerId, context, items)
	local player = getSpecificPlayer(playerId)

	items = ISInventoryPane.getActualItems(items)

	if #items > 1 then
		return
	end

	for _,k in ipairs(items) do
		--if instanceof(k, "InventoryItem") then
			checkInventoryItem(player, context, k)
		--end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(populateContextMenu)
