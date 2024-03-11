require 'recipecode.lua'

function Recipe.GetItemTypes.SimpleGunParts(scriptItems)
	scriptItems:addAll(getScriptManager():getItemsTag("GunPartSimple"))
end

function Recipe.GetItemTypes.ModerateGunParts(scriptItems)
	scriptItems:addAll(getScriptManager():getItemsTag("GunPartModerate"))
end

function Recipe.GetItemTypes.ComplexGunParts(scriptItems)
	scriptItems:addAll(getScriptManager():getItemsTag("GunPartComplex"))
end

function Recipe.OnCreate.RepairFirearmPartALittle(items, _, player)
	for i=1,items:size() do
		local item = items:get(i-1)

		if item:getDisplayCategory() == "FirearmPart" then
			-- create new item of the same type as the input
			local actual = instanceItem(item:getFullType())

			-- copy mod data
			actual:copyModData(item:getModData())

			-- get improvement rating
			local improveAmount = 4
			if player:getPerkLevel(Perks.Gunsmith) > 2 then
				improveAmount = improveAmount + 1
			elseif player:getPerkLevel(Perks.Gunsmith) > 5 then
				improveAmount = improveAmount + 1
			end

			-- improve condition
			local condition = item:getCondition()
			condition = math.min(condition + improveAmount, actual:getConditionMax())
			actual:setCondition(condition)

			-- remove original item, add new
			player:getInventory():DoRemoveItem(item)
			player:getInventory():AddItem(actual)

			if player:getPrimaryHandItem() == item then
				player:setPrimaryHandItem(actual)
			end
			if player:getSecondaryHandItem() == item then
				player:setSecondaryHandItem(actual)
			end
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
