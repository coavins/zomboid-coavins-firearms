require "ISUI/ISToolTip"
local ASSEMBLY = require('coavins-firearms/FirearmsAssembly')

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
	ISTimedActionQueue.add(ISDisassembleFirearm:new(player, item, 60*4))
end

local assembleFirearmParts = function(partA, partB)
	-- assemble parts
end

local checkInventoryItem = function(player, context, item)
	local type = item:getType() -- Base.Pistol

	if not type then
		return
	end

	if item:getContainer() ~= player:getInventory() then
		return
	end

	if ASSEMBLY.isValidFirearm(type) then
		local option = context:addOption(getText("ContextMenu_Firearm_Disassemble"), player, disassembleFirearm, item)
		--if not isItemValid(player, type, item) then
		--DisableOption(option, "Unable")
		--end
	elseif ASSEMBLY.isValidFirearmPart(type) then
		local subMenu = context:getNew(context)

		local types = ASSEMBLY.getCompatibleParts(type)
		-- for each type that is compatible with this item
		for _,i in ipairs(types) do
			local parts = player:getInventory():getAllTypeRecurse(i)
			-- for each item of this type
			for k=0, parts:size() - 1 do
				local part = parts:get(k)
				subMenu:addOption(part:getName(), item, assembleFirearmParts, part)
			end
		end

		local assembleOption = context:addOption(getText("ContextMenu_Firearm_Assemble"), item, nil)
		context:addSubMenu(assembleOption, subMenu)
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
