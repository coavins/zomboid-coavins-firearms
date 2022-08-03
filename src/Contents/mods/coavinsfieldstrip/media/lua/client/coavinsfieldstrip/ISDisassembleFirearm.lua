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
	local fData = FIELDSTRIP.getModData(fItem)

	-- get model
	local model = FIELDSTRIP.getFirearmModel(FIELDSTRIP.getFirearmModelForType(fType))

	-- give parts
	for _,k in ipairs(model.BreaksInto) do
		local pType = 'coavinsfieldstrip.' .. k
		local pItem = self.character:getInventory():AddItem(pType)
		local pModel = FIELDSTRIP.getPartModel(k)
		local pData = FIELDSTRIP.getModData(pItem)

		-- Receiver must hold some characteristics of the original item
		if k == model.SaveTypeIn then
			pItem:setName(fItem:getName() .. ' (Frame)')
			pData.realFirearm = fType
		end

		local data = nil
		if fData.parts then
			data = fData.parts[k]
		end

		if data then
			-- copy data to new part
			local newData = FIELDSTRIP.tableDeepCopy(data)
			pData.parts = newData.parts

			-- set condition
			pItem:setCondition(data.condition)
		else
			-- no data, this firearm hasn't been disassembled before
			-- just make it be holding the parts necessary for it to function
			pData.parts = {}
			if pModel.Holds then
				for _,j in ipairs(pModel.Holds) do
					pData.parts[j] = {}
					pData.parts[j].condition = 10
				end
			end

			-- set this part to the firearm's part
			pItem:setCondition(fItem:getCondition())
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
	return o
end
