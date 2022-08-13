-- To add a new model, just include a file like this and call the function below

CoavinsFirearms.AddOrReplaceModel(
	'GenericPistol'
, { 'PistolReceiver', 'PistolSlide' }
, 'PistolReceiver'
, 'Base.Pistol')
CoavinsFirearms.AddOrReplaceModel(
	'GenericRevolver'
, { 'RevolverReceiver', 'RevolverCylinder' }
, 'RevolverReceiver'
, 'Base.Revolver')
CoavinsFirearms.AddOrReplaceModel(
	'GenericShotgun'
, { 'ShotgunReceiver', 'ShotgunBarrel' }
, 'ShotgunReceiver'
, 'Base.Shotgun')
CoavinsFirearms.AddOrReplaceModel(
	'M16Rifle'
, { 'M16UpperReceiver', 'M16LowerReceiver' }
, 'M16LowerReceiver'
, 'Base.AssaultRifle')
CoavinsFirearms.AddOrReplaceModel(
	'BoltActionRifle'
, { 'BoltActionReceiver', 'BoltActionBolt' }
, 'BoltActionReceiver'
, 'Base.VarmintRifle')

CoavinsFirearms.AddOrReplaceModel(
	'SKS'
, { 'SKS_Receiver', 'SKS_BoltCarrier' }
, 'SKS_Receiver')

CoavinsFirearms.AddOrReplaceModel(
	'AK47'
, { 'AK47_Receiver', 'AK47_BoltCarrier' }
, 'AK47_Receiver')