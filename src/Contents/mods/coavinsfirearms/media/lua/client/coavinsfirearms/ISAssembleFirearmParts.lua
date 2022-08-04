require "TimedActions/ISBaseTimedAction"
local FIREARMS = require('coavinsfirearms/FirearmsHelper')

ISAssembleFirearmParts = ISBaseTimedAction:derive("ISAssembleFirearmParts");

local function predicateNotBroken(item)
	return not item:isBroken()
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

	-- remove parts from inventory
	self.character:getInventory():Remove(itemA)
	self.character:getInventory():Remove(itemB)

	-- get model
	local modelA = FIREARMS.getPartModel(typeA)
	local modelB = FIREARMS.getPartModel(typeB)

	local dataA = FIREARMS.getModData(itemA)
	local dataB = FIREARMS.getModData(itemB)

	local resultType -- the type we are producing

	-- if we're building a firearm
	if modelA.FormsFirearm or modelB.FormsFirearm then
		-- grab the real firearm type
		if modelA.FormsFirearm then
			resultType = dataA.realFirearm
		else
			resultType = dataB.realFirearm
		end
		-- something went wrong, use default pistol type
		if not resultType then
			-- TODO: use default type for this model
		end
	-- if we're building a part
	elseif modelA.FormsPart or modelB.FormsPart then
		-- grab from either, should be the same
		resultType = modelA.FormsPart or modelB.FormsPart
		resultType = 'coavinsfirearms.' .. resultType
	end

	-- create item
	local resultItem = self.character:getInventory():AddItem(resultType)

	-- set data
	local resultData = FIREARMS.getModData(resultItem)
	resultData.parts = {}
	resultData.parts[typeA] = {}
	resultData.parts[typeA].condition = itemA:getCondition()
	resultData.parts[typeA].parts = dataA.parts
	resultData.parts[typeB] = {}
	resultData.parts[typeB].condition = itemB:getCondition()
	resultData.parts[typeB].parts = dataB.parts

	-- update condition
	FIREARMS.updateFirearm(resultItem)

	self.character:setPrimaryHandItem(nil);
	self.character:setSecondaryHandItem(nil);

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