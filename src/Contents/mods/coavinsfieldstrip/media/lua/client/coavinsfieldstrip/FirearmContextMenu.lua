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
		local model = FIELDSTRIP.getModel(item:getType())
		if not model then
			return
		end

		local subMenu = context:getNew(context)
		local doAssemble = false

		-- for each type that is compatible with this item
		local parts = player:getInventory():getAllTypeRecurse(model.CombinesWith)
		-- for each item of this type
		for k=0, parts:size() - 1 do
			local part = parts:get(k)
			subMenu:addOption(part:getName(), player, assembleFirearmParts, item, part)
			doAssemble = true
		end

		if doAssemble then
			local assembleOption = context:addOption(getText("ContextMenu_Firearm_Assemble"), item, nil)
			context:addSubMenu(assembleOption, subMenu)
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
