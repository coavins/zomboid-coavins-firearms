local this = {}

local nvl = function(a, b)
	if a then return a
	else return b
	end
end

this.itemIsFirearm = function(item)
	if not item then
		return false
	end

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

this.itemIsPart = function(item)
	if not item then
		return false
	end

	local cat = item:getDisplayCategory() -- Weapon
	if not cat then
		return false
	end

	if cat == 'FirearmPart' then
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
this.parts.PistolReceiver.ConditionLowerChance = 0 -- always when firearm incurs condition loss
this.parts.PistolReceiver.ConditionMax = 10
this.parts.PistolSlide = {}
this.parts.PistolSlide.CombinesWith = 'PistolReceiver'
this.parts.PistolSlide.Holds = { 'PistolBarrel' }
this.parts.PistolSlide.ConditionLowerChance = 1 -- 1/2
this.parts.PistolSlide.ConditionMax = 10
this.parts.PistolBarrel = {}
this.parts.PistolBarrel.InsertsInto = 'PistolSlide'
this.parts.PistolBarrel.ConditionLowerChance = 2 -- 1/3
this.parts.PistolBarrel.ConditionMax = 10

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

this.initializeFirearmModData = function(item)
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

this.initializeDataForPart = function(name, data)
	print("Initializing part: " .. name)
	local model = this.getPartModel(name)

	-- this function either creates a new table (and returns it)
	-- or uses the table that you provided
	if not data then
		data = {}
	end

	data.conditionLowerChance = nvl(data.conditionLowerChance, nvl(model.ConditionLowerChance, 0))
	data.conditionMax = nvl(data.conditionMax,nvl(model.ConditionMax, 10))
	data.condition = nvl(data.condition,data.conditionMax)

	if not data.parts then
		data.parts = {}
		if model.Holds then
			for _,k in ipairs(model.Holds) do
				data.parts[k] = this.initializeDataForPart(k)
			end
		end
	end

	return data
end

this.initializeComponentModData = function(item)
	local type = item:getType()
	local data = this.getModData(item)

	this.initializeDataForPart(type, data)
end

this.checkConditionForAllParts = function(model, installedParts, damage)
	local modelParts = nvl(nvl(model.BreaksInto, model.Holds), {})
	local lowestCondition = 10000.0

	-- for each part we're supposed to have
	for _,part in ipairs(modelParts) do
		local installedPart = installedParts[part]
		if installedPart then
			-- this part is installed
			if damage and damage > 0 then
				-- try to apply damage
				if ZombRand(installedPart.conditionLowerChance) == 0 then
					-- apply damage to this part
					print(string.format('Apply %.0f damage to %s', damage, part))
					installedPart.condition = installedPart.condition - damage
					if installedPart.condition < 0 then
						installedPart.condition = 0
					end
				end
			end

			print(string.format('%s has %.0f condition', part, installedPart.condition))

			-- remember lowest condition
			if installedPart.condition < lowestCondition then
				lowestCondition = installedPart.condition
			end

			-- recursively check this part's parts
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
this.updateFirearmCondition = function(firearm, conditionDamage)
	local type = firearm:getFullType()
	local model = this.getFirearmModelForFullType(type)
	local data = this.getModData(firearm)

	if not data.parts then
		this.initializeFirearmModData(firearm)
	end

	local lowestCondition = this.checkConditionForAllParts(model, data.parts, conditionDamage)
	local maxCondition = firearm:getConditionMax()

	if lowestCondition > maxCondition then
		lowestCondition = maxCondition
	end

	print(string.format('Set firearm to %.0f', lowestCondition))
	firearm:setCondition(lowestCondition)
end

this.getNameForPart = function(part)
	return getItemNameFromFullType('coavinsfirearms.' .. part)
end

this.getTooltipTextForPartItem = function(item)
	local type = item:getType()
	local data = this.getModData(item)
	return this.getTooltipText(type, data, item:getCondition(), item:getConditionMax())
end

this.getTooltipTextForPartData = function(type, data)
	local model = this.getPartModel(type)
	return this.getTooltipText(type, data, data.condition, model.ConditionMax)
end

this.getTooltipText = function(type, data, condition, conditionMax)
	local model = this.getPartModel(type)
	local text = ''

	if not data.parts then
		data.parts = {}
		data.parts[type] = this.initializeDataForPart(type)
	end

	-- show condition
	local conditionPct = (condition / conditionMax) * 100
	text = getText('Tooltip_weapon_Condition') .. ': ' .. string.format('%.0f%%', conditionPct)

	if model.Holds and data.parts then
		for _,part in ipairs(model.Holds) do
			local installedPart = data.parts[part]
			if text ~= '' then
				text = text .. ' <LINE> '
			end
			if installedPart then
				text = text .. this.getNameForPart(part) .. ': ' .. getText('ContextMenu_Firearm_Installed') .. ' (' .. string.format('%.1f', installedPart.condition) .. ')'
			else
				text = text .. ' <RGB:1,0,0> ' .. this.getNameForPart(part) .. ': ' .. getText('ContextMenu_Firearm_NotInstalled')
			end
		end
	end

	return text
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
