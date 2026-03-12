extends Node2D

var pellets : int

var pelletGroup : Array
var powerupGroup : Array

signal scoreChanged

func _ready():
	pellets = _countPellets()
	_createGroups()
	
	event_bus.restart.connect(reset)
	
func removePellet(pellet):
	pellet.visible = false
	
	scoreChanged.emit(10)
	
	event_bus.emit_signal("pelletConsumed")
	
func removePowerUp(powerUp):
	powerUp.visible = false
	
	scoreChanged.emit(50)
	
	event_bus.emit_signal("pelletConsumed")
	
func _countPellets():
	var pelletCount = 0
	
	for i in self.get_children():
		if i.is_in_group("pellet"):
			i.connect("pelletCrossed", removePellet)
			
			if i.eaten == false:
				pelletCount += 1
	
	return pelletCount
	
func _createGroups():
	for i in self.get_children():
		if i.is_in_group("powerup"):
			powerupGroup.append(i)
			i.connect("powerUpCrossed", removePowerUp)
		elif i.is_in_group("pellet"):
			pelletGroup.append(i)
	
func reset(death, level):
	# If a restart is happening due to a death
	if death:
		pass
		
	# If a restart is happening due to completion of the level
	else:
		for i in pelletGroup:
			i.visible = true
			i.eaten = false
		for i in powerupGroup:
			i.visible = true
			i.eaten = false
			
		pellets = _countPellets()
