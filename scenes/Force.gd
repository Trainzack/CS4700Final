extends Node

export(int, "white", "black") var team = 1
export var player_controlled = false
var units = []

func _ready():
	pass

func _process():
	pass
	
# This is the method called when it is this force's turn
func startTurn():
	pass
	
# This method returns the units that this force has
func getUnits():
	return units
	
func isPlayerControlled():
	return player_controlled
	
func getTeam():
	return team