extends Area2D

var encounter_scene = preload("res://scenes/Encounter.tscn")

var encounter = null

signal clicked

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	selectEncounter("tut1")


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

#Handles clicking by propgating a signal to parent nodes
#Parent nodes must connect the "clicked" signal
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		print("clicked")
		emit_signal("clicked")
