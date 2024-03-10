local ItemReader = {}

local modDataPrefix = "coavinsfirearms"

---Get the coavinsfirearms mod data if it exists,
---otherwise return nil
---@param item InventoryItem
---@return string|nil
ItemReader.getModDataFromItem = function(item)
	if not item then
		return nil
	end

	if not item.getModData then
		return nil
	end

	local modData = item:getModData()

	if not modData or not modData[modDataPrefix] then
		return nil
	end

	return modData[modDataPrefix]
end

return ItemReader
