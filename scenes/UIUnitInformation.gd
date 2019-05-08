extends Container
var unit_scene = preload("res://scenes/unit_scenes/Unit.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/King.tscn")

onready var unit_to_show = $GeneralPanel/UnitToShow
onready var unit_name = $GeneralPanel/UnitName
onready var unit_attack_power = $GeneralPanel/AttackPower
onready var unit_hp = $GeneralPanel/HitPoints
onready var swim_label = $GeneralPanel/SwimAbility
onready var climb_label = $GeneralPanel/ClimbAbility
onready var moves_label = $ActionPanel/Label/MoveInfo
onready var attacks_label = $ActionPanel/Label2/AttacksInfo
onready var action_panel = $ActionPanel
var current_action_panel_size

#if you increase or decrease the font size, change these as well
var default_action_panel_size = 47
var panel_size_increment = 39

func _ready():
	#var test_unit = pawn_scene.instance()
	#test_unit.set_black()
	#add_child(test_unit)
	#construct_unit_data(test_unit)
	pass

func construct_unit_data(unit):
	current_action_panel_size = default_action_panel_size
	action_panel.rect_size.y = current_action_panel_size
	set_unit_image(unit)
	get_unit_general_information(unit)
	get_unit_move_information(unit,"move")
	get_unit_move_information(unit,"attack")

func set_scale(x,y):
	rect_scale.x = x
	rect_scale.y = y

func set_position(x,y):
	rect_position.x = x
	rect_position.y = y

func set_unit_image(unit):
	var animation_string = unit.get_type().to_lower()
	if unit.get_team() == 0:
		animation_string += "_light"
	elif unit.get_team() == 1:
		animation_string += "_dark"
	else:
		animation_string = "none"
	print(animation_string)
	unit_to_show.animation = animation_string

func show_information(unit):
	construct_unit_data(unit)
	show()

func hide_information():
	hide()

#Fills in the text for general unit information on the first panel
func get_unit_general_information(unit):
	unit_name.text = unit.get_type().to_upper()
	unit_hp.text = "HP: " + str(unit.get_current_health()) + " / " + str(unit.max_health)
	unit_attack_power.text = "Attack Power: " + str(unit.get_attack_power())
	swim_label.text = "Can attack from water" if unit.can_attack_from_water() else "Cannot attack from water"
	climb_label.text = "Can traverse high ground" if unit.can_go_on_walls() else "Cannot traverse high ground"

#Constructs the action panel's information and sets its size based on 
#how many moves a unit has.
func get_unit_move_information(unit,type):
	var extra_panel_size = 0
	var label_to_write
	var move_array
	if type == "move":
		label_to_write = moves_label
		move_array = unit.get_movement_moves()
	elif type == "attack":
		label_to_write = attacks_label
		move_array = unit.get_attack_moves()
	
	label_to_write.text = ""
	
	for move in move_array:
		extra_panel_size += panel_size_increment
		label_to_write.text += str(move.atom)
		if(move.rider):
			label_to_write.text += " R"
		label_to_write.text += "\n"
	
	if extra_panel_size + default_action_panel_size > current_action_panel_size:
		current_action_panel_size = extra_panel_size + default_action_panel_size
		action_panel.rect_size.y = current_action_panel_size