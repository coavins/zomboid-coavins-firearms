require "TimedActions/ISBaseTimedAction"
local FIELDSTRIP = require('coavinsfieldstrip/FieldStrip')

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

	-- remove firearm
	self.character:getInventory():Remove(self.firearm)

	-- create components table if not already exist
	if not self.firearm:getModData().firearmcomponents then
		self.firearm:getModData().firearmcomponents = {}
	end

	local c = self.firearm:getModData().firearmcomponents

	-- give frame
	local frame = self.character:getInventory():AddItem("coavinsfieldstrip.PistolFrame")

	-- set name to reflect original firearm
	frame:setName(self.firearm:getName() .. ' (Frame)')
	-- remember type for original firearm
	frame:getModData().realFirearm = self.firearm:getType()

	-- set condition
	if c.frame then
		-- use condition that was saved previously
		frame:setCondition(c.frame.condition)
	else
		-- no saved data found, just use the condition of the firearm
		frame:setCondition(self.firearm:getCondition())
	end

	-- give slide
	local slide = self.character:getInventory():AddItem("coavinsfieldstrip.PistolSlide")

	-- set condition
	if c.slide then
		-- use condition that was saved previously
		slide:setCondition(c.slide.condition)
	else
		-- no saved data found, just use the condition of the firearm
		slide:setCondition(self.firearm:getCondition())
	end

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