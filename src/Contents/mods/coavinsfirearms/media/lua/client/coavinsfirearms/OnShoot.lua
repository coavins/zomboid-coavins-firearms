local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local function OnPlayerAttackFinished(_, handWeapon)
	if FIREARMS.itemIsFirearm(handWeapon) then
		-- first, get the amount of condition lost from this attack
		local chance = handWeapon:getConditionLowerChance();
		local conditionLoss = 0

		if ZombRand(chance) == 0 then
			-- weapon sustained damage
			conditionLoss = 1
		end

		-- update the condition of the firearm to match its internal parts
		-- if any loss was incurred, each part will handle its own calculation
		FIREARMS.updateFirearm(handWeapon, conditionLoss)
	end
	print(string.format('Condition is %.2f', handWeapon:getCondition()))
end

Events.OnPlayerAttackFinished.Add(OnPlayerAttackFinished)