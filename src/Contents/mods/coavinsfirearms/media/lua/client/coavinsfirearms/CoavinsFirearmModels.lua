-- global singleton, do not override
CoavinsFirearmModels = {}

CoavinsFirearmModels.match = {}

function CoavinsFirearmModels:Include(fullType, model)
	self.match[fullType] = model
end

function CoavinsFirearmModels:GetModel(fullType)
	return self.match[fullType]
end
