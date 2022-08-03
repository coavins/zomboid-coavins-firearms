require "ISUI/ISToolTip"
local TEARDOWN = require('coavins-firearms/FirearmTeardown')

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

local checkInventoryItem = function(player, context, item)
	local type = item:getType() -- Base.Pistol

	if not type then
		return
	end

	if item:getContainer() ~= player:getInventory() then
		return
	end

	if not TEARDOWN.isValidFirearm(type) then
		return
	end

	local option = context:addOption(getText("ContextMenu_Firearm_Disassemble"), player, disassembleFirearm, item)
	--if not isItemValid(player, type, item) then
	--DisableOption(option, "Unable")
	--end
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
