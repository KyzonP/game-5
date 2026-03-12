extends Area2D

signal powerUpCrossed(powerUp)
var eaten : bool = false

func _on_area_entered(area):
	if !eaten:
		event_bus.emit_signal("ghostState", "frightened")
		eaten = true
		powerUpCrossed.emit(self)
