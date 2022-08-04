local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local function OnPlayerAttackFinished(player, item)
	if FIREARMS.itemIsFirearm(item) then
		FIREARMS.updateFirearmCondition(item, 1)
	end
end

Events.OnPlayerAttackFinished.Add(OnPlayerAttackFinished)