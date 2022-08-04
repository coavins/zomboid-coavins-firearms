local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local function OnPlayerAttackFinished(character, handWeapon)
	FIREARMS.updateFirearmCondition(handWeapon)
end

Events.OnPlayerAttackFinished.Add(OnPlayerAttackFinished)