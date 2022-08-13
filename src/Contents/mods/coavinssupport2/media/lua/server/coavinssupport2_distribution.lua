require 'Items/ProceduralDistributions'

local spawns = {}
local debugMultiplier = 1.0 -- change to 100 to guarantee spawns

-- Make a new set of items and where they spawn
local MakeSet = function(distribution, items)
	table.insert(spawns, { distribution, items })
end

-- Define a place where things can spawn, with specified name and base rarity
local MakeDistribution = function(name, rarity)
	return { name, rarity }
end

-- Define an item that can spawn, with specified type and rarity multiplier
local MakeItem = function(type, rarityMultiplier)
	return {type, rarityMultiplier }
end

-- Add spawn sets

-- Gun parts
MakeSet(
	{ -- Where they should spawn
		MakeDistribution('PawnShopGunsSpecial' , 5.0),
		MakeDistribution('GunStoreShelf'       , 5.0),
		MakeDistribution('ArmyStorageGuns'     , 0.5),
		MakeDistribution('ArmySurplusBackpacks', 1.0),
		MakeDistribution('LockerArmyBedroom'   , 5.0),
		MakeDistribution('PoliceStorageGuns'   , 2.0),
		MakeDistribution('GunStoreDisplayCase' , 0.1),
		MakeDistribution('FirearmWeapons'      , 1.0),
		MakeDistribution('HuntingLockers'      , 2.0),
	},
	{ -- What should spawn here
		MakeItem('coavinsfirearms.SKS_Receiver'        , 1.2),
		MakeItem('coavinsfirearms.SKS_GasPiston'       , 0.5),
		MakeItem('coavinsfirearms.SKS_TriggerAssembly' , 0.7),
		MakeItem('coavinsfirearms.SKS_MagazineAssembly', 0.7),
		MakeItem('coavinsfirearms.SKS_BoltCarrier'     , 0.7),
		MakeItem('coavinsfirearms.SKS_Bolt'            , 0.5),
		MakeItem('coavinsfirearms.SKS_FiringPin'       , 0.3),
	}
)

-- If adding a new spawn set, do it here


-- Actually insert the requisite items in the game tables
local AddSpawn = function(place, type, rarity)
	table.insert(ProceduralDistributions.list[place].items, type)
  table.insert(ProceduralDistributions.list[place].items, rarity)
end

-- for each spawn
for _,spawn in ipairs(spawns) do
	local distributions = spawn[1]
	local items         = spawn[2]
	-- for each distribution
	for _,distribution in ipairs(distributions) do
		local place  = distribution[1]
		local rarity = distribution[2]
		-- for each item
		for _,item in ipairs(items) do
			local type             = item[1]
			local rarityMultiplier = item[2]
			local actualRarity = rarity * rarityMultiplier * debugMultiplier
			-- spawn this item at this distribution
			AddSpawn(place, type, actualRarity)
		end
	end
end
