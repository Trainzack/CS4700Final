extends Area2D
export var max_health = 3
export var type = "abstract_unit"

# Whether this piece can move on land
export var land_allowed = true
# Whether this piece can move on water
export var water_allowed = false
# Whether this piece can move on walls
export var wall_allowed = false

# Make this assignment onready so that ubstypes have a chance to override
onready var current_health = max_health
var equipmentList = []
onready var moves = $Moves
var team = null

var has_moved = false
var has_attacked = false

export var attack_power = 1

var units_per_health = 32

onready var health_bar = $HealthBar

onready var selector_icon = $SelectorIcon
onready var damage_timer = $DamageTimer
onready var display_health_timer = $DisplayHealthTimer

func _ready():
	$DisplayHealthTimer.connect("timeout",self,"hide_health")
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# If max_health ever changes, this code will need to be refactored out!
	# Make health bar size dependant on max health
	health_bar.rect_size.x = max_health * units_per_health
	# Recenter the health bar
	health_bar.rect_position.x = max_health * units_per_health * -0.5
	pass

func get_attack_power():
	return attack_power

func get_movement_moves():
	var moves = []
	for move in get_moves():
		if move.is_move:
			moves.append(move)
	return moves

# Returns whether this unit can end its move on a particular tile
# Useful for allowing upgrades that allow tiles to move over particular types of terrain
func can_occupy(tile):
	if tile.is_water and not water_allowed:
		return false
	if not tile.is_water and not land_allowed:
		return false
	if tile.is_wall and not wall_allowed:
		return false
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
	# Checking for death is a placeholder, unless we go with ItB style death
	if is_dead() or unit.is_dead():
		return false
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

# func is_type(type): return type == "MyObject" or .is_type(type)

# Called whenever this unit is move
func moved():
	$MoveSound.play()
	# Debug, test health and damage until we get combat
	#damage_by(1)
	
# Called whenever this unit needs to die. Calling this method should be the only thing needed to kill this unit.
func die():
	# TODO: Finish implementing death!
	current_health = 0
	$DieSound.play()
	# Make translucent
	$UnitSprite.modulate = Color(1, 1, 1, 0.5)
	
func is_dead():
	return current_health <= 0
	
func get_type():
	return type

func is_dummy():
	return type == "abstract_unit"

#To be used during combat to reset the units actions
func reset_moves():
	has_moved = false
	has_attacked = false

#To be used after combat to reset the units actions and restore it to full heatlh
func refresh():
	current_health = max_health
	has_moved = false
	has_attacked = false

func print_info():
	print($UnitSprite.animation," ", type, " with health of ", current_health)

func damage_by(amount):
	$TargetedSound.play()
	damage_display_health()
	damage_timer.set_wait_time(0.3)
	damage_timer.start()
	yield(damage_timer,"timeout")
	$DamagedSound.play()
	set_health(current_health - amount)

func damage_display_health():
	health_bar.show()
	$DisplayHealthTimer.set_wait_time(0.6)
	$DisplayHealthTimer.start()

func display_health():
	health_bar.show()

func hide_health():
	health_bar.hide()