require "TimedActions/ISBaseTimedAction"
local FIELDSTRIP = require('coavinsfieldstrip/FieldStrip')

ISAssembleFirearmParts = ISBaseTimedAction:derive("ISAssembleFirearmParts");

local function predicateNotBroken(item)
	return not item:isBroken()
end

local function getModData(item)
	if not item:getModData().coavinsfieldstrip then
		item:getModData().coavinsfieldstrip = {}
	end
	return item:getModData().coavinsfieldstrip
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
	local modelA = FIELDSTRIP.getModel(typeA)
	local modelB = FIELDSTRIP.getModel(typeB)

	local dataA = getModData(itemA)
	local dataB = getModData(itemB)

	local resultType = modelA.Forms or modelB.Forms

	if resultType == 'Pistol' then
		resultType = dataA.realFirearm or dataB.realFirearm
		if not resultType then
			resultType = 'Base.Pistol'
		end
	else
		resultType = 'coavinsfieldstrip.' .. resultType
	end

	local resultItem = self.character:getInventory():AddItem(resultType)
	resultItem:setCondition(itemA:getCondition())

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