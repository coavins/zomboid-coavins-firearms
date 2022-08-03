local this = {}

this.pistols = {}
this.pistols["Pistol"] = true
this.pistols["Pistol2"] = true
this.pistols["Pistol3"] = true

this.revolvers = {}
this.revolvers["Revolver"] = true
this.revolvers["Revolver_Short"] = true
this.revolvers["Revolver_Long"] = true

this.parts = {}
this.parts["PistolFrame"] = true
this.parts["PistolSlide"] = true
this.parts["PistolBarrel"] = true

this.match = {}
this.match["PistolFrame"] = { "PistolSlide" }
this.match["PistolSlide"] = { "PistolFrame", "PistolBarrel" }
this.match["PistolBarrel"] = { "PistolSlide" }

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

this.isValidFirearmPart = function(type)
	return isInTable(this.parts, type)
end

this.getCompatibleParts = function(type)
	return this.match[type]
end

return this
