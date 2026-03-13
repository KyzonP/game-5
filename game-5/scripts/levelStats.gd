extends Node

var level = 1

var bonusPoints = [100, 300, 500, 500, 700, 700, 1000, 1000, 2000, 2000, 3000, 3000, 5000]
var samSpeed = [80,90,90,90,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,90]
var ghostSpeed = [75,85,85,85,95]
var ghostTunnelSpeed =[40,45,45,45,50]
var elroySpeed = [80,90,90,90,100]
var elroySpeed2 = [85,95,95,95,105]
var scareSamSpeed = [90,95,95,95,100]
var scareGhostSpeed = [50,55,55,55,60]
var scareTime = [6,5,4,3,2,5,2,2,1,5,2,1,1,3,1,1]
var scareFlashes = [5,5,5,5,5,5,5,5,3,5,5,3,3,5,3,3]
var stateTimes = [[7,20,7,20,5,20,5],[7,20,7,20,5,1033,0.016],[7,20,7,20,5,1033,0.016],[7,20,7,20,5,1033,0.016],[5,20,5,20,5,1037,0.016]]

func setStats(array):
	if array[level] != null:
		return array[level-1]
	else:
		return array[-1]
