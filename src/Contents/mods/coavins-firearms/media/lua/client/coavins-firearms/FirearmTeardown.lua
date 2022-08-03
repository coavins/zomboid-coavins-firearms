local FirearmTeardown = {}

FirearmTeardown.pistols = {}
FirearmTeardown.pistols["Pistol"] = true
FirearmTeardown.pistols["Pistol2"] = true
FirearmTeardown.pistols["Pistol3"] = true

FirearmTeardown.revolvers = {}
FirearmTeardown.revolvers["Revolver"] = true
FirearmTeardown.revolvers["Revolver_Short"] = true
FirearmTeardown.revolvers["Revolver_Long"] = true

local isInTable = function(table, type)
	if table[type] then
		return true
	else
		return false
	end
end

FirearmTeardown.isPistol = function(type)
	return isInTable(FirearmTeardown.pistols, type)
end

FirearmTeardown.isRevolver = function(type)
	return isInTable(FirearmTeardown.revolvers, type)
end

FirearmTeardown.isValidFirearm = function(type)
	if FirearmTeardown.isPistol(type)
	or FirearmTeardown.isRevolver(type)
	then
		return true
	else
		return false
	end
end

return FirearmTeardown
