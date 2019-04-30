extends Node

onready var overworld = $OverworldScene
var combat_scene = null

var combat_scene_class = preload("res://scenes/MasterCombatScene.tscn")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func begin_combat(encounter):
	if combat_scene != null:
		printerr("Error! Cannot start combat when combat still exists!")
	else:
		remove_child(overworld)
		combat_scene = combat_scene_class.instance()
		add_child(combat_scene)
		combat_scene.set_encounter(encounter)
		
	
func end_combat():
	remove_child(combat_scene)
	combat_scene = null
	add_child(overworld)
	
	
	