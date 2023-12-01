local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local ConditionLossChance = {
	0.5,
	1.0,
	1.5,
	2.0
}

local function OnPlayerAttackFinished(player, handWeapon)
	if handWeapon and FIREARMS.itemIsFirearm(handWeapon) then
		-- first, get the amount of condition lost from this attack
		local lowerChance = handWeapon:getConditionLowerChance()
		local maintenanceMod = player:getMaintenanceMod()
		local lossModifier = ConditionLossChance[SandboxVars.coavinsfirearms.ConditionLossChance]
		local conditionLoss = 0

		print(string.format('1: %.2f, 2: %.2f, 3: %.2f', lowerChance, lossModifier, maintenanceMod))

		local chance = (lowerChance * lossModifier) + (maintenanceMod * 2)

		if ZombRand(chance) == 0 then
			-- weapon sustained damage
			conditionLoss = 1
		end

		-- update the condition of the firearm to match its internal parts
		-- if any loss was incurred, each part will handle its own calculation
		FIREARMS.updateFirearm(handWeapon, conditionLoss)
	end
	--print(string.format('Condition is %.2f', handWeapon:getCondition()))
end

Events.OnPlayerAttackFinished.Add(OnPlayerAttackFinished)