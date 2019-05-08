extends Area2D
export var max_health = 3
export var type = "abstract_unit"

# How much this piece worth
export var unit_cost = 1
# Whether this piece can move on land
export var land_allowed = true
# Whether this piece can move on water
export var water_allowed = false
# Whether this piece can move on walls
export var wall_allowed = false

signal unit_death(unit)

# Make this assignment onready so that ubstypes have a chance to override
onready var current_health = max_health
var equipmentList = []
onready var moves = $Moves
var team = null

var has_moved = false
var has_attacked = false

#A unit has focus if it is being attacked or if it is currently selected
#used for keeping info of the unit onscreen
var has_focus = false
var is_acting = false

export var attack_power = 1

var units_per_health = 32

onready var health_bar = $HealthBar
onready var health_bar_number = $HealthBar/Label
onready var movement_icon = $MoveAvailability
onready var attack_icon = $AttackAvailability
onready var power_icon = $AttackPowerIcon
onready var selector_icon = $SelectorIcon
onready var damage_timer = $DamageTimer
onready var display_health_timer = $DisplayHealthTimer
onready var unit_sprite = $UnitSprite

func _ready(): 
	$DisplayHealthTimer.connect("timeout",self,"damage_hide_stats")
	health_bar.max_value = max_health
	set_health(current_health)
	
	# If max_health ever changes, this code will need to be refactored out!
	# Make health bar size dependant on max health
	health_bar.rect_size.x = max_health * units_per_health
	# Recenter the health bar
	health_bar.rect_position.x = max_health * units_per_health * -0.5
	health_bar.show_behind_parent = false
	
	power_icon.position.y = health_bar.rect_position.y + 15
	power_icon.position.x = health_bar.rect_position.x - 30
	power_icon.animation = str(attack_power)
	hide_stats()
	#hide_action_icons()

func get_cost():
	return unit_cost

func get_current_health():
	return current_health

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
func can_occupy(tile, move_type="move"):
	#if tile.is_water and not water_allowed:
	#	return false
	if not tile.is_water and not land_allowed and move_type != "attack":
		return false
	if tile.is_wall and not wall_allowed:
		return false
	return not tile.is_occupied()

# Returns whether this unit can pass through a tile without ending its turn there
func can_pass_through(tile, move_type):	
	if can_occupy(tile, move_type):
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

func get_team():
	return team

func set_unselected():
	$SelectorIcon.animation = "unselected"
	has_focus = false
	hide_health()
	hide_attack_power()
	if is_acting == true:
		display_action_icons_passive()

func set_selected():
	has_focus = true
	update_selection_icon()
	$SelectorIcon.play()
	$SelectSound.play()
	hide_action_icons()
	display_stats()

func update_selection_icon():
	if (not has_attacked) and (not has_moved):
		$SelectorIcon.animation = "selected"
	elif (not has_attacked) and (has_moved):
		$SelectorIcon.animation = "selected_move_d"
	elif (has_attacked) and (has_moved):
		$SelectorIcon.animation = "selected_both_d"

func set_health(h):
	if h < 0:
		h = 0
	current_health = h
	if current_health > max_health:
		current_health = max_health
	health_bar.value = current_health
	health_bar_number.text = str(current_health) + "/" + str(max_health)
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
	# Make translucent
	$UnitSprite.modulate = Color(1, 1, 1, 0.5)
	$DieSound.play()
	
	#Wait a second before sending out the signal for dying
	$DespawnTimer.start()
	yield($DespawnTimer,"timeout")
	emit_signal("unit_death",self)
	
func is_dead():
	return current_health <= 0
	
func get_type():
	return type

func is_dummy():
	return type == "abstract_unit"

#To be used during combat to reset the units actions
func reset_moves():
	is_acting = false
	has_moved = false
	movement_icon.animation = "available"
	has_attacked = false
	attack_icon.animation = "available"

func toggle_acting():
	is_acting = true

#To be used after combat to reset the units actions and restore it to full heatlh
func refresh():
	current_health = max_health
	has_moved = false
	movement_icon.animation = "available"
	has_attacked = false
	attack_icon.animation = "available"

func print_info():
	print($UnitSprite.animation," ", type, " with health of ", current_health)

#Calls the damage_display_health method to show the health and start a timer for how long it stays on screen
#That timer is run concurrently with the timer that is started in this method.
#The one that starts in this method delays the call to set_health for a bit. 
#Once the timer has timed out the health is decremented and since the health is still displayed on screen,
#this decrease is shown in real time.
func damage_by(amount):
	has_focus = true
	$TargetedSound.play()
	damage_display_health()
	damage_timer.set_wait_time(0.4)
	damage_timer.start()
	yield(damage_timer,"timeout")
	$DamagedSound.play()
	set_health(current_health - amount)

#Shows the health bar and then starts a timer to keep it on screen for a short time.
#On the timers timeout, a signal is detected which calls hide_health automatically.
func damage_display_health():
	health_bar.show()
	display_health_timer.set_wait_time(0.8)
	display_health_timer.start()

#unfocus the damaged unit and hides its health
func damage_hide_stats():
	has_focus = false
	hide_health()
	hide_attack_power()

func display_stats():
	display_health()
	if not is_dead():
		#display_action_icons()
		display_attack_power()

func hide_stats():
	hide_health()
	hide_action_icons()
	hide_attack_power()

func display_health():
	health_bar.show()

func hide_health():
	health_bar.hide()

func display_action_icons():
	attack_icon.show()
	movement_icon.show()

func display_action_icons_passive():
	attack_icon.position.y = health_bar.rect_position.y + 15
	movement_icon.position.y = health_bar.rect_position.y + 15
	display_action_icons()

func display_action_icons_hover():
	attack_icon.position.y = $SelectorIcon.position.y
	movement_icon.position.y = $SelectorIcon.position.y
	display_action_icons()

func hide_action_icons():
	attack_icon.hide()
	movement_icon.hide()

func display_attack_power():
	power_icon.show()

func hide_attack_power():
	power_icon.hide()

func expend_attack():
	has_attacked = true
	attack_icon.animation = "unavailable"

func expend_movement():
	has_moved = true
	movement_icon.animation = "unavailable"

func make_full_size():
	scale.x = 1.0
	scale.y = 1.0

func can_attack_from_water():
	return water_allowed

func can_go_on_walls():
	return wall_allowed

func get_sprite_frames():
	print($UnitSprite.frames)
	return $UnitSprite.frames

func has_actions():
	if(has_attacked == false or has_moved == false):
		return true
	else:
		return false