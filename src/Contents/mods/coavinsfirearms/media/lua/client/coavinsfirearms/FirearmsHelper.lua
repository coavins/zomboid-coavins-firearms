local this = {}

this.itemIsFirearm = function(item)
	local type = item:getFullType() -- Base.Pistol
	if not type then
		return false
	end
	local cat = item:getDisplayCategory() -- Weapon
	if not cat then
		return false
	end

	if cat == 'Weapon' and this.getFirearmModelNameForFullType(type) then
		return true
	end

	return false
end

-- indicates which model is used for each firearm in the game
this.typeModels = {}
this.typeModels["Base.Pistol"] = "Pistol"
this.typeModels["Base.Pistol2"] = "Pistol"
this.typeModels["Base.Pistol3"] = "Pistol"
--this.typeModels["Revolver"] = "Revolver"
--this.typeModels["Revolver_Short"] = "Revolver"
--this.typeModels["Revolver_Long"] = "Revolver"

this.getFirearmModelNameForFullType = function(type)
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

this.getFirearmModelForFullType = function(type)
	local modelName = this.getFirearmModelNameForFullType(type)
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
	if not item:getModData().coavinsfirearms then
		item:getModData().coavinsfirearms = {}
	end
	return item:getModData().coavinsfirearms
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

this.initializeDataForFirearm = function(item)
	local type = item:getFullType()
	local model = this.getFirearmModelForFullType(type)
	local data = this.getModData(item)

	if data.parts then
		return
	end

	print("Initializing firearm: " .. type)
	data.parts = {}

	for _,k in ipairs(model.BreaksInto) do
		data.parts[k] = this.initializeDataForPart(k)
	end
end

this.initializeDataForPart = function(name)
	print("Initializing part: " .. name)
	local model = this.getPartModel(name)
	local data = {}

	data.condition = 10
	data.parts = {}
	if model.Holds then
		for _,k in ipairs(model.Holds) do
			data.parts[k] = this.initializeDataForPart(k)
		end
	end

	return data
end

this.checkConditionForAllParts = function(model, installedParts, damage)
	local modelParts = {}
	if model.BreaksInto then
		modelParts = model.BreaksInto
	elseif model.Holds then
		modelParts = model.Holds
	end

	local lowestCondition = 10000.0

	-- for each part we're supposed to have
	for _,part in ipairs(modelParts) do
		local installedPart = installedParts[part]
		if installedPart then
			-- this part is installed
			if damage then
				installedPart.condition = installedPart.condition - damage
			end

			if installedPart.condition < lowestCondition then
				lowestCondition = installedPart.condition
			end

			if installedPart.parts then
				local lowest = this.checkConditionForAllParts(this.getPartModel(part), installedPart.parts, damage)
				if lowest < lowestCondition then
					lowestCondition = lowest
				end
			end
		else
			-- this part is not installed
			lowestCondition = 0
		end
	end

	return lowestCondition
end

-- updates firearm to match condition of most damaged part
-- optionally deals condition damage to parts
this.updateFirearmCondition = function(item, conditionDamage)
	local type = item:getFullType()
	local model = this.getFirearmModelForFullType(type)
	local data = this.getModData(item)

	if not data.parts then
		this.initializeDataForFirearm(item)
	end

	local lowestCondition = this.checkConditionForAllParts(model, data.parts, conditionDamage)
	item:setCondition(lowestCondition)
end

this.copyDataFromParent = function(parentItem, childItem)
	local parentData = this.getModData(parentItem)
	local childType = childItem:getType()
	local childData = this.getModData(childItem) -- don't reassign

	-- try to get data for this type from the parent
	local data = nil
	if parentData.parts then
		data = parentData.parts[childType]
	end

	local newData = {}
	if data then
		-- copy data to child
		newData = this.tableDeepCopy(data)
	else
		-- no data, this item hasn't been disassembled before
		newData = this.initializeDataForPart(childType)
	end

	childData.parts = newData.parts

	-- apply condition
	childItem:setCondition(newData.condition)
end

return this
