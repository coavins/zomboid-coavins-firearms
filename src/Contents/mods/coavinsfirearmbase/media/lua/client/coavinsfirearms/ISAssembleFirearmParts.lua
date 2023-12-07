require "TimedActions/ISBaseTimedAction"
local FIREARMS = require('coavinsfirearms/FirearmsHelper')

ISAssembleFirearmParts = ISBaseTimedAction:derive("ISAssembleFirearmParts");

local nvl = function(a, b)
	if a then return a
	else return b
	end
end

function ISAssembleFirearmParts:isValid()
	if not self.character:getInventory():contains(self.partA)
	or not self.character:getInventory():contains(self.partB)
	then
		return false
	else
		return true
	end
end

function ISAssembleFirearmParts:update()
	self.partA:setJobDelta(self:getJobDelta())
	self.partB:setJobDelta(self:getJobDelta())

	self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function ISAssembleFirearmParts:start()
	self.partA:setJobType(getText("ContextMenu_Firearm_Assemble"));
	self.partA:setJobDelta(0.0);
	self.partB:setJobType(getText("ContextMenu_Firearm_Assemble"));
	self.partB:setJobDelta(0.0);
	self:setActionAnim(CharacterActionAnims.Craft)
	self:setOverrideHandModels(nil, nil)
end

function ISAssembleFirearmParts:stop()
	ISBaseTimedAction.stop(self);
	self.partA:setJobDelta(0.0);
	self.partB:setJobDelta(0.0);
end

function ISAssembleFirearmParts:perform()
	local itemA = self.partA
	local typeA = itemA:getType()
	local itemB = self.partB
	local typeB = itemB:getType()

	itemA:setJobDelta(0.0);
	itemB:setJobDelta(0.0);

	-- get model
	local modelA = FIREARMS.getPartModel(typeA)
	local modelB = FIREARMS.getPartModel(typeB)

	local dataA = FIREARMS.getModData(itemA)
	local dataB = FIREARMS.getModData(itemB)

	local resultType -- the type we are producing

	-- if we're building a firearm
	if dataA.realFirearm or dataB.realFirearm then
		-- grab the real firearm type
		resultType = nvl(dataA.realFirearm, dataB.realFirearm)

		-- if we're building a part
	elseif modelA.FormsPart or modelB.FormsPart then
		-- grab from either, should be the same
		resultType = 'coavinsfirearms.' .. nvl(modelA.FormsPart, modelB.FormsPart)

		-- we must be building a firearm, but don't know which one
	else
		-- find a model that fits our parts
		local ourModel = nil
		local models = CoavinsFirearms.GetModels()
		for name,model in pairs(models) do
			local thisOne = true
			for _,part in ipairs(model.BreaksInto) do
				if typeA ~= part and typeB ~= part then
					thisOne = false
				end
			end
			if thisOne then
				-- We will build the fallback type for this model
				ourModel = name
			end
		end

		if ourModel then
			-- pick any gun that matches to this model
			local matches = CoavinsFirearms.GetMatches()
			local viable = {}
			for fullType,modelName in pairs(matches) do
				if modelName == ourModel then
					table.insert(viable, fullType)
				end
			end

			if #viable > 0 then
				-- choose a random viable gun
				resultType = viable[ZombRand(#viable)+1]
			end
		end
	end

	-- abort if we have no type to create
	if not resultType then
		return
	end

	-- remove parts from inventory
	self.character:getInventory():Remove(itemA)
	self.character:getInventory():Remove(itemB)

	-- create item
	local resultItem = self.character:getInventory():AddItem(resultType)

	if resultItem:getRackSound() then
		self.character:playSound(resultItem:getRackSound())
	elseif resultItem:getInsertAmmoStopSound() then
		self.character:playSound(resultItem:getInsertAmmoStopSound());
	end

	-- initialize data
	FIREARMS.initializeFirearmModData(resultItem)

	-- set data
	local resultData = FIREARMS.getModData(resultItem)
	resultData.parts[typeA].condition = itemA:getCondition()
	resultData.parts[typeA].parts = dataA.parts
	resultData.parts[typeB].condition = itemB:getCondition()
	resultData.parts[typeB].parts = dataB.parts

	-- update condition
	FIREARMS.updateFirearm(resultItem)

	if self.character:getPrimaryHandItem() == itemA
	or self.character:getPrimaryHandItem() == itemB then
		self.character:setPrimaryHandItem(nil)
	end
	if self.character:getSecondaryHandItem() == itemA
	or self.character:getSecondaryHandItem() == itemB then
		self.character:setSecondaryHandItem(nil);
	end

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISAssembleFirearmParts:new(character, partA, partB, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.partA = partA;
	o.partB = partB;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	if character:isTimedActionInstant() then
			o.maxTime = 1;
	end
	return o;
end