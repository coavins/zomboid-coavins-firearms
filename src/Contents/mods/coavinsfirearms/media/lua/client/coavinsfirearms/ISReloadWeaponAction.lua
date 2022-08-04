local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local handleJamChance = function(weapon)
	if weapon:getCondition() >= weapon:getConditionMax() then
		return
	end

	if weapon:getJamGunChance() > 0 and weapon:getCurrentAmmoCount() > 0 then
		local baseJamChance = weapon:getJamGunChance();

		if baseJamChance == 0 then
			return; -- magic gun that never jams i guess
		end

		-- every condition loss increase the chance of jamming the gun
		baseJamChance = baseJamChance + ((weapon:getConditionMax() - weapon:getCondition()) / 4)
		if baseJamChance > 7 then
			baseJamChance = 7;
		end

		if ZombRand(100) < baseJamChance then
			weapon:setJammed(true);
		end
	end
end

local realFn = ISReloadWeaponAction.onShoot

ISReloadWeaponAction.onShoot = function(player, weapon)
	-- Fallback to original function if mod isn't handling this weapon
	if not FIREARMS.itemIsFirearm(weapon) then
		return realFn(player, weapon)
	end

	-- What follows should be mostly what was taken from the original function

	if not weapon:isRanged() then return; end
	if getDebug() and getDebugOptions():getBoolean("Cheat.Player.UnlimitedAmmo") then
		return;
	end
	if weapon:haveChamber() then
		weapon:setRoundChambered(false);
	end
	if weapon:isRackAfterShoot() then
		-- shotgun need to be rack after each shot to rechamber round
		-- See ISReloadWeaponAction.OnPlayerAttackFinished()
		if weapon:haveChamber() then
			weapon:setSpentRoundChambered(true);
		end
	else
		-- automatic weapons eject the bullet cartridge
		if not weapon:isManuallyRemoveSpentRounds() then
			if weapon:getShellFallSound() then
				player:getEmitter():playSound(weapon:getShellFallSound())
			end
		end
		if weapon:getCurrentAmmoCount() >= weapon:getAmmoPerShoot() then
			-- remove ammo, add one to chamber if we still have some
			if weapon:haveChamber() then
				weapon:setRoundChambered(true);
			end
			weapon:setCurrentAmmoCount(weapon:getCurrentAmmoCount() - weapon:getAmmoPerShoot())
		end
	end
	if weapon:isManuallyRemoveSpentRounds() then
		weapon:setSpentRoundCount(weapon:getSpentRoundCount() + weapon:getAmmoPerShoot())
	end

	-- override the original functionality for handling jam chance
	handleJamChance(weapon)
end