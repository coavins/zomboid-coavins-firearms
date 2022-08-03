require "TimedActions/ISBaseTimedAction"
local FIELDSTRIP = require('coavinsfieldstrip/FieldStrip')

ISReassembleFirearmParts = ISBaseTimedAction:derive("ISReassembleFirearmParts");

local function predicateNotBroken(item)
	return not item:isBroken()
end

function ISReassembleFirearmParts:isValid()
	if not self.character:getInventory():contains(self.partA)
	or not self.character:getInventory():contains(self.partB)
	then
		return false
	else
		return true
	end
end

function ISReassembleFirearmParts:update()
	self.partA:setJobDelta(self:getJobDelta())
	self.partB:setJobDelta(self:getJobDelta())

	self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function ISReassembleFirearmParts:start()
	self.partA:setJobType(getText("ContextMenu_Firearm_Reassemble"));
	self.partA:setJobDelta(0.0);
	self.partB:setJobType(getText("ContextMenu_Firearm_Reassemble"));
	self.partB:setJobDelta(0.0);
end

function ISReassembleFirearmParts:stop()
	ISBaseTimedAction.stop(self);
	self.partA:setJobDelta(0.0);
	self.partB:setJobDelta(0.0);
end

function ISReassembleFirearmParts:perform()
	self.partA:setJobDelta(0.0);
	self.partB:setJobDelta(0.0);

	-- give resulting part

	self.character:getInventory():Remove(self.partA);
	self.character:getInventory():Remove(self.partB);
	self.character:setPrimaryHandItem(nil);
	self.character:setSecondaryHandItem(nil);
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISReassembleFirearmParts:new(character, weapon, part, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.weapon = weapon;
	o.part = part;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	if character:isTimedActionInstant() then
			o.maxTime = 1;
	end
	return o;
end