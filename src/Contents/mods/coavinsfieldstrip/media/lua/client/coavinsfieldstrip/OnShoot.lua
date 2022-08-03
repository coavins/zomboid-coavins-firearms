local FIELDSTRIP = require('coavinsfieldstrip/FieldStrip')

local function OnPlayerAttackFinished(character, handWeapon)
	FIELDSTRIP.updateFirearmCondition(handWeapon)
end

Events.OnPlayerAttackFinished.Add(OnPlayerAttackFinished)