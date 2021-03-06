extends Node
var unit_scene = preload("res://scenes/unit_scenes/Unit.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Centaur.tscn")

onready var unit_to_show = $Container/Panel/UnitToShow
onready var unit_name = $Container/Panel/UnitName
onready var unit_attack_power = $Container/Panel/AttackPower
onready var unit_hp = $Container/Panel/HitPoints
onready var swim_label = $Container/Panel/SwimAbility
onready var climb_label = $Container/Panel/ClimbAbility

func _ready():
	var test_unit = pawn_scene.instance()
	test_unit.set_black()
	#add_child(test_unit)
	construct_unit_data(test_unit)

func construct_unit_data(unit):
	set_unit_image(unit)
	get_unit_information(unit)

func set_scale(x,y):
	$Container.rect_scale.x = x
	$Container.rect_scale.y = y

func set_position(x,y):
	$Container.rect_position.x = x
	$Container.rect_position.y = y

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
	$Container.show()

func hide_information():
	$Container.hide()

func get_unit_information(unit):
	unit_name.text = unit.get_type().to_upper()
	unit_hp.text = "HP: " + str(unit.get_current_health())
	unit_attack_power.text = "Attack Power: " + str(unit.get_attack_power())
	swim_label.text = "Can Swim" if unit.can_go_on_water() else "Cannot Swim"
	climb_label.text = "Can Climb" if unit.can_go_on_walls() else "Cannot Climb"