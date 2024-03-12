local function addProfessionGunsmith()
	local gunsmith = ProfessionFactory.addProfession("gunsmith", getText("UI_prof_gunsmith"), "profession_veteran2", 2);
	gunsmith:addXPBoost(Perks.Gunsmith, 4)
	gunsmith:addXPBoost(Perks.Maintenance, 1)
	BaseGameCharacterDetails.SetProfessionDescription(gunsmith)

	local veteran = ProfessionFactory.getProfession("veteran")
	if veteran then
		veteran:addXPBoost(Perks.Gunsmith, 2)
		BaseGameCharacterDetails.SetProfessionDescription(veteran)
	end

	local policeofficer = ProfessionFactory.getProfession("policeofficer")
	if policeofficer then
		policeofficer:addXPBoost(Perks.Gunsmith, 1)
		BaseGameCharacterDetails.SetProfessionDescription(policeofficer)
	end
end

Events.OnGameBoot.Add(addProfessionGunsmith);
