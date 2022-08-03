require "TimedActions/ISBaseTimedAction"
local FIELDSTRIP = require('coavinsfieldstrip/FieldStrip')

ISDisassembleFirearm = ISBaseTimedAction:derive("ISDisassembleFirearm");

local function predicateNotBroken(item)
	return not item:isBroken()
end

local function getModData(item)
	if not item:getModData().coavinsfieldstrip then
		item:getModData().coavinsfieldstrip = {}
	end
	return item:getModData().coavinsfieldstrip
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

	self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function ISDisassembleFirearm:start()
	self.firearm:setJobType(getText("ContextMenu_Firearm_Disassemble"))
	self.firearm:setJobDelta(0.0)
end

function ISDisassembleFirearm:stop()
	ISBaseTimedAction.stop(self)
	self.firearm:setJobDelta(0.0)
end

function ISDisassembleFirearm:perform()
	local fItem = self.firearm
	local fType = fItem:getFullType()

	fItem:setJobDelta(0.0)

	-- remove firearm from inventory
	self.character:getInventory():Remove(fItem)

	-- get firearm mod data
	local c = getModData(fItem)

	-- get model
	local model = FIELDSTRIP.getFirearmModel(FIELDSTRIP.getFirearmModelForType(fType))

	-- give parts
	for i,k in ipairs(model.BreaksInto) do
		local pType = 'coavinsfieldstrip.' .. k
		local part = self.character:getInventory():AddItem(pType)

		-- Receiver must hold some characteristics of the original item
		if k == model.SaveTypeIn then
			part:setName(fItem:getName() .. ' (Frame)')
			getModData(part).realFirearm = fType
		end

		if c[i] then
			part:setCondition(c[i].condition)
		else
			part:setCondition(fItem:getCondition())
		end
	end

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISDisassembleFirearm:new(character, firearm, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.firearm = firearm
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time
	if character:isTimedActionInstant() then
			o.maxTime = 1
	end
	return o;
end