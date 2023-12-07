require "TimedActions/ISBaseTimedAction"
local FIREARMS = require('coavinsfirearms/FirearmsHelper')

ISRemoveFirearmPart = ISBaseTimedAction:derive("ISRemoveFirearmPart");

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
	self.part:setJobType(getText("ContextMenu_Firearm_RemoveComponent"))
	self.part:setJobDelta(0.0)
	self:setActionAnim(CharacterActionAnims.Craft)
	self:setOverrideHandModels(nil, nil)
end

function ISRemoveFirearmPart:stop()
	ISBaseTimedAction.stop(self)
	self.part:setJobDelta(0.0)
end

function ISRemoveFirearmPart:perform()
	local pItem = self.part
	local target = self.partToRemove

	pItem:setJobDelta(0.0)

	-- get mod data
	local pData = FIREARMS.getModData(pItem)

	local heldParts = pData.parts
	if heldParts and heldParts[target] then
		local tType = 'coavinsfirearms.' .. target
		local tItem = self.character:getInventory():AddItem(tType)

		if not tItem then
			return
		end

		tItem:setFavorite(pItem:isFavorite())

		FIREARMS.copyDataFromParent(pItem, tItem)

		-- remove this part from parent
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
