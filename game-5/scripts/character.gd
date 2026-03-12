extends Area2D

var lastDir : Direction = Direction.RIGHT
var moveDir : Direction = Direction.RIGHT
var speed : float = 59.88
var freeze : bool = false


@export var helper : Node2D

const SNAP_DISTANCE = 4

enum Direction {UP, DOWN, LEFT, RIGHT, VOID}

@export var startPos : Vector2 = Vector2(224, 424)

func _ready():
	event_bus.restart.connect(reset)
	event_bus.freeze.connect(freezeSam)
	
	refreshMovement()
	
# Func to stop weird movement on resets/pauses
func refreshMovement():
	lastDir = Direction.UP
	moveDir = Direction.UP
	var cell = helper.maze.local_to_map(global_position)
	var centre = helper.maze.map_to_local(cell)
	global_position = centre

func _input(event):
	if event.is_action_pressed("move_up"):
		lastDir = Direction.UP
	if event.is_action_pressed("move_down"):
		lastDir = Direction.DOWN
	if event.is_action_pressed("move_left"):
		lastDir = Direction.LEFT
	if event.is_action_pressed("move_right"):
		lastDir = Direction.RIGHT
	
func _physics_process(delta):
	var cell = helper.maze.local_to_map(global_position)
	var centre = helper.maze.map_to_local(cell)
	
	# If lastDir != moveDir, check the different directions. If that direction is free, change the moveDir
	if lastDir != moveDir and helper.is_tile_free(lastDir, global_position):

		if global_position.distance_to(centre) < SNAP_DISTANCE:
			global_position = centre
			moveDir = lastDir
			
	# Check if we can even keep moving forwards
	if global_position.distance_to(centre) < (speed * delta):
		
		if not helper.is_tile_free(moveDir, global_position):
			global_position = centre
			moveDir = Direction.VOID
	
	# Move in the direction currently set if not frozen
	if !freeze:
		match moveDir:
			Direction.UP: global_position.y -= speed * delta
			Direction.DOWN: global_position.y += speed * delta
			Direction.LEFT: global_position.x -= speed * delta
			Direction.RIGHT: global_position.x += speed * delta
		
	### CHECK FOR OVERLAPPING AREA ###
	var overlapping_areas = get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("ghost"):
			var ghostCell = helper.maze.local_to_map(area.global_position)
			if cell == ghostCell:
				event_bus.emit_signal("endGame", true)
				
func freezeSam():
	freeze = true
		
func reset(death, level):
	# If a restart is happening due to a death
	if death:
		global_position = startPos
		refreshMovement()
		
	# If a restart is happening due to completion of the level
	else:
		global_position = startPos
		refreshMovement()
		
	freeze = false
