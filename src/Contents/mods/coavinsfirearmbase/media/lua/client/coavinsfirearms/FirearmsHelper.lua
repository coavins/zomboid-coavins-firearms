local ItemHandler = require 'coavinsfirearms/ItemHandler'

local this = {}

local nvl = function(a, b)
	if a then return a
	else return b
	end
end

this.getFirearmModelNameForItem = function(item)
	if not item then
		return
	end

	local fullType = item:getFullType() -- Base.Pistol
	if not fullType then
		return
	end

	return CoavinsFirearms.GetModelName(fullType)
end

this.itemIsFirearm = function(item)
	if this.getFirearmModelNameForItem(item) then
		return true
	end

	return false
end

this.itemIsPart = function(item)
	if not item then
		return false
	end

	local cat = item:getDisplayCategory() -- Weapon
	if not cat then
		return false
	end

	if cat == 'FirearmPart' then
		return true
	end

	return false
end

this.getFirearmModelForItem = function(item)
	local modelName = this.getFirearmModelNameForItem(item)
	if modelName then
		return CoavinsFirearms.GetModel(modelName)
	else
		return nil
	end
end

this.parts = {}
this.parts.PistolReceiver = {}
this.parts.PistolReceiver.CombinesWith = 'PistolSlide'
this.parts.PistolReceiver.ConditionLowerChance = 1 -- 100%
this.parts.PistolReceiver.ConditionMax = 20
this.parts.PistolSlide = {}
this.parts.PistolSlide.CombinesWith = 'PistolReceiver'
this.parts.PistolSlide.Holds = { 'PistolBarrel' }
this.parts.PistolSlide.ConditionLowerChance = 2 -- 1/2
this.parts.PistolSlide.ConditionMax = 20
this.parts.PistolBarrel = {}
this.parts.PistolBarrel.InsertsInto = 'PistolSlide'
this.parts.PistolBarrel.ConditionLowerChance = 3 -- 1/3
this.parts.PistolBarrel.ConditionMax = 20
this.parts.RevolverReceiver = {}
this.parts.RevolverReceiver.CombinesWith = 'RevolverCylinder'
this.parts.RevolverReceiver.ConditionLowerChance = 1
this.parts.RevolverReceiver.ConditionMax = 20
this.parts.RevolverCylinder = {}
this.parts.RevolverCylinder.CombinesWith = 'RevolverReceiver'
this.parts.RevolverCylinder.ConditionLowerChance = 3
this.parts.RevolverCylinder.ConditionMax = 20
this.parts.ShotgunReceiver = {}
this.parts.ShotgunReceiver.CombinesWith = 'ShotgunBarrel'
this.parts.ShotgunReceiver.Holds = { 'ShotgunForend' }
this.parts.ShotgunReceiver.ConditionLowerChance = 1
this.parts.ShotgunReceiver.ConditionMax = 20
this.parts.ShotgunForend = {}
this.parts.ShotgunForend.InsertsInto = 'ShotgunReceiver'
this.parts.ShotgunForend.Holds = { 'ShotgunBoltCarrier' }
this.parts.ShotgunForend.ConditionLowerChance = 2
this.parts.ShotgunForend.ConditionMax = 20
this.parts.ShotgunBoltCarrier = {}
this.parts.ShotgunBoltCarrier.InsertsInto = 'ShotgunForend'
this.parts.ShotgunBoltCarrier.Holds = { 'ShotgunBolt' }
this.parts.ShotgunBoltCarrier.ConditionLowerChance = 4
this.parts.ShotgunBoltCarrier.ConditionMax = 20
this.parts.ShotgunBolt = {}
this.parts.ShotgunBolt.InsertsInto = 'ShotgunBoltCarrier'
this.parts.ShotgunBolt.ConditionLowerChance = 3
this.parts.ShotgunBolt.ConditionMax = 20
this.parts.ShotgunBarrel = {}
this.parts.ShotgunBarrel.CombinesWith = 'ShotgunReceiver'
this.parts.ShotgunBarrel.ConditionLowerChance = 3
this.parts.ShotgunBarrel.ConditionMax = 20
this.parts.BoltActionReceiver = {}
this.parts.BoltActionReceiver.CombinesWith = 'BoltActionBolt'
this.parts.BoltActionReceiver.ConditionLowerChance = 1
this.parts.BoltActionReceiver.ConditionMax = 20
this.parts.BoltActionBolt = {}
this.parts.BoltActionBolt.CombinesWith = 'BoltActionReceiver'
this.parts.BoltActionBolt.ConditionLowerChance = 3
this.parts.BoltActionBolt.ConditionMax = 20
this.parts.M16LowerReceiver = {}
this.parts.M16LowerReceiver.CombinesWith = 'M16UpperReceiver'
this.parts.M16LowerReceiver.ConditionLowerChance = 2
this.parts.M16LowerReceiver.ConditionMax = 20
this.parts.M16UpperReceiver = {}
this.parts.M16UpperReceiver.CombinesWith = 'M16LowerReceiver'
this.parts.M16UpperReceiver.Holds = { 'M16BoltCarrier' }
this.parts.M16UpperReceiver.ConditionLowerChance = 2
this.parts.M16UpperReceiver.ConditionMax = 20
this.parts.M16BoltCarrier = {}
this.parts.M16BoltCarrier.InsertsInto = 'M16UpperReceiver'
this.parts.M16BoltCarrier.Holds = { 'M16FiringPin', 'M16Bolt' }
this.parts.M16BoltCarrier.ConditionLowerChance = 3
this.parts.M16BoltCarrier.ConditionMax = 20
this.parts.M16FiringPin = {}
this.parts.M16FiringPin.InsertsInto = 'M16BoltCarrier'
this.parts.M16FiringPin.ConditionLowerChance = 4
this.parts.M16FiringPin.ConditionMax = 20
this.parts.M16Bolt = {}
this.parts.M16Bolt.InsertsInto = 'M16BoltCarrier'
this.parts.M16Bolt.ConditionLowerChance = 2
this.parts.M16Bolt.ConditionMax = 20
this.parts.SKS_Receiver = {}
this.parts.SKS_Receiver.CombinesWith = 'SKS_BoltCarrier'
this.parts.SKS_Receiver.Holds = { 'SKS_GasPiston', 'SKS_TriggerAssembly', 'SKS_MagazineAssembly' }
this.parts.SKS_Receiver.ConditionLowerChance = 2
this.parts.SKS_Receiver.ConditionMax = 20
this.parts.SKS_GasPiston = {}
this.parts.SKS_GasPiston.InsertsInto = 'SKS_Receiver'
this.parts.SKS_GasPiston.ConditionLowerChance = 3
this.parts.SKS_GasPiston.ConditionMax = 20
this.parts.SKS_TriggerAssembly = {}
this.parts.SKS_TriggerAssembly.InsertsInto = 'SKS_Receiver'
this.parts.SKS_TriggerAssembly.ConditionLowerChance = 4
this.parts.SKS_TriggerAssembly.ConditionMax = 20
this.parts.SKS_MagazineAssembly = {}
this.parts.SKS_MagazineAssembly.InsertsInto = 'SKS_Receiver'
this.parts.SKS_MagazineAssembly.ConditionLowerChance = 3
this.parts.SKS_MagazineAssembly.ConditionMax = 20
this.parts.SKS_BoltCarrier = {}
this.parts.SKS_BoltCarrier.CombinesWith = 'SKS_Receiver'
this.parts.SKS_BoltCarrier.Holds = { 'SKS_Bolt', 'SKS_FiringPin' }
this.parts.SKS_BoltCarrier.ConditionLowerChance = 3
this.parts.SKS_BoltCarrier.ConditionMax = 20
this.parts.SKS_Bolt = {}
this.parts.SKS_Bolt.InsertsInto = 'SKS_BoltCarrier'
this.parts.SKS_Bolt.ConditionLowerChance = 4
this.parts.SKS_Bolt.ConditionMax = 20
this.parts.SKS_FiringPin = {}
this.parts.SKS_FiringPin.InsertsInto = 'SKS_BoltCarrier'
this.parts.SKS_FiringPin.ConditionLowerChance = 4
this.parts.SKS_FiringPin.ConditionMax = 20
this.parts.AK47_Receiver = {}
this.parts.AK47_Receiver.CombinesWith = 'AK47_BoltCarrier'
this.parts.AK47_Receiver.Holds = { 'AK47_GasTube' }
this.parts.AK47_Receiver.ConditionLowerChance = 1
this.parts.AK47_Receiver.ConditionMax = 20
this.parts.AK47_GasTube = {}
this.parts.AK47_GasTube.InsertsInto = 'AK47_Receiver'
this.parts.AK47_GasTube.ConditionLowerChance = 2
this.parts.AK47_GasTube.ConditionMax = 20
this.parts.AK47_BoltCarrier = {}
this.parts.AK47_BoltCarrier.CombinesWith = 'AK47_Receiver'
this.parts.AK47_BoltCarrier.Holds = { 'AK47_Bolt' }
this.parts.AK47_BoltCarrier.ConditionLowerChance = 2
this.parts.AK47_BoltCarrier.ConditionMax = 20
this.parts.AK47_Bolt = {}
this.parts.AK47_Bolt.InsertsInto = 'AK47_BoltCarrier'
this.parts.AK47_Bolt.ConditionLowerChance = 3
this.parts.AK47_Bolt.ConditionMax = 20
this.parts.PistolReceiver_45acp = {}
this.parts.PistolReceiver_45acp.CombinesWith = 'PistolSlide_45acp'
this.parts.PistolReceiver_45acp.ConditionLowerChance = 1 -- 100%
this.parts.PistolReceiver_45acp.ConditionMax = 20
this.parts.PistolSlide_45acp = {}
this.parts.PistolSlide_45acp.CombinesWith = 'PistolReceiver_45acp'
this.parts.PistolSlide_45acp.Holds = { 'PistolBarrel_45acp' }
this.parts.PistolSlide_45acp.ConditionLowerChance = 2 -- 1/2
this.parts.PistolSlide_45acp.ConditionMax = 20
this.parts.PistolBarrel_9mm = {}
this.parts.PistolBarrel_9mm.InsertsInto = 'PistolSlide_9mm'
this.parts.PistolBarrel_9mm.ConditionLowerChance = 3 -- 1/3
this.parts.PistolBarrel_9mm.ConditionMax = 20
this.parts.PistolReceiver_9mm = {}
this.parts.PistolReceiver_9mm.CombinesWith = 'PistolSlide_9mm'
this.parts.PistolReceiver_9mm.ConditionLowerChance = 1 -- 100%
this.parts.PistolReceiver_9mm.ConditionMax = 20
this.parts.PistolSlide_9mm = {}
this.parts.PistolSlide_9mm.CombinesWith = 'PistolReceiver_9mm'
this.parts.PistolSlide_9mm.Holds = { 'PistolBarrel_9mm' }
this.parts.PistolSlide_9mm.ConditionLowerChance = 2 -- 1/2
this.parts.PistolSlide_9mm.ConditionMax = 20
this.parts.PistolBarrel_9mm = {}
this.parts.PistolBarrel_9mm.InsertsInto = 'PistolSlide_9mm'
this.parts.PistolBarrel_9mm.ConditionLowerChance = 3 -- 1/3
this.parts.PistolBarrel_9mm.ConditionMax = 20
this.parts.PistolBarrel_45acp = {}
this.parts.PistolBarrel_45acp.InsertsInto = 'PistolSlide_45acp'
this.parts.PistolBarrel_45acp.ConditionLowerChance = 3 -- 1/3
this.parts.PistolBarrel_45acp.ConditionMax = 20
this.parts.ShotgunReceiver_10g = {}
this.parts.ShotgunReceiver_10g.CombinesWith = 'ShotgunBarrel_10g'
this.parts.ShotgunReceiver_10g.Holds = { 'ShotgunForend_10g' }
this.parts.ShotgunReceiver_10g.ConditionLowerChance = 1
this.parts.ShotgunReceiver_10g.ConditionMax = 20
this.parts.ShotgunForend_10g = {}
this.parts.ShotgunForend_10g.InsertsInto = 'ShotgunReceiver_10g'
this.parts.ShotgunForend_10g.Holds = { 'ShotgunBoltCarrier_10g' }
this.parts.ShotgunForend_10g.ConditionLowerChance = 2
this.parts.ShotgunForend_10g.ConditionMax = 20
this.parts.ShotgunBoltCarrier_10g = {}
this.parts.ShotgunBoltCarrier_10g.InsertsInto = 'ShotgunForend_10g'
this.parts.ShotgunBoltCarrier_10g.Holds = { 'ShotgunBolt_10g' }
this.parts.ShotgunBoltCarrier_10g.ConditionLowerChance = 4
this.parts.ShotgunBoltCarrier_10g.ConditionMax = 20
this.parts.ShotgunBolt_10g = {}
this.parts.ShotgunBolt_10g.InsertsInto = 'ShotgunBoltCarrier_10g'
this.parts.ShotgunBolt_10g.ConditionLowerChance = 3
this.parts.ShotgunBolt_10g.ConditionMax = 20
this.parts.ShotgunBarrel_10g = {}
this.parts.ShotgunBarrel_10g.CombinesWith = 'ShotgunReceiver_10g'
this.parts.ShotgunBarrel_10g.ConditionLowerChance = 3
this.parts.ShotgunBarrel_10g.ConditionMax = 20
this.parts.ShotgunReceiver_12g = {}
this.parts.ShotgunReceiver_12g.CombinesWith = 'ShotgunBarrel_12g'
this.parts.ShotgunReceiver_12g.Holds = { 'ShotgunForend_12g' }
this.parts.ShotgunReceiver_12g.ConditionLowerChance = 1
this.parts.ShotgunReceiver_12g.ConditionMax = 20
this.parts.ShotgunForend_12g = {}
this.parts.ShotgunForend_12g.InsertsInto = 'ShotgunReceiver_12g'
this.parts.ShotgunForend_12g.Holds = { 'ShotgunBoltCarrier_12g' }
this.parts.ShotgunForend_12g.ConditionLowerChance = 2
this.parts.ShotgunForend_12g.ConditionMax = 20
this.parts.ShotgunBoltCarrier_12g = {}
this.parts.ShotgunBoltCarrier_12g.InsertsInto = 'ShotgunForend_12g'
this.parts.ShotgunBoltCarrier_12g.Holds = { 'ShotgunBolt_12g' }
this.parts.ShotgunBoltCarrier_12g.ConditionLowerChance = 4
this.parts.ShotgunBoltCarrier_12g.ConditionMax = 20
this.parts.ShotgunBolt_12g = {}
this.parts.ShotgunBolt_12g.InsertsInto = 'ShotgunBoltCarrier_12g'
this.parts.ShotgunBolt_12g.ConditionLowerChance = 3
this.parts.ShotgunBolt_12g.ConditionMax = 20
this.parts.ShotgunBarrel_12g = {}
this.parts.ShotgunBarrel_12g.CombinesWith = 'ShotgunReceiver_12g'
this.parts.ShotgunBarrel_12g.ConditionLowerChance = 3
this.parts.ShotgunBarrel_12g.ConditionMax = 20
this.parts.PistolReceiver_22lr = {}
this.parts.PistolReceiver_22lr.CombinesWith = 'PistolSlide_22lr'
this.parts.PistolReceiver_22lr.ConditionLowerChance = 1 -- 100%
this.parts.PistolReceiver_22lr.ConditionMax = 20
this.parts.PistolSlide_22lr = {}
this.parts.PistolSlide_22lr.CombinesWith = 'PistolReceiver_22lr'
this.parts.PistolSlide_22lr.Holds = { 'PistolBarrel_22lr' }
this.parts.PistolSlide_22lr.ConditionLowerChance = 2 -- 1/2
this.parts.PistolSlide_22lr.ConditionMax = 20
this.parts.PistolBarrel_22lr = {}
this.parts.PistolBarrel_22lr.InsertsInto = 'PistolSlide_22lr'
this.parts.PistolBarrel_22lr.ConditionLowerChance = 3 -- 1/3
this.parts.PistolBarrel_22lr.ConditionMax = 20
this.parts.RevolverReceiver_45lc = {}
this.parts.RevolverReceiver_45lc.CombinesWith = 'RevolverCylinder_45lc'
this.parts.RevolverReceiver_45lc.ConditionLowerChance = 1
this.parts.RevolverReceiver_45lc.ConditionMax = 20
this.parts.RevolverCylinder_45lc = {}
this.parts.RevolverCylinder_45lc.CombinesWith = 'RevolverReceiver_45lc'
this.parts.RevolverCylinder_45lc.ConditionLowerChance = 3
this.parts.RevolverCylinder_45lc.ConditionMax = 20
this.parts.PistolReceiver_380acp = {}
this.parts.PistolReceiver_380acp.CombinesWith = 'PistolSlide_380acp'
this.parts.PistolReceiver_380acp.ConditionLowerChance = 1 -- 100%
this.parts.PistolReceiver_380acp.ConditionMax = 20
this.parts.PistolSlide_380acp = {}
this.parts.PistolSlide_380acp.CombinesWith = 'PistolReceiver_380acp'
this.parts.PistolSlide_380acp.Holds = { 'PistolBarrel_380acp' }
this.parts.PistolSlide_380acp.ConditionLowerChance = 2 -- 1/2
this.parts.PistolSlide_380acp.ConditionMax = 20
this.parts.PistolBarrel_380acp = {}
this.parts.PistolBarrel_380acp.InsertsInto = 'PistolSlide_380acp'
this.parts.PistolBarrel_380acp.ConditionLowerChance = 3 -- 1/3
this.parts.PistolBarrel_380acp.ConditionMax = 20
this.parts.RifleLowerReceiver_556 = {}
this.parts.RifleLowerReceiver_556.CombinesWith = 'RifleUpperReceiver_556'
this.parts.RifleLowerReceiver_556.ConditionLowerChance = 2
this.parts.RifleLowerReceiver_556.ConditionMax = 20
this.parts.RifleUpperReceiver_556 = {}
this.parts.RifleUpperReceiver_556.CombinesWith = 'RifleLowerReceiver_556'
this.parts.RifleUpperReceiver_556.Holds = { 'RifleBoltCarrier_556' }
this.parts.RifleUpperReceiver_556.ConditionLowerChance = 2
this.parts.RifleUpperReceiver_556.ConditionMax = 20
this.parts.RifleBoltCarrier_556 = {}
this.parts.RifleBoltCarrier_556.InsertsInto = 'RifleUpperReceiver_556'
this.parts.RifleBoltCarrier_556.Holds = { 'RifleFiringPin_556', 'RifleBolt_556' }
this.parts.RifleBoltCarrier_556.ConditionLowerChance = 3
this.parts.RifleBoltCarrier_556.ConditionMax = 20
this.parts.RifleFiringPin_556 = {}
this.parts.RifleFiringPin_556.InsertsInto = 'RifleBoltCarrier_556'
this.parts.RifleFiringPin_556.ConditionLowerChance = 4
this.parts.RifleFiringPin_556.ConditionMax = 20
this.parts.RifleBolt_556 = {}
this.parts.RifleBolt_556.InsertsInto = 'RifleBoltCarrier_556'
this.parts.RifleBolt_556.ConditionLowerChance = 2
this.parts.RifleBolt_556.ConditionMax = 20
this.parts.RevolverReceiver_357 = {}
this.parts.RevolverReceiver_357.CombinesWith = 'RevolverCylinder_357'
this.parts.RevolverReceiver_357.ConditionLowerChance = 1
this.parts.RevolverReceiver_357.ConditionMax = 20
this.parts.RevolverCylinder_357 = {}
this.parts.RevolverCylinder_357.CombinesWith = 'RevolverReceiver_357'
this.parts.RevolverCylinder_357.ConditionLowerChance = 3
this.parts.RevolverCylinder_357.ConditionMax = 20
this.parts.PistolReceiver_44cal = {}
this.parts.PistolReceiver_44cal.CombinesWith = 'PistolSlide_44cal'
this.parts.PistolReceiver_44cal.ConditionLowerChance = 1 -- 100%
this.parts.PistolReceiver_44cal.ConditionMax = 20
this.parts.PistolSlide_44cal = {}
this.parts.PistolSlide_44cal.CombinesWith = 'PistolReceiver_44cal'
this.parts.PistolSlide_44cal.Holds = { 'PistolBarrel_44cal' }
this.parts.PistolSlide_44cal.ConditionLowerChance = 2 -- 1/2
this.parts.PistolSlide_44cal.ConditionMax = 20
this.parts.PistolBarrel_44cal = {}
this.parts.PistolBarrel_44cal.InsertsInto = 'PistolSlide_44cal'
this.parts.PistolBarrel_44cal.ConditionLowerChance = 3 -- 1/3
this.parts.PistolBarrel_44cal.ConditionMax = 20
this.parts.RevolverReceiver_38spc = {}
this.parts.RevolverReceiver_38spc.CombinesWith = 'RevolverCylinder_38spc'
this.parts.RevolverReceiver_38spc.ConditionLowerChance = 1
this.parts.RevolverReceiver_38spc.ConditionMax = 20
this.parts.RevolverCylinder_38spc = {}
this.parts.RevolverCylinder_38spc.CombinesWith = 'RevolverReceiver_38spc'
this.parts.RevolverCylinder_38spc.ConditionLowerChance = 3
this.parts.RevolverCylinder_38spc.ConditionMax = 20
this.parts.ShotgunReceiver_410g = {}
this.parts.ShotgunReceiver_410g.CombinesWith = 'ShotgunBarrel_410g'
this.parts.ShotgunReceiver_410g.Holds = { 'ShotgunForend_410g' }
this.parts.ShotgunReceiver_410g.ConditionLowerChance = 1
this.parts.ShotgunReceiver_410g.ConditionMax = 20
this.parts.ShotgunForend_410g = {}
this.parts.ShotgunForend_410g.InsertsInto = 'ShotgunReceiver_410g'
this.parts.ShotgunForend_410g.Holds = { 'ShotgunBoltCarrier_410g' }
this.parts.ShotgunForend_410g.ConditionLowerChance = 2
this.parts.ShotgunForend_410g.ConditionMax = 20
this.parts.ShotgunBoltCarrier_410g = {}
this.parts.ShotgunBoltCarrier_410g.InsertsInto = 'ShotgunForend_410g'
this.parts.ShotgunBoltCarrier_410g.Holds = { 'ShotgunBolt_410g' }
this.parts.ShotgunBoltCarrier_410g.ConditionLowerChance = 4
this.parts.ShotgunBoltCarrier_410g.ConditionMax = 20
this.parts.ShotgunBolt_410g = {}
this.parts.ShotgunBolt_410g.InsertsInto = 'ShotgunBoltCarrier_410g'
this.parts.ShotgunBolt_410g.ConditionLowerChance = 3
this.parts.ShotgunBolt_410g.ConditionMax = 20
this.parts.ShotgunBarrel_410g = {}
this.parts.ShotgunBarrel_410g.CombinesWith = 'ShotgunReceiver_410g'
this.parts.ShotgunBarrel_410g.ConditionLowerChance = 3
this.parts.ShotgunBarrel_410g.ConditionMax = 20
this.parts.ShotgunReceiver_20g = {}
this.parts.ShotgunReceiver_20g.CombinesWith = 'ShotgunBarrel_20g'
this.parts.ShotgunReceiver_20g.Holds = { 'ShotgunForend_20g' }
this.parts.ShotgunReceiver_20g.ConditionLowerChance = 1
this.parts.ShotgunReceiver_20g.ConditionMax = 20
this.parts.ShotgunForend_20g = {}
this.parts.ShotgunForend_20g.InsertsInto = 'ShotgunReceiver_20g'
this.parts.ShotgunForend_20g.Holds = { 'ShotgunBoltCarrier_20g' }
this.parts.ShotgunForend_20g.ConditionLowerChance = 2
this.parts.ShotgunForend_20g.ConditionMax = 20
this.parts.ShotgunBoltCarrier_20g = {}
this.parts.ShotgunBoltCarrier_20g.InsertsInto = 'ShotgunForend_20g'
this.parts.ShotgunBoltCarrier_20g.Holds = { 'ShotgunBolt_20g' }
this.parts.ShotgunBoltCarrier_20g.ConditionLowerChance = 4
this.parts.ShotgunBoltCarrier_20g.ConditionMax = 20
this.parts.ShotgunBolt_20g = {}
this.parts.ShotgunBolt_20g.InsertsInto = 'ShotgunBoltCarrier_20g'
this.parts.ShotgunBolt_20g.ConditionLowerChance = 3
this.parts.ShotgunBolt_20g.ConditionMax = 20
this.parts.ShotgunBarrel_20g = {}
this.parts.ShotgunBarrel_20g.CombinesWith = 'ShotgunReceiver_20g'
this.parts.ShotgunBarrel_20g.ConditionLowerChance = 3
this.parts.ShotgunBarrel_20g.ConditionMax = 20
this.parts.RifleLowerReceiver_308BA = {}
this.parts.RifleLowerReceiver_308BA.CombinesWith = 'RifleUpperReceiver_308BA'
this.parts.RifleLowerReceiver_308BA.ConditionLowerChance = 2
this.parts.RifleLowerReceiver_308BA.ConditionMax = 20
this.parts.RifleUpperReceiver_308BA = {}
this.parts.RifleUpperReceiver_308BA.CombinesWith = 'RifleLowerReceiver_308BA'
this.parts.RifleUpperReceiver_308BA.Holds = { 'RifleBoltCarrier_308BA' }
this.parts.RifleUpperReceiver_308BA.ConditionLowerChance = 2
this.parts.RifleUpperReceiver_308BA.ConditionMax = 20
this.parts.RifleBoltCarrier_308BA = {}
this.parts.RifleBoltCarrier_308BA.InsertsInto = 'RifleUpperReceiver_308BA'
this.parts.RifleBoltCarrier_308BA.Holds = { 'RifleFiringPin_308BA', 'RifleBolt_308BA' }
this.parts.RifleBoltCarrier_308BA.ConditionLowerChance = 3
this.parts.RifleBoltCarrier_308BA.ConditionMax = 20
this.parts.RifleFiringPin_308BA = {}
this.parts.RifleFiringPin_308BA.InsertsInto = 'RifleBoltCarrier_308BA'
this.parts.RifleFiringPin_308BA.ConditionLowerChance = 4
this.parts.RifleFiringPin_308BA.ConditionMax = 20
this.parts.RifleBolt_308BA = {}
this.parts.RifleBolt_308BA.InsertsInto = 'RifleBoltCarrier_308BA'
this.parts.RifleBolt_308BA.ConditionLowerChance = 2
this.parts.RifleBolt_308BA.ConditionMax = 20
this.parts.RifleLowerReceiver_308AR = {}
this.parts.RifleLowerReceiver_308AR.CombinesWith = 'RifleUpperReceiver_308AR'
this.parts.RifleLowerReceiver_308AR.ConditionLowerChance = 2
this.parts.RifleLowerReceiver_308AR.ConditionMax = 20
this.parts.RifleUpperReceiver_308AR = {}
this.parts.RifleUpperReceiver_308AR.CombinesWith = 'RifleLowerReceiver_308AR'
this.parts.RifleUpperReceiver_308AR.Holds = { 'RifleBoltCarrier_308AR' }
this.parts.RifleUpperReceiver_308AR.ConditionLowerChance = 2
this.parts.RifleUpperReceiver_308AR.ConditionMax = 20
this.parts.RifleBoltCarrier_308AR = {}
this.parts.RifleBoltCarrier_308AR.InsertsInto = 'RifleUpperReceiver_308AR'
this.parts.RifleBoltCarrier_308AR.Holds = { 'RifleFiringPin_308AR', 'RifleBolt_308AR' }
this.parts.RifleBoltCarrier_308AR.ConditionLowerChance = 3
this.parts.RifleBoltCarrier_308AR.ConditionMax = 20
this.parts.RifleFiringPin_308AR = {}
this.parts.RifleFiringPin_308AR.InsertsInto = 'RifleBoltCarrier_308AR'
this.parts.RifleFiringPin_308AR.ConditionLowerChance = 4
this.parts.RifleFiringPin_308AR.ConditionMax = 20
this.parts.RifleBolt_308AR = {}
this.parts.RifleBolt_308AR.InsertsInto = 'RifleBoltCarrier_308AR'
this.parts.RifleBolt_308AR.ConditionLowerChance = 2
this.parts.RifleBolt_308AR.ConditionMax = 20
this.parts.ShotgunReceiver_4g = {}
this.parts.ShotgunReceiver_4g.CombinesWith = 'ShotgunBarrel_4g'
this.parts.ShotgunReceiver_4g.Holds = { 'ShotgunForend_4g' }
this.parts.ShotgunReceiver_4g.ConditionLowerChance = 1
this.parts.ShotgunReceiver_4g.ConditionMax = 20
this.parts.ShotgunForend_4g = {}
this.parts.ShotgunForend_4g.InsertsInto = 'ShotgunReceiver_4g'
this.parts.ShotgunForend_4g.Holds = { 'ShotgunBoltCarrier_4g' }
this.parts.ShotgunForend_4g.ConditionLowerChance = 2
this.parts.ShotgunForend_4g.ConditionMax = 20
this.parts.ShotgunBoltCarrier_4g = {}
this.parts.ShotgunBoltCarrier_4g.InsertsInto = 'ShotgunForend_4g'
this.parts.ShotgunBoltCarrier_4g.Holds = { 'ShotgunBolt_4g' }
this.parts.ShotgunBoltCarrier_4g.ConditionLowerChance = 4
this.parts.ShotgunBoltCarrier_4g.ConditionMax = 20
this.parts.ShotgunBolt_4g = {}
this.parts.ShotgunBolt_4g.InsertsInto = 'ShotgunBoltCarrier_4g'
this.parts.ShotgunBolt_4g.ConditionLowerChance = 3
this.parts.ShotgunBolt_4g.ConditionMax = 20
this.parts.ShotgunBarrel_4g = {}
this.parts.ShotgunBarrel_4g.CombinesWith = 'ShotgunReceiver_4g'
this.parts.ShotgunBarrel_4g.ConditionLowerChance = 3
this.parts.ShotgunBarrel_4g.ConditionMax = 20
this.parts.PistolReceiver_50ae = {}
this.parts.PistolReceiver_50ae.CombinesWith = 'PistolSlide_50ae'
this.parts.PistolReceiver_50ae.ConditionLowerChance = 1 -- 100%
this.parts.PistolReceiver_50ae.ConditionMax = 20

this.getPartModel = function(modelName)
	return this.parts[modelName]
end

this.getModData = function(item)
	ItemHandler.createModDataIfNotExist(item)

	return ItemHandler.getModDataFromItem(item)
end

-- https://gist.github.com/MihailJP/3931841
this.tableDeepCopy = function(t)
	if type(t) ~= "table" then return t end
	local meta = getmetatable(t)
	local target = {}
	for k, v in pairs(t) do
			if type(v) == "table" then
					target[k] = this.tableDeepCopy(v)
			else
					target[k] = v
			end
	end
	setmetatable(target, meta)
	return target
end

this.initializeFirearmModData = function(firearm)
	local model = this.getFirearmModelForItem(firearm)
	if not model then
		return
	end
	local type = firearm:getFullType()
	local data = this.getModData(firearm)
	local cond = firearm:getCondition() / firearm:getConditionMax()

	if not data.parts then
		print("Initializing firearm: " .. type)
		data.parts = {}

		for _,k in ipairs(model.BreaksInto) do
			data.parts[k] = this.initializeDataForPart(k, nil, true, cond) -- looted guns always have all their parts
		end

		this.updateFirearm(firearm)
	end
end

this.initializeDataForPart = function(type, data, guaranteedParts, overrideConditionPct)
	print("Initializing mod data for part: " .. type)
	local model = this.getPartModel(type)

	-- this function either creates a new table (and returns it)
	-- or uses the table that you provided
	if not data then
		data = {}
	end

	if not data.conditionLowerChance then
		data.conditionLowerChance = nvl(model.ConditionLowerChance, 0)
	end

	if not data.conditionMax then
		data.conditionMax = nvl(model.ConditionMax, 10)
	end

	if not data.condition then
		-- we have not yet determined a condition for this part
		local initialConditionPct

		if overrideConditionPct and not SandboxVars.coavinsfirearms.RollConditionForParts then
			-- this part is probably inside a gun that already had a condition rolled for it
			initialConditionPct = overrideConditionPct
			print(string.format('inherit condition %.2f', initialConditionPct))
		else
			-- generate a starting condition for gun which the user just picked up
			local initialMax = SandboxVars.coavinsfirearms.InitialConditionMax
			local initialMin = SandboxVars.coavinsfirearms.InitialConditionMin
			if initialMax < initialMin then
				initialMax = 1.0
			end
			local difference = initialMax - initialMin
			initialConditionPct = initialMax - (ZombRand((difference * 100) + 1) / 100.0)
			print(string.format('rolled condition %.2f between %.2f and %.2f', initialConditionPct, initialMin, initialMax))
		end

		data.condition = math.floor(data.conditionMax * initialConditionPct)
		print(string.format('set new condition: %.2f', data.condition))
	else
		-- we already determined a condition for this part
		print(string.format('found existing condition: %.2f', data.condition))
	end

	if not data.parts then
		data.parts = {}
		if model.BreaksInto then
			for _,k in ipairs(model.BreaksInto) do
				data.parts[k] = this.initializeDataForPart(k, nil, guaranteedParts, overrideConditionPct)
			end
		end
		if model.Holds then
			for _,k in ipairs(model.Holds) do
				-- 50% chance for this part to be missing
				if guaranteedParts or ZombRand(2) == 0 then
					data.parts[k] = this.initializeDataForPart(k, nil, guaranteedParts, overrideConditionPct)
				end
			end
		end
	end

	return data
end

this.initializePartItem = function(item)
	print("Initializing part: " .. item:getFullType())
	local type = item:getType()
	local data = this.getModData(item)

	local shouldUpdateItemCondition = false

	if not data.condition then
		shouldUpdateItemCondition = true
	end

	this.initializeDataForPart(type, data)

	if shouldUpdateItemCondition then
		item:setCondition(data.condition)
	end
end

this.checkConditionForAllParts = function(model, installedParts, damage)
	local modelParts = nvl(nvl(model.BreaksInto, model.Holds), {})
	local lowestCondition = 1.0

	-- for each part we're supposed to have
	for _,part in ipairs(modelParts) do
		local installedPart = installedParts[part]
		if installedPart then
			-- this part is installed
			if damage and damage > 0 then
				-- try to apply damage
				if ZombRand(installedPart.conditionLowerChance) == 0 then
					-- apply damage to this part
					print(string.format('Apply %.0f damage to %s', damage, part))
					installedPart.condition = installedPart.condition - damage
					if installedPart.condition < 0 then
						installedPart.condition = 0
					end
				end
			end

			print(string.format('%s has %.0f condition', part, installedPart.condition))

			-- remember lowest condition
			local thisCondition = installedPart.condition / installedPart.conditionMax
			if thisCondition < lowestCondition then
				lowestCondition = thisCondition
			end

			-- recursively check this part's parts
			if installedPart.parts then
				local lowest = this.checkConditionForAllParts(this.getPartModel(part), installedPart.parts, damage)
				if lowest < lowestCondition then
					lowestCondition = lowest
				end
			end
		else
			-- this part is not installed
			lowestCondition = 0
		end
	end

	return lowestCondition
end

-- updates firearm to match condition of most damaged part
-- optionally deals condition damage to parts
this.updateFirearm = function(firearm, conditionDamage)
	local model = this.getFirearmModelForItem(firearm)
	if not model then
		return
	end
	local data = this.getModData(firearm)

	if not data.parts then
		this.initializeFirearmModData(firearm)
	end

	local lowestCondition = this.checkConditionForAllParts(model, data.parts, conditionDamage)

	local max = firearm:getConditionMax()
	local actual = lowestCondition * max

	print(string.format('Set firearm to %.0f', actual))

	firearm:setCondition(actual)
end

this.getShortNameForPart = function(part)
	return getItemNameFromFullType('coavinsfirearms.' .. part .. '_Short')
end

this.getNameForPart = function(part)
	return getItemNameFromFullType('coavinsfirearms.' .. part)
end

this.getTooltipTextForItem = function(item)
	local type = item:getType()
	local data = this.getModData(item)
	local model = this.getFirearmModelForItem(item)
	local cond
	local condMax
	if model then
		-- it's a firearm
		this.initializeFirearmModData(item)
		cond = item:getCondition()
		condMax = item:getConditionMax()
	else
		-- it's a component
		model = this.getPartModel(type)
		this.initializeDataForPart(type, data)
		cond = item:getCondition()
		condMax = model.ConditionMax
	end

	return this.getTooltipText(model, data, cond, condMax)
end

this.getTooltipTextForPartData = function(type, data)
	local model = this.getPartModel(type)

	this.initializeDataForPart(type, data)

	return this.getTooltipText(model, data, data.condition, model.ConditionMax)
end

this.generateTooltipForModel = function(text, model, data)
	if model.BreaksInto then
		for _,part in ipairs(model.BreaksInto) do
			local component = data.parts[part]
			local componentModel = this.getPartModel(part)
			if text ~= '' then
				text = text .. ' <LINE> '
			end
			local pct = (component.condition / component.conditionMax) * 100
			text = text .. ' <RGB:0.8,0.8,0.8> ' .. this.getShortNameForPart(part) .. ': ' .. string.format('%.0f%%', pct)
			text = this.generateTooltipForModel(text, componentModel, component)
		end
	end

	if model.Holds then
		for _,part in ipairs(model.Holds) do
			local component = data.parts[part]
			local componentModel = this.getPartModel(part)
			if text ~= '' then
				text = text .. ' <LINE> '
			end
			if component then
				local pct = (component.condition / component.conditionMax) * 100
				text = text .. ' <RGB:0.8,0.8,0.8> ' .. this.getShortNameForPart(part) .. ': ' .. string.format('%.0f%%', pct)
				text = this.generateTooltipForModel(text, componentModel, component)
			else
				text = text .. ' <RGB:1,0,0> ' .. this.getShortNameForPart(part) .. ': '
				text = text .. getText('ContextMenu_Firearm_NotInstalled')
			end
		end
	end

	return text
end

this.getTooltipText = function(model, data, condition, conditionMax)
	local text

	-- show condition
	local conditionPct = (condition / conditionMax) * 100
	if conditionPct == 0 then
		text = ' <RGB:1,0,0> ' .. getText('Tooltip_weapon_Condition') .. ': ' .. string.format('%.0f%%', conditionPct)
	else
		text = ' <RGB:1,1,1> ' .. getText('Tooltip_weapon_Condition') .. ': ' .. string.format('%.0f%%', conditionPct)
	end


	text = this.generateTooltipForModel(text, model, data)

	return text
end

this.copyDataFromParent = function(parentItem, childItem)
	local parentData = this.getModData(parentItem)
	local childType = childItem:getType()
	local childData = this.getModData(childItem) -- don't reassign

	-- try to get data for this type from the parent
	local data = nil
	if parentData.parts then
		data = parentData.parts[childType]
	end

	local newData
	if data then
		-- copy data from parent
		newData = this.tableDeepCopy(data)
	else
		-- no data, this item hasn't been disassembled before
		newData = this.initializeDataForPart(childType)
	end

	-- copy data to child
	childData.condition = newData.condition
	childData.conditionLowerChance = newData.conditionLowerChance
	childData.conditionMax = newData.conditionMax
	childData.parts = newData.parts

	-- apply condition
	childItem:setCondition(newData.condition)
end

return this
