local Recipe = Recipe

--[[
local function addExistingItemType(scriptItems, type)
	local all = getScriptManager():getItemsByType(type)
	for i=1,all:size() do
		local scriptItem = all:get(i-1)
		if not scriptItems:contains(scriptItem) then
			scriptItems:add(scriptItem)
		end
	end
end
]]

function Recipe.GetItemTypes.SimpleGunParts(scriptItems)
	scriptItems:addAll(getScriptManager():getItemsTag("GunPartSimple"))
end

function Recipe.GetItemTypes.ModerateGunParts(scriptItems)
	scriptItems:addAll(getScriptManager():getItemsTag("GunPartModerate"))
end

function Recipe.GetItemTypes.ComplexGunParts(scriptItems)
	scriptItems:addAll(getScriptManager():getItemsTag("GunPartComplex"))
end

function Recipe.OnTest.GunPartIsDamaged(item)
	if item:getDisplayCategory() ~= "FirearmPart" then
		return true
	end

	if item:getCondition() < item:getConditionMax() then
		return true
	else
		return false
	end
end

local function repairPart(itemToRepair, improveAmount, player)
	if itemToRepair:getDisplayCategory() ~= "FirearmPart" then
		return
	end

	-- create new item of the same type as the input
	local actual = instanceItem(itemToRepair:getFullType())

	-- copy mod data
	actual:copyModData(itemToRepair:getModData())

	-- higher skill means better repair job
	if player:getPerkLevel(Perks.Gunsmith) > 2 then
		improveAmount = improveAmount + 1
	elseif player:getPerkLevel(Perks.Gunsmith) > 5 then
		improveAmount = improveAmount + 1
	end

	-- improve condition
	local condition = itemToRepair:getCondition()
	condition = math.min(condition + improveAmount, actual:getConditionMax())
	actual:setCondition(condition)

	-- remove original item, add new
	player:getInventory():DoRemoveItem(itemToRepair)
	player:getInventory():AddItem(actual)

	if player:getPrimaryHandItem() == itemToRepair then
		player:setPrimaryHandItem(actual)
	end
	if player:getSecondaryHandItem() == itemToRepair then
		player:setSecondaryHandItem(actual)
	end
end

function Recipe.OnCreate.RepairFirearmPartALittle(items, _, player)
	for i=1,items:size() do
		local item = items:get(i-1)

		if item:getDisplayCategory() == "FirearmPart" then
			repairPart(item, 4, player)
		end
	end
end

function Recipe.OnCreate.RepairFirearmPartSome(items, _, player)
	for i=1,items:size() do
		local item = items:get(i-1)

		if item:getDisplayCategory() == "FirearmPart" then
			repairPart(item, 8, player)
		end
	end
end

function Recipe.OnCreate.RepairFirearmPartALot(items, _, player)
	for i=1,items:size() do
		local item = items:get(i-1)

		if item:getDisplayCategory() == "FirearmPart" then
			repairPart(item, 12, player)
		end
	end
end

function Recipe.OnCreate.RepairFirearmPartATon(items, _, player)
	for i=1,items:size() do
		local item = items:get(i-1)

		if item:getDisplayCategory() == "FirearmPart" then
			repairPart(item, 18, player)
		end
	end
end

function Recipe.OnGiveXP.GunsmithingNotMuch(_, _, _, player)
	if player:getPerkLevel(Perks.Gunsmith) < 3 then
		player:getXp():AddXP(Perks.Gunsmith, 20);
	elseif player:getPerkLevel(Perks.Gunsmith) < 6 then
		player:getXp():AddXP(Perks.Gunsmith, 10);
	else
		player:getXp():AddXP(Perks.Gunsmith, 5);
	end
end

function Recipe.OnGiveXP.GunsmithingSome(_, _, _, player)
	if player:getPerkLevel(Perks.Gunsmith) < 3 then
		player:getXp():AddXP(Perks.Gunsmith, 40);
	elseif player:getPerkLevel(Perks.Gunsmith) < 6 then
		player:getXp():AddXP(Perks.Gunsmith, 20);
	else
		player:getXp():AddXP(Perks.Gunsmith, 15);
	end
end

function Recipe.OnGiveXP.GunsmithingALot(_, _, _, player)
	if player:getPerkLevel(Perks.Gunsmith) < 3 then
		player:getXp():AddXP(Perks.Gunsmith, 80);
	elseif player:getPerkLevel(Perks.Gunsmith) < 6 then
		player:getXp():AddXP(Perks.Gunsmith, 50);
	else
		player:getXp():AddXP(Perks.Gunsmith, 30);
	end
end
