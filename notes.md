# Parts introduced by this mod

## Handguns

### Revolvers

* Revolver Frame
* Revolver Cylinder

### Pistols

* Pistol Receiver
* Pistol Slide
	* Pistol Barrel

### Not handled

* Magazines (must be removed prior to disassembly)
* Sights (must be removed prior to disassembly)
* Grip
* Trigger
* Hammer
* Firing pin
* Magwell

## Rifles

### M16 Assault Rifle

* Lower Receiver
* Upper
	* Bolt carrier
		* Bolt
		* Firing pin

### Others

## ?

## Shotguns

## ?

# Operations

* A + B -> C
* C -> A & B
* A + B = A(B)
* A - B = A(_)

# Comments

so modData is saved client side, and recipes that have execute oncreates, will save things on clientside. you need to explicitly send commands to the server from the client, and something on the serverside to receive the commands to tell the server to modify the moddata. Then the oncreate would also need the same commands to the server get the info from the server to be able to get info back tot he client, so it can be used in the oncreate. This is if you want to have it working properly in multiplayer

in SP you dont need to do all this stuff. it would technically work in MP, if you put in some code to handle nil cases, since other players wont be able to access the modData, because their client doesnt have that info. So you could make it "work" in MP, but it would be abusable. Like one player attaches a blade to an almost broken spear. Gives it to another player, and they remove the blade. Their client doesnt know what to put the durability to, so you have to just have some default value put in