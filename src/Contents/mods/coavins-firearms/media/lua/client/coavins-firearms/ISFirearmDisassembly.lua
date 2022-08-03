require "ISUI/ISToolTip"
require "TimedActions/ISBaseTimedAction"

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

local pistols = {}
pistols["Pistol"] = true
pistols["Pistol2"] = true
pistols["Pistol3"] = true

local revolvers = {}
revolvers["Revolver"] = true
revolvers["Revolver_Short"] = true
revolvers["Revolver_Long"] = true

local isInTable = function(table, type)
	if table[type] then
		return true
	else
		return false
	end
end

local isPistol = function(type)
	return isInTable(pistols, type)
end

local isRevolver = function(type)
	return isInTable(revolvers, type)
end

local isValidFirearm = function(type)
	if isPistol(type)
	or isRevolver(type)
	then
		return true
	else
		return false
	end
end

local disassembleFirearm = function(player, item)
	player:getInventory():Remove(item)
	player:getInventory():AddItem("Coavins.PistolReceiver")
	player:getInventory():AddItem("Coavins.PistolSlide")
	player:getInventory():AddItem("Coavins.PistolBarrel")
end

local checkInventoryItem = function(player, context, item)
	local type = item:getType() -- Base.Pistol

	if not type then
		return
	end

	if item:getContainer() ~= player:getInventory() then
		return
	end

	if not isValidFirearm(type) then
		return
	end

	local option = context:addOption("Field Strip", player, disassembleFirearm, type, item)
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
