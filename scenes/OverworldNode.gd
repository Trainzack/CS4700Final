extends Area2D

var encounter_scene = preload("res://scenes/Encounter.tscn")

var encounter = null

var next_nodes = []

var node_lines = {}

var selected = false

signal clicked

onready var sprite = $AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass


func selectEncounter(encounter_type):
	if encounter:
		encounter.free()
	encounter = encounter_scene.instance()
	add_child(encounter)
	encounter.select_encounter(encounter_type)

func get_difficulty():
	return encounter.get_difficulty()
	
func get_reward():
	return encounter.get_reward()	

func get_name():
	return encounter.type

# Connects a node, after both of them have been placed on the map
func connect_node(next_node):
	next_nodes.append(next_node)
	var line = Line2D.new()
	node_lines[next_node] = line
	line.add_point(position)
	line.add_point(next_node.position)
	line.width = 10
	line.default_color = Color( 0.9, 0.9, 0.9 )
	line.z_index = 5
	get_parent().add_child(line)
	

func select():
	selected = true
	sprite.modulate = Color( 1, 1, 0)
	for n in next_nodes:
		var l = node_lines[n]
		l.default_color = Color( 0.9, 0.9, 0)

func unselect():
	selected = false
	sprite.modulate = Color( 1, 1, 1)
	for n in next_nodes:
		var l = node_lines[n]
		l.default_color = Color( 0.9, 0.9, 0.9)

#Handles clicking by propgating a signal to parent nodes
#Parent nodes must connect the "clicked" signal
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		print("clicked")
		emit_signal("clicked")
