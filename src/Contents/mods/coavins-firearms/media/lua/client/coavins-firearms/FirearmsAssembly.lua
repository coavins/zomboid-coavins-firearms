local this = {}

this.pistols = {}
this.pistols["Pistol"] = true
this.pistols["Pistol2"] = true
this.pistols["Pistol3"] = true

this.revolvers = {}
this.revolvers["Revolver"] = true
this.revolvers["Revolver_Short"] = true
this.revolvers["Revolver_Long"] = true

local isInTable = function(table, type)
	if table[type] then
		return true
	else
		return false
	end
end

this.isPistol = function(type)
	return isInTable(this.pistols, type)
end

this.isRevolver = function(type)
	return isInTable(this.revolvers, type)
end

this.isValidFirearm = function(type)
	if this.isPistol(type)
	or this.isRevolver(type)
	then
		return true
	else
		return false
	end
end


return this
