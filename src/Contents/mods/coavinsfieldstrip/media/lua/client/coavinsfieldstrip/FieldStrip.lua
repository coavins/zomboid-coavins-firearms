local this = {}

-- indicates which model is used for each firearm in the game
this.typeModels = {}
this.typeModels["Base.Pistol"] = "Pistol"
this.typeModels["Base.Pistol2"] = "Pistol"
this.typeModels["Base.Pistol3"] = "Pistol"
--this.typeModels["Revolver"] = "revolver"
--this.typeModels["Revolver_Short"] = "revolver"
--this.typeModels["Revolver_Long"] = "revolver"

this.models = {}

this.getModel = function(modelName)
	return this.models[modelName]
end

this.models.Pistol = {}
this.models.Pistol.BreaksInto = { 'PistolReceiver', 'PistolSlide' }
this.models.Pistol.SaveTypeIn = 'PistolReceiver'
this.models.PistolReceiver = {}
this.models.PistolReceiver.CombinesWith = 'PistolSlide'
this.models.PistolReceiver.Forms = 'Pistol'
this.models.PistolSlide = {}
this.models.PistolSlide.CombinesWith = 'PistolReceiver'
this.models.PistolSlide.Forms = 'Pistol'
this.models.PistolSlide.Holds = { 'PistolBarrel' }
this.models.PistolBarrel = {}
this.models.PistolBarrel.InsertsInto = 'PistolSlide'

this.getFirearmModelForType = function(type)
	return this.typeModels[type]
end

return this
