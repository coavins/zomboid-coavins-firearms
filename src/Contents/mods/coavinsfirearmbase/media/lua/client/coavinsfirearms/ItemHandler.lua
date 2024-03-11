local ItemHandler = {}

local modDataPrefix = "coavinsfirearms"

---Check if a variable looks like an item
---@param item InventoryItem
---@return boolean isItem If the parameter is an InventoryItem
ItemHandler.isItem = function(item)
	if item and item.getModData then
		return true
	else
		return false
	end
end

---Create the coavinsfirearms mod data if it doesn't already exist
---@param item InventoryItem
---@return boolean didCreate If mod data was created
ItemHandler.createModDataIfNotExist = function(item)
	if not ItemHandler.isItem(item) then
		return false
	end

	local modData = item:getModData()

	if modData and not modData[modDataPrefix] then
		-- create our mod data
		modData[modDataPrefix] = {}

		print("Created mod data for item: " .. item:getFullType())

		return true
	else
		return false
	end
end

---Get the coavinsfirearms mod data if it exists,
---otherwise return nil
---@param item InventoryItem
---@return string|nil
ItemHandler.getModDataFromItem = function(item)
	if not ItemHandler.isItem(item) then
		return nil
	end

	local modData = item:getModData()

	if not modData or not modData[modDataPrefix] then
		return nil
	end

	return modData[modDataPrefix]
end

return ItemHandler
