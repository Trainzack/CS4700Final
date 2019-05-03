extends Area2D
export var tyle_type = "white"
export var highlight_type = "none"
onready var movement_highlight = get_node("TileSprite").get_node("MovementHighlight")
onready var attack_highlight = get_node("TileSprite").get_node("AttackHighlight")
onready var subtle_attack_highlight = get_node("TileSprite").get_node("SubtleAttackHighlight")
onready var subtle_movement_highlight = get_node("TileSprite").get_node("SubtleMovementHighlight")
onready var unavailable_movement_highlight = get_node("TileSprite").get_node("UnavailableMovementHighlight")
onready var unavailable_attack_highlight = get_node("TileSprite").get_node("UnavailableAttackHighlight")
onready var outline = get_node("TileSprite").get_node("Outline")
onready var placement_position = get_node("PlacementPosition")
var can_move_to = false
var can_attack_space = false
var occupied = false

export var is_water = false
export var is_wall = false

signal clicked

func set_occupied(occupado):
	occupied = occupado

func is_occupied():
	return occupied

func set_tile_type(type):
	tyle_type = type
	$TileSprite.animation = tyle_type

func set_attack_option():
	attack_highlight.animation = "attack"
	attack_highlight.play()
	can_attack_space = true

func set_subtle_attack_option():
	subtle_attack_highlight.animation = "attack"
	subtle_attack_highlight.play()

func set_unavailable_attack_option():
	unavailable_attack_highlight.animation = "attack"
	unavailable_attack_highlight.play()

func set_movement_option():
	if occupied == false:
		movement_highlight.animation = "movement"
		movement_highlight.play()
		can_move_to = true

func set_subtle_movement_option():
	subtle_movement_highlight.animation = "movement"
	subtle_movement_highlight.play()

func set_unavailable_movement_option():
	unavailable_movement_highlight.animation = "movement"
	unavailable_movement_highlight.play()

func toggle_outline():
	if outline.animation == "not_hovered":
		outline.animation = "hovered"
	else:
		outline.animation = "not_hovered"

func deactivate():
	movement_highlight.animation = "none"
	subtle_movement_highlight.animation = "none"
	unavailable_movement_highlight.animation = "none"
	attack_highlight.animation = "none"
	subtle_attack_highlight.animation = "none"
	unavailable_attack_highlight.animation = "none"
	can_move_to = false
	can_attack_space = false

func get_placement_position():
	return placement_position

func _ready():
	pass

#Handles clicking by propgating a signal to parent nodes
#Parent nodes must connect the "clicked" signal
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		emit_signal("clicked")