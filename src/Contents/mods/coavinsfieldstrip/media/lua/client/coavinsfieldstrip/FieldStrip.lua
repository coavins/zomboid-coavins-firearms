local this = {}

-- indicates which model is used for each firearm in the game
this.typeModels = {}
this.typeModels["Base.Pistol"] = "Pistol"
this.typeModels["Base.Pistol2"] = "Pistol"
this.typeModels["Base.Pistol3"] = "Pistol"
--this.typeModels["Revolver"] = "Revolver"
--this.typeModels["Revolver_Short"] = "Revolver"
--this.typeModels["Revolver_Long"] = "Revolver"

this.getFirearmModelForType = function(type)
	return this.typeModels[type]
end

this.firearms = {}
this.firearms.Pistol = {}
this.firearms.Pistol.BreaksInto = { 'PistolReceiver', 'PistolSlide' }
this.firearms.Pistol.SaveTypeIn = 'PistolReceiver'
this.firearms.Pistol.FallbackType = 'Base.Pistol'

this.getFirearmModel = function(modelName)
	return this.firearms[modelName]
end

this.parts = {}
this.parts.PistolReceiver = {}
this.parts.PistolReceiver.CombinesWith = 'PistolSlide'
this.parts.PistolReceiver.FormsFirearm = 'Pistol'
this.parts.PistolSlide = {}
this.parts.PistolSlide.CombinesWith = 'PistolReceiver'
this.parts.PistolSlide.Holds = { 'PistolBarrel' }
this.parts.PistolBarrel = {}
this.parts.PistolBarrel.InsertsInto = 'PistolSlide'

this.getPartModel = function(modelName)
	return this.parts[modelName]
end

this.getModData = function(item)
	if not item:getModData().coavinsfieldstrip then
		item:getModData().coavinsfieldstrip = {}
	end
	return item:getModData().coavinsfieldstrip
end

-- https://gist.github.com/MihailJP/3931841
this.tableDeepCopy = function(t)
	if type(t) ~= "table" then return t end
	local meta = getmetatable(t)
	local target = {}
	for k, v in pairs(t) do
			if type(v) == "table" then
					target[k] = this.tableDeepCopy(v)
			else
					target[k] = v
			end
	end
	setmetatable(target, meta)
	return target
end

return this
