extends Area2D

signal powerUpCrossed(powerUp)
var eaten : bool = false

func _on_area_entered(area):
	if !eaten:
		event_bus.emit_signal("ghostState", "frightened")
		if area.is_in_group("player") or area.is_in_group("elroy"):
			area.powerupFreeze = true
		eaten = true
		powerUpCrossed.emit(self)
