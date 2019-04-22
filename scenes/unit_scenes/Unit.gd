extends Area2D
export var max_health = 3
# Make this assignment onready so that ubstypes have a chance to override
onready var current_health = max_health
var equipmentList = []
export var type = "abstract_unit"
onready var moves = $Moves
var team = null

var has_moved = false
var has_attacked = false

var units_per_health = 32

onready var health_bar = $HealthBar

onready var selector_icon = $SelectorIcon

func _ready():
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# If max_health ever changes, this code will need to be refactored out!
	# Make health bar size dependant on max health
	health_bar.rect_size.x = max_health * units_per_health
	# Recenter the health bar
	health_bar.rect_position.x = max_health * units_per_health * -0.5
	pass

func get_movement_moves():
	var moves = []
	for move in get_moves():
		if move.is_move:
			moves.append(move)
	return moves

# Returns whether this unit can end its move on a particular tile
# Useful for allowing upgrades that allow tiles to move over particular types of terrain
func can_occupy(tile):
	return not tile.is_occupied()

# Returns whether this unit can pass through a tile without ending its turn there
func can_pass_through(tile):	
	if can_occupy(tile):
		# This should always be true
		return true
	# Todo: add other conditions that allow us to pass through tiles we can't occupy
	return false
	
# Returns whether this unit can attack the specified unit
func can_attack(unit):
	if unit.is_dummy() or is_dummy():
		return false
	return team != unit.team
	
func get_attack_moves():
	var moves = []
	for move in get_moves():
		if move.is_attack:
			moves.append(move)
	return moves
	
func get_moves():
	var m = []
	for move in moves.get_children():
		m.append(move)
	return m

func set_white():
	$UnitSprite.animation = "white"
	team = 0

func set_black():
	$UnitSprite.animation = "black"
	team = 1

func set_unselected():
	$SelectorIcon.animation = "unselected"
	health_bar.hide()

func set_selected():
	$SelectorIcon.animation = "selected"
	$SelectorIcon.play()
	$SelectSound.play()
	health_bar.show()

func set_health(h):
	current_health = h
	if current_health > max_health:
		current_health = max_health
	health_bar.value = current_health
	if current_health <= 0:
		die()
		
func damage_by(amount):
	set_health(current_health - amount)

# func is_type(type): return type == "MyObject" or .is_type(type)

# Called whenever this unit is move
func moved():
	$MoveSound.play()
	# Debug, test health and damage until we get combat
	damage_by(1)
	
# Called whenever this unit needs to die. Calling this method should be the only thing needed to kill this unit.
func die():
	# TODO
	$DieSound.play()
	
func get_type():
	return type

func is_dummy():
	return type == "abstract_unit"

func reset_moves():
	has_moved = false
	has_attacked = false

func refresh():
	current_health = max_health
	has_moved = false
	has_attacked = false

func print_info():
	print($UnitSprite.animation," ", type, " with health of ", current_health)