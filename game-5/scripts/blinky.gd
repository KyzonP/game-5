extends Node2D

@export var scatterTile : Vector2i
@export var player : Area2D
@export var pelletsEaten : int = 0
@export var releasePellets : int
@export var released : bool = false

enum States {CHASE, SCATTER, FRIGHTENED}
enum Direction {UP, DOWN, LEFT, RIGHT, VOID}

func _ready():
	scatterTile = get_parent().helper.maze.local_to_map(Vector2(408,8))
	
	get_parent().connect("calculateTarget", blinkyTarget)
	
	event_bus.pelletConsumed.connect(checkRelease)
	
func blinkyTarget(state : States):
	if state == States.CHASE:
		get_parent().targetTile = get_parent().helper.maze.local_to_map(player.global_position)
	elif state == States.SCATTER:
		get_parent().targetTile = scatterTile
		
### CRUISE ELROY CODE HERE ###
func checkRelease():
	pelletsEaten += 1
	
	if pelletsEaten >= releasePellets and !released:
		release()
	
func release():
	get_parent().refreshMovement()
	
	released = true
