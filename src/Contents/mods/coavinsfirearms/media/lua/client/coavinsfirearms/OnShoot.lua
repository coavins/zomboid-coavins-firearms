local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local function OnPlayerAttackFinished(player, handWeapon)
	if FIREARMS.itemIsFirearm(handWeapon) then
		-- first, get the amount of condition lost from this attack
		local lowerChance = handWeapon:getConditionLowerChance()
		local maintenanceMod = player:getMaintenanceMod()
		local conditionLoss = 0

		print(string.format('1: %.2f, 2: %.2f', lowerChance, maintenanceMod))

		local chance = lowerChance + (maintenanceMod * 2)

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