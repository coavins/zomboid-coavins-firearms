local ItemReader = require "src.Contents.mods.coavinsfirearmbase.media.lua.client.coavinsfirearms.ItemReader"

---@diagnostic disable: undefined-global
describe("ItemReader", function()
	it("returns nil when there is no item", function()
		local item = nil

		local actual = ItemReader.getModDataFromItem(item)
		local expected = nil

		assert.are_equal(actual, expected)
	end)

	it("returns nil when there is no getModData function", function()
		local item = {}

		local actual = ItemReader.getModDataFromItem(item)
		local expected = nil

		assert.are_equal(actual, expected)
	end)

	it("returns nil when there is no mod data", function()
		local item = {}
		item.getModData = function()
			return nil
		end

		local actual = ItemReader.getModDataFromItem(item)
		local expected = nil

		assert.are_equal(actual, expected)
	end)

	it("returns nil when there is no mod data from us", function()
		local item = {}
		item.getModData = function()
			local modData = {}
			modData.test = "123"
			return modData
		end

		local actual = ItemReader.getModDataFromItem(item)
		local expected = nil

		assert.are_equal(actual, expected)
	end)

	it("returns test value from our mod data", function()
		local item = {}
		item.getModData = function()
			local modData = {}
			modData.coavinsfirearms = {}
			modData.coavinsfirearms.test = "123"
			return modData
		end

		local actual = ItemReader.getModDataFromItem(item)["test"]
		local expected = "123"

		assert(actual == expected)
	end)

	it("returns the right value from mod data", function()
		local item = {}
		item.getModData = function()
			local modData = {}
			modData.test = "456"
			modData.coavinsfirearms = {}
			modData.coavinsfirearms.test = "123"
			return modData
		end

		local actual = ItemReader.getModDataFromItem(item)["test"]
		local expected = "123"

		assert(actual == expected)
	end)
end)
