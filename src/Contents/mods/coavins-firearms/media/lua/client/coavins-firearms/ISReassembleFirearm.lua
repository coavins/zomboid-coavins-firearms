require "TimedActions/ISBaseTimedAction"

ISReassembleFirearm = ISBaseTimedAction:derive("ISReassembleFirearm");

local function predicateNotBroken(item)
	return not item:isBroken()
end

function ISReassembleFirearm:isValid()
	if not self.character:getInventory():contains(self.partA)
	or not self.character:getInventory():contains(self.partB)
	then
		return false
	else
		return true
	end
end

function ISReassembleFirearm:update()
	self.partA:setJobDelta(self:getJobDelta())
	self.partB:setJobDelta(self:getJobDelta())

	self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function ISReassembleFirearm:start()
	self.weapon:setJobType(getText("ContextMenu_Firearm_Reassemble"));
	self.weapon:setJobDelta(0.0);
	self.part:setJobType(getText("ContextMenu_Firearm_Reassemble"));
	self.part:setJobDelta(0.0);
end

function ISReassembleFirearm:stop()
	ISBaseTimedAction.stop(self);
	self.weapon:setJobDelta(0.0);
	self.part:setJobDelta(0.0);
end

function ISReassembleFirearm:perform()
	self.weapon:setJobDelta(0.0);
	self.part:setJobDelta(0.0);
	self.weapon:attachWeaponPart(self.part)
	self.character:getInventory():Remove(self.part);
	self.character:setSecondaryHandItem(nil);
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISReassembleFirearm:new(character, weapon, part, time)
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