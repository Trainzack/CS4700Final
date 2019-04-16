extends Area2D
export var max_health = 0
var current_health = max_health
var equipmentList = []
export var type = "abstract_unit"
onready var moves = $Moves

var has_moved = false
var has_attacked = false

onready var selector_icon = $SelectorIcon

func _ready():
	pass

func get_movement_atoms():
	var movement_atoms = []
	for move in get_moves():
		if move.is_move:
			movement_atoms.append(move.atom)
	return movement_atoms

func get_attack_atoms():
	var attack_atoms = []
	for move in get_moves():
		if move.is_attack:
			attack_atoms.append(move.atom)
	return attack_atoms
	
func get_moves():
	var m = []
	for move in moves.get_children():
		m.append(move)
	return m

func set_white():
	$UnitSprite.animation = "white"

func set_black():
	$UnitSprite.animation = "black"

func set_unselected():
	$SelectorIcon.animation = "unselected"

func set_selected():
	$SelectorIcon.animation = "selected"
	$SelectorIcon.play()

# func is_type(type): return type == "MyObject" or .is_type(type)

func get_type():
	return type

func reset_moves():
	has_moved = false
	has_attacked = false

func print_info():
	print($UnitSprite.animation," ", type, " with health of ", current_health)