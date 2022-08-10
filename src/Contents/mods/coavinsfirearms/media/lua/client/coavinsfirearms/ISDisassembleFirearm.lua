require "TimedActions/ISBaseTimedAction"
local FIREARMS = require('coavinsfirearms/FirearmsHelper')

ISDisassembleFirearm = ISBaseTimedAction:derive("ISDisassembleFirearm");

function ISDisassembleFirearm:isValid()
	if not self.character:getInventory():contains(self.firearm)
	or self.firearm:getAllWeaponParts():size() > 0
	or (self.firearm:getMagazineType() and self.firearm:isContainsClip())
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
	self:setActionAnim(CharacterActionAnims.Craft)
	self:setOverrideHandModels(nil, nil)
end

function ISDisassembleFirearm:stop()
	ISBaseTimedAction.stop(self)
	self.firearm:setJobDelta(0.0)
end

function ISDisassembleFirearm:perform()
	local fItem = self.firearm
	local fModel = FIREARMS.getFirearmModelForItem(fItem)
	if not fModel then
		return
	end
	local fFullType = fItem:getFullType()

	fItem:setJobDelta(0.0)

	-- remove firearm from inventory
	self.character:getInventory():Remove(fItem)

	-- add components to inventory
	for _,k in ipairs(fModel.BreaksInto) do
		local pType = 'coavinsfirearms.' .. k
		local pItem = self.character:getInventory():AddItem(pType)

		if not pItem then
			return
		end

		local pData = FIREARMS.getModData(pItem)

		pItem:setFavorite(fItem:isFavorite())

		-- Receiver must hold some characteristics of the original item
		if k == fModel.SaveTypeIn then
			local firearmName = getItemNameFromFullType(fItem:getFullType())
			local partName = FIREARMS.getShortNameForPart(k)
			pItem:setName(firearmName .. ' ' .. partName)
			pData.realFirearm = fFullType
		end

		FIREARMS.copyDataFromParent(fItem, pItem)
	end

	if self.character:getPrimaryHandItem() == fItem then
		self.character:setPrimaryHandItem(nil)
	end
	if self.character:getSecondaryHandItem() == fItem then
		self.character:setSecondaryHandItem(nil)
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
	return o
end
