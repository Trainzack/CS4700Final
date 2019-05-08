extends Node

onready var main_menu = $MainMenuScene
var scene_stack = []

onready var confirm_sound = $ConfirmSound

var combat_scene_class = preload("res://scenes/MasterCombatScene.tscn")
var overworld_scene_class = preload("res://scenes/OverworldScene.tscn")

onready var quit_main_menu_box = $CanvasLayer/ConfirmationDialog

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	quit_main_menu_box.connect("confirmed",self,"return_to_menu")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		quit_main_menu_box.show()
		 

func begin_combat(encounter):
	remove_child(scene_stack[0])
	var combat_scene = combat_scene_class.instance()
	add_child(combat_scene)
	combat_scene.set_encounter(encounter)
	scene_stack.push_front(combat_scene)
		
func exit_scene(delay=0, sound=false):
	if sound:
		Global.confirmSound()
	remove_child(scene_stack.pop_front())
	yield(get_tree().create_timer(delay), "timeout")
	add_child(scene_stack[0])
	
func begin_overworld():
	remove_child(main_menu)
	var overworld = overworld_scene_class.instance()
	add_child(overworld)
	scene_stack.push_front(overworld)
	
func return_to_menu():
	remove_child(scene_stack.pop_front())
	scene_stack = []
	add_child(main_menu)
	main_menu.enable_buttons()
	
	
	