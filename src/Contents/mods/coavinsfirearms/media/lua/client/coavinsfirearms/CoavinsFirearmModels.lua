-- global singleton, do not override
CoavinsFirearms = {}

CoavinsFirearms.match = {}

function CoavinsFirearms:Include(fullType, model)
	self.match[fullType] = model
end

function CoavinsFirearms:GetModel(fullType)
	return self.match[fullType]
end
