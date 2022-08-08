require 'Items/ProceduralDistributions'

local spawns = {}
local debugMultiplier = 1.0 -- change to 100 to guarantee spawns

-- Defines a distribution with specified name and base rarity
local MakeDistribution = function(name, rarity)
	return { name, rarity }
end

-- Defines an item of specified type and rarity multiplier
local MakeItem = function(type, rarityMultiplier)
	return {type, rarityMultiplier }
end

local MakeSet = function(distribution, items)
	table.insert(spawns, { distribution, items })
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
	--MakeItem('coavinsfirearms.PistolReceiver'    , 1.0),
	MakeItem('coavinsfirearms.PistolSlide'       , 1.0),
	MakeItem('coavinsfirearms.PistolBarrel'      , 1.0),
	--MakeItem('coavinsfirearms.RevolverReceiver'  , 1.0),
	MakeItem('coavinsfirearms.RevolverCylinder'  , 1.0),
	--MakeItem('coavinsfirearms.BoltActionReceiver', 1.0),
	MakeItem('coavinsfirearms.BoltActionBolt'    , 1.0),
	--MakeItem('coavinsfirearms.M16LowerReceiver'  , 1.0),
	MakeItem('coavinsfirearms.M16UpperReceiver'  , 1.0),
	MakeItem('coavinsfirearms.M16BoltCarrier'    , 1.0),
	MakeItem('coavinsfirearms.M16FiringPin'      , 1.0),
	MakeItem('coavinsfirearms.M16Bolt'           , 1.0),
	--MakeItem('coavinsfirearms.ShotgunReceiver'   , 1.0),
	MakeItem('coavinsfirearms.ShotgunForend'     , 1.0),
	MakeItem('coavinsfirearms.ShotgunBoltCarrier', 1.0),
	MakeItem('coavinsfirearms.ShotgunBolt'       , 1.0),
	MakeItem('coavinsfirearms.ShotgunBarrel'     , 1.0),
	
})

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
