extends Node
var unit_scene = preload("res://scenes/unit_scenes/Unit.tscn")
var pawn_scene = preload("res://scenes/unit_scenes/Knight.tscn")

onready var unit_to_show = $Container/Panel/UnitToShow
onready var unit_name = $Container/Panel/UnitName
onready var unit_attack_power = $Container/Panel/AttackPower
onready var unit_hp = $Container/Panel/HitPoints
onready var health_position = $Container/Panel/HealthBarPosition
var unit

func _ready():
	var test_unit = pawn_scene.instance()
	
	add_child(test_unit)
	construct_unit_data(test_unit)

func construct_unit_data(unit):
	unit_to_show.frames = unit.get_sprite_frames()
	print(unit_to_show.frames)
	unit_to_show.play()
	unit_to_show.position = Vector2(85,195)
	get_unit_information(unit)
	
func get_unit_information(unit):
	unit_name.text = unit.get_type().to_upper()
	unit_hp.text = "HP: " + str(unit.get_current_health())
	unit_attack_power.text = "Attack Power: " + str(unit.get_attack_power())
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
