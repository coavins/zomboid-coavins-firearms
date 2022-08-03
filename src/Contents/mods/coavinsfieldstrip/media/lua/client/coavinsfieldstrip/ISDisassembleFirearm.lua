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

	local condition = self.firearm:getCondition()

	-- give frame
	local frame = self.character:getInventory():AddItem("coavinsfieldstrip.PistolFrame")
	frame:setCondition(condition)

	-- give slide
	local slide = self.character:getInventory():AddItem("coavinsfieldstrip.PistolSlide")
	slide:setCondition(condition)

	--[[
	-- create components table if not already exist
	if not self.firearm.components then
		self.firearm.components = {}
	end

	-- give receiver
	if self.firearm.components.receiver then
		self.character.getInventory():AddItem(self.firearm.components.receiver)
	else
		-- add receiver to firearm if not already exist
		local receiver = self.character:getInventory():AddItem("coavinsfirearms.PistolReceiver")
		receiver.condition = self.firearm.condition
		self.firearm.components.receiver = receiver
	end

	-- give slide
	if self.firearm.components.slide then
		self.character.getInventory():AddItem(self.firearm.components.slide)
	else
		-- add slide to firearm if not already exist
		local slide = self.character:getInventory():AddItem("coavinsfirearms.PistolSlide")
		slide.condition = self.firearm.condition
		self.firearm.components.slide = slide
	end
	]]

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