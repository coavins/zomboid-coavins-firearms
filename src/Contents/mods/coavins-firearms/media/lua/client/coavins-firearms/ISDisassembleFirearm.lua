require "TimedActions/ISBaseTimedAction"

ISDisassembleFirearm = ISBaseTimedAction:derive("ISDisassembleFirearm");

local function predicateNotBroken(item)
	return not item:isBroken()
end

function ISDisassembleFirearm:isValid()
	if not self.character:getInventory():contains(self.firearm)
	then
		return false
	else
		return true
	end
end

function ISDisassembleFirearm:update()
	self.firearm:setJobDelta(self:getJobDelta())

	self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function ISDisassembleFirearm:start()
	self.firearm:setJobType(getText("ContextMenu_Firearm_Disassemble"));
	self.firearm:setJobDelta(0.0);
end

function ISDisassembleFirearm:stop()
	ISBaseTimedAction.stop(self);
	self.firearm:setJobDelta(0.0);
end

function ISDisassembleFirearm:perform()
	self.firearm:setJobDelta(0.0);
	-- take the actual steps to disassemble
	self.character:getInventory():Remove(self.firearm)
	self.character:getInventory():AddItem("coavinsfirearms.PistolReceiver")
	self.character:getInventory():AddItem("coavinsfirearms.PistolSlide")
	self.character:getInventory():AddItem("coavinsfirearms.PistolBarrel")
	--self.weapon:detachWeaponPart(self.part)
	--self.character:getInventory():AddItem(self.part);
	--self.character:resetEquippedHandsModels();
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISDisassembleFirearm:new(character, firearm, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.firearm = firearm;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	if character:isTimedActionInstant() then
			o.maxTime = 1;
	end
	return o;
end