extends Node2D

var score : int = 0
var level = 1

@export var pelletsEaten : int = 0
var won : bool = false
var freeze : bool = false
var ghostFrightened : bool = false

var state : States = States.SCATTER

var stateTimes = [7,20,7,20,5,20,5]

enum States {CHASE, SCATTER, FRIGHTENED}

var stateTimer = 0.0

var frightenedTimer = 0.0
var frightenedTimerMax = 6.0

func _ready():
	$Pellets.connect("scoreChanged", ScoreChanged)
	
	event_bus.pelletConsumed.connect(checkWin)
	event_bus.endGame.connect(endGame)
	event_bus.ghostState.connect(ghostFrightenedToggle)
		
func reset(death, level):
	# If a restart is happening due to a death
	if death:
		pass
		
	# If a restart is happening due to completion of the level
	else:
		stateTimer = 0
		
		level = level + 1
		
		if level > 1 and level < 5:
			stateTimes = [7,20,7,20,5,1033,0.016666]
		elif level >= 5:
			stateTimes = [5,20,5,20,5,1037,0.016666]
			
		stateTimes = level_stats.setStats(level_stats.stateTimes)
			
	freeze = false
		
func checkWin():
	pelletsEaten += 1
	
	if pelletsEaten >= 244 and !won:
		won = true
		endGame(false)
		
		
func endGame(death):
	if !freeze:
		freeze = true
		event_bus.emit_signal("freeze")
		
		# Do a few things #
		await get_tree().create_timer(2.0).timeout
		
		if death:
			event_bus.emit_signal("restart", true, level)
		else:
			event_bus.emit_signal("restart", false, level + 1)
			level_stats.level = level+1
	
func _physics_process(delta):
	if !ghostFrightened:
		stateTimer += delta
		if stateTimes.size() > 0 and stateTimer >= stateTimes[0]:
			stateTimer = 0
			stateTimes.pop_front()

			if state == States.SCATTER:
				event_bus.emit_signal("ghostState", "chase")
				state = States.CHASE
			elif state == States.CHASE:
				event_bus.emit_signal("ghostState", "scatter")
				state = States.SCATTER
	else:
		frightenedTimer += delta
		if frightenedTimer >= frightenedTimerMax:
			frightenedTimer = 0
			ghostFrightened = true
			if state == States.SCATTER:
				event_bus.emit_signal("ghostState", "scatter")
			elif state == States.CHASE:
				event_bus.emit_signal("ghostState", "chase")
		
func ghostFrightenedToggle(state):
	if state == "frightened":
		ghostFrightened = true


func ScoreChanged(amount):
	score += amount
	$Score.text = "[center]" + str(score)
