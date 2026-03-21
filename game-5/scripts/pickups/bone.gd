extends Area2D

var eaten : bool = true

var timer : float = 0.0
var timerMax : float = 10.0

@onready var anim = $Sprite

### AUDIO ###
var boneSound = preload("res://audio/bone_randomizer.tres")

func _ready():
	anim.animation = level_stats.getStats(level_stats.fruitName)
	
	event_bus.spawnFruit.connect(spawnBone)
	event_bus.restart.connect(reset)
		
func reset(_death, _level):
	despawnBone()
	timer = 0.0
	anim.animation = level_stats.getStats(level_stats.fruitName)

func _physics_process(delta):
	if !eaten:
		timer += delta
		
		if timer >= timerMax:
			despawnBone()

func _on_area_entered(area):
	if !eaten and area.is_in_group("player"):
		
		AudioManager.play_sfx(boneSound)
		despawnBone()
		event_bus.fruitEaten.emit(level_stats.getStats(level_stats.bonusPoints))

func spawnBone():
	if eaten:
		AudioManager.play_sfx(boneSound)
		timer = 0.0
		visible = true
		eaten = false
		
		timerMax = randf_range(9.0,10.0)
	
func despawnBone():
	AudioManager.play_sfx(boneSound)
	visible = false
	eaten = true

	
