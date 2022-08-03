require "TimedActions/ISBaseTimedAction"
local FIELDSTRIP = require('coavinsfieldstrip/FieldStrip')

-- Installs a firearm component into another component
ISInstallFirearmPart = ISBaseTimedAction:derive("ISInstallFirearmPart");

local function predicateNotBroken(item)
	return not item:isBroken()
end

function ISInstallFirearmPart:isValid()
	if not self.character:getInventory():contains(self.part)
	then
		return false
	else
		return true
	end
end

function ISInstallFirearmPart:update()
	self.part:setJobDelta(self:getJobDelta())

	self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function ISInstallFirearmPart:start()
	self.part:setJobType(getText("ContextMenu_Firearm_InstallComponent"))
	self.part:setJobDelta(0.0)
end

function ISInstallFirearmPart:stop()
	ISBaseTimedAction.stop(self)
	self.part:setJobDelta(0.0)
end

function ISInstallFirearmPart:perform()
	local pItem = self.part
	local pType = pItem:getType()
	local tItem = self.partToInstall
	local tType = tItem:getType()

	pItem:setJobDelta(0.0)

	-- get mod data
	local pData = FIELDSTRIP.getModData(pItem)

	-- get model
	--local pModel = FIELDSTRIP.getPartModel(pType)

	if not pData.parts then
		pData.parts = {}
	end

	local heldParts = pData.parts
	-- if part is not already installed
	if not heldParts[tType] then
		-- remove installed part from inventory
		self.character:getInventory():Remove(tItem)

		-- add installed part to mod data
		local t = {}
		t.condition = tItem:getCondition()
		heldParts[tType] = t
	end

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISInstallFirearmPart:new(character, part, partToInstall, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.part = part
	o.partToInstall = partToInstall
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time
	if character:isTimedActionInstant() then
			o.maxTime = 1
	end
	return o
end
