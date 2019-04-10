extends "res://scenes/unit_scenes/Unit.gd"

var movement_atoms = []
var attack_atoms = []

func _ready():
	movement_atoms.append(Vector2(1,2))
	movement_atoms.append(Vector2(2,1))
	attack_atoms.append(Vector2(1,0))

func get_movement_atoms():
	return movement_atoms

func get_attack_atoms():
	return attack_atoms

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
