extends Area2D
export var health = 0
var equipmentList = []
export var type = "abstract_unit"
onready var moves = $Moves 

#onready var highlight = get_node("UnitSprite").get_node("Highlight")
onready var selector_icon = $SelectorIcon

func _ready():
	pass

#func toggle_highlight():
#	if highlight.animation == "highlighted":
#		highlight.animation = "unhighlighted"
#	else:
#		highlight.animation = "highlighted"

func get_movement_atoms():
	var movement_atoms = []
	for move in moves.get_children():
		if move.type == 0:
			movement_atoms.append(move.atom)
	return movement_atoms

func get_attack_atoms():
	var attack_atoms = []
	for move in moves.get_children():
		if move.type == 1:
			attack_atoms.append(move.atom)
	return 

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

func print_info():
	print($UnitSprite.animation," ", type, " with health of ", health)