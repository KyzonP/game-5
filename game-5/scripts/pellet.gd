extends Area2D

signal pelletCrossed(pellet)

var eaten = false

func _on_area_entered(area):
	if !eaten:
		eaten = true
		pelletCrossed.emit(self)
