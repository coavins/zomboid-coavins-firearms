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
		MakeItem('coavinsfirearms.PistolReceiver'    , 0.3),
		MakeItem('coavinsfirearms.PistolSlide'       , 1.0),
		MakeItem('coavinsfirearms.PistolBarrel'      , 0.7),
		MakeItem('coavinsfirearms.RevolverReceiver'  , 0.3),
		MakeItem('coavinsfirearms.RevolverCylinder'  , 1.0),
		MakeItem('coavinsfirearms.BoltActionReceiver', 0.3),
		MakeItem('coavinsfirearms.BoltActionBolt'    , 0.7),
		MakeItem('coavinsfirearms.M16LowerReceiver'  , 1.0),
		MakeItem('coavinsfirearms.M16UpperReceiver'  , 1.0),
		MakeItem('coavinsfirearms.M16BoltCarrier'    , 1.0),
		MakeItem('coavinsfirearms.M16FiringPin'      , 0.5),
		MakeItem('coavinsfirearms.M16Bolt'           , 0.7),
		MakeItem('coavinsfirearms.ShotgunReceiver'   , 1.0),
		MakeItem('coavinsfirearms.ShotgunForend'     , 1.0),
		MakeItem('coavinsfirearms.ShotgunBoltCarrier', 1.0),
		MakeItem('coavinsfirearms.ShotgunBolt'       , 0.7),
		MakeItem('coavinsfirearms.ShotgunBarrel'     , 0.7),
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
