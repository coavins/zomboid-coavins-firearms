local FIREARMS = require('coavinsfirearms/FirearmsHelper')

-- global singleton, do not override
CoavinsFirearms = {}

-- "private" matching table
local match = {}

function CoavinsFirearms.Include(fullType, model)
	match[fullType] = model
end

function CoavinsFirearms.GetModelName(fullType)
	return match[fullType]
end

function CoavinsFirearms.GetMatches()
	return FIREARMS.tableDeepCopy(match)
end

local models = {}

function CoavinsFirearms.AddOrReplaceModel(name, breaksInto, saveTypeIn, fallbackType)
	local newModel = {}
	newModel.BreaksInto = breaksInto
	newModel.SaveTypeIn = saveTypeIn
	newModel.FallbackType = fallbackType

	models[name] = newModel
end

function CoavinsFirearms.GetModel(name)
	return models[name]
end

function CoavinsFirearms.GetModels()
	local ret = FIREARMS.tableDeepCopy(models)
	return ret
end
