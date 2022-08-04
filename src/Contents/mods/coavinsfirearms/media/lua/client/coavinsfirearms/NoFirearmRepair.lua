local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local removeRepairForFirearms = function(playerId, context, items)
	local brokenObject = nil
	for i,v in ipairs(items) do
		local testItem = v
		if not instanceof(v, "InventoryItem") then
			testItem = v.items[1];
		end
		if testItem:isBroken() or testItem:getCondition() < testItem:getConditionMax() then
			brokenObject = testItem;
		end
	end

	if brokenObject and FIREARMS.itemIsFirearm(brokenObject) then
		local optionName = getText("ContextMenu_Repair") .. getItemNameFromFullType(brokenObject:getFullType())
		context:removeOptionByName(optionName)
	end
end

Events.OnFillInventoryObjectContextMenu.Add(removeRepairForFirearms)
