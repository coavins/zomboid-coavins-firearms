local this = {}

local nvl = function(a, b)
	if a then return a
	else return b
	end
end

this.getFirearmModelNameForItem = function(item)
	if not item then
		return
	end

	local fullType = item:getFullType() -- Base.Pistol
	if not fullType then
		return
	end

	return CoavinsFirearms:GetModel(fullType)
end

this.itemIsFirearm = function(item)
	if this.getFirearmModelNameForItem(item) then
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

this.firearms = {}
this.firearms.GenericPistol = {}
this.firearms.GenericPistol.BreaksInto = { 'PistolReceiver', 'PistolSlide' }
this.firearms.GenericPistol.SaveTypeIn = 'PistolReceiver'
this.firearms.GenericPistol.FallbackType = 'Base.Pistol'
this.firearms.GenericRevolver = {}
this.firearms.GenericRevolver.BreaksInto = { 'RevolverReceiver', 'RevolverCylinder' }
this.firearms.GenericRevolver.SaveTypeIn = 'RevolverReceiver'
this.firearms.GenericRevolver.FallbackType = 'Base.Revolver'
this.firearms.GenericShotgun = {} -- should also work for break action
this.firearms.GenericShotgun.BreaksInto = { 'ShotgunReceiver', 'ShotgunBarrel' }
this.firearms.GenericShotgun.SaveTypeIn = 'ShotgunReceiver'
this.firearms.GenericShotgun.FallbackType = 'Base.Shotgun'
this.firearms.M16Rifle = {}
this.firearms.M16Rifle.BreaksInto = { 'M16UpperReceiver', 'M16LowerReceiver' }
this.firearms.M16Rifle.SaveTypeIn = 'M16LowerReceiver'
this.firearms.M16Rifle.FallbackType = 'Base.AssaultRifle'
this.firearms.BoltActionRifle = {}
this.firearms.BoltActionRifle.BreaksInto = { 'BoltActionReceiver', 'BoltActionBolt'}
this.firearms.BoltActionRifle.SaveTypeIn = 'BoltActionReceiver'
this.firearms.BoltActionRifle.FallbackType = 'Base.VarmintRifle'

this.getFirearmModelForItem = function(item)
	local modelName = this.getFirearmModelNameForItem(item)
	if modelName then
		return this.firearms[modelName]
	else
		return nil
	end
end

this.parts = {}
this.parts.PistolReceiver = {}
this.parts.PistolReceiver.CombinesWith = 'PistolSlide'
this.parts.PistolReceiver.ConditionLowerChance = 1 -- 100%
this.parts.PistolReceiver.ConditionMax = 10
this.parts.PistolSlide = {}
this.parts.PistolSlide.CombinesWith = 'PistolReceiver'
this.parts.PistolSlide.Holds = { 'PistolBarrel' }
this.parts.PistolSlide.ConditionLowerChance = 2 -- 1/2
this.parts.PistolSlide.ConditionMax = 10
this.parts.PistolBarrel = {}
this.parts.PistolBarrel.InsertsInto = 'PistolSlide'
this.parts.PistolBarrel.ConditionLowerChance = 3 -- 1/3
this.parts.PistolBarrel.ConditionMax = 10
this.parts.RevolverReceiver = {}
this.parts.RevolverReceiver.CombinesWith = 'RevolverCylinder'
this.parts.RevolverReceiver.ConditionLowerChance = 1
this.parts.RevolverReceiver.ConditionMax = 10
this.parts.RevolverCylinder = {}
this.parts.RevolverCylinder.CombinesWith = 'RevolverReceiver'
this.parts.RevolverCylinder.ConditionLowerChance = 3
this.parts.RevolverCylinder.ConditionMax = 10
this.parts.ShotgunReceiver = {}
this.parts.ShotgunReceiver.CombinesWith = 'ShotgunBarrel'
this.parts.ShotgunReceiver.Holds = { 'ShotgunForend' }
this.parts.ShotgunReceiver.ConditionLowerChance = 1
this.parts.ShotgunReceiver.ConditionMax = 10
this.parts.ShotgunForend = {}
this.parts.ShotgunForend.InsertsInto = 'ShotgunReceiver'
this.parts.ShotgunForend.Holds = { 'ShotgunBoltCarrier' }
this.parts.ShotgunForend.ConditionLowerChance = 2
this.parts.ShotgunForend.ConditionMax = 10
this.parts.ShotgunBoltCarrier = {}
this.parts.ShotgunBoltCarrier.InsertsInto = 'ShotgunForend'
this.parts.ShotgunBoltCarrier.Holds = { 'ShotgunBolt' }
this.parts.ShotgunBoltCarrier.ConditionLowerChance = 4
this.parts.ShotgunBoltCarrier.ConditionMax = 10
this.parts.ShotgunBolt = {}
this.parts.ShotgunBolt.InsertsInto = 'ShotgunBoltCarrier'
this.parts.ShotgunBolt.ConditionLowerChance = 3
this.parts.ShotgunBolt.ConditionMax = 10
this.parts.ShotgunBarrel = {}
this.parts.ShotgunBarrel.CombinesWith = 'ShotgunReceiver'
this.parts.ShotgunBarrel.ConditionLowerChance = 3
this.parts.ShotgunBarrel.ConditionMax = 10
this.parts.BoltActionReceiver = {}
this.parts.BoltActionReceiver.CombinesWith = 'BoltActionBolt'
this.parts.BoltActionReceiver.ConditionLowerChance = 1
this.parts.BoltActionReceiver.ConditionMax = 10
this.parts.BoltActionBolt = {}
this.parts.BoltActionBolt.CombinesWith = 'BoltActionReceiver'
this.parts.BoltActionBolt.ConditionLowerChance = 3
this.parts.BoltActionBolt.ConditionMax = 10
this.parts.M16LowerReceiver = {}
this.parts.M16LowerReceiver.CombinesWith = 'M16UpperReceiver'
this.parts.M16LowerReceiver.ConditionLowerChance = 2
this.parts.M16LowerReceiver.ConditionMax = 10
this.parts.M16UpperReceiver = {}
this.parts.M16UpperReceiver.CombinesWith = 'M16LowerReceiver'
this.parts.M16UpperReceiver.Holds = { 'M16BoltCarrier' }
this.parts.M16UpperReceiver.ConditionLowerChance = 2
this.parts.M16UpperReceiver.ConditionMax = 10
this.parts.M16BoltCarrier = {}
this.parts.M16BoltCarrier.InsertsInto = 'M16UpperReceiver'
this.parts.M16BoltCarrier.Holds = { 'M16FiringPin', 'M16Bolt' }
this.parts.M16BoltCarrier.ConditionLowerChance = 3
this.parts.M16BoltCarrier.ConditionMax = 10
this.parts.M16FiringPin = {}
this.parts.M16FiringPin.InsertsInto = 'M16BoltCarrier'
this.parts.M16FiringPin.ConditionLowerChance = 4
this.parts.M16FiringPin.ConditionMax = 10
this.parts.M16Bolt = {}
this.parts.M16Bolt.InsertsInto = 'M16BoltCarrier'
this.parts.M16Bolt.ConditionLowerChance = 2
this.parts.M16Bolt.ConditionMax = 10

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

this.initializeFirearmModData = function(firearm)
	local model = this.getFirearmModelForItem(firearm)
	if not model then
		return
	end
	local type = firearm:getFullType()
	local data = this.getModData(firearm)

	if not data.parts then
		print("Initializing firearm: " .. type)
		data.parts = {}

		for _,k in ipairs(model.BreaksInto) do
			data.parts[k] = this.initializeDataForPart(k, nil, true) -- looted guns always have all their parts
		end

		this.updateFirearm(firearm)
	end
end

this.initializeDataForPart = function(type, data, guaranteedParts)
	print("Initializing part: " .. type)
	local model = this.getPartModel(type)

	-- this function either creates a new table (and returns it)
	-- or uses the table that you provided
	if not data then
		data = {}
	end

	if not data.conditionLowerChance then
		data.conditionLowerChance = nvl(model.ConditionLowerChance, 0)
	end

	if not data.conditionMax then
		data.conditionMax = nvl(model.ConditionMax, 10)
	end

	if not data.condition then
		data.condition = ZombRand(data.conditionMax * 0.7, data.conditionMax)
	end

	if not data.parts then
		data.parts = {}
		if model.BreaksInto then
			for _,k in ipairs(model.BreaksInto) do
				data.parts[k] = this.initializeDataForPart(k, nil, guaranteedParts)
			end
		end
		if model.Holds then
			for _,k in ipairs(model.Holds) do
				-- 50% chance for this part to be missing
				if guaranteedParts or ZombRand(2) == 0 then
					data.parts[k] = this.initializeDataForPart(k, nil, guaranteedParts)
				end
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
this.updateFirearm = function(firearm, conditionDamage)
	local model = this.getFirearmModelForItem(firearm)
	if not model then
		return
	end
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

this.getShortNameForPart = function(part)
	return getItemNameFromFullType('coavinsfirearms.' .. part .. '_Short')
end

this.getNameForPart = function(part)
	return getItemNameFromFullType('coavinsfirearms.' .. part)
end

this.getTooltipTextForItem = function(item)
	local type = item:getType()
	local data = this.getModData(item)
	local model = this.getFirearmModelForItem(item)
	if model then
		-- it's a firearm
		this.initializeFirearmModData(item)
	else
		-- it's a component
		model = this.getPartModel(type)
		this.initializeDataForPart(type, data)
	end

	return this.getTooltipText(type, model, data, item:getCondition(), item:getConditionMax())
end

this.getTooltipTextForPartData = function(type, data)
	local model = this.getPartModel(type)

	this.initializeDataForPart(type, data)

	return this.getTooltipText(type, model, data, data.condition, model.ConditionMax)
end

this.generateTooltipForModel = function(text, model, data)
	if model.BreaksInto then
		for _,part in ipairs(model.BreaksInto) do
			local component = data.parts[part]
			local componentModel = this.getPartModel(part)
			if text ~= '' then
				text = text .. ' <LINE> '
			end
			local pct = (component.condition / component.conditionMax) * 100
			text = text .. ' <RGB:0.8,0.8,0.8> ' .. this.getShortNameForPart(part) .. ': ' .. string.format('%.0f%%', pct)
			text = this.generateTooltipForModel(text, componentModel, component)
		end
	end

	if model.Holds then
		for _,part in ipairs(model.Holds) do
			local component = data.parts[part]
			local componentModel = this.getPartModel(part)
			if text ~= '' then
				text = text .. ' <LINE> '
			end
			if component then
				local pct = (component.condition / component.conditionMax) * 100
				text = text .. ' <RGB:0.8,0.8,0.8> ' .. this.getShortNameForPart(part) .. ': ' .. string.format('%.0f%%', pct)
				text = this.generateTooltipForModel(text, componentModel, component)
			else
				text = text .. ' <RGB:1,0,0> ' .. this.getShortNameForPart(part) .. ': ' .. getText('ContextMenu_Firearm_NotInstalled')
			end
		end
	end

	return text
end

this.getTooltipText = function(type, model, data, condition, conditionMax)
	local text = ''

	-- show condition
	local conditionPct = (condition / conditionMax) * 100
	if conditionPct == 0 then
		text = ' <RGB:1,0,0> ' .. getText('Tooltip_weapon_Condition') .. ': ' .. string.format('%.0f%%', conditionPct)
	else
		text = ' <RGB:1,1,1> ' .. getText('Tooltip_weapon_Condition') .. ': ' .. string.format('%.0f%%', conditionPct)
	end


	text = this.generateTooltipForModel(text, model, data)

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
