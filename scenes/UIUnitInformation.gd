extends Container
var unit_scene = preload("res://scenes/unit_scenes/Unit.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Centaur.tscn")

onready var unit_to_show = $Panel/UnitToShow
onready var unit_name = $Panel/UnitName
onready var unit_attack_power = $Panel/AttackPower
onready var unit_hp = $Panel/HitPoints
onready var swim_label = $Panel/SwimAbility
onready var climb_label = $Panel/ClimbAbility

func _ready():
	#var test_unit = pawn_scene.instance()
	#test_unit.set_black()
	#add_child(test_unit)
	#construct_unit_data(test_unit)
	pass

func construct_unit_data(unit):
	set_unit_image(unit)
	get_unit_information(unit)

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

func get_unit_information(unit):
	unit_name.text = unit.get_type().to_upper()
	unit_hp.text = "HP: " + str(unit.get_current_health())
	unit_attack_power.text = "Attack Power: " + str(unit.get_attack_power())
	swim_label.text = "Can Swim" if unit.can_go_on_water() else "Cannot Swim"
	climb_label.text = "Can Climb" if unit.can_go_on_walls() else "Cannot Climb"