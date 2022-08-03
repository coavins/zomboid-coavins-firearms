require "TimedActions/ISBaseTimedAction"
local FIELDSTRIP = require('coavinsfieldstrip/FieldStrip')

ISRemoveFirearmPart = ISBaseTimedAction:derive("ISRemoveFirearmPart");

local function predicateNotBroken(item)
	return not item:isBroken()
end

function ISRemoveFirearmPart:isValid()
	if not self.character:getInventory():contains(self.part)
	then
		return false
	else
		return true
	end
end

function ISRemoveFirearmPart:update()
	self.part:setJobDelta(self:getJobDelta())

	self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function ISRemoveFirearmPart:start()
	self.part:setJobType(getText("ContextMenu_Firearm_Disassemble"))
	self.part:setJobDelta(0.0)
end

function ISRemoveFirearmPart:stop()
	ISBaseTimedAction.stop(self)
	self.part:setJobDelta(0.0)
end

function ISRemoveFirearmPart:perform()
	local pItem = self.part
	local pType = pItem:getType()
	local target = self.partToRemove

	pItem:setJobDelta(0.0)

	-- get mod data
	local pData = FIELDSTRIP.getModData(pItem)

	-- get model
	--local pModel = FIELDSTRIP.getPartModel(pType)

	local heldParts = pData.parts
	if heldParts and heldParts[target] then
		local t = heldParts[target]

		local tType = 'coavinsfieldstrip.' .. target
		local tItem = self.character:getInventory():AddItem(tType)

		if t then
			tItem:setCondition(pData.condition)
		end

		heldParts[target] = nil
	end

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISRemoveFirearmPart:new(character, part, partToRemove, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.part = part
	o.partToRemove = partToRemove
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time
	if character:isTimedActionInstant() then
			o.maxTime = 1
	end
	return o
end
